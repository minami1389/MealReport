//
//  MMCalendarCollectionReusableView.m
//  MealReport
//
//  Created by minami on 3/5/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import "MMCalendarCollectionReusableView.h"

@implementation MMCalendarCollectionReusableView

- (IBAction)dayButtonPushed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dayButtonPushed)]) {
        [self.delegate dayButtonPushed];
    }
}

- (IBAction)prevMonthButtonPushed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(prevMonthButtonPushed)]) {
        [self.delegate prevMonthButtonPushed];
    }
}

- (IBAction)nextMonthButtonPushed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(nextMonthButtonPushed)]) {
        [self.delegate nextMonthButtonPushed];
    }
}
@end
