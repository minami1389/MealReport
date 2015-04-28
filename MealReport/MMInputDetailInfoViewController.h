//
//  MMInputDetailInfoViewController.h
//  MealReport
//
//  Created by minami on 2014/09/15.
//  Copyright (c) 2014年 Minami Baba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAlertView.h"
#import "MMString.h"

@interface MMInputDetailInfoViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic) NSInteger selectedButtonIndex;
@property (nonatomic) NSString *dateNotForDB;

//DBで管理するもの
@property (nonatomic, retain) NSString * month;
@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSNumber * time;

@end
