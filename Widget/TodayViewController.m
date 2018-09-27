//
//  TodayViewController.m
//  Widget
//
//  Created by Grishka on 30.10.2017.
//  Copyright © 2017 Grishka. All rights reserved.
//

#import "TodayViewController.h"
#import "CWCalendarView.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController{
	NSEdgeInsets insets;
	
	NSTextField* titleText;
	CGFloat width;
	NSCalendar* calendar;
	NSDate* currentDate;
	CWCalendarView* calendarView;
	NSButton* nextButton;
	NSButton* prevButton;
	
	int offsetInMonths;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
	// Update your data and prepare for a snapshot. Call completion handler when you are done
	// with NoData if nothing has changed or NewData if there is new data since the last
	// time we called you
	offsetInMonths=0;
	[self updateCurrentDay];
	completionHandler(NCUpdateResultNewData);
}

- (void)viewDidLoad{
	offsetInMonths=0;
	NSView* content=[self view];
	titleText=[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 320, 320)];
	[titleText setStringValue:@"W"];
	[titleText setBezeled:NO];
	[titleText setDrawsBackground:NO];
	[titleText setEditable:NO];
	[titleText setSelectable:NO];
	[titleText setTextColor:[NSColor textColor]];
	[titleText setAlignment:NSTextAlignmentCenter];
	[titleText setFont:[NSFont boldSystemFontOfSize:[NSFont systemFontSize]]];
	[content addSubview:titleText];
	
	calendarView=[[CWCalendarView alloc] initWithFrame:NSMakeRect(0, 0, 210, 200)];
	[content addSubview:calendarView];
	
	prevButton=[[NSButton alloc]initWithFrame:NSMakeRect(0, 200, 30, 30)];
	[prevButton setImage:[NSImage imageNamed:NSImageNameGoLeftTemplate]];
	[prevButton setFocusRingType:NSFocusRingTypeNone];
	[prevButton setBordered:false];
	[prevButton setTarget:self];
	[prevButton setAction:@selector(onButtonClick:)];
	[content addSubview:prevButton];
	
	nextButton=[[NSButton alloc]initWithFrame:NSMakeRect(0, 200, 30, 30)];
	[nextButton setImage:[NSImage imageNamed:NSImageNameGoRightTemplate]];
	[nextButton setBordered:false];
	[nextButton setFocusRingType:NSFocusRingTypeNone];
	[nextButton setTarget:self];
	[nextButton setAction:@selector(onButtonClick:)];
	[content addSubview:nextButton];
	
	self.preferredContentSize=NSMakeSize(0, 230);
}

- (NSEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(NSEdgeInsets)defaultMarginInset{
	CGFloat horizInset=defaultMarginInset.left>defaultMarginInset.right ? defaultMarginInset.left : defaultMarginInset.right;
	insets=NSEdgeInsetsMake(defaultMarginInset.top, horizInset, defaultMarginInset.bottom, horizInset);
	return insets;
}

- (void)updateLayout{
	[[self view] setFrameSize:NSMakeSize(width, 230)];
	CGFloat titleHeight=[titleText attributedStringValue].size.height;
	[titleText setFrame:NSMakeRect(0, 200+(15-(int)(titleHeight/2)), width, titleHeight)];
	[calendarView setFrameOrigin:NSMakePoint((int)(width/2-calendarView.bounds.size.width/2), 0)];
	[nextButton setFrameOrigin:NSMakePoint(width-30, 200)];
	
	self.preferredContentSize=NSMakeSize(width, 230);
}

- (void)viewWillTransitionToSize:(NSSize)newSize{
	width=newSize.width;
	[self updateLayout];
}

- (void)updateCurrentDay{
	currentDate=[NSDate date];
	calendar=[NSCalendar currentCalendar];
	
	if(offsetInMonths!=0){
		currentDate=[calendar dateByAddingUnit:NSCalendarUnitMonth value:offsetInMonths toDate:currentDate options:0];
	}
	
	NSLocale *locale = [NSLocale localeWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]];
	NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
	formatter.timeStyle=NSDateFormatterNoStyle;
	formatter.dateStyle=NSDateFormatterMediumStyle;
	formatter.locale=locale;
	[formatter setLocalizedDateFormatFromTemplate:@"MMMMYYYY"];
	[titleText setStringValue:[formatter stringFromDate:currentDate]];
	NSInteger era, year, month;
	[calendar getEra:&era year:&year month:&month day:NULL fromDate:currentDate];
	[calendarView setCurrentEra:era year:year month:month];
}

- (void)onButtonClick:(id)sender{
	if(sender==prevButton){
		offsetInMonths--;
	}else if(sender==nextButton){
		offsetInMonths++;
	}
	[self updateCurrentDay];
}

@end

