//
//  MMCalendarNavigationView.m
//  MealReport
//
//  Created by minami on 4/30/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import "MMCalendarNavigationView.h"

@implementation MMCalendarNavigationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
}

+ (instancetype)view
{
    NSString *className = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:0] firstObject];
}

- (IBAction)pushLeftArrowButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pushLeftArrowButton)]) {
        [self.delegate pushLeftArrowButton];
    }
}
- (IBAction)pushRightArrowButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pushRightArrowButton)]) {
        [self.delegate pushRightArrowButton];
    }
}

@end
