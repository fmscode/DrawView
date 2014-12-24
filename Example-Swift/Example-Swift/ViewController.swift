//
//  ViewController.swift
//  Example-Swift
//
//  Created by Frank Michael on 12/24/14.
//  Copyright (c) 2014 Frank Michael Sanchez. All rights reserved.
//

import UIKit
import AssetsLibrary

class ViewController: UIViewController {

    @IBOutlet weak var mainDrawView: DrawView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mainDrawView.drawingMode = .Signature
        // Need to do a refresh since the view has adapted to the current device size.
        self.mainDrawView.refreshCanvas()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.mainDrawView.refreshCanvas()
    }
    // MARK: Class Actions
    
    @IBAction func undo(sender: AnyObject) {
        self.mainDrawView.undoLastPath()
    }
    @IBAction func signatureMode(sender: AnyObject) {
        if self.mainDrawView.drawingMode == .Signature {
            self.mainDrawView.drawingMode = .Default
        }else{
            self.mainDrawView.drawingMode = .Signature
        }
    }
    @IBAction func saveCanvas(sender: AnyObject) {
        let saveAction = UIAlertController(title: "Draw View Saving", message: "", preferredStyle: .ActionSheet)
        saveAction.addAction(UIAlertAction(title: "Save to Camera Roll", style: .Default, handler: { (action: UIAlertAction!) -> Void in
            let canvasImage = self.mainDrawView.imageRepresentation()
            let cameraRoll = ALAssetsLibrary()
            cameraRoll.writeImageToSavedPhotosAlbum(canvasImage.CGImage, orientation: .Up, completionBlock: { (assetURL: NSURL!, error: NSError!) -> Void in
                NSLog("\(assetURL)")
                NSLog("\(error)")
            })
        }))
        saveAction.addAction(UIAlertAction(title: "Save as UIImage", style: .Default, handler: { (action: UIAlertAction!) -> Void in
            let canvasImage = self.mainDrawView.imageRepresentation()
            NSLog("\(canvasImage)")
        }))
        saveAction.addAction(UIAlertAction(title: "Save as UIBezierPath", style: .Default, handler: { (action: UIAlertAction!) -> Void in
            let canvasPath = self.mainDrawView.bezierPathRepresentation()
            NSLog("\(canvasPath)")
        }))
        saveAction.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(saveAction, animated: true, completion: nil)
    }
    @IBAction func animate(sender: AnyObject) {
        self.mainDrawView.animateCanvas()
    }
    // For iOS 7 support
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.mainDrawView.refreshCanvas()
    }
    // For iOS 8 support
    override func viewDidLayoutSubviews() {
        self.mainDrawView.refreshCanvas()
    }


}

