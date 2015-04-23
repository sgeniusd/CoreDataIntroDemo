//
//  Entity1.h
//  CoreDataIntroDemo
//
//  Created by bita on 15/4/20.
//  Copyright (c) 2015年 bita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+ActiveRecord.h"

@interface Entity1 : NSManagedObject

@property (nonatomic, copy) NSString  *ycTitle;
@property (nonatomic, assign) NSInteger ycOrder;
@property (nonatomic, strong) NSDate    *ycCreateTime;
@property (nonatomic, strong) UIColor   *ycColor;
@property (nonatomic, strong) NSArray   *ycValues;
@property (nonatomic, copy) NSString    *ycExtra;
@property (nonatomic, strong) Entity1   *parent;
@property (nonatomic, strong) NSSet     *child;
@property (nonatomic, strong) NSSet     *otherchild;

/**
 *  自定义property（临时）
 */
@property (nonatomic, readonly) NSString *formateDate;  //格式化日期

- (NSFetchedResultsController *)childrenFetchedResultsController;

/**
 *  无parent的Entity1
 */
+ (Entity1 *)rootItem;

- (void)addOtherchild:(NSSet *)objects;
- (void)removeOtherchild:(NSSet *)objects;

@end
