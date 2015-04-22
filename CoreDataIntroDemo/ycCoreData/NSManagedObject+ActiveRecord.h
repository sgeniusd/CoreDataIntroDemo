//
//  NSManagedObject+ActiveRecord.h
//  CoreDataIntroDemo
//
//  Created by bita on 15/4/20.
//  Copyright (c) 2015年 bita. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (ActiveRecord)

/**
 *  NSManagedObject对应Entity的名称，默认与类名相同，可以在子类中重写
 */
+ (NSString *)entityName;

/**
 *  默认的FetchRequest
 */
+ (NSFetchRequest *)defaultFetchRequest;

/**
 *  插入一条新的NSManagedObject对象
 */
+ (instancetype)insertNewObject;

/**
 *  根据谓词查询
 */
+ (NSArray *)fetchByPredicate:(NSString *)predicate,...;

/**
 *  查询所有数据并排序
 */
+ (NSArray *)fetchBySortKey:(NSString*)sortKey
                  ascending:(BOOL)ascending;

/**
 *  根据谓词查询并排序(可变参数)
 */
+ (NSArray *)fetchBySortKey:(NSString*)sortKey
                  ascending:(BOOL)ascending
                  predicate:(NSString *)predicate,...;

/**
 *  根据谓词查询并排序(内部封装用)
 */
+ (NSArray *)fetchBySortKey:(NSString*)sortKey
                  ascending:(BOOL)ascending
                  predicate:(NSString *)predicate
                  arguments:(va_list)argList;

/**
 *  根据ID删除
 */
+ (void) deleteObjectByID:(NSManagedObjectID*)objectID;

/**
 *  根据谓词删除
 */
+ (void)deleteObjectByPredicate:(NSString *)predicate,...;

/**
 *  删除当前对象
 */
- (void) deleteSelf;

@end
