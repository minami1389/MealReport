//
//  MMAlertView.h
//  MealReport
//
//  Created by minami on 3/5/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AlertActionBlock)(void);

@interface MMAlertView : NSObject<UIAlertViewDelegate>

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message selfVC:(UIViewController *)selfVC;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message selfVC:(UIViewController *)selfVC cancel:(NSString *)cancel ok:(NSString *)ok action:(AlertActionBlock)action;


@end
