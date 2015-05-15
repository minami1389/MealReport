//
//  MMCalendarNavigationView.h
//  MealReport
//
//  Created by minami on 4/30/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMCalendarNavigationViewDelegate <NSObject>

- (void)pushLeftArrowButton;
- (void)pushRightArrowButton;

@end

@interface MMCalendarNavigationView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
+ (instancetype)view;

@property (nonatomic, assign) id<MMCalendarNavigationViewDelegate>delegate;
@end
