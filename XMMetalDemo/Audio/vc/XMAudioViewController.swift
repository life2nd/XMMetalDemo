//
//  XMAudioViewController.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/1/3.
//

import UIKit
import Combine
import AVFoundation

class XMAudioViewController: UIViewController {

    @IBOutlet weak var audioBrife: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var skipPreBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var skipNextBtn: UIButton!
    
    let audioPlayer = XMAudioPlayer()
    var streamPlayer: AudioStreamPlayer!
    
    var cancellables = Set<AnyCancellable>()
    
    deinit {
        cancellables.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAudioSession()
        customInit()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }

    
    @IBAction func progressValueChanged(_ sender: Any) {
    }
    
    @IBAction func clickSkipPreAction(_ sender: Any) {
        let time = self.currentPlayer().currentTime() - 10
        self.currentPlayer().seekToTime(time)
    }
    
    @IBAction func clickPlayAction(_ sender: Any) {
        
//        useStreamPlayer()
        mp3ToPCMData()
        
        /*
        if self.currentPlayer().status == .Playing {
            self.currentPlayer().pause()
        }
        else if self.currentPlayer().status == .Pause {
            self.currentPlayer().play()
        }
        else {
            guard let filePath = Bundle.main.url(forResource: "富士山下", withExtension: "mp3") else { return }
//            guard let filePathEffect = Bundle.main.url(forResource: "花开忘忧", withExtension: "mp3") else { return }
            
            self.currentPlayer().initWithFilePath(filePath)
//            self.currentPlayer().initWithEffectFilePath(filePath, filePathEffect)
            self.currentPlayer().play()
        }
         */
    }
    
    @IBAction func clickSkipNextAction(_ sender: Any) {
        let time = self.currentPlayer().currentTime() + 10
        self.currentPlayer().seekToTime(time)
    }
    
    @IBAction func handleSeekAction(_ sender: Any) {
    }
    
    
    fileprivate func customInit() {
        
        streamPlayer = AudioStreamPlayer()
        
        self.currentPlayer().publisher.sink { [weak self] newStatus in
            guard let self = self else { return }
            handlePlayStChanged(newStatus)
        }.store(in: &cancellables)
        
        self.currentPlayer().progressPublisher.sink { [weak self] progress in
            guard let self = self else { return }
            self.progressSlider.value = progress
        }.store(in: &cancellables)
    }
    
    private func currentPlayer() -> XMAudioPlayer {
        return XMAudioPlayer.shared
    }
    
    private func handlePlayStChanged(_ status: XMAudioPlayerStatus) {
        
        // 播放按钮的状态变更
        if status == .Playing {
            let image = UIImage(systemName: "pause")
            DispatchQueue.main.async {
                self.playBtn.setImage(image, for: .normal)
            }
        }
        else {
            let image = UIImage(systemName: "play")
            DispatchQueue.main.async {
                self.playBtn.setImage(image, for: .normal)
            }
        }
        
        if status == .Prepare {
            // 播放信息的更新
            self.audioBrife.text = self.currentPlayer().fileDescripe()
            
            // 音频总时长的更新
            self.progressSlider.minimumValue = 0
            self.progressSlider.maximumValue = self.currentPlayer().fileDuration()
            self.progressSlider.value = self.currentPlayer().currentTime()
        }
    }
    
}

extension XMAudioViewController {
    
    func useStreamPlayer() {
        
//        let url = Bundle.main.url(forResource: "熊猫侦探团", withExtension: "mp3")!
        let url = Bundle.main.url(forResource: "part2", withExtension: "mp3")!
        if let data = try? Data(contentsOf: url) {
//            var config = AudioStreamPlayer.Configuration.default
//            config.sampleRate = 48000.0
//            streamPlayer.configure(with: config)
            streamPlayer.appendAudioData(data)
        }
        
        // 使用示例：
        let frequency = 440.0 // 440Hz (标准A音)
        let duration = 10.0    // 1秒
//        let pcmData = createSineWavePCM(frequency: frequency, duration: duration)
        let pcmData = createWhiteNoisePCM(duration: duration)
        
        // 使用示例
//        let rainGenerator = RainSoundGenerator()

        // 生成不同类型的雨声
//        let duration = 10.0 // 10秒

        // 小雨
//        let lightRain = rainGenerator.createLightRainPCM(duration: duration)

        // 中雨
//        let mediumRain = rainGenerator.createMediumRainPCM(duration: duration)

        // 大雨
//        let heavyRain = rainGenerator.createHeavyRainPCM(duration: duration)

        // 雷雨
//        let thunderstorm = rainGenerator.createThunderstormPCM(duration: duration)
        
//        streamPlayer.appendAudioData(pcmData)
    }
    
    func createSineWavePCM(frequency: Double, duration: Double, sampleRate: Double = 44100) -> Data {
        let amplitude: Float = 0.5
        let numSamples = Int(duration * sampleRate)
        var pcmData = Data()
        
        for i in 0..<numSamples {
            let time = Double(i) / sampleRate
            // 生成正弦波
            let value = Float(sin(2.0 * .pi * frequency * time)) * amplitude
            
            // 将浮点数转换为16位整数
            let int16Value = Int16(value * Float(Int16.max))
            
            // 添加到数据中
            pcmData.append(contentsOf: withUnsafeBytes(of: int16Value) { Array($0) })
        }
        
        return pcmData
    }
    
    func createWhiteNoisePCM(duration: Double, sampleRate: Double = 44100) -> Data {
        let amplitude: Float = 0.5
        let numSamples = Int(duration * sampleRate)
        var pcmData = Data()
        
        for _ in 0..<numSamples {
            // 生成白噪声
            let value = Float.random(in: -1...1) * amplitude
            
            let int16Value = Int16(value * Float(Int16.max))
            pcmData.append(contentsOf: withUnsafeBytes(of: int16Value) { Array($0) })
        }
        
        return pcmData
    }

}


