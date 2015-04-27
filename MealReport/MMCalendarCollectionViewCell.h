//
//  MMCalendarCollectionViewCell.h
//  MealReport
//
//  Created by minami on 3/5/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCalendarCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mealPhotoImageView;

@property (weak, nonatomic) IBOutlet UILabel *mealCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) IBOutlet UILabel *breakfastMark;
@property (weak, nonatomic) IBOutlet UILabel *lunchMark;
@property (weak, nonatomic) IBOutlet UILabel *dinnerMark;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
