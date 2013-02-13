//
//  ViewController.h
//  VolOver
//
//  Created by Owen McGirr on 14/01/2013.
//  Copyright (c) 2013 Owen McGirr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController
{
    __weak IBOutlet UIButton *inButton;
    __weak IBOutlet UIButton *decButton;
    __weak IBOutlet UISlider *volSlider;
    BOOL firstloadComplete; // This is for checking that the app isn't launching in viewDidLoad.
    NSTimer *startTimer; // This is to initialise the volume on launch.
    NSTimer *scanning;
    float currentValue; // This is for returning to the original volume after Mute and Full.
}
- (IBAction)refreshAct:(id)sender;
- (IBAction)vFullAct:(id)sender;
- (IBAction)vMuteAct:(id)sender;
- (IBAction)vUpAct:(id)sender;
- (IBAction)vDownAct:(id)sender;
- (IBAction)volChanged:(id)sender;
@end
