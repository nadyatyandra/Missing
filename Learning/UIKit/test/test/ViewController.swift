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
