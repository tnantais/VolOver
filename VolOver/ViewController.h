//
//  ViewController.h
//  VolOver
//
//  Created by Owen McGirr on 14/01/2013.
//  Copyright (c) 2013 Owen McGirr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CALayer.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CustomButton.h"

@interface ViewController : UIViewController
{
	
	
	// outlets 
	
    __weak IBOutlet UISlider *volSlider;
    __weak IBOutlet UIImageView *backgroundView;
    __weak IBOutlet CustomButton *muteButton;
    __weak IBOutlet CustomButton *lowerButton;
    __weak IBOutlet CustomButton *higherButton;
    NSTimer *startTimer; // This is to initialise the volume on launch.
	
	
	// variables
	
    float currentValue; // This is for returning to the original volume after Mute.
	
	
}


// actions

- (IBAction)vMuteAct:(id)sender;
- (IBAction)vUpAct:(id)sender;
- (IBAction)vDownAct:(id)sender;
- (IBAction)volChanged:(id)sender;


@end
