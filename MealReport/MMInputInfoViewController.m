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
{
    CGRect startRect;
    CGRect pickerRect;
}

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
    
    //UIDateViewを準備
    self.dateView = [[UIView alloc] init];
    
    self.datePicker = [[UIDatePicker alloc] init];
    [self.dateView addSubview:self.datePicker];
    [self.datePicker addTarget:self action:@selector(pickerDidChange:) forControlEvents:UIControlEventValueChanged];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    returnButton.frame = CGRectMake(50, self.datePicker.frame.size.height, self.screenRect.size.width - 100, 50);
    [returnButton setTitle:@"決定" forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:30];
    [returnButton addTarget:self action:@selector(closeDatePicker) forControlEvents:UIControlEventTouchDown];
    [self.dateView addSubview:returnButton];
    
    //navigation bar title
    //self.navigationItem.title = @"記録";
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
    
    //viewにaddされているか否かによって条件分岐
    if (self.dateView.superview == nil || self.dateView.frame.origin.y == startRect.origin.y) {
        
        //superviewにadd
        [self.view.window addSubview:self.dateView];
        
        //DatePickerのsizeと隠れている時のRectを指定
        CGSize pickerSize = [self.datePicker sizeThatFits:CGSizeZero];
        startRect = CGRectMake(0.0, self.screenRect.origin.y + self.screenRect.size.height, pickerSize.width, pickerSize.height);
        
        //隠しRectに指定
        self.dateView.frame = startRect;
        
        //DatePickerの見えている時のRectを指定
        CGFloat buttonHeight = 40;
        pickerRect = CGRectMake(0.0, self.screenRect.origin.y + self.containerView.frame.origin.y + self.underLine.frame.origin.y + buttonHeight / 4, pickerSize.width, self.screenRect.size.height);
        
        [self presentDatePicker];
        
    } else {
        
        [self closeDatePicker];

    }
    

}

- (void)pickerDidChange:(UIDatePicker *)datePicker
{
    NSString *date = [[self dateFormatter] stringFromDate:datePicker.date];
    self.dateLabel.text = date;
    self.selectedDateString = date;
}

- (void)presentDatePicker
{
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.dateView.frame = pickerRect;
                     }];
}

- (void)closeDatePicker
{
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.dateView.frame = startRect;
                     }];
}

@end
