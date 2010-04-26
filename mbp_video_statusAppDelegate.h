//
//  mbp_video_statusAppDelegate.h
//  mbp-video-status
//
//  Created by Tim Horton on 2010.04.26.
//  Copyright 2010 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface mbp_video_statusAppDelegate : NSObject <NSApplicationDelegate>
{
    NSWindow * window;
    NSImage * nvidiaImage, * intelImage;
    NSTimer * timer;
    NSStatusItem * statusItem;
}

@property (assign) IBOutlet NSWindow *window;

- (void)updateStatus:(id)sender;

@end
