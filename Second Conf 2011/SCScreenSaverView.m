//
//  SCScreenSaverView.m
//  Second Conf 2011
//
//  Created by Simon Whitaker <simon@goosoftware.co.uk> on 24/09/2011.
//

#import "SCScreenSaverView.h"

@interface SCSegment : NSObject

// A simple class for representing a segment ("slice of pie") in the logo

@property (nonatomic, retain) NSColor * color;
@property (nonatomic) NSUInteger numberOfChunks;
    
+ (SCSegment*)segmentWithColor:(NSColor*)color 
             andNumberOfChunks:(NSUInteger)numberOfChunks;

@end

@implementation SCSegment

@synthesize color=_color;
@synthesize numberOfChunks=_numberOfChunks;

+ (SCSegment*)segmentWithColor:(NSColor*)color 
             andNumberOfChunks:(NSUInteger)numberOfChunks
{
    SCSegment *segment = [[SCSegment alloc] init];
    segment.color = color;
    segment.numberOfChunks = numberOfChunks;
    return [segment autorelease];
}

@end

@implementation SCScreenSaverView

@synthesize angleOffsetRads=_angleOffsetRads;
@synthesize lastFired=_lastFired;
@synthesize pulseChunk=_pulseChunk;
@synthesize lastChangedChunkPulse=_lastChangedChunkPulse;

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        self.angleOffsetRads = 0.0;
        self.pulseChunk = 0;
        self.lastChangedChunkPulse = [NSDate date];
        [self setAnimationTimeInterval:1/30.0];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithFrame:NSZeroRect isPreview:NO];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
    NSPoint center = NSMakePoint(rect.size.width / 2, rect.size.height / 2);
    
    // What's the widest we can go?
    CGFloat limit = center.x > center.y ? center.y : center.x;
    
    // baseRadius is the radius of the inside of the inner-most chunks. Think of it
    // as the radius of the black circle in the middle of the puzzle
    CGFloat baseRadius = limit / 5.0;
    
    // chunkWidth is the width ("thickness"?) of the chunks, i.e. the distance
    // between the inner curve and the outer curve of a chunk.
    CGFloat chunkWidth = baseRadius / 2.5;

    // Declare the constants we'll need to draw the logo
    static NSArray *Segments = nil;
    
    if (Segments == nil) {
        NSColor * orangeColor = [NSColor colorWithDeviceHue:0.06 saturation:1.0 brightness:1.0 alpha:1.0];
        NSColor * grayColor = [NSColor colorWithDeviceHue:0.0 saturation:0.0 brightness:0.5 alpha:1.0];
        NSColor * yellowColor = [NSColor colorWithDeviceHue:0.13 saturation:1.0 brightness:1.0 alpha:1.0];
        
        Segments = [[NSArray alloc] initWithObjects:
                    [SCSegment segmentWithColor:grayColor   andNumberOfChunks:5],
                    [SCSegment segmentWithColor:orangeColor andNumberOfChunks:3],
                    [SCSegment segmentWithColor:yellowColor andNumberOfChunks:5],
                    [SCSegment segmentWithColor:orangeColor andNumberOfChunks:6],
                    [SCSegment segmentWithColor:grayColor   andNumberOfChunks:7],
                    [SCSegment segmentWithColor:orangeColor andNumberOfChunks:0],
                    [SCSegment segmentWithColor:yellowColor andNumberOfChunks:7],
                    [SCSegment segmentWithColor:grayColor   andNumberOfChunks:2],
                    [SCSegment segmentWithColor:orangeColor andNumberOfChunks:7],
                    [SCSegment segmentWithColor:yellowColor andNumberOfChunks:2],
                    nil];
    }
    
    // Step through the segments. A segment is all the stuff between two radii. Or to
    // put it another way, it's a slice of pie. Mmmm, pie! 
    //
    // (Please don't confuse "Mmmm, pie!" with M_PI, for that way lies disaster.)
    for (NSUInteger i = 0; i < [Segments count]; i++) {
        SCSegment *segment = [Segments objectAtIndex:i];
        for (NSUInteger chunk = 0; chunk < segment.numberOfChunks; chunk++) {
            CGFloat segmentStartAngleRads = M_PI * 2 / [Segments count];
            
            CGFloat startRads = segmentStartAngleRads * i + self.angleOffsetRads;
            CGFloat endRads = startRads + segmentStartAngleRads;
            CGFloat insideRadius = baseRadius + chunkWidth * chunk;
            CGFloat outsideRadius = insideRadius + chunkWidth;
            
            CGPoint insideStart = NSMakePoint(center.x + insideRadius * sinf(startRads),
                                              center.y + insideRadius * cosf(startRads));
            CGPoint outsideStart = NSMakePoint(center.x + (outsideRadius) * sinf(startRads),
                                               center.y + (outsideRadius) * cosf(startRads));
            CGPoint insideEnd = NSMakePoint(center.x + (insideRadius) * sinf(endRads),
                                            center.y + (insideRadius)* cosf(endRads));
            
            NSBezierPath *aPath = [NSBezierPath bezierPath];
            
            // Set the stroke width to a suitable fraction of the size of a chunk
            [aPath setLineWidth:chunkWidth / 10.0];

            // Convert angles in radians that increase clockwise from 12 o'clock to
            // angles in degrees that increase anticlockwise from 3 o'clock
            CGFloat startDegrees = 90 - (startRads / M_PI * 180.0);
            CGFloat endDegrees = 90 - (endRads / M_PI * 180.0);
            
            [aPath moveToPoint:insideStart];
            [aPath lineToPoint:outsideStart];
            [aPath appendBezierPathWithArcWithCenter:center
                                              radius:outsideRadius
                                          startAngle:startDegrees
                                            endAngle:endDegrees
                                           clockwise:YES];
            [aPath lineToPoint:insideEnd];
            [aPath appendBezierPathWithArcWithCenter:center
                                              radius:insideRadius
                                          startAngle:endDegrees
                                            endAngle:startDegrees
                                           clockwise:NO];
            if (self.pulseChunk > chunk) {
                [[NSColor colorWithDeviceHue:segment.color.hueComponent
                                  saturation:segment.color.saturationComponent
                                  brightness:segment.color.brightnessComponent
                                       alpha:0.1 + 0.3 * (self.pulseChunk - chunk)] setFill];
                
            }
            else {
                [segment.color setFill];
            }
             
            [aPath fill];
            
            [[NSColor blackColor] setStroke];
            
            [aPath stroke];
        }
    }
    if (!self.isAnimating) {
        [self startAnimation];
    }
}

- (void)animateOneFrame
{
    static CGFloat RevsPerSecond = 1.0 / 60.0;
    static NSTimeInterval PulseChunkChangeDelay = 0.05;
    NSDate * now = [NSDate date];
    
    if (self.lastFired == nil) {
        self.lastFired = now;
        self.angleOffsetRads = 0.0;
    } else {
        NSTimeInterval secondsSinceLastFire = [now timeIntervalSinceDate:self.lastFired];
        CGFloat numRevolutions = RevsPerSecond * secondsSinceLastFire;
        CGFloat angularIncrementRads = M_PI * 2 * numRevolutions;
        
        self.angleOffsetRads = self.angleOffsetRads + angularIncrementRads;
        self.lastFired = now;
    }
    
    if ([now timeIntervalSinceDate:self.lastChangedChunkPulse] > PulseChunkChangeDelay) {
        self.lastChangedChunkPulse = now;
        self.pulseChunk = (self.pulseChunk + 1) % 20;
    }
    
    if (self.angleOffsetRads > M_PI * 2) {
        self.angleOffsetRads -= M_PI * 2;
    }
    self.needsDisplay = YES;
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
