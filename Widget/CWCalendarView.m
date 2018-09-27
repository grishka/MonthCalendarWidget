//
//  CWCalendarView.m
//  Widget
//
//  Created by Grishka on 30.10.2017.
//  Copyright © 2017 Grishka. All rights reserved.
//

#import "CWCalendarView.h"

@implementation CWCalendarView{
	NSFont* font;
	NSFont* weekdayFont;
	NSColor* weekdayColor;
	NSColor* weekendColor;
	NSColor* otherMonthColor;
	
	NSCalendar* calendar;
	NSDate* startDate;
	NSInteger month;
	NSInteger year;
	NSInteger era;
}

- (id)initWithFrame:(NSRect)frame {
	self=[super initWithFrame:frame];
	
	font=[NSFont systemFontOfSize:[NSFont systemFontSize]];
	weekdayFont=[NSFont labelFontOfSize:[NSFont labelFontSize]];
	[self _updateColors];
	
	NSLocale *locale = [NSLocale localeWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]];
	calendar=[NSCalendar currentCalendar];
	calendar.locale=locale;
	
	//[self addObserver:self forKeyPath:@"effectiveAppearance" options:0 context:nil];
	
	return self;
}

/*- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context{
	[self _updateColors];
	[self setNeedsDisplay:YES];
}*/

- (void)_updateColors{
	weekdayColor=[[NSColor textColor] colorWithAlphaComponent:1.0];
	weekendColor=[[NSColor textColor] colorWithAlphaComponent:0.6];
	otherMonthColor=[[NSColor textColor] colorWithAlphaComponent:0.2];
}

- (void)setCurrentEra:(NSInteger)_era year:(NSInteger)_year month:(NSInteger)_month{
	era=_era;
	year=_year;
	month=_month;
	
	
	NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
	formatter.timeStyle=NSDateFormatterNoStyle;
	formatter.dateStyle=NSDateFormatterMediumStyle;
	formatter.locale=calendar.locale;
	
	NSDate* date=[calendar dateWithEra:era year:year month:month day:0 hour:0 minute:0 second:0 nanosecond:0];
	NSUInteger firstWeekday=[calendar firstWeekday];
	while([calendar component:NSCalendarUnitWeekday fromDate:date]!=firstWeekday){
		date=[calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:date options:0];
	}
	startDate=date;
	[self display];
}

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
	
	[self _updateColors];
	NSUInteger firstDay=[calendar firstWeekday];
	NSArray<NSString*>* dayLabels=[calendar shortStandaloneWeekdaySymbols];
	for(int i=0;i<7;i++){
		NSString* label=dayLabels[(firstDay+i-1)%dayLabels.count];
		CGSize size=[label sizeWithAttributes:@{NSFontAttributeName:font}];
		NSColor* textColor=weekdayColor;
		[label drawAtPoint:NSMakePoint(30*i+15-(int)(size.width/2), 190-(int)(size.height/2)) withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:textColor}];
	}
	
	NSDate* date=[startDate copy];
	NSDate* today=[NSDate date];
	for(int week=0;week<6;week++){
		for(int day=0;day<7;day++){
			NSInteger d, m;
			[calendar getEra:NULL year:NULL month:&m day:&d fromDate:date];
			
			NSColor* textColor;
			if(m!=month){
				textColor=otherMonthColor;
				[otherMonthColor set];
			}else if([calendar isDateInWeekend:date]){
				textColor=weekendColor;
				[weekendColor set];
			}else{
				textColor=weekdayColor;
				[weekdayColor set];
			}
			
			//[NSBezierPath strokeRect:NSMakeRect(30*day, 30*(5-week), 30, 30)];
			if([calendar isDate:date equalToDate:today toUnitGranularity:NSCalendarUnitDay] && m==month){
				NSBezierPath* rect=[NSBezierPath bezierPath];
				[rect appendBezierPathWithRoundedRect:NSMakeRect(30*day, 30*(5-week), 30, 30) xRadius:3 yRadius:3];
				[weekendColor set];
				[rect fill];
				if([[[self effectiveAppearance] name] containsString:@"Dark"])
					textColor=[NSColor blackColor];
				else
    				textColor=[NSColor whiteColor];
			}
			
			NSString* s=[NSString stringWithFormat:@"%d", (int)d];
			CGSize size=[s sizeWithAttributes:@{NSFontAttributeName:font}];
			[s drawAtPoint:NSMakePoint(30*day+15-(int)(size.width/2), 30*(5-week)+15-(int)(size.height/2)) withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:textColor}];
			
			date=[calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:date options:0];
		}
	}
	
}

@end