class RainSoundGenerator {
    // 随机水滴声
    private func createDropSound(amplitude: Float, duration: Double, sampleRate: Double) -> [Float] {
        let numSamples = Int(duration * sampleRate)
        var samples = [Float]()
        
        // 水滴声的包络
        let attackTime = 0.001 // 1ms
        let decayTime = 0.05  // 50ms
        
        let attackSamples = Int(attackTime * sampleRate)
        let decaySamples = Int(decayTime * sampleRate)
        
        for i in 0..<numSamples {
            var envelope: Float = 0
            
            if i < attackSamples {
                // Attack
                envelope = Float(i) / Float(attackSamples)
            } else if i < attackSamples + decaySamples {
                // Decay
                let decayProgress = Float(i - attackSamples) / Float(decaySamples)
                envelope = 1.0 - decayProgress
            }
            
            // 使用随机频率创建水滴声
            let frequency = Float.random(in: 1000...4000)
            let time = Double(i) / sampleRate
            let value = sin(2.0 * .pi * Double(frequency) * time)
            
            samples.append(Float(value) * envelope * amplitude)
        }
        
        return samples
    }
    
    // 创建雨声PCM数据
    func createRainPCM(duration: Double, intensity: Float = 0.5, sampleRate: Double = 44100) -> Data {
        let numSamples = Int(duration * sampleRate)
        var rainSamples = Array(repeating: Float(0), count: numSamples)
        
        // 背景白噪声（持续的雨声）
        for i in 0..<numSamples {
            rainSamples[i] = Float.random(in: -0.3...0.3) * intensity
        }
        
        // 添加随机水滴声
        let dropsPerSecond = Int(intensity * 100) // 根据强度确定水滴数量
        let totalDrops = Int(duration) * dropsPerSecond
        
        for _ in 0..<totalDrops {
            // 随机水滴开始时间
            let startTime = Double.random(in: 0..<duration)
            let startSample = Int(startTime * sampleRate)
            
            // 创建单个水滴声
            let dropDuration = Double.random(in: 0.01...0.05)
            let dropAmplitude = Float.random(in: 0.1...0.3) * intensity
            let dropSamples = createDropSound(amplitude: dropAmplitude, duration: dropDuration, sampleRate: sampleRate)
            
            // 将水滴声添加到主采样中
            for (index, sample) in dropSamples.enumerated() {
                let position = startSample + index
                if position < numSamples {
                    rainSamples[position] += sample
                }
            }
        }
        
        // 转换为PCM数据
        var pcmData = Data()
        for sample in rainSamples {
            // 限制采样值在-1到1之间
            let clampedSample = max(-1.0, min(1.0, Float(sample)))
            let int16Value = Int16(clampedSample * Float(Int16.max))
            pcmData.append(contentsOf: withUnsafeBytes(of: int16Value) { Array($0) })
        }
        
        return pcmData
    }
    
    // 创建不同类型的雨声
    func createLightRainPCM(duration: Double) -> Data {
        return createRainPCM(duration: duration, intensity: 0.3)
    }
    
    func createMediumRainPCM(duration: Double) -> Data {
        return createRainPCM(duration: duration, intensity: 0.6)
    }
    
    func createHeavyRainPCM(duration: Double) -> Data {
        return createRainPCM(duration: duration, intensity: 1.0)
    }
    
    // 创建带有雷声的雨声
    func createThunderstormPCM(duration: Double) -> Data {
        var rainData = createHeavyRainPCM(duration: duration)
        
        // 添加雷声
        func createThunder(duration: Double, sampleRate: Double = 44100) -> [Float] {
            let numSamples = Int(duration * sampleRate)
            var samples = [Float]()
            
            for i in 0..<numSamples {
                let time = Double(i) / sampleRate
                
                // 低频轰鸣声
                let lowFreq = sin(2.0 * .pi * 50 * time)
                let midFreq = sin(2.0 * .pi * 120 * time)
                
                // 添加噪声
                let noise = Float.random(in: -1...1)
                
                // 包络
                let envelope = exp(-time * 2) // 指数衰减
                
                let sample = Float(lowFreq * 0.6 + midFreq * 0.3) + noise * 0.1
                samples.append(sample * Float(envelope))
            }
            
            return samples
        }
        
        // 添加几声雷
        let thunderTimes = Int.random(in: 1...3)
        for _ in 0..<thunderTimes {
            let startTime = Double.random(in: 0..<duration)
            let thunderDuration = Double.random(in: 1.0...3.0)
            let thunderSamples = createThunder(duration: thunderDuration)
            
            let startSample = Int(startTime * 44100) * 2 // *2 因为是16位采样
            for (index, sample) in thunderSamples.enumerated() {
                let position = startSample + index * 2
                if position < rainData.count - 1 {
                    let int16Value = Int16(sample * Float(Int16.max))
                    rainData[position] = UInt8(truncatingIfNeeded: int16Value & 0xFF)
                    rainData[position + 1] = UInt8(truncatingIfNeeded: (int16Value >> 8) & 0xFF)
                }
            }
        }
        
        return rainData
    }
}

extension XMAudioViewController {
    func mp3ToPCMData() -> NSData? {
        let decoder = MP3Decoder()
        
        guard let filePathEffect = Bundle.main.path(forResource: "part2", ofType: "mp3") else { return nil }
        let mp3Data = try? decoder.decodeToPCM(inputFile: filePathEffect, outputFile: "")
        streamPlayer.appendAudioData(mp3Data!)
        
        return nil
    }
}
