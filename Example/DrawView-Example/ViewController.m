//
//  ViewController.m
//  DrawView-Example
//
//  Created by Frank Michael on 4/8/14.
//  Copyright (c) 2014 Frank Michael Sanchez. All rights reserved.
//

#import "ViewController.h"
#import <DrawView.h>
@interface ViewController () {
    IBOutlet DrawView *drawingView;
}

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [drawingView setBackgroundColor:[UIColor whiteColor]];
    [drawingView strokeColor:[UIColor blackColor]];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
