//
//  XMNewAudioPlayer.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/1/8.
//

import UIKit
import AVFoundation
import AudioToolbox

class AudioStreamPlayer {
    
    private var audioUnit: AudioUnit?
    private var audioConverter: AudioConverterRef?
    private var inputFormat = AudioStreamBasicDescription()
    private var outputFormat = AudioStreamBasicDescription()
    
    private var audioData = Data()
    private var readOffset: Int = 0
    private var isPlaying = false
    private let dataLock = NSLock()
    
    init() {
        setupAudio()
    }
    
    func setupAudio() {
        
        inputFormat.mFormatID = kAudioFormatMPEGLayer3
        inputFormat.mSampleRate = 48000.0
        inputFormat.mChannelsPerFrame = 2
        inputFormat.mFormatFlags = 0
        inputFormat.mFramesPerPacket = 1152
        
//        inputFormat.mSampleRate = 44100.0
//        inputFormat.mFormatID = kAudioFormatLinearPCM
//        inputFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked
//        inputFormat.mFramesPerPacket = 1
//        inputFormat.mChannelsPerFrame = 2
//        inputFormat.mBitsPerChannel = 16
//        inputFormat.mBytesPerPacket = inputFormat.mBitsPerChannel / 8 * inputFormat.mChannelsPerFrame
//        inputFormat.mBytesPerFrame = inputFormat.mBytesPerPacket
        
        outputFormat.mSampleRate = 44100.0
        outputFormat.mFormatID = kAudioFormatLinearPCM
        outputFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked
        outputFormat.mFramesPerPacket = 1
        outputFormat.mChannelsPerFrame = 2
        outputFormat.mBitsPerChannel = 16
        outputFormat.mBytesPerPacket = outputFormat.mBitsPerChannel / 8 * outputFormat.mChannelsPerFrame
        outputFormat.mBytesPerFrame = outputFormat.mBytesPerPacket
        
        var audioConverterTemp: AudioConverterRef?
        let status = AudioConverterNew(&inputFormat, &outputFormat, &audioConverterTemp)
        guard status == noErr, let converter = audioConverterTemp else {
            print("Failed to create audio converter")
            return
        }
        audioConverter = converter
        
        setupAudioUnit()
    }
    
    func setupAudioUnit() {
        
        var description = AudioComponentDescription(componentType: kAudioUnitType_Output,
                                                    componentSubType: kAudioUnitSubType_RemoteIO,
                                                    componentManufacturer: kAudioUnitManufacturer_Apple,
                                                    componentFlags: 0,
                                                    componentFlagsMask: 0)
        
        guard let component = AudioComponentFindNext(nil, &description) else { return }
        
        var tempUnit: AudioUnit?
        AudioComponentInstanceNew(component, &tempUnit)
        guard let unit = tempUnit else { return }
        audioUnit = unit
        
        var outputFormat = self.outputFormat
        AudioUnitSetProperty(unit,
                             kAudioUnitProperty_StreamFormat,
                             kAudioUnitScope_Input,
                             0,
                             &outputFormat, 
                             UInt32(MemoryLayout<AudioStreamBasicDescription>.size))
        
        var callBack = AURenderCallbackStruct(inputProc: renderCallBack,
                                              inputProcRefCon: Unmanaged.passUnretained(self).toOpaque())
        AudioUnitSetProperty(unit,
                             kAudioUnitProperty_SetRenderCallback,
                             kAudioUnitScope_Input,
                             0,
                             &callBack,
                             UInt32(MemoryLayout<AudioStreamBasicDescription>.size))
        
        AudioUnitInitialize(unit)
    }
    
    
    private let audioConverterCallBack: AudioConverterComplexInputDataProc = {
        (
            inAudioConverter,
            ioNumberDataPackets,
            ioData,
            outDataPacketDescription,
            inUserData
        ) -> OSStatus in
        
        let player = Unmanaged<AudioStreamPlayer>.fromOpaque(inUserData!).takeUnretainedValue()
        
        player.dataLock.lock()
        defer { player.dataLock.unlock() }
        
        let remainingBytes = player.audioData.count - player.readOffset
        if remainingBytes == 0 {
            ioNumberDataPackets.pointee = 0
            return -1
        }
        
        let buffer = UnsafeMutableAudioBufferListPointer(ioData)
        if let mData = buffer[0].mData {
            player.audioData.withUnsafeBytes { rawBuffer in
                let src = rawBuffer.baseAddress! + player.readOffset
                let size = min(remainingBytes, 2048)
                memcpy(mData, src, size)
                buffer[0].mDataByteSize = UInt32(size)
            }
            player.readOffset += Int(buffer[0].mDataByteSize)
        }
        
        return noErr
    }
    
