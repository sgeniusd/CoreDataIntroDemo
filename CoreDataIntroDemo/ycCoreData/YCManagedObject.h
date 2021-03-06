//
//  YCManagedObject.h
//  CoreDataIntroDemo
//
//  Created by bita on 15/4/20.
//  Copyright (c) 2015年 bita. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface YCManagedObject : NSManagedObject

/**
 *  插入一条新的NSManagedObject对象
 */
+ (instancetype)insertNewObject;

/**
 *  NSManagedObject对应Entity的名称，默认与类名相同，可以在子类中重写
 */
+ (NSString *)entityName;

/**
 *  默认的FetchRequest
 */
- (NSFetchRequest *)defaultFetchRequest;

/**
 *  根据谓词查询
 */
- (NSArray *)fetchByPredicate:(NSString *)predicate;

/**
 *  查询所有数据并排序
 */
- (NSArray *)fetchBySortKey:(NSString*)sortKey
                  ascending:(BOOL)ascending;

/**
 *  根据谓词查询并排序
 */
- (NSArray *)fetchByPredicate:(NSString *)predicate
                      sortKey:(NSString*)sortKey
                    ascending:(BOOL)ascending
                        error:(NSError **)error;

/**
 *  根据ID删除
 */
- (void) deleteObjectByID:(NSManagedObjectID*)objectID;

/**
 *  删除当前对象
 */
- (void) deleteSelf;

/**
 *  根据谓词删除
 */
- (void)deleteObjectByPredicate:(NSString *)predicate;

@end
