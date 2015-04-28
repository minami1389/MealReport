//
//  MMCalendarDetailViewController.h
//  MealReport
//
//  Created by minami on 4/24/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Record.h"

@interface MMCalendarDetailViewController : UIViewController

@property (weak, nonatomic) Record *record;
@property NSInteger index;


@end
