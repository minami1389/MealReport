//
//  Record.h
//  MealReport
//
//  Created by minami on 2014/10/04.
//  Copyright (c) 2014年 Minami Baba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Record : NSManagedObject

@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * cost;

@end
