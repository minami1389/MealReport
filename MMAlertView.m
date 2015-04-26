//
//  MMAlertView.m
//  MealReport
//
//  Created by minami on 3/5/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import "MMAlertView.h"


@implementation MMAlertView
{
    AlertActionBlock alertActionBlock;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message selfVC:(UIViewController *)selfVC
{
    if(NSClassFromString(@"UIAlertController")){
        // UIAlertControllerを使ってアラートを表示
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [selfVC presentViewController:alert animated:YES completion:nil];
    } else {
        // UIAlertViewを使ってアラートを表示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message selfVC:(UIViewController *)selfVC cancel:(NSString *)cancel ok:(NSString *)ok action:(AlertActionBlock)alertAction
{
    if(NSClassFromString(@"UIAlertController")){
        // UIAlertControllerを使ってアラートを表示
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        if (cancel) {
            [alert addAction:[UIAlertAction actionWithTitle:cancel
                                                      style:UIAlertActionStyleDefault
                                                    handler:nil]];
        }
        if (ok) {
            [alert addAction:[UIAlertAction actionWithTitle:ok
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action){
                                                        alertAction();
                                                    }]];
        }
        [selfVC presentViewController:alert animated:YES completion:nil];
    } else {
        // UIAlertViewを使ってアラートを表示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:selfVC
                                              cancelButtonTitle:cancel
                                              otherButtonTitles:ok, nil];
        [alert show];
    }
}

@end
