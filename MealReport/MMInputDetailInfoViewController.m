//
//  MMInputDetailInfoViewController.m
//  MealReport
//
//  Created by minami on 2014/09/15.
//  Copyright (c) 2014年 Minami Baba. All rights reserved.
//

#import "MMInputDetailInfoViewController.h"
#import "Record.h"

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
    
    //imageViewの設定
    self.imageView.layer.borderWidth = 1.5;
    self.imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.imageView.layer.cornerRadius = 10.0f;
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
    
    //デフォルト値設定
    switch (self.selectedButtonIndex) {
        case 0:
            self.mealTitle = @"朝食";
            self.mealCost = @(500);
            break;
        
        case 1:
            self.mealTitle = @"昼食";
            self.mealCost = @(500);
            break;
        
        case 2:
            self.mealTitle = @"夕食";
            self.mealCost = @(500);
            break;
            
        default:
            break;
    }

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
    
    //imageSelectButtonメッセージ,枠線非表示
    [self.imageSelectButton setTitle:@"" forState:UIControlStateNormal];
    self.imageView.layer.borderWidth = 0;
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
    
    if (![self.titleTextField.text isEqualToString:@""]) {
        self.mealTitle = self.titleTextField.text;
    }
    
    if (![self.costTextField.text isEqualToString:@""]) {
        NSString *string = self.costTextField.text;
        self.mealCost = @(string.integerValue);
    }
    
    self.image = [[NSData alloc] initWithData:UIImagePNGRepresentation(self.imageView.image)];
    self.idNumber = [NSString stringWithFormat:@"%@%@",self.time,self.day];
    
    [self saveData];
    
    //アラート表示
    Class class = NSClassFromString(@"UIAlertController");
    if (class) {
        
        //iOS8時の処理
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存しますか？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"いいえ" style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"はい" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存が完了しました" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"はい" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        
        //iOS7時の処理
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存が完了しました" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
        
    }
}

//データを保存
- (void)saveData
{
    Record *record = [Record MR_createEntity];
    record.day = self.day;
    record.time = self.time;
    record.image = self.image;
    record.title = self.mealTitle;
    record.cost = self.mealCost;
    record.primaryId= self.idNumber;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [self checkData];
}

- (void)checkData
{
    NSNumber *count = [Record MR_numberOfEntities];
    NSLog(@"count:%@",count);
    
    NSLog(@"ID:%@",self.idNumber);
    
    NSString *num = self.idNumber;
    Record *record = [Record MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"primaryId = %@",num]];
    NSLog(@"info:%@,%@,%@,%@,%@,%@",record.day,record.time,record.image,record.title,record.cost,record.primaryId);
}


@end
