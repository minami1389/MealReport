//
//  MMInputInfoViewController.m
//  MealReport
//
//  Created by minami on 2014/09/15.
//  Copyright (c) 2014年 Minami Baba. All rights reserved.
//

#import "MMInputInfoViewController.h"

@interface MMInputInfoViewController ()
{
    CGRect startRect;
    CGRect pickerRect;
    
    CGRect screenRect;
    UIDatePicker *recordDatePicker;
    UIView *recordDatePickerView;
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
    screenRect = [[UIScreen mainScreen] bounds];
    
    //表示される日付を今日に
    self.selectedDateString = [NSString stringWithFormat:@"%@",[[self dateFormatter] stringFromDate:[NSDate date]]];
    self.dateLabel.text = self.selectedDateString;
    
    //UIDateViewを準備
    recordDatePickerView = [[UIView alloc] init];
    
    recordDatePicker = [[UIDatePicker alloc] init];
    [recordDatePickerView addSubview:recordDatePicker];
    [recordDatePicker addTarget:self action:@selector(pickerDidChange:) forControlEvents:UIControlEventValueChanged];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    returnButton.frame = CGRectMake(50, recordDatePicker.frame.size.height, screenRect.size.width - 100, 50);
    [returnButton setTitle:@"決定" forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:30];
    [returnButton addTarget:self action:@selector(closeDatePicker) forControlEvents:UIControlEventTouchDown];
    [recordDatePickerView addSubview:returnButton];
    
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
    self.selectedTime = @(self.selectedButtonIndex);
    
    //画面遷移
    [self performSegueWithIdentifier:@"toNextView" sender:self];
}

//昼食ボタンをタップ
- (IBAction)lunchButtonPressed:(id)sender
{
    
    //押したボタンのindex取得
    self.selectedButtonIndex = 1;
    self.selectedTime = @(self.selectedButtonIndex);
    
    //画面遷移
    [self performSegueWithIdentifier:@"toNextView" sender:self];

}

//夕食ボタンをタップ
- (IBAction)dinnerButtonPressed:(id)sender {
    
    self.selectedButtonIndex = 2;
    self.selectedTime = @(self.selectedButtonIndex);
    
    [self performSegueWithIdentifier:@"toNextView" sender:self];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MMInputDetailInfoViewController *nextView = [segue destinationViewController];
    nextView.day = self.selectedDateString;
    nextView.time = self.selectedTime;
    nextView.selectedButtonIndex = self.selectedButtonIndex;
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
    recordDatePickerView.backgroundColor = [UIColor whiteColor];

    //DatePickerに日付を指定
    recordDatePicker.date = [[self dateFormatter] dateFromString:self.dateLabel.text];
    
    //DatePickerの設定
    recordDatePicker.datePickerMode = UIDatePickerModeDate;
    
    //viewにaddされているか否かによって条件分岐
    if (recordDatePickerView.superview == nil || recordDatePickerView.frame.origin.y == startRect.origin.y) {
        
        //superviewにadd
        [self.view.window addSubview:recordDatePickerView];
        
        //DatePickerのsizeと隠れている時のRectを指定
        CGSize pickerSize = [recordDatePicker sizeThatFits:CGSizeZero];
        startRect = CGRectMake(0.0, screenRect.origin.y + screenRect.size.height, pickerSize.width, pickerSize.height);
        
        //隠しRectに指定
        recordDatePickerView.frame = startRect;
        
        //DatePickerの見えている時のRectを指定
        CGFloat buttonHeight = 40;
        pickerRect = CGRectMake(0.0, screenRect.origin.y + self.containerView.frame.origin.y + self.underLine.frame.origin.y + buttonHeight / 4, pickerSize.width, screenRect.size.height);
        
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
                         recordDatePickerView.frame = pickerRect;
                     }];
}

- (void)closeDatePicker
{
    [UIView animateWithDuration:0.5f
                     animations:^{
                         recordDatePickerView.frame = startRect;
                     }];
}

@end
