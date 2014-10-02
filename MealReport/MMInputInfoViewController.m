//
//  MMInputInfoViewController.m
//  MealReport
//
//  Created by minami on 2014/09/15.
//  Copyright (c) 2014年 Minami Baba. All rights reserved.
//

#import "MMInputInfoViewController.h"
#import "MMInputDetailInfoViewController.h"

@interface MMInputInfoViewController ()

@end

@implementation MMInputInfoViewController

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
    
    //アプリ画面サイズを取得
    self.screenRect = [[UIScreen mainScreen] bounds];
    
    //表示される日付を今日に
    self.dateLabel.text = [NSString stringWithFormat:@"%@",[[self dateFormatter] stringFromDate:[NSDate date]]];
    
    //UIDatePickerを準備
    self.datePicker = [[UIDatePicker alloc] init];
    self.dateView = [[UIView alloc] init];
    [self.dateView addSubview:self.datePicker];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - 画面遷移
//朝食ボタンをタップ
- (IBAction)breakfastButtonPressed:(id)sender
{
    
    //押したボタンのindex取得
    self.selectedButtonIndex = 0;
    
    //画面遷移
    MMInputDetailInfoViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InputDetailInfoView"];
    [self.navigationController pushViewController:nextViewController animated:YES];
}

//昼食ボタンをタップ
- (IBAction)lunchButtonPressed:(id)sender
{
    
    //押したボタンのindex取得
    self.selectedButtonIndex = 1;
    
    //画面遷移
    MMInputDetailInfoViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InputDetailInfoView"];
    [self.navigationController pushViewController:nextViewController animated:YES];
}

//夕食ボタンをタップ
- (IBAction)dinnerButtonPressed:(id)sender {
    
    self.selectedButtonIndex = 2;
    
    MMInputDetailInfoViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InputDetailInfoView"];
    [self.navigationController pushViewController:nextViewController animated:YES];
}


#pragma mark - datePicker
//日付をタップ
- (IBAction)dateButton:(id)sender {
    
    //DatePickerを表示
    [self showUpDatePicker];
    
}

//日付のフォーマット指定
- (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"jp_JP"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 の"];
    
    return dateFormatter;
}

//日付をタップすると呼ばれる
//DatePickerを出す
- (void)showUpDatePicker
{
    self.dateView.backgroundColor = [UIColor whiteColor];

    //DatePickerに日付を指定
    self.datePicker.date = [[self dateFormatter] dateFromString:self.dateLabel.text];
    
    //DatePickerの設定
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    
    
    //DatePickerのsizeと隠れている時のRectを指定
    CGSize pickerSize = [self.datePicker sizeThatFits:CGSizeZero];
    CGRect startRect = CGRectMake(0.0, self.screenRect.origin.y + self.screenRect.size.height, pickerSize.width, pickerSize.height);
    
    //viewにaddされているか否かによって条件分岐
    if (self.dateView.superview == nil || self.dateView.frame.origin.y == startRect.origin.y) {
        
        //superviewにadd
        [self.view.window addSubview:self.dateView];
        
        //隠しRectに指定
        self.dateView.frame = startRect;
        
        //DatePickerの見えている時のRectを指定
        CGFloat buttonHeight = 40;
        CGRect pickerRect = CGRectMake(0.0, self.screenRect.origin.y + self.containerView.frame.origin.y + self.underLine.frame.origin.y + buttonHeight / 2, pickerSize.width, self.screenRect.size.height);
        
        //アニメーション処理
        [UIView animateWithDuration:0.5f
                         animations:^{
                             self.dateView.frame = pickerRect;
                         }];
    } else {
        //アニメーション処理
        [UIView animateWithDuration:0.5f
                         animations:^{
                             self.dateView.frame = startRect;
                         }];
    }
    

}

- (void)pickerDidChange:(UIDatePicker *)datePicker
{
    NSString *date = [[self dateFormatter] stringFromDate:datePicker.date];
    self.selectedDateString = date;
}

@end
