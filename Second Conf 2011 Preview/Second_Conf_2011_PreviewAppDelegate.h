//
//  Second_Conf_2011_PreviewAppDelegate.h
//  Second Conf 2011 Preview
//
//  Created by Simon Whitaker on 28/09/2011.
//  Copyright 2011 Goo Software Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ScreenSaver/ScreenSaver.h>

@interface Second_Conf_2011_PreviewAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet ScreenSaverView * view;
@property (retain) NSTimer * timer;
@end
