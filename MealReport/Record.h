//
//  Record.h
//  MealReport
//
//  Created by minami on 4/26/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Record : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * primaryId;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSString * month;

@end
