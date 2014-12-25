//
//  ViewController.m
//  DrawView-Example
//
//  Created by Frank Michael on 4/8/14.
//  Copyright (c) 2014 Frank Michael Sanchez. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController () <UIActionSheetDelegate> {
    IBOutlet DrawView *drawingView;
}
- (IBAction)loadArchived:(id)sender;
- (IBAction)saveDrawing:(id)sender;
- (IBAction)animateDrawing:(id)sender;
- (IBAction)signatureMode:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Drawing View";
    UIBarButtonItem *animateButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:drawingView action:@selector(clearDrawing)];
    self.navigationItem.rightBarButtonItem = animateButton;
    UIBarButtonItem *archivedButton = [[UIBarButtonItem alloc] initWithTitle:@"Load" style:UIBarButtonItemStylePlain target:self action:@selector(loadArchived:)];
    self.navigationItem.leftBarButtonItem = archivedButton;
    // Drawing view setup.
    drawingView.strokeColor = [UIColor redColor];
    drawingView.strokeWidth = 25.0f;
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loadArchived:(id)sender{
    // Load an archived array of bezier paths
    UIBezierPath *path = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"test-path" ofType:@"txt"]];
    // Display archived path.
    [drawingView drawBezier:path];
}
- (IBAction)animateDrawing:(id)sender{
    [drawingView animatePath];
}
- (IBAction)saveDrawing:(id)sender{
    UIActionSheet *saveSheet = [[UIActionSheet alloc] initWithTitle:@"Save" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera Roll",@"UIImage",@"UIBezierPath", nil];
    [saveSheet showInView:self.view];
}
- (IBAction)signatureMode:(id)sender{
    [drawingView setMode:SignatureMode];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [drawingView refreshCurrentMode];
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex != actionSheet.cancelButtonIndex){
        if (buttonIndex == 0){
            UIImage *drawingImage = [drawingView imageRepresentation];
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageToSavedPhotosAlbum:drawingImage.CGImage orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error) {
                NSLog(@"%@",assetURL);
                NSLog(@"%@",error);
            }];
        }else if (buttonIndex == 1){
            UIImage *drawingImage = [drawingView imageRepresentation];
            NSLog(@"%@",drawingImage);
        }else if (buttonIndex == 2){
            UIBezierPath *path = [drawingView bezierPathRepresentation];
            NSLog(@"%@",path);
        }
    }
}
@end
