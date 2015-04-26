//
//  MMCalendarViewController.m
//  MealReport
//
//  Created by minami on 3/5/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import "MMCalendarViewController.h"
#import "MMCalendarCollectionViewCell.h"
#import "Record.h"
#import "MMCalendarDetailViewController.h"

@interface MMCalendarViewController ()
{
    NSInteger year_;
    NSInteger month_;
    NSInteger dayCount_;
    
    NSArray *mealRecords;
    
    NSInteger costSum_month;
}

@end

@implementation MMCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:today];
    year_ = dateComps.year;
    month_ = dateComps.month;
    dayCount_ = [self daysCountAtMonth];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_calendarView reloadData];
}

- (NSInteger)daysCountAtMonth
{
    // デフォルトのカレンダーを取得
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"yyyy/M/d"];
    
    NSString *nextMonth = [NSString stringWithFormat:@"%ld/%ld",(long)year_,(long)[self nextMonth]];
    NSDate *firstDay = [inputDateFormatter dateFromString:[nextMonth stringByAppendingFormat:@"/1"]]; //次月の1日
    NSDate *lastDay = [firstDay initWithTimeInterval:-1*24*60*60 sinceDate:firstDay]; // 当月の末日
    NSDateComponents *resComps = [calendar components:
                                  NSYearCalendarUnit   |
                                  NSMonthCalendarUnit  |
                                  NSDayCalendarUnit
                                             fromDate:lastDay];
    return resComps.day;
}

- (NSInteger)nextMonth
{
    NSInteger next = month_+1;
    if (month_ == 12) next = 1;
    return next;
}

- (NSInteger)weekDay:(NSString *)dateString
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"yyyy/M/d"];
    
    NSDate *date = [inputDateFormatter dateFromString:dateString];
    NSDateComponents *c = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    return [c weekday];
}


#pragma mark - collection view delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dayCount_;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"calendarCell" forIndexPath:indexPath];
    cell.mealPhotoImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.breakfastMark.hidden = YES;
    cell.lunchMark.hidden = YES;
    cell.dinnerMark.hidden = YES;
    
    cell.dayLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    NSInteger weekday = [self weekDay:[NSString stringWithFormat:@"%ld/%ld/%d",(long)year_,(long)month_,indexPath.row+1]];
    if (weekday == 5) {
        cell.layer.borderColor = [UIColor colorWithRed:173/255.0 green:216/255.0 blue:230/255.0 alpha:1.0].CGColor;
    } else if(weekday == 6) {
        cell.layer.borderColor = [UIColor colorWithRed:255/255.0 green:182/255.0 blue:193/255.0 alpha:1.0].CGColor;
    } else {
        cell.layer.borderColor = [UIColor colorWithRed:255/255.0 green:222/255.0 blue:173/255.0 alpha:1.0].CGColor;
    }
    
    //データ挿入
    NSArray *records = [self getRecordsWithday:indexPath.row+1];
    Record *record0 = nil;
    Record *record1 = nil;
    Record *record2 = nil;
    for(Record *record in records) {
        switch ([record.time integerValue]) {
            case 0:
                record0 = record;
                break;
            case 1:
                record1 = record;
                break;
            case 2:
                record2 = record;
                break;
            default:
                break;
        }
    }

    NSInteger costSum_day = 0;
    NSData *photo_data = nil;
    if (record0) {
        if (record0.image) { photo_data = record0.image; }
        costSum_month += [record0.cost integerValue];
        costSum_day += [record0.cost integerValue];
        cell.breakfastMark.hidden = NO;
    }
    if (record1) {
        if (record1.image) { photo_data = record1.image; }
        costSum_month += [record1.cost integerValue];
        costSum_day += [record1.cost integerValue];
        cell.lunchMark.hidden = NO;
    }
    if (record2) {
        if (record2.image) { photo_data = record2.image; }
        costSum_month += [record2.cost integerValue];
        costSum_day += [record2.cost integerValue];
        cell.dinnerMark.hidden = NO;
    }
    /*
    if (photo_data) {
        [cell.mealPhotoImageView setImage:[[UIImage alloc] initWithData:photo_data]];
        cell.mealPhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.mealPhotoImageView.alpha = 1.0;
    }
     */
    cell.mealCostLabel.text = [NSString stringWithFormat:@"%ld円",(long)costSum_day];
    
    return cell;
}

- (NSArray *)getRecordsWithday:(NSInteger)day
{
    NSString *year_string = [NSString stringWithFormat:@"%ld",(long)year_];
    NSString *month_string = [NSString stringWithFormat:@"%ld",(long)month_];
    if (month_ < 10) { month_string = [NSString stringWithFormat:@"0%ld",(long)month_]; }
    NSString *day_string = [NSString stringWithFormat:@"%ld",(long)day];
    if (day < 10) { day_string = [NSString stringWithFormat:@"0%ld",(long)day]; }
    
    NSArray *records = [Record MR_findByAttribute:@"day"
                                        withValue:[NSString stringWithFormat:@"%@%@%@",year_string,month_string,day_string]];
    return records;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    MMCalendarCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"calendarHeader" forIndexPath:indexPath];
    header.delegate = self;
    [header.dayButton setTitle:[NSString stringWithFormat:@"%ld年%ld月",(long)year_,(long)month_] forState:UIControlStateNormal];
    header.sumCostLabel.text = [NSString stringWithFormat:@"合計%ld円",(long)costSum_month];
    header.aveCostLabel.text = [NSString stringWithFormat:@"日平均%d円",costSum_month/dayCount_];
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toDetailView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MMCalendarDetailViewController *nextView = [segue destinationViewController];
    
}


#pragma mark - MMCalendarHeaderViewDelegate
- (void)dayButtonPushed
{}

- (void)prevMonthButtonPushed
{
    if (month_ == 1) {
        month_ = 12;
        year_--;
    } else {
        month_--;
    }
    dayCount_ = [self daysCountAtMonth];
    [_calendarView reloadData];
}

- (void)nextMonthButtonPushed
{
    if (month_ == 12) {
        month_ = 1;
        year_++;
    } else {
        month_++;
    }
    dayCount_ = [self daysCountAtMonth];
    [_calendarView reloadData];
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
