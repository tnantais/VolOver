//
//  Bubble.h
//  bubbles
//
//  Created by Tom Nantais on 13-06-08.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bubble : NSObject
{
    UIImageView *img;
}

-(BOOL)loadImage:(NSString*) strName onParent:(UIView*)parent;
-(void)tic:(CGFloat)deltaT;


@property (nonatomic,retain) UIImageView* img;
@property (nonatomic,assign) CGPoint location;
@property (nonatomic,assign) CGFloat period;
@property (nonatomic,assign) CGFloat amplitude;
@property (nonatomic,assign) CGFloat phase;
@property (nonatomic,assign) CGFloat speed;
@property (nonatomic,assign) CGFloat offset;
@property (nonatomic,readonly) CGFloat radius;
@property (nonatomic,assign) BOOL visible;
@property (nonatomic,assign) CGFloat pixelwidth;

@end
