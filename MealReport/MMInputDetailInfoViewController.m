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
    self.titleTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.costTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    
    

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


- (IBAction)yen200Button:(id)sender {
}


- (IBAction)yen500Button:(id)sender {
    
}

- (IBAction)yen1000Button:(id)sender {
}



@end
