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
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic) NSInteger selectedButtonIndex;
@property (nonatomic) NSString *selectedDateString;

@end
