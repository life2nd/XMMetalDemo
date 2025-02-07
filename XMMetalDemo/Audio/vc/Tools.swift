//
//  Tools.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/1/10.
//

import UIKit

// MP3 帧头结构
struct MP3FrameHeader {
    var version: Int
    var layer: Int
    var errorProtection: Bool
    var bitrate: Int
    var samplingRate: Int
    var padding: Bool
    var ext: Bool
    var mode: Int
    var modeExt: Int
    var copyright: Bool
    var original: Bool
    var emphasis: Int
    
    // MPEG 版本常量
    enum MPEGVersion {
        static let MPEG1 = 3
        static let MPEG2 = 2
        static let MPEG2_5 = 0
    }
    
    // 声道模式常量
    enum ChannelMode {
        static let STEREO = 0
        static let JOINT_STEREO = 1
        static let DUAL_CHANNEL = 2
        static let MONO = 3
    }
}

class MP3Decoder {
    // 比特率表 (kbps)
    private static let bitrates: [[[Int]]] = [
        [ // MPEG 1
            [0,32,64,96,128,160,192,224,256,288,320,352,384,416,448], // Layer 1
            [0,32,48,56,64,80,96,112,128,160,192,224,256,320,384],    // Layer 2
            [0,32,40,48,56,64,80,96,112,128,160,192,224,256,320]      // Layer 3
        ],
        [ // MPEG 2 & 2.5
            [0,32,48,56,64,80,96,112,128,144,160,176,192,224,256],    // Layer 1
            [0,8,16,24,32,40,48,56,64,80,96,112,128,144,160],         // Layer 2
            [0,8,16,24,32,40,48,56,64,80,96,112,128,144,160]          // Layer 3
        ]
    ]
    
    // 采样率表 (Hz)
    private static let samplingRates: [[Int]] = [
        [44100, 48000, 32000], // MPEG 1
        [22050, 24000, 16000], // MPEG 2
        [11025, 12000, 8000]   // MPEG 2.5
    ]
    
    // 解析帧头
    private func parseFrameHeader(_ buffer: [UInt8]) -> MP3FrameHeader? {
        guard buffer.count >= 4 else { return nil }
        
        let headerRaw = UInt32(buffer[0]) << 24 | UInt32(buffer[1]) << 16 | UInt32(buffer[2]) << 8 | UInt32(buffer[3])
        
        // 检查同步字
        guard (headerRaw & 0xFFE00000) == 0xFFE00000 else {
            return nil
        }
        
        return MP3FrameHeader(
            version: Int((headerRaw >> 19) & 3),
            layer: Int((headerRaw >> 17) & 3),
            errorProtection: ((headerRaw >> 16) & 1) == 0,
            bitrate: Int((headerRaw >> 12) & 0xF),
            samplingRate: Int((headerRaw >> 10) & 3),
            padding: ((headerRaw >> 9) & 1) == 1,
            ext: ((headerRaw >> 8) & 1) == 1,
            mode: Int((headerRaw >> 6) & 3),
            modeExt: Int((headerRaw >> 4) & 3),
            copyright: ((headerRaw >> 3) & 1) == 1,
            original: ((headerRaw >> 2) & 1) == 1,
            emphasis: Int(headerRaw & 3)
        )
    }
    
    // 计算帧大小
    private func calculateFrameSize(_ header: MP3FrameHeader) -> Int {
        let bitrateIndex = header.version == MP3FrameHeader.MPEGVersion.MPEG1 ? 0 : 1
        let layerIndex = 3 - header.layer
        
        let bitrate = MP3Decoder.bitrates[bitrateIndex][layerIndex][header.bitrate]
        
        let samplingRateIndex = header.version == MP3FrameHeader.MPEGVersion.MPEG1 ? 0 : 1
        let samplingRate = MP3Decoder.samplingRates[samplingRateIndex][header.samplingRate]
        
        if header.layer == 3 { // Layer 1
            return ((12 * bitrate * 1000 / samplingRate) + (header.padding ? 1 : 0)) * 4
        } else { // Layer 2 & 3
            return (144 * bitrate * 1000 / samplingRate) + (header.padding ? 1 : 0)
        }
    }
    
    // 解码MP3文件到PCM
    func decodeToPCM(inputFile: String, outputFile: String) throws  -> Data {
        guard let inputData = try? Data(contentsOf: URL(fileURLWithPath: inputFile)) else {
            throw NSError(domain: "MP3Decoder", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cannot read input file"])
        }
        
        var outputData = Data()
        var offset = 0
        
        while offset < inputData.count {
            // 读取4字节帧头
            let headerBytes = Array(inputData[offset..<min(offset + 4, inputData.count)])
            guard headerBytes.count == 4,
                  let header = parseFrameHeader(headerBytes) else {
                offset += 1
                continue
            }
            
            let frameSize = calculateFrameSize(header)
            guard offset + frameSize <= inputData.count else { break }
            
            // 读取整个帧
            let frameData = Array(inputData[offset..<offset + frameSize])
            
            // 解码帧数据到PCM
//            if let pcmData = decodeFrame(frameData, header: header) {
//                outputData.append(pcmData)
//            }
            
            let mp3Data = inputData.subdata(in: offset..<offset + frameSize)
            outputData.append(mp3Data)
            
            offset += frameSize
        }
        
        // 写入输出文件
//        try outputData.write(to: URL(fileURLWithPath: outputFile))
        
        return outputData
    }
    
    // 解码单个帧
    private func decodeFrame(_ frameData: [UInt8], header: MP3FrameHeader) -> Data? {
        // 这里需要实现实际的解码过程
        // 1. Huffman解码
        // 2. 反量化
        // 3. 立体声处理
        // 4. IMDCT
        // 5. 子带合成
        
        // 示例：生成空的PCM数据
        let samplesPerFrame = 1152 // MP3 Layer 3的标准样本数
        let channelCount = header.mode == MP3FrameHeader.ChannelMode.MONO ? 1 : 2
        var pcmData = Data(count: samplesPerFrame * channelCount * 2) // 16-bit per sample
        
        return pcmData
    }
}

