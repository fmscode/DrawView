//
//  DrawView.swift
//  Example-Swift
//
//  Created by Frank Michael on 12/24/14.
//  Copyright (c) 2014 Frank Michael Sanchez. All rights reserved.
//

import UIKit

class DrawView: UIView {
    // Drawing Mode enum
    enum DrawingMode {
        case Default
        case Signature
    }
    enum EditingMode {
        case None
        case Editable
    }
    var drawingMode: DrawingMode = .Default {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var editingMode: EditingMode = .Editable
    var strokeColor: UIColor = UIColor.blackColor()
    var strokeWidth: CGFloat = 25.0
    var debugingBox: Bool = false
    var animationDuration: Double = 3.0
    private var paths: [UIBezierPath] = []
    private var bezierPath: UIBezierPath = UIBezierPath()
    private var signLine: UIBezierPath?
    private var existingPath: CGPathRef?
    private var animationLayer: CAShapeLayer?
    private var isAnimating: Bool = false
    // MARK: Init
    override init() {
        super.init()
        self.setupCanvas()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCanvas()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupCanvas()
    }
    // MARK: Class setup
    private func setupCanvas() {
        self.backgroundColor = UIColor.whiteColor()
        self.signLine = UIBezierPath()
        self.signLine?.lineCapStyle = kCGLineCapRound
        self.signLine?.lineWidth = 3.0
        // Draw the "x" for the line
        self.signLine?.moveToPoint(CGPointMake(20.0, self.frame.size.height-30.0))
        self.signLine?.addLineToPoint(CGPointMake(30.0, self.frame.size.height-40.0))
        self.signLine?.moveToPoint(CGPointMake(30.0, self.frame.size.height-30.0))
        self.signLine?.addLineToPoint(CGPointMake(20.0, self.frame.size.height-40.0))
        // Draw the actual line for the signature mode
        self.signLine?.moveToPoint(CGPointMake(20.0, self.frame.size.height-20.0))
        self.signLine?.addLineToPoint(CGPointMake(self.frame.size.width-20.0, self.frame.size.height-20.0))
        self.setNeedsDisplay()
    }
    override func drawRect(rect: CGRect) {
        if !isAnimating{
            self.strokeColor.setStroke()
            if let existing = self.existingPath {
                self.bezierPath.strokeWithBlendMode(kCGBlendModeNormal, alpha: 1.0)
            }else{
                for path in self.paths{
                    path.strokeWithBlendMode(kCGBlendModeNormal, alpha: 1.0)
                }
            }
        }
        
        if self.drawingMode == .Signature {
            UIColor.lightGrayColor().setStroke()
            self.signLine?.strokeWithBlendMode(kCGBlendModeNormal, alpha: 1.0)
        }
    }
    // MARK: Public Functions
    func drawPath(path: CGPathRef) {
        self.editingMode = .None
        self.existingPath = path
        
        self.bezierPath = UIBezierPath()
        self.bezierPath.CGPath = self.existingPath!
        self.bezierPath.lineCapStyle = kCGLineCapRound
        self.bezierPath.lineWidth = self.strokeWidth
        self.bezierPath.miterLimit = 0.0
        // If iPad, apply the scale first so the paths bounds is in its final state.
        // Center the drawing within the view
        let pathBounds = self.bezierPath.bounds
        let pathXMid = CGRectGetMidX(pathBounds)
        let pathYMid = CGRectGetMidY(pathBounds)
        let viewBounds = self.bounds
        let viewCenterX = CGRectGetMidX(viewBounds)
        let viewCenterY = CGRectGetMidY(viewBounds)
        
        self.bezierPath.applyTransform(CGAffineTransformMakeTranslation((viewCenterX-pathXMid), (viewCenterY-pathYMid)))
        self.setNeedsDisplay()
        
        if self.debugingBox {
            let blockView = UIView(frame: CGRectMake(self.bezierPath.bounds.origin.x, self.bezierPath.bounds.origin.y, self.bezierPath.bounds.size.width, self.bezierPath.bounds.size.height))
            blockView.backgroundColor = UIColor.blackColor()
            blockView.alpha = 0.5
            self.addSubview(blockView)
        }
    }
    func drawBezierPath(path: UIBezierPath) {
        self.drawPath(path.CGPath)
    }
    func clearCanvas() {
        self.bezierPath = UIBezierPath()
        self.paths.removeAll(keepCapacity: false)
        self.setNeedsDisplay()
        self.setupCanvas()
    }
    func refreshCanvas() {
        self.setupCanvas()
    }
    // MARK Undo support
    func undoLastPath() {
        self.paths.removeLast()
        self.setNeedsDisplay()
    }
    // MARK View Draw Reading
    func imageRepresentation() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size)
        let context = UIGraphicsGetCurrentContext()
        self.layer.renderInContext(context)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return viewImage
    }
    func bezierPathRepresentation() -> UIBezierPath {
        var singleBezierPath = UIBezierPath()
        if self.paths.count > 0 {
            for path in paths {
                singleBezierPath.appendPath(path)
            }
        }else{
            singleBezierPath = self.bezierPath
        }
        return singleBezierPath
    }
    // MARK: Animation
    func animateCanvas() {
        var animatingPath = UIBezierPath()
        if self.editingMode == .Editable {
            for path in self.paths {
                animatingPath.appendPath(path)
            }
        }else{
            animatingPath = self.bezierPath
        }
        // Clear out the existing view
        self.isAnimating = true
        self.setNeedsDisplay()
        // Create shapre layer that stores the path
        self.animationLayer = CAShapeLayer()
        self.animationLayer?.fillColor = nil
        self.animationLayer?.path = animatingPath.CGPath
        self.animationLayer?.strokeColor = self.strokeColor.CGColor
        self.animationLayer?.lineWidth = self.strokeWidth
        self.animationLayer?.miterLimit = 0.0
        self.animationLayer?.lineCap = "round"
        // Create animation of path
        let animation = CABasicAnimation()
        animation.duration = self.animationDuration
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.delegate = self
        self.animationLayer?.addAnimation(animation, forKey: "strokeEnd")
        self.layer.addSublayer(self.animationLayer?)
    }
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        self.isAnimating = false
        self.animationLayer?.removeFromSuperlayer()
        self.animationLayer = CAShapeLayer()
        self.setNeedsDisplay()
    }
    // MARK: Touch Tracking
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if self.editingMode == .Editable {
            self.bezierPath = UIBezierPath()
            self.bezierPath.lineCapStyle = kCGLineCapRound
            self.bezierPath.lineWidth = self.strokeWidth
            self.bezierPath.miterLimit = 0.0
            
            let touch = touches.allObjects[0] as UITouch
            bezierPath.moveToPoint(touch.locationInView(self))
            self.paths.append(self.bezierPath)
        }
    }
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if self.editingMode == .Editable {
            let touch = touches.allObjects[0] as UITouch
            self.bezierPath.addLineToPoint(touch.locationInView(self))
            self.setNeedsDisplay()
        }
    }
}
