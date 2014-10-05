//
//  MMInputInfoViewController.h
//  MealReport
//
//  Created by minami on 2014/09/15.
//  Copyright (c) 2014年 Minami Baba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMInputDetailInfoViewController.h"

@interface MMInputInfoViewController : UIViewController

- (IBAction)breakfastButtonPressed:(id)sender;
- (IBAction)lunchButtonPressed:(id)sender;
- (IBAction)dinnerButtonPressed:(id)sender;
- (IBAction)dateButton:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic) NSInteger selectedButtonIndex;

//Databaseで管理するもの
@property (nonatomic) NSString *selectedDateString;
@property (nonatomic) NSNumber *selectedTime;


@end
