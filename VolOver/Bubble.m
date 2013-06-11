//
//  Bubble.m
//  bubbles
//
//  Created by Tom Nantais on 13-06-08.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Bubble.h"
#include <math.h>

#define kPi 3.14159265358979

@implementation Bubble

@synthesize img;
@synthesize period,amplitude,offset,speed,phase,pixelwidth;

-(BOOL)loadImage:(NSString*) strName onParent:(UIView*)parent
{
    BOOL bSuccess = YES;
    
    UIImage* image = [UIImage imageNamed:strName];
    self.img = [[UIImageView alloc] initWithImage:image];
    
    bSuccess = img!=nil;
    
    if (bSuccess)
    {
        img.alpha = 1.0;
        CGRect newFrame = img.frame;
        newFrame.origin = CGPointMake(0, 0);
        img.frame = newFrame;
        [parent addSubview:img];
    }
    
    return(bSuccess);
}

-(CGPoint)location
{
    CGRect currentFrame = img.frame;
    
    return(CGPointMake(currentFrame.origin.x + currentFrame.size.width/2.0, currentFrame.origin.y + currentFrame.size.height/2.0));
}

-(void)setLocation:(CGPoint)location
{
    CGRect newFrame = img.frame;
    newFrame.origin = CGPointMake(location.x - newFrame.size.width/2.0, location.y - newFrame.size.height/2.0);
    img.frame = newFrame;
}

-(CGFloat)radius
{
    return(img.frame.size.width/2.0);
}

-(void)tic:(CGFloat)deltaT
{
    CGPoint loc = self.location;
    
    CGFloat a = 2*kPi*period/pixelwidth;

    CGFloat deltaX = sqrtf(powf(speed*deltaT, 2.0)/(1.0 + powf(a*amplitude*cos(a*loc.x+phase), 2.0)));

    loc.x += deltaX;
    loc.y = amplitude*sin(a*loc.x+phase)+offset;
    
    self.location = loc;
}

-(void)dealloc
{
    self.img = nil;
}

-(BOOL)visible
{
    return(self.img.alpha>0.1);
}

-(void)setVisible:(BOOL)visible
{
    self.img.alpha = visible ? 1.0 : 0.0;
}

@end