    private let renderCallBack: AURenderCallback = { (
        inRefCon,
        ioActionFlags,
        inTimeStamp,
        inBusNumber,
        inNumberFrames,
        ioData
    ) -> OSStatus in
        
        let player = Unmanaged<AudioStreamPlayer>.fromOpaque(inRefCon).takeUnretainedValue()
        guard player.isPlaying else { return noErr }
        
        var inOutputDataPackets = inNumberFrames
        
        let status = AudioConverterFillComplexBuffer(player.audioConverter!,
                                                     player.audioConverterCallBack,
                                                     inRefCon,
                                                     &inOutputDataPackets,
                                                     ioData!,
                                                     nil)
        return status
    }
    
    func play() {
        guard !isPlaying, let unit = audioUnit else { return }
        isPlaying = true
        AudioOutputUnitStart(unit)
    }
    
    func stop() {
        guard isPlaying, let unit = audioUnit else { return }
        isPlaying = false
        AudioOutputUnitStop(unit)
        readOffset = 0
    }
    
    func setVolume(_ volume: Float) {
        guard let unit = audioUnit else { return }
        AudioUnitSetParameter(unit, 
                              kHALOutputParam_Volume,
                              kAudioUnitScope_Output,
                              0,
                              volume,
                              0)
    }
    
    deinit {
        if let converter = audioConverter {
            AudioConverterDispose(converter)
        }
        
        if let unit = audioUnit {
            AudioUnitUninitialize(unit)
            AudioComponentInstanceDispose(unit)
        }
    }
    
    
    // MARK: - Public Methods
    
    func appendAudioData(_ data: Data) {
        dataLock.lock()
        audioData.append(data)
        dataLock.unlock()
        
        if !isPlaying && audioData.count > 4096 {
            play()
        }
    }
    
}

extension AudioStreamPlayer {
    
    var hasEnoughBuffer: Bool {
        dataLock.lock()
        defer { dataLock.unlock() }
        
        return (audioData.count - readOffset) > 4096
    }
    
    func clearBuffer() {
        dataLock.lock()
        audioData.removeAll()
        readOffset = 0
        dataLock.unlock()
    }
}

extension AudioStreamPlayer {
    
    enum PlaybackState {
        case playing
        case stopped
        case buffering
    }
    
    static let playbackStateDidChange = Notification.Name("AudioPlayerPlaybackStateDidChange")
    static let bufferingProgressDidChange = Notification.Name("AudioPlayerBufferingProgressDidChange")
    
    private func notifyPlaybackStateChanged(_ state: PlaybackState) {
        NotificationCenter.default.post(name: AudioStreamPlayer.playbackStateDidChange,
                                        object: self,
                                        userInfo: ["state": state])
    }
    
    private func notifyBufferingProgress(_ progress: Float) {
        NotificationCenter.default.post(name: AudioStreamPlayer.bufferingProgressDidChange,
                                        object: self,
                                        userInfo: ["progress": progress])
    }
}

extension AudioStreamPlayer {
    
    struct Configuration {
        var sampleRate: Double = 44100.0
        var channels: UInt32 = 2
        var bufferSize: Int = 4096
        
        static let `default` = Configuration()
    }
    
    func configure(with config: Configuration) {
        inputFormat.mSampleRate = config.sampleRate
        inputFormat.mChannelsPerFrame = config.channels
    }
}

extension AudioStreamPlayer {
    func handleInterruption(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        switch type {
        case .began:
            stop()
        case .ended:
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                play()
            }
        @unknown default:
            break
        }
    }
}
