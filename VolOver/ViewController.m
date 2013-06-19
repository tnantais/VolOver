//
//  ViewController.m
//  VolOver
//
//  Created by Owen McGirr on 14/01/2013.
//  Copyright (c) 2013 Owen McGirr. All rights reserved.
//

#import "ViewController.h"

//handy macro for determining if running on an iPad
#define IS_IPAD ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@interface ViewController ()

@end

@implementation ViewController

- (void)makeButtonRound:(UIButton*)button
{
    [button.layer setCornerRadius:(button.frame.size.width/8.0)];
    button.layer.masksToBounds = YES;
}

-(void)updateBubblesFromSlider
{
    int intensity = (int) (volSlider.value*100);
    if (intensity<0)
        intensity = 0;
    if (intensity>99)
        intensity = 99;
    bubbleWrangler.intensity = intensity;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lastControlWithFocus = nil;
    
    MPMusicPlayerController *vControl = [MPMusicPlayerController iPodMusicPlayer];
    
    if (vControl!=nil)
    {
        [volSlider setValue:vControl.volume];
        currentValue = vControl.volume;
        if ([vControl playbackState] == MPMusicPlaybackStatePaused) {
            float v = vControl.volume;
            [vControl setVolume:0.0];
            [NSThread sleepForTimeInterval:1];
            [vControl play];
            [NSThread sleepForTimeInterval:1];
            [vControl pause];
            [NSThread sleepForTimeInterval:1];
            [vControl setVolume:v];
        }
        else if ([vControl playbackState] == MPMusicPlaybackStateStopped) {
            float v = vControl.volume;
            [vControl setVolume:0.0];
            [NSThread sleepForTimeInterval:1];
            [vControl play];
            [NSThread sleepForTimeInterval:1];
            [vControl pause];
            [NSThread sleepForTimeInterval:1];
            [vControl setVolume:v];
        }
    }
    
    [self makeButtonRound:muteButton];
    [self makeButtonRound:lowerButton];
    [self makeButtonRound:higherButton];
    
    bubbleWrangler = [[BubbleWrangler alloc] init];
    [bubbleWrangler loadImages:self.view];
    [self updateBubblesFromSlider];
    
    bubbleWrangler.box = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self checkInterfaceOrientation:self.interfaceOrientation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessibilityFocusChanged:) name:AccessibilityElementFocusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessibilityFocusLost:) name:AccessibilityElementLostFocusNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AccessibilityElementFocusNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AccessibilityElementLostFocusNotification object:nil];
}

-(void)enableCatchAllControl:(BOOL)bEn
{
    if (bEn)
    {
        if (!(accessibilityRedirect.isAccessibilityElement))
        {
            accessibilityRedirect.isAccessibilityElement = YES;
            //UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
        }
    }
    else
    {
        if (accessibilityRedirect.isAccessibilityElement)
        {
            accessibilityRedirect.isAccessibilityElement = NO;
            //UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
        }
    }
}

-(void)shiftFocusToMostRecentControl
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        if (lastControlWithFocus!=nil)
        {
            NSLog(@"shifting focus programmatically");
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, lastControlWithFocus);
        }
    }
    else
    {
        NSLog(@"incompatible device, using oldschool method");
        accessibilityRedirect.isAccessibilityElement = NO;
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
    }
}

-(void)checkForLossOfAccessibilityFocus
{
    NSLog(@"check for loss of acccessibility focus");
    //if none of our controls is focused, we can assume that focus has shifted to someplace inaccessible like the status bar.  enable the catchall
    if ( !([lowerButton accessibilityElementIsFocused] || [higherButton accessibilityElementIsFocused] || [muteButton accessibilityElementIsFocused]))
    {
        [self enableCatchAllControl:YES];
    }
}

-(void)accessibilityFocusLost:(NSNotification*)notification
{
    [self performSelector:@selector(checkForLossOfAccessibilityFocus) withObject:nil afterDelay:1.5];
}

