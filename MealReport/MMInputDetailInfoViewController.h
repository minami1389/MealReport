//
//  MMInputDetailInfoViewController.h
//  MealReport
//
//  Created by minami on 2014/09/15.
//  Copyright (c) 2014年 Minami Baba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMInputDetailInfoViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *imageSelectButton;
- (IBAction)imageSelectButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *costTextField;
- (IBAction)saveButton:(id)sender;

@property (nonatomic) UIImage *selectedImage;

@property (nonatomic) NSInteger selectedButtonIndex;

//Databaseで管理するもの
@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * mealTitle;
@property (nonatomic, retain) NSNumber * mealCost;
@property (nonatomic, retain) NSNumber * idNumber;



@end
