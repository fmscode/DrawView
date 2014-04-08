//
//  DrawView.h
//  DrawView
//
//  Created by Frank Michael on 4/8/14.
//  Copyright (c) 2014 Frank Michael Sanchez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

// If the drawing view can be drawn on. By default canEdit is true.
@property (nonatomic) BOOL canEdit;
// Debug value to add a box around the path when drawing a existing path.
@property (nonatomic) BOOL debugBox;
// Background color of the drawing view.
- (void)backgroundColor:(UIColor *)color;
// The stroke color of the path.
- (void)strokeColor:(UIColor *)color;
// Draw a CGPath that already exists. canEdit is set to false if this is called.
- (void)drawPath:(CGPathRef)path;
// Draw a UIBezierPath that already exists. canEdit is set to false if this is called.
- (void)drawBezier:(UIBezierPath *)path;
// Animate the current path.
- (void)animatePath;

@end
