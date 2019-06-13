//
//  ViewController.swift
//  NickNap
//
//  Created by Nicholas Jenkins on 6/6/19.
//  Copyright © 2019 Nicholas Jenkins. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var pause: UIButton!
    @IBOutlet weak var stop: UIButton!
    
    @IBOutlet weak var m25: UIButton!
    @IBOutlet weak var m95: UIButton!
    @IBOutlet weak var ma: UIButton!
    
    var STATE:Int = 0
    // I'd like to replace this with an enum but got stuck
    // Ready = 0
    // Active = 1
    // Alarmed = 2
    // Stopped = 3
    // Paused = 4
    
    
    var player = AVAudioPlayer()
    var player2 = AVAudioPlayer()

    var seconds = 60 * 30 * 17 // 8.5 hours
    var timer = Timer()
    var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let path_rain = Bundle.main.path(forResource: "42-Rain-10min", ofType: "mp3")!
        let url_rain = URL(fileURLWithPath: path_rain)
        do {
            player = try AVAudioPlayer(contentsOf: url_rain)
            player.prepareToPlay
            player.numberOfLoops = -1
        } catch let error as NSError {
            print(error.description)
        }

        var audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback, options: AVAudioSession.CategoryOptions.mixWithOthers)
        } catch {}
        
        let path_alarm = Bundle.main.path(forResource: "alarm", ofType: "mp3")!
        let url_alarm = URL(fileURLWithPath: path_alarm)
        do {
            player2 = try AVAudioPlayer(contentsOf: url_alarm)
            player2.prepareToPlay
            player2.numberOfLoops = -1
        } catch let error as NSError {
            print(error.description)
        }
        
        
    }

    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        time.text = timeString(time: TimeInterval(seconds))
        if seconds <= 0 {
            STATE = 2
            manage_states(msg: "alarmed")
        }
    }
    
    
    func disableNapButtons() {
        m25.isEnabled = false
        m95.isEnabled = false
        ma.isEnabled = false
    }
    
    func enableNapButtons() {
        m25.isEnabled = true
        m95.isEnabled = true
        ma.isEnabled = true
    }

    func disableControlButtons() {
        pause.isEnabled = false
        stop.isEnabled = false
    }

    func enableControlButtons() {
        pause.isEnabled = true
        stop.isEnabled = true
    }

    
    
    @IBAction func m25(_ sender: Any) {manage_states(msg: "m25")}
    @IBAction func m95(_ sender: Any) {manage_states(msg: "m95")}
    @IBAction func ma(_ sender: Any) {manage_states(msg: "ma")}
    @IBAction func pause(_ sender: Any){manage_states(msg: "pause")}
    @IBAction func stop(_ sender: Any) {manage_states(msg: "stop")}

    func manage_states(msg: String){
        if STATE == 0 { // Ready
            if msg == "m25" {
                seconds = 25 // * 60
            } else if msg == "m95" {
                seconds = 95 * 60
            }

            if msg == "m25" || msg == "m95" || msg == "ma" {
                enableControlButtons()
                disableNapButtons()
                player.play()
                STATE = 1
                runTimer()

            }
        }
        else if STATE == 1 { // Active
            if msg == "stop" {
                timer.invalidate()
                player.stop()
                stop.setTitle("Reset", for: .normal)
                STATE = 3
            } else if msg == "pause" {
                timer.invalidate()
                player.pause()
                pause.setTitle("Resume", for: .normal)
                STATE = 4
            }
        }
        else if STATE == 2 { // Alarmed
            if msg == "alarmed" {
                player.stop()
                timer.invalidate()
                player2.play()
            }
            if msg == "stop" {
                stop.setTitle("Reset", for: .normal)
                player2.stop()
                STATE = 3
            }
        }
        else if STATE == 3 { // Stopped
            if msg == "stop" {
                stop.setTitle("Stop", for: .normal)
                enableNapButtons()
                seconds = 0
                time.text = timeString(time: TimeInterval(seconds))
                seconds = 60 * 30 * 17 // 8.5 hours
                disableControlButtons()
                STATE = 0
            }
        }
        else if STATE == 4 { // Paused
            if msg == "pause" {
                pause.setTitle("Pause", for: .normal)
                runTimer()
                player.play()
                STATE = 1
            }
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
}

