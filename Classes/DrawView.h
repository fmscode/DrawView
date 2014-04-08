//
//  DrawView.h
//  DrawView
//
//  Created by Frank Michael on 4/8/14.
//  Copyright (c) 2014 Frank Michael Sanchez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

@property (nonatomic) BOOL canEdit;

- (void)drawPath:(CGPathRef)path;
- (void)drawBezier:(UIBezierPath *)path;
- (void)animatePath;

- (void)backgroundColor:(UIColor *)color;
- (void)strokeColor:(UIColor *)color;

@end
