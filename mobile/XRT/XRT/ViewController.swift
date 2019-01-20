//
//  ViewController.swift
//  XRT
//
//  Created by Travis Ho on 1/19/19.
//  Copyright © 2019 Travis Ho. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

enum SoundType {
    case lotus
    case starry
}

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        // AR auto adds light to the scene?
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func playSound(soundType: SoundType) {
        let url = soundType == .lotus ? Bundle.main.url(forResource: "lotus_anim", withExtension: "wav") : Bundle.main.url(forResource: "starry_anim", withExtension: "wav")
        if (player != nil) {
            player?.stop()
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url!, fileTypeHint: AVFileType.wav.rawValue)
            //player?.numberOfLoops = -1
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Paintings", bundle: Bundle.main) {
            
            configuration.trackingImages = imageToTrack
            
            configuration.maximumNumberOfTrackedImages = 2
        }
        sceneView.session.run(configuration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {

        let node = SCNNode()

        if let imageAnchor = anchor as? ARImageAnchor {

            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)

            plane.firstMaterial?.diffuse.contents = UIColor.clear

            let planeNode = SCNNode(geometry: plane)

            planeNode.eulerAngles.x = -.pi / 2

            node.addChildNode(planeNode)

            if imageAnchor.referenceImage.name == "starry-night" {
                if let paintingScene = SCNScene(named: "art.scnassets/StarryTrial03.dae") {
                    playSound(soundType: .starry)
                    let paintingNode = SCNNode()
                    
                    for child in paintingScene.rootNode.childNodes {
                        paintingNode.addChildNode(child)
                    }
                    paintingNode.scale = SCNVector3(2.0, 2.0, 2.0)
                    
                    // Add the node to the scene
                    planeNode.addChildNode(paintingNode)
                }
            }
            if imageAnchor.referenceImage.name == "lotus" {
                if let paintingScene = SCNScene(named: "art.scnassets/lotus.scn") {
                    playSound(soundType: .lotus)
                    
                    let paintingNode = SCNNode()
                    
                    for child in paintingScene.rootNode.childNodes {
                        paintingNode.addChildNode(child)
                    }
                    paintingNode.scale = SCNVector3(2.0, 2.0, 2.0)
                    
                    // Add the node to the scene
                    planeNode.addChildNode(paintingNode)
                }
            }
        }
        return node
    }
}