-(void)accessibilityFocusChanged:(NSNotification*)notification
{
    UIView *control = (UIView*)[notification object];
    NSLog(@"ViewController> Accessibility focus changed");
    if (control==lowerButton||control==higherButton||control==muteButton)
    {
        NSLog(@"setting last control with focus");
        lastControlWithFocus = control;
        [self enableCatchAllControl:NO];
    }
    else if (control==accessibilityRedirect)
    {
        [self performSelector:@selector(shiftFocusToMostRecentControl) withObject:nil afterDelay:0];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    everything = [MPMediaQuery songsQuery];
    if (everything == nil) { // If music library is empty.
        UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"You must have at least one song in your music library to use VolOver." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [err show];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)checkInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation
{
    if (IS_IPAD)
    {
        if (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
        {
            backgroundView.frame = CGRectMake(0, 0, 1024, 748);
            backgroundView.image = [UIImage imageNamed:@"Default-Landscape.png"];
        }
        else if (toInterfaceOrientation==UIInterfaceOrientationPortrait || toInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown)
        {
            backgroundView.frame = CGRectMake(0, 0, 768, 1004);
            backgroundView.image = [UIImage imageNamed:@"Default.png"];
        }
    }
    else //iphone
    {
        if (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
        {
            backgroundView.frame = CGRectMake(0, 0, 480, 320);
            backgroundView.image = [UIImage imageNamed:@"iphonebackground-landscape.png"];
        }
        else if (toInterfaceOrientation==UIInterfaceOrientationPortrait || toInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown)
        {
            backgroundView.frame = CGRectMake(0,0,320,460);
            backgroundView.image = [UIImage imageNamed:@"iphonebackground.png"];
        }
    }    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self checkInterfaceOrientation:toInterfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    bubbleWrangler.box = self.view.bounds;
}

// button actions

- (IBAction)vMuteAct:(id)sender {
    MPMusicPlayerController *vControl = [MPMusicPlayerController iPodMusicPlayer];
    if (vControl!=nil)
    {
        if (volSlider.value > 0.0) {
            currentValue = volSlider.value;
            [volSlider setValue:0.0];
            [self updateBubblesFromSlider];
            [vControl setVolume:volSlider.value];
        }
        else {
            [volSlider setValue:currentValue];
            [self updateBubblesFromSlider];
            [vControl setVolume:volSlider.value];
        }
        if (currentValue == 0.0) {
            [volSlider setValue:0.5];
            [self updateBubblesFromSlider];
            [vControl setVolume:volSlider.value];
            currentValue = volSlider.value;
        }
    }
    
    [sender performSelector:@selector(checkHighlight:) withObject:sender afterDelay:0];
}

- (IBAction)vUpAct:(id)sender {
    [volSlider setValue:volSlider.value+0.1];
    currentValue = volSlider.value;
    MPMusicPlayerController *vControl = [MPMusicPlayerController iPodMusicPlayer];
    if (vControl!=nil)
    {
        [vControl setVolume:volSlider.value];
    }
    [self updateBubblesFromSlider];
    [sender performSelector:@selector(checkHighlight:) withObject:sender afterDelay:0];
}

- (IBAction)vDownAct:(id)sender {
    [volSlider setValue:volSlider.value-0.1];
    currentValue = volSlider.value;
    
    MPMusicPlayerController *vControl = [MPMusicPlayerController iPodMusicPlayer];
    if (vControl!=nil)
    {
        [vControl setVolume:volSlider.value];
    }
    [self updateBubblesFromSlider];
    [sender performSelector:@selector(checkHighlight:) withObject:sender afterDelay:0];    
}

- (IBAction)volChanged:(id)sender {
    MPMusicPlayerController *vControl = [MPMusicPlayerController iPodMusicPlayer];
    if (vControl!=nil)
    {
        [vControl setVolume:volSlider.value];
    }
    [self updateBubblesFromSlider];
    currentValue = volSlider.value;
}

- (void)viewDidUnload {
    backgroundView = nil;
    backgroundView = nil;
    muteButton = nil;
    lowerButton = nil;
    higherButton = nil;
    accessibilityRedirect = nil;
    [super viewDidUnload];
}
@end
