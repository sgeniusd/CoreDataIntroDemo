//
//  YCStore.h
//  CoreDataIntroDemo
//
//  Created by bita on 15/4/20.
//  Copyright (c) 2015年 bita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  CoreData堆栈对象管理类，请不要直接调用此类的方法进行增删改查操作(使用ManagedObject的父类替代之)
 */
@interface YCStore : NSObject

+ (instancetype)sharedInstance;

/**
 *  将Context中数据持久化到本地
 */
+ (void)saveContext;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 *  插入一条ManagedObject对象
 *
 *  @param entityName 实体名称
 *
 *  @return 返回一个以entityName命名的实体对象
 */
- (NSManagedObject*)insertNewObjectForEntityName:(NSString *)entityName;

/**
 *  条件查询（通过fetchRequest）
 *
 *  @param request 请求条件模型
 *  @param error   错误信息
 *
 *  @return 返回符合NSFetchRequest条件的NSManagedObject数组
 */
- (NSArray *)executeFetchRequest:(NSFetchRequest *)request
                           error:(NSError **)error;

/**
 *  查询NSManagedObject（根据objectID）
 *
 *  @param objectID An object ID.
 *
 *  @return The object for the specified ID.
 */
- (NSManagedObject *)objectWithID:(NSManagedObjectID *)objectID;

/**
 *  删除NSManagedObject（根据objectID）
 *
 *  @param objectID an objectID
 */
- (void)deleteObjectByID:(NSManagedObjectID *)objectID;

/**
 *  删除NSManagedObject（根据NSManagedObject）
 *
 *  @param objectID an NSManagedObject
 */
- (void)deleteObject:(NSManagedObject *)object;

@end
