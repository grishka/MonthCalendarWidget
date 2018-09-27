//
//  AppDelegate.m
//  MonthCalendarWidget
//
//  Created by Grishka on 30.10.2017.
//  Copyright © 2017 Grishka. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow* window;
@end

@implementation AppDelegate
@synthesize window;

- (void)applicationWillFinishLaunching:(NSNotification *)notification{
	NSVisualEffectView* blurView=[[NSVisualEffectView alloc] initWithFrame:NSMakeRect(0, 0, window.frame.size.width, window.frame.size.height)];
	blurView.material=NSVisualEffectMaterialPopover;
	blurView.blendingMode=NSVisualEffectBlendingModeBehindWindow;
	blurView.state=NSVisualEffectStateActive;
	[window.contentView addSubview:blurView positioned:NSWindowBelow relativeTo:nil];
	window.movableByWindowBackground=true;
}

- (IBAction)openGithubPage:(id)sender{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/grishka/MonthCalendarWidget"]];
}

@end

@implementation HandCursorButton
- (void)resetCursorRects {
    [self addCursorRect:[self bounds] cursor:[NSCursor pointingHandCursor]];
}
@end
