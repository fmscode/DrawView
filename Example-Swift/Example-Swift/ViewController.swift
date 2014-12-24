//
//  ViewController.swift
//  Example-Swift
//
//  Created by Frank Michael on 12/24/14.
//  Copyright (c) 2014 Frank Michael Sanchez. All rights reserved.
//

import UIKit

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

