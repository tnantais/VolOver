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
    __weak IBOutlet UIBarButtonItem *playpauseButton;
    __weak IBOutlet UISlider *volSlider;
    BOOL firstloadComplete; // This is for checking that the app isn't launching in viewDidLoad.
    NSTimer *timer; // This is for checking the music playback state and returning the right style to the Play button.
    float currentValue; // This is for returning to the original volume after Mute and Full.
}
- (IBAction)playpauseAct:(id)sender;
- (IBAction)exitHelp:(id)sender;
- (IBAction)vFullAct:(id)sender;
- (IBAction)vMuteAct:(id)sender;
- (IBAction)vUpAct:(id)sender;
- (IBAction)vDownAct:(id)sender;
- (IBAction)volChanged:(id)sender;
@end
