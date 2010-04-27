//
//  mbp_video_statusAppDelegate.m
//  mbp-video-status
//
//  Created by Tim Horton on 2010.04.26.
//  Copyright 2010 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "mbp_video_statusAppDelegate.h"
#import <stdio.h>
#import <stdlib.h>
#import "RegexKitLite.h"

@implementation mbp_video_statusAppDelegate

@synthesize window;
@synthesize menu;

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
    FILE * fp;
    char output[4096];
    NSString * outString;
    NSRange leftParen, rightParen;
    NSArray * pidStrings;
    
    fp = popen("ioreg -l | grep -i \"task-list\"", "r");
    fgets(output, 4096, fp);
    pclose(fp);
    
    outString = [NSString stringWithUTF8String:output];
    leftParen = [outString rangeOfString:@"("];
    rightParen = [outString rangeOfString:@")"];
    
    if(leftParen.location + 1 == rightParen.location)
    {
        [statusItem setImage:intelImage];
        [statusItem setHighlightMode:NO];
        [statusItem setMenu:nil];
        return;
    }
    
    leftParen.location++;
    leftParen.length = rightParen.location - leftParen.location;
    outString = [outString substringWithRange:leftParen];
    
    [menu removeAllItems];
    
    pidStrings = [outString componentsSeparatedByString:@","];
    for(NSString * pidString in pidStrings)
    {
        NSString * command;
        int pid = [pidString intValue];
        snprintf(output, 4096, "ps -o command -p %d | grep -v 'COMMAND'", pid);
        fp = popen(output, "r");
        fgets(output, 4096, fp);
        pclose(fp);
        
        command = [NSString stringWithUTF8String:output];
        command = [command stringByReplacingOccurrencesOfRegex:@" -psn.*"
                                                    withString:@""];
        command = [[command componentsSeparatedByString:@"/"] lastObject];
        
        //NSLog(@"%@", command);
        [menu addItemWithTitle:command action:nil keyEquivalent:@""];
    }
    
    [statusItem setImage:nvidiaImage];
    [statusItem setHighlightMode:YES];
    [statusItem setMenu:menu];
}

@end
