//
//  MMInputDetailInfoViewController.h
//  MealReport
//
//  Created by minami on 2014/09/15.
//  Copyright (c) 2014年 Minami Baba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMInputDetailInfoViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *imageSelectButton;
- (IBAction)imageSelectButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *costTextField;

//Databaseで管理するもの
@property (weak) UIImage *selectedImage;



@end
