//
//  MMInputInfoViewController.h
//  MealReport
//
//  Created by minami on 2014/09/15.
//  Copyright (c) 2014年 Minami Baba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMInputInfoViewController : UIViewController

- (IBAction)breakfastButtonPressed:(id)sender;
- (IBAction)lunchButtonPressed:(id)sender;
- (IBAction)dinnerButtonPressed:(id)sender;
- (IBAction)dateButton:(id)sender;

@property (nonatomic) CGRect screenRect;

@property (nonatomic) NSInteger selectedButtonIndex;
@property (nonatomic) NSString *selectedDateString;

@property (nonatomic) UIDatePicker *datePicker;
@property (nonatomic) UIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *underLine;


@end
