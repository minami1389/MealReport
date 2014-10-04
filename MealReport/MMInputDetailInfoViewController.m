//
//  MMInputDetailInfoViewController.m
//  MealReport
//
//  Created by minami on 2014/09/15.
//  Copyright (c) 2014年 Minami Baba. All rights reserved.
//

#import "MMInputDetailInfoViewController.h"

@interface MMInputDetailInfoViewController ()

@end

@implementation MMInputDetailInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //imageViewの設定
    self.imageView.layer.borderWidth = 1.5;
    self.imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.imageView.clipsToBounds = YES;
    
    //textFieldの設定
    self.titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.titleTextField.placeholder = @"朝食";
    self.titleTextField.keyboardType = UIKeyboardTypeDefault;
    self.titleTextField.delegate = self;
    self.titleTextField.returnKeyType = UIReturnKeyDone;
    
    self.costTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.costTextField.placeholder = @"500";
    self.costTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.titleTextField.delegate = self;
    
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - photo

//写真部分をタップした時に呼ばれる
- (IBAction)imageSelectButton:(id)sender
{
    [self showPhotoLibrary];
}

- (void)showPhotoLibrary
{
    //photoLibaryが使えるかどうかの判断
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        //アラート表示
        Class class = NSClassFromString(@"UIAlertController");
        if (class) {
            
            //iOS8時の処理
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"フォトアルバム" message:@"使うことが出来ません" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            
            //iOS7時の処理
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"フォトアルバム" message:@"使うことが出来ません" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        
        }
        
        return;
    }
    
    //photoLibrary表示
    UIImagePickerController *photoLibrary = [[UIImagePickerController alloc] init];
    photoLibrary.delegate = self;
    [photoLibrary setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:photoLibrary animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //photoLibrary dismiss
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //photo取得
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imageView setImage:image];
    self.selectedImage = image;
    
    //imageSelectButtonメッセージ非表示
    [self.imageSelectButton setTitle:@"" forState:UIControlStateNormal];
}


#pragma mark - textField

//画面の何もない部分を触ればキーボードが閉じる
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - save
- (IBAction)saveButton:(id)sender {
    
    self.mealTitle = self.titleTextField.text;
    NSString *string = self.costTextField.text;
    self.mealCost = string.integerValue;
}
@end
