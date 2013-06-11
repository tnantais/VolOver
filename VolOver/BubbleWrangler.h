//
//  BubbleWrangler.h
//  bubbles
//
//  Created by Tom Nantais on 13-06-08.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bubble.h"

@interface BubbleWrangler : NSObject
    {
        NSMutableArray* bubbles;
    }

    -(void)loadImages:(UIView*)parent;
    -(void)launchBubble:(Bubble*)bubble;


@property (nonatomic,assign) int intensity;
@end
