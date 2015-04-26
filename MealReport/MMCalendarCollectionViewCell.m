//
//  MMCalendarCollectionViewCell.m
//  MealReport
//
//  Created by minami on 3/5/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import "MMCalendarCollectionViewCell.h"

@implementation MMCalendarCollectionViewCell

- (void)awakeFromNib
{
    self.layer.borderColor = [UIColor colorWithRed:0.90 green:0.60 blue:0.16 alpha:1.0].CGColor;
    self.layer.borderWidth = 1.0f;
    
    self.mealCostLabel.layer.cornerRadius = 2.0f;
    self.mealCostLabel.adjustsFontSizeToFitWidth = YES;
    
    self.breakfastMark.textColor = [UIColor colorWithRed:255/255 green:127/255 blue:80/255 alpha:1.0];
    self.lunchMark.textColor = [UIColor colorWithRed:255/255 green:140/255 blue:0 alpha:1.0];
    self.dinnerMark.textColor = [UIColor colorWithRed:100/255 green:149/255 blue:237/255 alpha:1.0];
}
    
@end
