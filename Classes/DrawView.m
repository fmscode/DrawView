//
//  DrawView.m
//  DrawView
//
//  Created by Frank Michael on 4/8/14.
//  Copyright (c) 2014 Frank Michael Sanchez. All rights reserved.
//

#import "DrawView.h"

@interface DrawView () {
    NSMutableArray *paths;
    UIBezierPath *bezierPath;
    CAShapeLayer *animateLayer;
    BOOL isAnimating;
    BOOL isDrawingExisting;
    UIColor *strokeColor;
}
- (IBAction)undoDrawing:(id)sender;

@end

@implementation DrawView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupUI];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    paths = [NSMutableArray new];
    self.backgroundColor = [UIColor blackColor];
    strokeColor = [UIColor redColor];
    _canEdit = YES;
}
- (void)backgroundColor:(UIColor *)color{
    self.backgroundColor = color;
}
- (void)strokeColor:(UIColor *)color{
    strokeColor = color;
}
- (void)drawRect:(CGRect)rect{
    // Drawing code
    if (!isAnimating){
        [[UIColor redColor] setStroke];
        if (!isDrawingExisting){
            for (UIBezierPath *path in paths){
                [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
            }
        }else{
            [bezierPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
        }
    }
}
- (void)drawPath:(CGPathRef)path{
    isDrawingExisting = YES;
    
    bezierPath = [UIBezierPath new];
    bezierPath.CGPath = path;
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineWidth = 10.0f;
    bezierPath.miterLimit = 0.0f;
    // If iPad apply the scale first so the paths bounds is in its final state.
    if ([[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound){
        [bezierPath setLineWidth:20.0];
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(2, 2);
        [bezierPath applyTransform:scaleTransform];
    }
    // Center the character within the view.
    // Center character
    CGRect charBounds = bezierPath.bounds;
    CGFloat charX = CGRectGetMidX(charBounds);
    CGFloat charY = CGRectGetMidY(charBounds);
    CGRect cellBounds = self.bounds;
    CGFloat centerX = CGRectGetMidX(cellBounds);
    CGFloat centerY = CGRectGetMidY(cellBounds);
    
    [bezierPath applyTransform:CGAffineTransformMakeTranslation(centerX-charX, centerY-charY)];
    
    // Debugging bounds view.
    UIView *blockView = [[UIView alloc] initWithFrame:CGRectMake(bezierPath.bounds.origin.x, bezierPath.bounds.origin.y, bezierPath.bounds.size.width, bezierPath.bounds.size.height)];
    [blockView setBackgroundColor:[UIColor blackColor]];
    [blockView setAlpha:0.5];
//    [self addSubview:blockView];
}
- (void)drawBezier:(UIBezierPath *)path{
    [self drawPath:path.CGPath];
}
#pragma mark - Animation
- (void)animatePath{
    isAnimating = YES;
    [self setNeedsDisplay];
    animateLayer = [[CAShapeLayer alloc] init];
    animateLayer.frame = self.frame;
    animateLayer.strokeColor = [[UIColor redColor] CGColor];
    animateLayer.lineWidth = 10.0;
    animateLayer.miterLimit = 0;
    animateLayer.lineCap = @"round";
    [animateLayer setPath:bezierPath.CGPath];
    CABasicAnimation *animation = [[CABasicAnimation alloc] init];
    animation.duration = 4.0;
    animation.fromValue = @(0.0f);
    animation.toValue = @(1.0f);
    animation.delegate = self;
    [animateLayer addAnimation:animation forKey:@"strokeEnd"];
    [self.layer addSublayer:animateLayer];
}
- (IBAction)undoDrawing:(id)sender{
    [paths removeLastObject];
    [self setNeedsDisplay];
}
#pragma mark - Animation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    isAnimating = NO;
    [animateLayer removeFromSuperlayer];
    animateLayer = nil;
    [self setNeedsDisplay];
}
#pragma mark - Touch Detecting
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_canEdit){
        bezierPath = [[UIBezierPath alloc] init];
        [bezierPath setLineCapStyle:kCGLineCapRound];
        [bezierPath setLineWidth:10.0];
        [bezierPath setMiterLimit:0];
        
        UITouch *currentTouch = [[touches allObjects] objectAtIndex:0];
        [bezierPath moveToPoint:[currentTouch locationInView:self]];
        [paths addObject:bezierPath];
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_canEdit){
        UITouch *movedTouch = [[touches allObjects] objectAtIndex:0];
        [bezierPath addLineToPoint:[movedTouch locationInView:self]];
        [self setNeedsDisplay];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

@end
