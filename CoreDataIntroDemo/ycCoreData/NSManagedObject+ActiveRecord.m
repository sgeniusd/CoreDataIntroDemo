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

/**
 *  NSManagedObject对应Entity的名称，默认与类名相同，可以在子类中重写
 */
+ (NSString *)entityName
{
    return NSStringFromClass([self class]);
}

#pragma mark - 插入
/**
 *  插入一条新的NSManagedObject对象
 */
+ (instancetype)insertNewObject
{
    return (id)[[YCStore sharedInstance]insertNewObjectForEntityName:[self entityName]];
}

///**
// *  异步插入
// */
//+ (void)insertNewObjectAsyn:(void(^)(NSManagedObject *object))insertFinishBlock
//{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        __weak NSManagedObject *insertObject = [[YCStore sharedInstance]insertNewObjectForEntityName:[self entityName]];
//        insertFinishBlock(insertObject);
//        [YCStore saveContext];
//    });
//}

#pragma mark - 查询

+ (NSFetchRequest *)defaultFetchRequest
{
    return [NSFetchRequest fetchRequestWithEntityName:[self entityName]];;
}

/**
 *  根据谓词查询
 */
+ (NSArray *)fetchByPredicate:(NSString *)predicate, ...
{
    NSFetchRequest* request = [self defaultFetchRequest];
    if (predicate.length > 0) {
        va_list args;
        va_start(args, predicate);
        request.predicate = [NSPredicate predicateWithFormat:predicate arguments:args];
        va_end(args);
    }
    return [[YCStore sharedInstance] executeFetchRequest:request error:nil];
}

//+ (void)fetchAsyn:(void(^)(NSArray *resultObjects))fetchFinishBlock
//      byPredicate:(NSString *)predicate,...
//{
//    NSFetchRequest* request = [self defaultFetchRequest];
//    if (predicate.length > 0) {
//        va_list args;
//        va_start(args, predicate);
//        request.predicate = [NSPredicate predicateWithFormat:predicate arguments:args];
//        va_end(args);
//    }
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSArray *resultObjects = [[YCStore sharedInstance] executeFetchRequest:request error:nil];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            fetchFinishBlock(resultObjects);
//        });
//    });
//}
//
/**
 *  查询所有数据并排序
 */
+ (NSArray *)fetchBySortKey:(NSString*)sortKey
                  ascending:(BOOL)ascending
{
    return [self fetchBySortKey:sortKey ascending:ascending predicate:nil];
}

/**
 *  根据谓词查询并排序
 */
+ (NSArray *)fetchBySortKey:(NSString*)sortKey
                    ascending:(BOOL)ascending
                    predicate:(NSString *)predicate,...
{
    NSFetchRequest* request = [self defaultFetchRequest];
    if (predicate.length > 0) {
        va_list args;
        va_start(args, predicate);
        request.predicate = [NSPredicate predicateWithFormat:predicate arguments:args];
        va_end(args);
    }
    if (sortKey.length > 0) {
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:ascending]];
    }
    return [[YCStore sharedInstance] executeFetchRequest:request error:nil];
}

/**
 *  根据谓词查询并排序(内部封装调用)
 */
+ (NSArray *)fetchBySortKey:(NSString*)sortKey
                  ascending:(BOOL)ascending
                  predicate:(NSString *)predicate
                  arguments:(va_list)argList
{
    NSFetchRequest* request = [self defaultFetchRequest];
    if (predicate.length > 0) {
        request.predicate = [NSPredicate predicateWithFormat:predicate arguments:argList];
    }
    if (sortKey.length > 0) {
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:ascending]];
    }
    return [[YCStore sharedInstance] executeFetchRequest:request error:nil];
}

+ (NSFetchedResultsController *)fetchedResultsControllerBySortKey:(NSString*)sortKey
                                                        ascending:(BOOL)ascending
                                                        predicate:(NSString *)predicate,...
{
    NSFetchRequest* request = [self defaultFetchRequest];
    if (predicate.length > 0) {
        va_list args;
        va_start(args, predicate);
        request.predicate = [NSPredicate predicateWithFormat:predicate arguments:args];
        va_end(args);
    }
    if (sortKey.length > 0) {
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:ascending]];
    }
    return [[YCStore sharedInstance] fetchedResultControllerForRequest:request error:nil];
}

#pragma mark - 删除

+ (void) deleteObjectByID:(NSManagedObjectID*)objectID {
    [[YCStore sharedInstance] deleteObjectByID:objectID];
}

/**
 *  根据谓词删除
 */
+ (void)deleteObjectByPredicate:(NSString *)predicate,...
{
    //TODO:可变参数的传递，如何搞
//    va_list args;
//    va_start(args, predicate);
//    NSArray *toDeleteObjects = [self fetchBySortKey:nil ascending:NO predicate:predicate arguments:args];
//    va_end(args);
    
    NSFetchRequest* request = [self defaultFetchRequest];
    if (predicate.length > 0) {
        va_list args;
        va_start(args, predicate);
        request.predicate = [NSPredicate predicateWithFormat:predicate arguments:args];
        va_end(args);
    }
    NSArray *toDeleteObjects = [[YCStore sharedInstance] executeFetchRequest:request error:nil];
    for (NSManagedObject *toDeleteObject in toDeleteObjects) {
        [toDeleteObject deleteSelf];
    }
}

- (void) deleteSelf {
    [[YCStore sharedInstance] deleteObjectByID:self.objectID];
}

@end
