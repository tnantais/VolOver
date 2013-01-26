//
//  ViewController.m
//  VolOver
//
//  Created by Owen McGirr on 14/01/2013.
//  Copyright (c) 2013 Owen McGirr. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    MPMusicPlayerController *vControl = [MPMusicPlayerController iPodMusicPlayer];
    [volSlider setValue:vControl.volume];
    currentValue = vControl.volume;
    if (firstloadComplete == NO) {
        if ([vControl playbackState] == MPMusicPlaybackStatePaused) {
            [vControl setVolume:0.0];
            [vControl play];
            [NSThread sleepForTimeInterval:1.0f];
            [vControl pause];
            [vControl setVolume:volSlider.value];
        }
        else if ([vControl playbackState] == MPMusicPlaybackStateStopped) {
            MPMediaQuery *everything = [[MPMediaQuery alloc] init];
            everything = [MPMediaQuery songsQuery];
            [vControl setQueueWithQuery:everything];
            [vControl setVolume:0.0];
            [vControl play];
            [NSThread sleepForTimeInterval:1.0f];
            [vControl pause];
            [vControl setVolume:volSlider.value];
        }
        // These if statements initialise the volume.
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(pbChanged) userInfo:nil repeats:YES]; // See .h for comment.
        firstloadComplete = YES;
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pbChanged { // Selector for timer.
    MPMusicPlayerController *vControl = [MPMusicPlayerController iPodMusicPlayer];
    if ([vControl playbackState] == MPMusicPlaybackStatePlaying) {
        [playpauseButton setStyle:UIBarButtonItemStyleDone];
    }
    else if ([vControl playbackState] == MPMusicPlaybackStatePaused) {
        [playpauseButton setStyle:UIBarButtonItemStyleBordered];
    }
    else if ([vControl playbackState] == MPMusicPlaybackStateStopped) {
        [playpauseButton setStyle:UIBarButtonItemStyleBordered];
    }
}

- (IBAction)playpauseAct:(id)sender {
    MPMusicPlayerController *vControl = [MPMusicPlayerController iPodMusicPlayer];
    if ([vControl playbackState] == MPMusicPlaybackStatePlaying) {
        [vControl pause];
    }
    else if ([vControl playbackState] == MPMusicPlaybackStatePaused) {
        [vControl play];
    }
    else if ([vControl playbackState] == MPMusicPlaybackStateStopped) {
        MPMediaQuery *everything = [[MPMediaQuery alloc] init];
        everything = [MPMediaQuery songsQuery];
        [vControl setQueueWithQuery:everything];
        [vControl play];
    }
}

- (IBAction)exitHelp:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil]; // iPhone/iPod Touch only.
}

- (IBAction)vFullAct:(id)sender {
    MPMusicPlayerController *vControl = [MPMusicPlayerController iPodMusicPlayer];
    if (volSlider.value < 1.0) {
        currentValue = volSlider.value;
        [volSlider setValue:1.0];
        [vControl setVolume:volSlider.value];
    }
    else {
        [volSlider setValue:currentValue];
        [vControl setVolume:volSlider.value];
    }
}

- (IBAction)vMuteAct:(id)sender {
    MPMusicPlayerController *vControl = [MPMusicPlayerController iPodMusicPlayer];
    if (volSlider.value > 0.0) {
        currentValue = volSlider.value;
        [volSlider setValue:0.0];
        [vControl setVolume:volSlider.value];
    }
    else {
        [volSlider setValue:currentValue];
        [vControl setVolume:volSlider.value];
    }
}

- (IBAction)vUpAct:(id)sender {
    [volSlider setValue:volSlider.value+0.1];
    currentValue = volSlider.value;
    MPMusicPlayerController *vControl = [MPMusicPlayerController iPodMusicPlayer];
    [vControl setVolume:volSlider.value];
}

- (IBAction)vDownAct:(id)sender {
    [volSlider setValue:volSlider.value-0.1];
    currentValue = volSlider.value;
    MPMusicPlayerController *vControl = [MPMusicPlayerController iPodMusicPlayer];
    [vControl setVolume:volSlider.value];
}

- (IBAction)volChanged:(id)sender {
    MPMusicPlayerController *vControl = [MPMusicPlayerController iPodMusicPlayer];
    [vControl setVolume:volSlider.value];
    currentValue = volSlider.value;
}
@end
