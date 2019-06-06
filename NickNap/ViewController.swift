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
    
    var player: AVAudioPlayer!

    var seconds = 60
    var timer = Timer()
    var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let path = Bundle.main.path(forResource: "42-Rain-10min", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.numberOfLoops = -1
        } catch let error as NSError {
            print(error.description)
        }

    }

    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        time.text = "\(seconds)" //This will update the label.
    }
    
    
    @IBAction func m25(_ sender: Any) {
        runTimer()
    }
    

    @IBAction func m95(_ sender: Any) {
        runTimer()
    }
    
    
    @IBAction func ma(_ sender: Any) {
        runTimer()
        player.play()
    }
    
    
    @IBAction func pause(_ sender: Any) {
        player.pause()
    }
    
    
    @IBAction func stop(_ sender: Any) {
        player.stop()
    }
    
    
}

