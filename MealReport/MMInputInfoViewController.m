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
    // Do any additional setup after loading the view.
    [self.datePicker addTarget:self action:@selector(pickerDidChange:) forControlEvents:UIControlEventValueChanged];
    }

- (void)pickerDidChange:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"jp_JP"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *date = [dateFormatter stringFromDate:datePicker.date];
    self.selectedDateString = date;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)breakfastButtonPressed:(id)sender {
    self.selectedButtonIndex = 0;
    MMInputDetailInfoViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InputDetailInfoView"];
    nextViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nextViewController animated:YES completion:nil];
}

- (IBAction)lunchButtonPressed:(id)sender {
    self.selectedButtonIndex = 1;
    MMInputDetailInfoViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InputDetailInfoView"];
    nextViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nextViewController animated:YES completion:nil];
}

- (IBAction)dinnerButtonPressed:(id)sender {
    self.selectedButtonIndex = 2;
    MMInputDetailInfoViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InputDetailInfoView"];
    nextViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nextViewController animated:YES completion:nil];
}
@end
