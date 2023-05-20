//
//  ViewController.swift
//  test
//
//  Created by Nadya Tyandra on 17/05/23.
//

import UIKit

class ViewController: UIViewController {
    
//    @IBAction func tapAction(_ sender: Any) {
//        print("Hello World")
//    }
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    let QuoteArray = [
        "satu",
        "dua",
        "tiga"
    ]
    
    @IBAction func tapAction(_ sender: Any) {
        print("Hello")
    }
    
    // timer
    var time = 10
    var timer = Timer()
    
    @IBOutlet weak var lbl: UILabel?
    
    @IBAction func start(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.action), userInfo: nil, repeats: true)
    }
    
    @IBAction func pause(_ sender: Any) {
        timer.invalidate()
    }
    
    @IBAction func reset(_ sender: Any) {
        timer.invalidate()
        time = 10
        lbl?.text = "10"
    }
    
    @objc func action() {
        time -= 1
//        lbl?.text = String(time)
        lbl?.text = timeFormatted(time)
        
        if time == 4 {
            print("4")
            timer.invalidate()
            lbl?.text = "Go!"
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let milliseconds: Int = (totalSeconds * 1000) / 1000
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d.%03d", minutes, seconds, milliseconds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let randomIndex = Int(arc4random_uniform(UInt32(QuoteArray.count)))
//        let randomItem = QuoteArray[randomIndex]
//        
//        label.text = randomItem
//        
//        label.isUserInteractionEnabled = true
//        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
//        label.addGestureRecognizer(tapGesture)
    }

    @objc func tapGesture() {
        let randomIndex = Int(arc4random_uniform(UInt32(QuoteArray.count)))
        let randomItem = QuoteArray[randomIndex]
        
        label.text = randomItem
    }
}
