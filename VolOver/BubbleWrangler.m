//
//  BubbleWrangler.m
//  bubbles
//
//  Created by Tom Nantais on 13-06-08.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BubbleWrangler.h"

extern CGFloat g_fViewWidth,g_fViewHeight;

@implementation BubbleWrangler

@synthesize intensity;

#define NUM_BUBBLE_TYPES 8
#define NUM_BUBBLES (NUM_BUBBLE_TYPES*6)

#define RANDOM_SEED() srandom(time(NULL))
#define RANDOM_INT(__MIN__,__MAX__) ((__MIN__) + random() % (((__MAX__)+1)-(__MIN__)))
//RANDOM_INT can include __MIN__ and __MAX__

-(id)init
{
    if (self = [super init])
    {
        int i;
        Bubble* bubble;
        bubbles = [[NSMutableArray alloc] init];
        for (i=0;i<NUM_BUBBLES;i++)
        {
            bubble = [[Bubble alloc] init];
            [bubbles addObject:bubble];
//            [bubble release];
        }
        RANDOM_SEED();
        intensity = 0;
    }
    
    return self;
}

-(BOOL) flipCoin: (int) nOutOf
{
    return ((0==RANDOM_INT(0, nOutOf)) ? YES : NO);
}


-(void) timerfunc:(NSTimer*)theTimer
{
    int i;
    Bubble* bubble;
    for (i=0;i<NUM_BUBBLES;i++)
    {
        bubble = [bubbles objectAtIndex:i];
        
        //advance all of the bubbles that are on the screen
        if (bubble.visible)
        {
            [bubble tic:1.0/30.0];
        }
        
        //see if this bubble has reached the end of the line
        CGPoint loc = bubble.location;
        if (loc.x>g_fViewWidth+bubble.radius)
        {
            bubble.visible = NO;
        }
    }
    
    //see if it's time to release a new bubble
    if ([self flipCoin:(20 - intensity*18/100)])
    {
        BOOL bFound = NO;
        i = 0;
        while (i<300&&!bFound)
        {
            int bubblemax = (intensity+10) * NUM_BUBBLES / 110;
            
            bubblemax = RANDOM_INT(bubblemax-10,bubblemax+10);
            
            if (bubblemax<10)
                bubblemax = 10;
            
            if (bubblemax>=NUM_BUBBLES)
                bubblemax = NUM_BUBBLES-1;
            
            int bubbleindex = RANDOM_INT(0, bubblemax);
            
            bubble = [bubbles objectAtIndex:bubbleindex];
            if (!bubble.visible)
            {
                bFound = YES;
            }
            else
            {
                i++;
            }
        }
        
        if (bFound)
        {
            [self launchBubble:bubble];
        }
    }
}

-(NSString*)getImageName:(int)imageNum
{
    NSString* rval;
    switch (imageNum)
    {
        case 0:
            rval = @"15px_icon_hollow.png";
            break;
        case 1:
            rval = @"15px_icon_fill.png";
            break;
        case 2:
            rval = @"30px_icon_hollow.png";
            break;
        case 3:
            rval = @"30px_icon_fill.png";
            break;
        case 4:
            rval = @"55px_icon_hollow.png";
            break;
        case 5:
            rval = @"55px_icon_fill.png";
            break;
        case 6:
            rval = @"100px_icon_hollow.png";
            break;
        case 7:
            rval = @"100px_icon_fill.png";
            break;
    }
    
    return(rval);
}

-(void)launchBubble:(Bubble*)bubble
{
    CGFloat fBubbleRadius;
    
    bubble.location = CGPointMake(-bubble.radius,g_fViewHeight/2.0);
    bubble.offset = g_fViewHeight/2.0;
    fBubbleRadius = bubble.radius;        
    bubble.speed = 100.0 - fBubbleRadius*(1.0*RANDOM_INT(5,9))/10.0 + 1.0*RANDOM_INT(0,50) + (1.0*intensity)/1.0;
    bubble.amplitude = 20.0+fBubbleRadius*2.0 -1.0*RANDOM_INT(0,20);
    bubble.phase = (1.0*RANDOM_INT(0,30))/5.0;
    bubble.period = 2.0-fBubbleRadius/40.0+(1.0*RANDOM_INT(0,10))/10.0;
    bubble.pixelwidth = g_fViewWidth;
    bubble.visible = YES;
}

-(void)loadImages:(UIView*)parent
{
    int i,j,count;
    Bubble *bubble;
    int nBubbleType;
    
    count = 0;
    for (i=0;i<NUM_BUBBLE_TYPES;i++)
    {
        for (j=0;j<(NUM_BUBBLES/NUM_BUBBLE_TYPES);j++)
        {
            bubble = [bubbles objectAtIndex:count];
            nBubbleType = i;
            [bubble loadImage:[self getImageName:nBubbleType] onParent:parent];
            bubble.visible = NO;
            count++;
        }
    }
    [NSTimer scheduledTimerWithTimeInterval:(1.0/30.0) target:self selector:@selector(timerfunc:) userInfo:nil repeats:YES];
}

- (void)dealloc
{
//    [bubbles release];
//    [super dealloc];
}

    
@end
