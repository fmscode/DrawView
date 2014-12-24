# DrawView
Subclass of UIView that supports drawing.

![](readmeassets/screen_shot_3.png)

# Installation
Using CocoaPods

    pod "DrawView"

To install without CocoaPods, drag the DrawView.h/.m from the classes folder to your project.

### Swift Installation
To use DrawView in a Swift project you will need to drag the ```DrawView.swift``` file in the Classes folder to your project. If you were using the Objective-C version some of the function names have been changed for clarity. The Swift version of DrawView should be considered a Beta.

# Usage
In the storyboard under the views Identity Inspector set the view class to ```DrawView```. 

![](readmeassets/screen_shot_1.png)

In the implementation file you can setup the drawing view. 

    drawingView.strokeColor = [UIColor blackColor];
    drawingView.strokeWidth = 25.0f;
    
Since DrawView is a subclass of UIView the background of the view can be changed by altering the view's ```backgroundColor``` property.

## Drawing Existing Paths
You can draw either an existing ```UIBezierPath``` or ```CGPathRef``` by calling either of the following methods.

    - (void)drawBezier:(UIBezierPath *)path;
    - (void)drawPath:(CGPathRef)path;

## Animating Path
To animate the current path in the draw view:
	
    - (void)animatePath;

## Undo Support
To support undo, add a button with a target to the ```DrawView``` instance, and set the action to ```undoDrawing:```. See example project for more details.

## Signature Mode
To enable signature mode call ```setMode:``` and pass in the ```SignatureMode``` mode type. This will give you a simple signature UI for the user to use while signing on the device.

![](readmeassets/screen_shot_4.png)

## Reading Drawing View
There are two ways to read what is currently in the drawing view. Either call ```imageRepresentation``` which will return an UIImage that can be later used in an email or saved to the user's Camera Roll. Or call ```bezierPathRepresentation``` which returns a single bezier path that can be archived and restored within your app. See the example project for more information.

    // How to read the drawing view into an image and save to the camera roll.
    UIImage *drawingImage = [drawingView imageRepresentation];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:drawingImage.CGImage orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error) {
        NSLog(@"%@",assetURL);
        NSLog(@"%@",error);
    }];

## Debugging Drawing
To debug the path set ```debugBox``` to ```true```. This will add a grey box around the bounds of the current path.

![](readmeassets/screen_shot_2.png)
