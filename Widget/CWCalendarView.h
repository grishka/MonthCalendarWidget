//
//  CWCalendarView.h
//  Widget
//
//  Created by Grishka on 30.10.2017.
//  Copyright © 2017 Grishka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CWCalendarView : NSView

- (void)setCurrentEra:(NSInteger)_era year:(NSInteger)_year month:(NSInteger)_month;

@end
