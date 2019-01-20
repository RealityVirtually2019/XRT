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
    
    func loadAnimations () {
        // Load the character in the idle animation
        let idleScene = SCNScene(named: "art.scnassets/idleFixed.dae")!
        
        // This node will be parent of all the animation models
        let node = SCNNode()
        
        // Add all the child nodes to the parent node
        for child in idleScene.rootNode.childNodes {
            node.addChildNode(child)
        }
        
        // Set up some properties
        node.position = SCNVector3(0, -1, -2)
        node.scale = SCNVector3(0.2, 0.2, 0.2)
        
        // Add the node to the scene
        sceneView.scene.rootNode.addChildNode(node)
        
        // Load all the DAE animations
        loadAnimation(withKey: "dancing", sceneName: "art.scnassets/StarryTrial03", animationIdentifier: "StarryTrial03-1")
    }
    
    func loadAnimation(withKey: String, sceneName:String, animationIdentifier:String) {
//        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
//        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
//
//        if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
//            print(animationObject)
//            // The animation will only play once
//            animationObject.repeatCount = 1
//            // To create smooth transitions between animations
//            animationObject.fadeInDuration = CGFloat(1)
//            animationObject.fadeOutDuration = CGFloat(0.5)
//
//            sceneView.scene.rootNode.addAnimation(animationObject, forKey: nil)
//        }
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
                    
                    // Add all the child nodes to the parent node
                    for child in paintingScene.rootNode.childNodes {
                        paintingNode.addChildNode(child)
                    }
                    //paintingNode.position = SCNVector3(0, -1, -2)
                    paintingNode.scale = SCNVector3(2.0, 2.0, 2.0)
                    
                    // Add the node to the scene
                    planeNode.addChildNode(paintingNode)
                    
                    // Load all the DAE animations
//                    loadAnimation(withKey: "dancing", sceneName: "art.scnassets/StarryTrial03", animationIdentifier: "StarryTrial03-1")
                    //let animation = CABasicAnimation(keyPath: "StarryTrial03-1")
                    //animation.duration
                    let sceneURL = Bundle.main.url(forResource: "art.scnassets/StarryTrial03", withExtension: "dae")
                    let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
                    print(sceneURL)
            
                    if let animationObject = sceneSource?.entryWithIdentifier("StarryTrial03-1", withClass: CAAnimation.self) {
                        print(animationObject)
                        // The animation will only play once
                        animationObject.repeatCount = 1
                        // To create smooth transitions between animations
                        animationObject.fadeInDuration = CGFloat(1)
                        animationObject.fadeOutDuration = CGFloat(0.5)
            
                        sceneView.scene.rootNode.addAnimation(animationObject, forKey: nil)
                        paintingNode.addAnimation(animationObject, forKey: nil)
                    }
                    
//                    if let paintingNode = paintingScene.rootNode.childNodes.first {
//                        //let action = SCNAction.scale(by: 2, duration: 1.0)
//                        paintingNode.scale = SCNVector3Make(2, 2, 2)
//                        //paintingNode.runAction(action)
//                        planeNode.addChildNode(paintingNode)
//                    }
                }
            }
        }
        return node
    }
}
