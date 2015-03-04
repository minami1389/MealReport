//
//  MMString.m
//  MealReport
//
//  Created by minami on 3/5/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import "MMString.h"

@implementation MMString

+ (NSString *)eliminateWhitespace:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
