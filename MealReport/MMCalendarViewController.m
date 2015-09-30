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
#import "MMColor.h"
#import "MMCalendarNavigationView.h"

@interface MMCalendarViewController ()<MMCalendarNavigationViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSInteger year_;
    NSInteger month_;
    NSInteger dayCount_;
    
    NSInteger costSum_month;
    
    NSInteger selectedDay;
    NSInteger selectedTime;
    
    NSCache *imageCache;
    NSOperationQueue *queue;
    
    MMCalendarNavigationView *navigationView;
}

@end

@implementation MMCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 左へスワイプ
    UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftGesture:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGesture];
    // 右へスワイプ
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightGesture:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGesture];
    
    navigationView = [MMCalendarNavigationView view];
    navigationView.delegate = self;
    self.navigationItem.titleView = navigationView;
    
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:today];
    year_ = dateComps.year;
    month_ = dateComps.month;
    dayCount_ = [self daysCountAtMonth];
    
    imageCache = [[NSCache alloc] init];
    queue = [[NSOperationQueue alloc] init];
    self.navigationItem.title = [NSString stringWithFormat:@"%ld年%ld月",(long)year_,(long)month_];
    navigationView.titleLabel.text = [NSString stringWithFormat:@"%ld年%ld月",(long)year_,(long)month_];
    [self getCostSumMonth];
}

- (void)viewWillAppear:(BOOL)animated
{
   
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
    [self updateCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)updateCell:(MMCalendarCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.selectable = NO;
    
    cell.breakfastMark.hidden = YES;
    cell.lunchMark.hidden = YES;
    cell.dinnerMark.hidden = YES;
    cell.mealCostLabel.hidden = YES;
    cell.mealPhotoImageView.image = nil;
    
    [cell.indicator stopAnimating];
    cell.indicator.hidden = YES;
    
    cell.dayLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    NSInteger weekday = [self weekDay:[NSString stringWithFormat:@"%ld/%ld/%d",(long)year_,(long)month_,indexPath.row+1]];
     if (weekday == 5) {
         cell.layer.borderColor = [MMColor dinnerColor].CGColor;
         cell.dayLabel.backgroundColor = [MMColor dinnerColor];
     } else if(weekday == 6) {
         cell.layer.borderColor = [MMColor breakfastColor].CGColor;
         cell.dayLabel.backgroundColor = [MMColor breakfastColor];
     } else {
         cell.layer.borderColor = [MMColor lunchColor].CGColor;
         cell.dayLabel.backgroundColor = [MMColor lunchColor];
     }
    
    
    //データ挿入
    NSString *imageUrl = nil;
    NSInteger costSum_day = 0;
    NSArray *records = [self getRecordsWithday:indexPath.row+1];
    for(Record *record in records) {
        cell.selectable = YES;
        if (record.imageUrl) { imageUrl = record.imageUrl; }
        costSum_day += [record.cost integerValue];
        cell.visibleTime = [record.time integerValue];
        switch (cell.visibleTime) {
            case 0:
                cell.breakfastMark.hidden = NO;
                break;
            case 1:
                cell.lunchMark.hidden = NO;
                break;
            case 2:
                cell.dinnerMark.hidden = NO;
                break;
            default:
                break;
        }
    }
    
    if (cell.selectable) {
        cell.mealCostLabel.text = [NSString stringWithFormat:@"%ld円",(long)costSum_day];
        cell.mealCostLabel.hidden = NO;
        if (imageUrl) {
            [cell setPost:imageUrl key:[NSString stringWithFormat:@"%@%d",[self getYMD:indexPath.row+1],cell.visibleTime]];
        } else {
             [cell setPost:@"default" key:[NSString stringWithFormat:@"%@%d",[self getYMD:indexPath.row+1],cell.visibleTime]];
        }
    }
    
    
}

- (NSString *)getYMD:(NSInteger)day
{
    NSString *year_string = [NSString stringWithFormat:@"%ld",(long)year_];
    NSString *month_string = [NSString stringWithFormat:@"%ld",(long)month_];
    if (month_ < 10) { month_string = [NSString stringWithFormat:@"0%ld",(long)month_]; }
    NSString *day_string = [NSString stringWithFormat:@"%ld",(long)day];
    if (day < 10) { day_string = [NSString stringWithFormat:@"0%ld",(long)day]; }
    
    return [NSString stringWithFormat:@"%@%@%@",year_string,month_string,day_string];
}

- (NSString *)getYM
{
    NSString *year_string = [NSString stringWithFormat:@"%ld",(long)year_];
    NSString *month_string = [NSString stringWithFormat:@"%ld",(long)month_];
    if (month_ < 10) { month_string = [NSString stringWithFormat:@"0%ld",(long)month_]; }
    
    return [NSString stringWithFormat:@"%@%@",year_string,month_string];
}

- (NSArray *)getRecordsWithday:(NSInteger)day
{
    NSArray *records = [Record MR_findByAttribute:@"day"
                                        withValue:[self getYMD:day]];
    return records;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    MMCalendarCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"calendarHeader" forIndexPath:indexPath];
    header.delegate = self;
    header.sumCostLabel.text = [NSString stringWithFormat:@"合計 %ld円",(long)costSum_month];
    header.aveCostLabel.text = [NSString stringWithFormat:@"平均 %ld円/日",costSum_month/dayCount_];
    return header;
}

- (void)getCostSumMonth
{
    costSum_month = 0;
    NSArray *records = [Record MR_findByAttribute:@"month" withValue:[self getYM]];
    for(Record *record in records) {
        costSum_month += [record.cost integerValue];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMCalendarCollectionViewCell *cell = (MMCalendarCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.selectable) {
        selectedDay = indexPath.row+1;
        selectedTime = cell.visibleTime;
        [self performSegueWithIdentifier:@"toDetailView" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MMCalendarDetailViewController *nextView = [segue destinationViewController];
    nextView.record = [self getRecord];
    nextView.index = -1;
}

- (Record *)getRecord
{
    NSArray *records = [Record MR_findByAttribute:@"primaryId"
                                        withValue:[NSString stringWithFormat:@"%@%d",[self getYMD:selectedDay],selectedTime]];
    return [records firstObject];
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
    [self reloadData];
}

- (void)nextMonthButtonPushed
{
    if (month_ == 12) {
        month_ = 1;
        year_++;
    } else {
        month_++;
    }
    [self reloadData];
}

- (void)reloadData
{
    dayCount_ = [self daysCountAtMonth];
    [self getCostSumMonth];
    self.navigationItem.title = [NSString stringWithFormat:@"%ld年%ld月",(long)year_,(long)month_];
    navigationView.titleLabel.text = [NSString stringWithFormat:@"%ld年%ld月",(long)year_,(long)month_];
    [_calendarView reloadData];
    [self showView];
}

- (void)handleSwipeRightGesture:(UISwipeGestureRecognizer *)sender
{
    [self prevMonthButtonPushed];
}
- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)sender
{
    [self nextMonthButtonPushed];
}
- (void)pushLeftArrowButton
{
    [self prevMonthButtonPushed];
}
- (void)pushRightArrowButton
{
    [self nextMonthButtonPushed];
}

- (void)showView
{
    [UIView animateWithDuration:0.8 animations:^{
        _calendarView.alpha = 0.2;
    }];
    [UIView animateWithDuration:0.8 animations:^{
        _calendarView.alpha = 1.0;
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat oneSide = (screenRect.size.width - 20) / 5;
    return CGSizeMake(oneSide, oneSide);
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
