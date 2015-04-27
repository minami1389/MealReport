//
//  MMColor.m
//  MealReport
//
//  Created by minami on 4/27/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import "MMColor.h"

@implementation MMColor

+ (MMColor *)breakfastColor
{
    return (MMColor *)[UIColor colorWithRed:255/255.0 green:182/255.0 blue:193/255.0 alpha:1.0];
}

+ (MMColor *)lunchColor
{
    return (MMColor *)[UIColor colorWithRed:255/255.0 green:222/255.0 blue:173/255.0 alpha:1.0];
}

+ (MMColor *)dinnerColor
{
    return (MMColor *)[UIColor colorWithRed:173/255.0 green:216/255.0 blue:230/255.0 alpha:1.0];
}

@end
