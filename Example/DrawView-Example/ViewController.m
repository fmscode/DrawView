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
- (IBAction)loadArchived:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Drawing View";
    UIBarButtonItem *animateButton = [[UIBarButtonItem alloc] initWithTitle:@"Animate" style:UIBarButtonItemStylePlain target:drawingView action:@selector(animatePath)];
    self.navigationItem.rightBarButtonItem = animateButton;
    UIBarButtonItem *archivedButton = [[UIBarButtonItem alloc] initWithTitle:@"Load" style:UIBarButtonItemStylePlain target:self action:@selector(loadArchived:)];
    self.navigationItem.leftBarButtonItem = archivedButton;
    // Drawing view setup.
    [drawingView setBackgroundColor:[UIColor whiteColor]];
    [drawingView strokeColor:[UIColor blackColor]];
//    [self loadArchived:nil];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loadArchived:(id)sender{
    // Load an archived array of bezier paths
    UIBezierPath *bezPath = [UIBezierPath new];
    NSData *testPath = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"]];
    NSArray *paths = [NSKeyedUnarchiver unarchiveObjectWithData:testPath];
    for (UIBezierPath *path in paths){
        [bezPath appendPath:path];
    }
    // Display archived path.
    [drawingView drawBezier:bezPath];
}
@end
