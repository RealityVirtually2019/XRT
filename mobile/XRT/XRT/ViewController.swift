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

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        //sceneView.scene = SCNScene(named: "art.scnassets/chinese_painting.scn")!
//        let scene = SCNScene(named: "VanGogh.dae", inDirectory: "art.scnassets")
//        let ship = scene!.rootNode.childNode(withName: "SM_OilPaint", recursively: true)
//        // ship!.simdPosition = float3(0, 0, -1)
//        ship!.position.z = -8
//        // half a meter in front of the *initial* camera position
//        sceneView.scene.rootNode.addChildNode(ship!)
        
        // AR auto adds light to the scene?
        sceneView.autoenablesDefaultLighting = true
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

            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)

            let planeNode = SCNNode(geometry: plane)

            planeNode.eulerAngles.x = -.pi / 2

            node.addChildNode(planeNode)

            if imageAnchor.referenceImage.name == "starry-night" {
                if let paintingScene = SCNScene(named: "art.scnassets/VanGogh_2.dae") {

                    if let paintingNode = paintingScene.rootNode.childNodes.first {
                        print(paintingNode.position)
                        print(paintingNode.scale)

                        //paintingNode.eulerAngles.x = .pi / 2

                        planeNode.addChildNode(paintingNode)
                    }
                }
            }
        }
        return node
    }
}
