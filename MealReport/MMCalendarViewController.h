//
//  MMCalendarViewController.h
//  MealReport
//
//  Created by minami on 3/5/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMCalendarCollectionReusableView.h"

@interface MMCalendarViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,MMCalendarHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *calendarView;

@end
