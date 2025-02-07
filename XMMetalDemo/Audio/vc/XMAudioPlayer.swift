//
//  XMAudioPlayer.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/1/3.
//

import UIKit
import AudioUnit
import AudioToolbox
import AVFoundation
import Combine

public enum XMAudioPlayerStatus {
    case Init, Prepare, Playing, Pause
}

class XMAudioPlayer: NSObject {
    
    static let shared = XMAudioPlayer()
    
    let queue = DispatchQueue(label: "xmAudioPlayer")
    let engine: AVAudioEngine! = AVAudioEngine()
    let playerNode: AVAudioPlayerNode! = AVAudioPlayerNode()
    var audioFile: AVAudioFile?
    var avAudioTime: AVAudioTime?
    
    var useEffect = false
    let playerNodeEffect: AVAudioPlayerNode! = AVAudioPlayerNode()

    public var status = XMAudioPlayerStatus.Init
    
    private let subject = PassthroughSubject<XMAudioPlayerStatus, Never>()
    private func updateState(_ newState: XMAudioPlayerStatus) {
        status = newState
        subject.send(newState)
    }
    var publisher: AnyPublisher<XMAudioPlayerStatus, Never> {
        subject.eraseToAnyPublisher()
    }
    
    private let progressSubject = PassthroughSubject<Float, Never>()
    private func updateProgress() {
        let currentTime = currentTime()
        progressSubject.send(currentTime)
    }
    var progressPublisher: AnyPublisher<Float, Never> {
        progressSubject.eraseToAnyPublisher()
    }
    
    public func fileDescripe() -> String? {
        
        guard let audioFile = audioFile else { return nil }
        
        let formate = audioFile.fileFormat
        let duration = Float(audioFile.length) / Float(formate.sampleRate)
        return "通道数:\(formate.channelCount), 采样率:\(formate.sampleRate), 时长:\(duration)s"
    }
    
    public func fileDuration() -> Float {
        
        guard let audioFile = audioFile else { return 0 }
        
        let formate = audioFile.processingFormat
        if formate.sampleRate <= 0 {
            return 0
        }
        return Float(audioFile.length) / Float(formate.sampleRate)
    }
    
    public func currentTime() -> Float {
        guard let avAudioTime = avAudioTime, let audioFile = audioFile else { return 0}
        return Float(avAudioTime.sampleTime) / Float(audioFile.fileFormat.sampleRate)
    }
    
    override init() {
        super.init()
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback)
            try session.setActive(true)
        }
        catch {
            print("error AVAudioSession !")
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if !engine.isRunning {
                return
            }
            if let playerTime = self.playerNode.lastRenderTime {
                self.avAudioTime = playerTime
                updateProgress()
            }
        }
        
        customInit()
    }
    
    private func customInit() {
        
    }
    
    public func initWithFilePath(_ filePath: URL!) {
        
        let mixer = engine.mainMixerNode
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: mixer.outputFormat(forBus: 0))
        
        engine.prepare()
        try? engine.start()
        
        updateState(.Init)
        
        audioFile = try? AVAudioFile(forReading: filePath)
        
        guard let audioFile = audioFile else { return }
        
        self.updateState(.Prepare)
        
        let format = audioFile.processingFormat
        let capacity = AVAudioFrameCount(audioFile.length)
        if let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: capacity) {
            try? audioFile.read(into: buffer, frameCount: capacity)
            
            playerNode.scheduleBuffer(buffer) { [weak self] in
                guard let self = self else { return }
                self.updateState(.Init)
            }
        }
    }
    
    public func initWithEffectFilePath(_ filePath: URL!, _ effectFilePath: URL!) {
        useEffect = true
        
        updateState(.Init)
        
        audioFile = try? AVAudioFile(forReading: filePath)
        
        guard let audioFile = audioFile else { return }
        
        self.updateState(.Prepare)
        engine.attach(playerNode)
        
        let effectFile = try! AVAudioFile(forReading: effectFilePath)
        let effectFormat = effectFile.processingFormat
        let effectCapaicty = AVAudioFrameCount(effectFile.length)
        let effectBuffer = AVAudioPCMBuffer(pcmFormat: effectFormat, frameCapacity: effectCapaicty)!
        try? effectFile.read(into: effectBuffer, frameCount: effectCapaicty)
        
        engine.attach(playerNodeEffect)
        engine.connect(playerNodeEffect, to: engine.mainMixerNode, format: effectFile.processingFormat)
        
        let effect = AVAudioUnitTimePitch()
        effect.rate = 0.9
        effect.pitch = -300
        engine.attach(effect)
        
        let effect2 = AVAudioUnitReverb()
        effect2.loadFactoryPreset(.cathedral)
        effect2.wetDryMix = 40
        engine.attach(effect2)

//        if engine.isRunning {
//            engine.stop()
//        }
//        engine.disconnectNodeInput(playerNode)
//        engine.disconnectNodeOutput(playerNode)
//        engine.detach(playerNode)
        
        engine.connect(playerNodeEffect, to: effect, format: effectFile.processingFormat)
        engine.connect(effect, to: effect2, format: effectFile.processingFormat)
        engine.connect(effect2, to: engine.mainMixerNode, format: effectFile.processingFormat)
        engine.connect(playerNode, to: engine.mainMixerNode, format: audioFile.processingFormat)
        
        engine.prepare()
        try? engine.start()
        
        playerNodeEffect.scheduleBuffer(effectBuffer) {
        }
        
        let format = audioFile.processingFormat
        let capacity = AVAudioFrameCount(audioFile.length)
        let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: capacity)!
        try? audioFile.read(into: buffer, frameCount: capacity)
        playerNode.scheduleBuffer(buffer) { [weak self] in
            guard let self = self else { return }
            self.updateState(.Init)
        }
    }
    
    public func play() {
        
        playerNode.volume = 1.0
        playerNode.play()
        updateState(.Playing)
        
        if useEffect {
            playerNode.pan = -0.5
            playerNodeEffect.pan = 0.5
            playerNodeEffect.volume = 0.5
            playerNodeEffect.play()
        }
    }
    
    public func pause() {
        playerNode.pause()
        updateState(.Pause)
        
        if useEffect {
            playerNodeEffect.pause()
        }
    }
    
    public func seekToTime(_ time: Float) {
        
        print("seekToTime: \(time)")
        
        guard let audioFile = audioFile else { return }
        
        playerNode.stop()
        playerNode.reset()
                
        let format = audioFile.processingFormat
        let capacity = AVAudioFrameCount(audioFile.length)
        let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: capacity)!
        try? audioFile.read(into: buffer, frameCount: capacity)
        
        let framePosition = AVAudioFramePosition(Double(time) * audioFile.processingFormat.sampleRate)
        
//        playerNode.scheduleBuffer(buffer)
        playerNode.scheduleSegment(audioFile, startingFrame: framePosition, frameCount: (capacity - UInt32(framePosition)), at: nil)
        
        
        playerNode.play()
    }
}
