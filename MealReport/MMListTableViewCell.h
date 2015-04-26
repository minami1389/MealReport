//
//  MMListTableViewCell.h
//  MealReport
//
//  Created by minami on 4/23/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end
