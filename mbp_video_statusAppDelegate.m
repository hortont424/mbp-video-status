//
//  mbp_video_statusAppDelegate.m
//  mbp-video-status
//
//  Created by Tim Horton on 2010.04.26.
//  Copyright 2010 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "mbp_video_statusAppDelegate.h"

@implementation mbp_video_statusAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    statusItem = [[NSStatusBar systemStatusBar]
                    statusItemWithLength:NSSquareStatusItemLength];
    nvidiaImage = [NSImage imageNamed:NSImageNameAddTemplate];
    intelImage = [NSImage imageNamed:NSImageNameRemoveTemplate];
    [self updateStatus:nil];

    timer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                             target:self
                                           selector:@selector(updateStatus:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)updateStatus:(id)sender
{
    if(system("ioreg -l | grep -i \"task-list\" | grep \"()\"") == 0)
    {
        [statusItem setImage:intelImage];
    }
    else
    {
        [statusItem setImage:nvidiaImage];
    }
}

@end
