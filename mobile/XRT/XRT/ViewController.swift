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
        
        // AR auto adds light to the scene?
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
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
