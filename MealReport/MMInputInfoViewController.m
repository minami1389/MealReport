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
    CGRect startRect_;
    CGRect pickerRect_;
    
    CGRect screenRect_;
    
    UIDatePicker *recordDatePicker_;
    UIView *recordDatePickerView_;
    
    //DBで管理するもの
    NSString *selectedDateString_;
    NSNumber *selectedTime_;

    NSInteger selectedButtonIndex_;
}

- (IBAction)breakfastButtonPressed:(id)sender;
- (IBAction)lunchButtonPressed:(id)sender;
- (IBAction)dinnerButtonPressed:(id)sender;
- (IBAction)dateButton:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

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
    screenRect_ = [[UIScreen mainScreen] bounds];
    
    //表示される日付を今日に
    selectedDateString_ = [NSString stringWithFormat:@"%@",[[self dateFormatterForDB] stringFromDate:[NSDate date]]];
    _dateLabel.text = [NSString stringWithFormat:@"%@",[[self dateFormatter] stringFromDate:[NSDate date]]];;
    
    //UIDateViewを準備
    recordDatePickerView_ = [[UIView alloc] init];
    
    recordDatePicker_ = [[UIDatePicker alloc] init];
    [recordDatePickerView_ addSubview:recordDatePicker_];
    [recordDatePicker_ addTarget:self action:@selector(pickerDidChange:) forControlEvents:UIControlEventValueChanged];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    returnButton.frame = CGRectMake(50, recordDatePicker_.frame.size.height, screenRect_.size.width - 100, 50);
    [returnButton setTitle:@"決定" forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:30];
    [returnButton addTarget:self action:@selector(closeDatePicker) forControlEvents:UIControlEventTouchDown];
    [recordDatePickerView_ addSubview:returnButton];
    
    //dateLabel設定
    _dateLabel.layer.borderWidth = 1.0f;
    _dateLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _dateLabel.layer.cornerRadius = 10.0f;

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
    selectedButtonIndex_ = 0;
    [self mealButtonPressed];
}

//昼食ボタンをタップ
- (IBAction)lunchButtonPressed:(id)sender
{
    selectedButtonIndex_ = 1;
    [self mealButtonPressed];
}

//夕食ボタンをタップ
- (IBAction)dinnerButtonPressed:(id)sender
{
    selectedButtonIndex_ = 2;
    [self mealButtonPressed];
}

- (void)mealButtonPressed
{
    selectedTime_ = @(selectedButtonIndex_);
    [self performSegueWithIdentifier:@"toNextView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MMInputDetailInfoViewController *nextView = [segue destinationViewController];
    nextView.day = selectedDateString_;
    nextView.time = selectedTime_;
    nextView.selectedButtonIndex = selectedButtonIndex_;
    nextView.dateNotForDB = _dateLabel.text;
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
    [dateFormatter setDateFormat:@"yyyy年M月d日"];
    
    return dateFormatter;
}

- (NSDateFormatter *)dateFormatterForDB
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"jp_JP"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    return dateFormatter;
}

//日付をタップすると呼ばれる
//DatePickerを出す
- (void)showUpDatePicker
{
    recordDatePickerView_.backgroundColor = [UIColor whiteColor];

    //DatePickerに日付を指定
    recordDatePicker_.date = [[self dateFormatter] dateFromString:_dateLabel.text];
    
    //DatePickerの設定
    recordDatePicker_.datePickerMode = UIDatePickerModeDate;
    
    //viewにaddされているか否かによって条件分岐
    if (recordDatePickerView_.superview == nil || recordDatePickerView_.frame.origin.y == startRect_.origin.y) {
        
        //superviewにadd
        [self.view.window addSubview:recordDatePickerView_];
        
        //DatePickerのsizeと隠れている時のRectを指定
        CGSize pickerSize = [recordDatePicker_ sizeThatFits:CGSizeZero];
        startRect_ = CGRectMake(0.0, screenRect_.origin.y + screenRect_.size.height, pickerSize.width, pickerSize.height);
        
        //隠しRectに指定
        recordDatePickerView_.frame = startRect_;
        
        //DatePickerの見えている時のRectを指定
        CGFloat buttonHeight = 40;
        pickerRect_ = CGRectMake(0.0, screenRect_.origin.y + _containerView.frame.origin.y + _dateLabel.frame.size.height + buttonHeight, pickerSize.width, screenRect_.size.height);
        
        [self presentDatePicker];
        
    } else {
        
        [self closeDatePicker];

    }
    

}

- (void)pickerDidChange:(UIDatePicker *)datePicker
{
    NSString *date = [[self dateFormatter] stringFromDate:datePicker.date];
    _dateLabel.text = date;
    
    NSString *dateForDB = [[self dateFormatterForDB] stringFromDate:datePicker.date];
    selectedDateString_ = dateForDB;
}

- (void)presentDatePicker
{
    [UIView animateWithDuration:0.5f
                     animations:^{
                         recordDatePickerView_.frame = pickerRect_;
                     }];
}

- (void)closeDatePicker
{
    [UIView animateWithDuration:0.5f
                     animations:^{
                         recordDatePickerView_.frame = startRect_;
                     }];
}

@end
