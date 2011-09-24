//
//  Second_Conf_2011View.m
//  Second Conf 2011
//
//  Created by Simon Whitaker on 24/09/2011.
//  Copyright 2011 Goo Software Ltd. All rights reserved.
//

#import "Second_Conf_2011View.h"

@implementation Second_Conf_2011View

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
