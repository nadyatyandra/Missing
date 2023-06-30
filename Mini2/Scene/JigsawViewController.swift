//
//  GameViewController.swift
//  Mini2
//
//  Created by Brandon Nicolas Marlim on 6/30/23.
//

//import UIKit
//import SpriteKit
//import GameplayKit
//
//class JigsawViewController: UIViewController {
//
//override func viewDidLoad() {
//    super.viewDidLoad()
//    let filename : String
//    if UIDevice.current.userInterfaceIdiom == .pad {
//        filename = "pieces-iPad.json"
//    } else {
//        filename = "pieces.json"
//    }
//    let scene = JigsawScene.scene(named: "person.json")
//    if let view = self.view as? SKView {
//        view.presentScene(scene)
//        view.ignoresSiblingOrder = true
//        view.showsFPS = true
//        view.showsNodeCount = true
//    }
//}
//
//    override var shouldAutorotate: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .landscape
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//}
