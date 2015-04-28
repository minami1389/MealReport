//
//  Record.h
//  MealReport
//
//  Created by minami on 4/28/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Record : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSString * primaryId;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * month;

@end
