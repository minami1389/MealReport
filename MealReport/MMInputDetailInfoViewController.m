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
{
    UIImage *_selectedImage;
    
    //DBで管理するもの
    NSData *_image;
    NSString *_mealTitle;
    NSNumber *_mealCost;
    NSString *_idNumber;
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
    
    //imageViewの設定
    _imageView.layer.borderWidth = 1.5;
    _imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _imageView.layer.cornerRadius = 10.0f;
    
    //commentTextFieldの設定
    _commentTextView.layer.borderWidth = 0.5;
    _commentTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _commentTextView.layer.cornerRadius = 5.0f;
    
    //デフォルト値設定
    switch (_selectedButtonIndex) {
        case 0:
            _mealTitle = @"朝食";
            _mealCost = @(500);
            break;
            
        case 1:
            _mealTitle = @"昼食";
            _mealCost = @(500);
            break;
            
        case 2:
            _mealTitle = @"夕食";
            _mealCost = @(500);
            break;
            
        default:
            break;
    }

    //textFieldの設定
    _titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _titleTextField.placeholder = _mealTitle;
    
    _costTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
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
        
        //アラート表示
        //iOS8時の処理
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"フォトアルバム" message:@"使うことが出来ません" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
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
    //photoLibrary dismiss
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //photo取得
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_imageView setImage:image];
    _selectedImage = image;
    
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
    
    //未入力の場合はデフォルト値を代入
    if (![_titleTextField.text isEqualToString:@""]) {
        _mealTitle = _titleTextField.text;
    }
    if (![_costTextField.text isEqualToString:@""]) {
        NSString *string = _costTextField.text;
        _mealCost = @(string.integerValue);
    }
    
    
    //値のセット
    _image = [[NSData alloc] initWithData:UIImagePNGRepresentation(_imageView.image)];
    _idNumber = [NSString stringWithFormat:@"%@%@",_time,_day];
    
    
    //アラート表示
    NSString *num = _idNumber;
    Record *record = [Record MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"primaryId = %@",num]];
    if (record) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@",_dateNotForDB,_titleTextField.placeholder] message:@"すでに登録されています" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"保存しない" style:UIAlertActionStyleDefault handler:nil]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"上書き保存する" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //上書き保存
            [self saveDataWithNew:NO];
            [self saveFinishedAlert];
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    
    } else {
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@",_dateNotForDB,_titleTextField.placeholder] message:@"保存しますか？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"いいえ" style:UIAlertActionStyleDefault handler:nil]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"はい" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //新規保存
            [self saveDataWithNew:YES];
            [self saveFinishedAlert];
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}


//データを保存
- (void)saveDataWithNew:(BOOL)new
{
    Record *record;
    if (new) {
        record = [Record MR_createEntity];
    } else {
        NSString *num = _idNumber;
        record = [Record MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"primaryId = %@",num]];
    }
    
    record.day = _day;
    record.time = _time;
    record.image = _image;
    record.title = _mealTitle;
    record.cost = _mealCost;
    record.primaryId= _idNumber;

    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [self checkData];
}

//データをチェック
- (void)checkData
{
    NSNumber *count = [Record MR_numberOfEntities];
    NSLog(@"count:%@",count);
    
    NSLog(@"ID:%@",_idNumber);
    
    NSString *num = _idNumber;
    Record *record = [Record MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"primaryId = %@",num]];
    NSLog(@"info:%@,%@,%@,%@,%@,%@",record.day,record.time,record.image,record.title,record.cost,record.primaryId);
}

//"保存が完了しました"alertを表示
- (void)saveFinishedAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存が完了しました" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"はい" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
