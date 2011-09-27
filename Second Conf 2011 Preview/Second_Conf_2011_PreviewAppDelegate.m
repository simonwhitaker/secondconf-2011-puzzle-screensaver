//
//  Second_Conf_2011_PreviewAppDelegate.m
//  Second Conf 2011 Preview
//
//  Created by Simon Whitaker on 28/09/2011.
//  Copyright 2011 Goo Software Ltd. All rights reserved.
//

#import "Second_Conf_2011_PreviewAppDelegate.h"
#import "SCScreenSaverView.h"

@implementation Second_Conf_2011_PreviewAppDelegate

@synthesize window;
@synthesize view=_view;
@synthesize timer=_timer;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.view.animationTimeInterval
                                                  target:self.view
                                                selector:@selector(animateOneFrame)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    [super dealloc];
}

@end
