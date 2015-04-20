//
//  NSManagedObject+ActiveRecord.m
//  CoreDataIntroDemo
//
//  Created by bita on 15/4/20.
//  Copyright (c) 2015年 bita. All rights reserved.
//

#import "NSManagedObject+ActiveRecord.h"
#import "YCStore.h"

@implementation NSManagedObject (ActiveRecord)

#pragma mark - 插入
/**
 *  插入一条新的NSManagedObject对象
 */
+ (instancetype)insertNewObject
{
    return (id)[[YCStore sharedInstance]insertNewObjectForEntityName:[self entityName]];
}

/**
 *  NSManagedObject对应Entity的名称，默认与类名相同，可以在子类中重写
 */
+ (NSString *)entityName
{
    return NSStringFromClass([self class]);
}

#pragma mark - 查询

+ (NSFetchRequest *)defaultFetchRequest
{
    return [NSFetchRequest fetchRequestWithEntityName:[self entityName]];;
}

/**
 *  根据谓词查询
 */
- (NSArray *)fetchByPredicate:(NSString *)predicate
{
    return [self fetchByPredicate:predicate sortKey:nil ascending:NO error:nil];
}

/**
 *  查询所有数据并排序
 */
- (NSArray *)fetchBySortKey:(NSString*)sortKey
                  ascending:(BOOL)ascending
{
    return [self fetchByPredicate:nil sortKey:sortKey ascending:ascending error:nil];
}

/**
 *  根据谓词查询并排序
 */
- (NSArray *)fetchByPredicate:(NSString *)predicate
                      sortKey:(NSString*)sortKey
                    ascending:(BOOL)ascending
                        error:(NSError **)error
{
    NSFetchRequest* request = [NSManagedObject defaultFetchRequest];
    if (predicate.length > 0) {
        request.predicate = [NSPredicate predicateWithFormat:predicate];
    }
    if (sortKey.length > 0) {
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:ascending]];
    }
    return [[YCStore sharedInstance] executeFetchRequest:request error:error];
}

#pragma mark - 删除

- (void) deleteObjectByID:(NSManagedObjectID*)objectID {
    [[YCStore sharedInstance] deleteObjectByID:objectID];
}


- (void) deleteSelf {
    [self deleteObjectByID:self.objectID];
}

/**
 *  根据谓词删除
 */
- (void)deleteObjectByPredicate:(NSString *)predicate
{
    NSArray *toDeleteObjects = [self fetchByPredicate:predicate];
    for (NSManagedObject *toDeleteObject in toDeleteObjects) {
        [toDeleteObject deleteSelf];
    }
}

@end
