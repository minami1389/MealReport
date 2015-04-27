//
//  MMCalendarCollectionViewCell.m
//  MealReport
//
//  Created by minami on 3/5/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import "MMCalendarCollectionViewCell.h"
#import "MMColor.h"

@implementation MMCalendarCollectionViewCell

- (void)awakeFromNib
{
    self.layer.borderWidth = 1.0f;
    self.mealCostLabel.adjustsFontSizeToFitWidth = YES;
}
    
@end
