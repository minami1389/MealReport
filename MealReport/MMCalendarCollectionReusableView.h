//
//  MMCalendarCollectionReusableView.h
//  MealReport
//
//  Created by minami on 3/5/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMCalendarHeaderViewDelegate <NSObject>

- (void)dayButtonPushed;
- (void)prevMonthButtonPushed;
- (void)nextMonthButtonPushed;

@end

@interface MMCalendarCollectionReusableView : UICollectionReusableView

@property (nonatomic, assign) id<MMCalendarHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *dayButton;
- (IBAction)dayButtonPushed:(id)sender;
- (IBAction)prevMonthButtonPushed:(id)sender;
- (IBAction)nextMonthButtonPushed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *sumCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *aveCostLabel;

@end
