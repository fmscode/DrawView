# DrawView
Subclass of UIView that supports drawing.

![](readmeassets/screen_shot_3.png)

# Basic Usage
Using CocoaPods

	pod "DrawView"

In the storyboard under the views Identity Inspector set the view class to ```DrawView```. 

![](readmeassets/screen_shot_1.png)

In the implementation file you can setup the drawing view. 

	[drawingView setBackgroundColor:[UIColor whiteColor]];
	[drawingView strokeColor:[UIColor blackColor]];

# Usage
## Drawing Existing Paths
You can draw either a existing ```UIBezierPath``` or ```CGPathRef``` by calling either of the following methods respectively.

	- (void)drawBezier:(UIBezierPath *)path;
	- (void)drawPath:(CGPathRef)path;

## Animating Path
To animate the current path in the draw view simply call
	
	- (void)animatePath;

## Undo Support
To support undo simply add a button with a target to the ```DrawView``` instance, and set the action to ```undoDrawing:```. See example for more details.

## Debugging Drawing
To debug the path simply set ```debugBox``` to ```true```. This will add a grey box around the bounds of the current path.

![](readmeassets/screen_shot_2.png)

## Reading Drawing View
There are two ways to read what is currently in the drawing view. Either call ```imageRepresentation``` which will return a UIImage that can be later used in a email or to save to the users Camera Roll. Or call ```bezierPathRepresentation``` which returns a single bezier path that can be archived and restored within your app. See the example project for more information.

			// How to read the drawing view into a image and save to the camera roll.
            UIImage *drawingImage = [drawingView imageRepresentation];
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageToSavedPhotosAlbum:drawingImage.CGImage orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error) {
                NSLog(@"%@",assetURL);
                NSLog(@"%@",error);
            }];
