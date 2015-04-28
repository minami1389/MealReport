//
//  MMInputDetailInfoViewController.m
//  MealReport
//
//  Created by minami on 2014/09/15.
//  Copyright (c) 2014年 Minami Baba. All rights reserved.
//

#import "MMInputDetailInfoViewController.h"
#import "Record.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface MMInputDetailInfoViewController ()
{
    UIImage *selectedImage_;
    
    //DBで管理するもの
    NSString *mealTitle_;
    NSNumber *mealCost_;
    NSString *comment_;
    NSString *idNumber_;
    NSString *imageUrl_;
    
    BOOL saveNewData;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *imageSelectButton;
- (IBAction)imageSelectButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *costTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
- (IBAction)saveButton:(id)sender;

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
    
    //デフォルト値設定
    mealCost_ = @(500);
    comment_ = @"";
    switch (_selectedButtonIndex) {
        case 0:
            mealTitle_ = @"朝食";
            break;
            
        case 1:
            mealTitle_ = @"昼食";
            break;
            
        case 2:
            mealTitle_ = @"夕食";
            break;
            
        default:
            break;
    }
    
    imageUrl_ = nil;
    
    //タイトルの設定
    self.navigationItem.title = _dateNotForDB;
    
    //titleTextFieldの設定
    _titleTextField.layer.borderWidth = 0.3;
    _titleTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _titleTextField.layer.cornerRadius = 5.0f;
    _titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _titleTextField.placeholder = mealTitle_;
    
    //costTextFieldの設定
    _costTextField.layer.borderWidth = 0.3;
    _costTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _costTextField.layer.cornerRadius = 5.0f;
    _costTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //commentTextFieldの設定
    _commentTextView.layer.borderWidth = 0.3;
    _commentTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _commentTextView.layer.cornerRadius = 5.0f;

    //imageViewの設定
    _imageView.layer.borderWidth = 1.5;
    _imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _imageView.layer.cornerRadius = 10.0f;
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

//フォトライブラリ表示
- (void)showPhotoLibrary
{
    //photoLibaryが使えるかどうかの判断
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        MMAlertView *alert = [[MMAlertView alloc] init];
        [alert showAlertWithTitle:@"フォトアルバム" message:@"使うことが出来ません" selfVC:self];
        return;
    }
    
    //photoLibrary表示
    UIImagePickerController *photoLibrary = [[UIImagePickerController alloc] init];
    photoLibrary.delegate = self;
    [photoLibrary setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:photoLibrary animated:YES completion:nil];
    
}

//写真を選択したら呼ばれる
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //photo取得
    NSURL *referenceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:referenceURL resultBlock:^(ALAsset *asset) {
        
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        Byte *buffer = (Byte*)malloc((unsigned)rep.size);
        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(unsigned)rep.size error:nil];
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES]; //これが必要なデータ
    
        UIImage *image = [UIImage imageWithData:data];
        [_imageView setImage:image];
        imageUrl_ = [referenceURL absoluteString];
        
        } failureBlock:^(NSError *error) {
        // error handling
    }];
    
    //photoLibrary dismiss
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //imageSelectButtonメッセージ,枠線非表示
    [_imageSelectButton setTitle:@"" forState:UIControlStateNormal];
    _imageView.layer.borderWidth = 0;
}


#pragma mark - textField

//画面の何もない部分を触ればキーボードが閉じる
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//returnを押せばキーボードが閉じる
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - save
//保存ボタンを押すと呼ばれる
- (IBAction)saveButton:(id)sender {
    
    //キーボードを閉じる
    [self.view endEditing:YES];
    
    //未入力(もしくはwhitespace)の場合はデフォルト値を代入
    if (![[MMString eliminateWhitespace:_titleTextField.text] isEqualToString:@""]) {
        mealTitle_ = _titleTextField.text;
    }
    if (![[MMString eliminateWhitespace:_costTextField.text] isEqualToString:@""]) {
        mealCost_ = @(_costTextField.text.integerValue);
    }
    if (![[MMString eliminateWhitespace:_commentTextView.text] isEqualToString:@""]) {
        comment_ = _commentTextView.text;
    }
    
    idNumber_ = [NSString stringWithFormat:@"%@%@",_day,_time];
    
    //アラート表示
    NSString *num = idNumber_;
    Record *record = [Record MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"primaryId = %@",num]];
    if (record) {
        
        saveNewData = NO;
        MMAlertView *alert = [[MMAlertView alloc] init];
        [alert showAlertWithTitle:[NSString stringWithFormat:@"%@%@",_dateNotForDB,_titleTextField.placeholder]
                          message:@"すでに登録されています"
                           selfVC:self
                           cancel:@"保存しない"
                               ok:@"上書き保存する" action:^(void){
                                   //上書き保存
                                   [self saveDataWithNew:saveNewData];
                                   [self saveFinishedAlert];
                               }];
    
    } else {
        
        saveNewData = YES;
        MMAlertView *alert = [[MMAlertView alloc] init];
        [alert showAlertWithTitle:[NSString stringWithFormat:@"%@%@",_dateNotForDB,_titleTextField.placeholder]
                          message:@"保存しますか"
                           selfVC:self
                           cancel:@"いいえ"
                               ok:@"はい"
                           action:^(void){
                               //新規保存
                               [self saveDataWithNew:saveNewData];
                               [self saveFinishedAlert];
                           }];
    }
}

//データを保存
- (void)saveDataWithNew:(BOOL)new
{
    Record *record;
    if (new) {
        record = [Record MR_createEntity];
    } else {
        NSString *num = idNumber_;
        record = [Record MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"primaryId = %@",num]];
    }
    
    record.day = _day;
    record.time = _time;
    record.imageUrl = imageUrl_;
    record.title = mealTitle_;
    record.cost = mealCost_;
    record.comment = comment_;
    record.primaryId= idNumber_;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [self checkData];
}

//データをチェック
- (void)checkData
{
    NSNumber *count = [Record MR_numberOfEntities];
    NSLog(@"count:%@",count);
    
    NSLog(@"ID:%@",idNumber_);
    
    NSString *num = idNumber_;
    Record *record = [Record MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"primaryId = %@",num]];
    NSLog(@"\ninfo{\n day:%@\n time:%@\n image:%@\n title:%@\n cost:%@\n comment:%@\n id:%@\n}",record.day,record.time,record.imageUrl,record.title,record.cost,record.comment,record.primaryId);
}

//"保存が完了しました"alertを表示
- (void)saveFinishedAlert
{
    MMAlertView *alert = [[MMAlertView alloc] init];
    [alert showAlertWithTitle:@"保存が完了しました" message:nil selfVC:self cancel:nil ok:@"はい" action:^(void){
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

//AlertAction
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            // 保存が完了しました->"はいボタンが押された時の処理
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
            // 保存or上書き保存ボタンが押されたときの処理
            [self saveDataWithNew:saveNewData];
            [self saveFinishedAlert];
            break;
    }
}


@end
