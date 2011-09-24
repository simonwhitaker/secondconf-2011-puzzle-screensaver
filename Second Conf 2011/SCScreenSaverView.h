//
//  SCScreenSaverView.h
//  Second Conf 2011
//
//  Created by Simon Whitaker <simon@goosoftware.co.uk> on 24/09/2011.
//

#import <ScreenSaver/ScreenSaver.h>

@interface SCScreenSaverView : ScreenSaverView

@property (nonatomic) CGFloat angleOffsetRads;
@property (nonatomic, retain) NSDate * lastFired;
@property (nonatomic) NSInteger pulseChunk;
@property (nonatomic, retain) NSDate * lastChangedChunkPulse;
@end
