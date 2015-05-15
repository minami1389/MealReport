//
//  MMCalendarDetailViewController.m
//  MealReport
//
//  Created by minami on 4/24/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import "MMCalendarDetailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface MMCalendarDetailViewController ()
{
    NSArray *monthRecords;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *leftArrowButton;
@property (weak, nonatomic) IBOutlet UIButton *rightArrowButton;
@end

@implementation MMCalendarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _commentTextView.layer.borderWidth = 0.5;
    _commentTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    //_commentTextView.layer.cornerRadius = 5.0f;
    
    _photo.layer.borderWidth = 0.5;
    _photo.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    [self setInfo];
    [self getRecordIndex];
    [self resetArrowHidden];
    
    // 左へスワイプ
    UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftGesture:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGesture];
    // 右へスワイプ
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightGesture:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGesture];
}

- (void)setInfo
{
    NSString *time;
    switch ([_record.time integerValue]) {
        case 0:
            time = @"朝食";
            break;
        case 1:
            time = @"昼食";
            break;
        case 2:
            time = @"夕食";
            break;
        default:
            break;
    }
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@日%@",[self dayStringConvert:_record.day],time];
    _titleLabel.text = _record.title;
    _costLabel.text = [NSString stringWithFormat:@"%@円",_record.cost];
    [self setMealPhoto:_record.imageUrl];
    _commentTextView.text = _record.comment;
}

- (NSString *)monthStringConvert:(NSString *)month
{
    NSDate *date = [[self dateFormatterMonthBefore] dateFromString:month];
    return [[self dateFormatterMonthAfter] stringFromDate:date];
}

- (NSString *)dayStringConvert:(NSString *)day
{
    NSDate *date = [[self dateFormatterDayBefore] dateFromString:day];
    return [[self dateFormatterDayAfter] stringFromDate:date];
}

- (NSDateFormatter *)dateFormatterMonthBefore
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"jp_JP"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyyMM"];
    
    return dateFormatter;
}

- (NSDateFormatter *)dateFormatterMonthAfter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"jp_JP"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyy年M月"];
    
    return dateFormatter;
}

- (NSDateFormatter *)dateFormatterDayBefore
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"jp_JP"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    return dateFormatter;
}

- (NSDateFormatter *)dateFormatterDayAfter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"jp_JP"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"d"];
    
    return dateFormatter;
}


- (void)setMealPhoto:(NSString *)url
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:[NSURL URLWithString:url] resultBlock:^(ALAsset *asset) {
        UIImage *image;
        if (!url) {
            self.photo.contentMode = UIViewContentModeScaleAspectFit;
            switch ([_record.time integerValue]) {
                case 0:
                    image = [UIImage imageNamed:@"iconRed.png"];
                    break;
                case 1:
                    image = [UIImage imageNamed:@"iconYellow.png"];
                    break;
                case 2:
                    image = [UIImage imageNamed:@"iconBlue.png"];
                    break;
                default:
                    break;
            }
        } else {
            self.photo.contentMode = UIViewContentModeScaleAspectFill;
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *buffer = (Byte*)malloc((unsigned)rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(unsigned)rep.size error:nil];
            NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES]; //これが必要なデータ
            image = [UIImage imageWithData:data];
        }
        [_photo setImage:image];
    } failureBlock:^(NSError *error) {
    }];
}

- (void)getRecordIndex
{
    NSString *compareId = _record.primaryId;
    NSArray *records = [Record MR_findByAttribute:@"month" withValue:_record.month andOrderBy:@"primaryId" ascending:YES];
    monthRecords = records;
    NSInteger index = 0;
    for (Record *record in records) {
        NSString *actualId = record.primaryId;
        if ([actualId isEqualToString:compareId]) { break; }
        index++;
    }
    if (index >= [records count]) { index = -1; }
    _index = index;
}

- (BOOL)hasPrevRecord
{
    return _index-1 >= 0;
}

- (BOOL)hasNextRecord
{
    return _index+1 < [monthRecords count];
}

- (void) handleSwipeRightGesture:(UISwipeGestureRecognizer *)sender
{
    [self pushLeftArrowButton:sender];
}

- (void) handleSwipeLeftGesture:(UISwipeGestureRecognizer *)sender
{
    [self pushRightArrowButton:sender];
}
- (IBAction)pushLeftArrowButton:(id)sender
{
    if ([self hasPrevRecord]) {
        _index--;
        _record = [monthRecords objectAtIndex:_index];
        [self setInfo];
        [self.view setNeedsLayout];
        [self showView];
    }
    [self resetArrowHidden];
}
- (IBAction)pushRightArrowButton:(id)sender
{
    if ([self hasNextRecord]) {
        _index++;
        _record = [monthRecords objectAtIndex:_index];
        [self setInfo];
        [self.view setNeedsLayout];
        [self showView];
    }
    [self resetArrowHidden];
    
}

- (void)resetArrowHidden
{
    if ([self hasPrevRecord]) {
        _leftArrowButton.hidden = NO;
    } else {
        _leftArrowButton.hidden = YES;
    }
    if ([self hasNextRecord]) {
        _rightArrowButton.hidden = NO;
    } else {
        _rightArrowButton.hidden = YES;
    }
}

- (void)showView
{
    _photo.alpha = 0;
    _titleLabel.alpha = 0;
    _costLabel.alpha = 0;
    _commentTextView.alpha = 0;
    [UIView animateWithDuration:0.7f animations:^{
        _photo.alpha = 1.0;
        _titleLabel.alpha = 1.0;
        _costLabel.alpha = 1.0;
        _commentTextView.alpha = 1.0;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
