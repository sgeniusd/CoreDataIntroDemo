//
//  YCStore.m
//  CoreDataIntroDemo
//
//  Created by bita on 15/4/20.
//  Copyright (c) 2015年 bita. All rights reserved.
//

#import "YCStore.h"

@interface YCStore ()

@end

@implementation YCStore

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static YCStore *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc]init];
    });
    return _sharedInstance;
}

#pragma mark - static Method


#pragma mark - 数据持久化到本地
/**
 *  将Context中数据持久化到本地
 */
+ (void)saveContext {
    NSManagedObjectContext *managedObjectContext = [YCStore sharedInstance].managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - 增删查
/**
 *  插入一条ManageObject对象
 *
 *  @param entityName 实体名称
 *
 *  @return 返回一个以entityName命名的实体对象
 */
- (NSManagedObject*)insertNewObjectForEntityName:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
}

/**
 *  条件查询（通过fetchRequest）
 *
 *  @param request 请求条件模型
 *  @param error   错误信息
 *
 *  @return 返回符合NSFetchRequest条件的NSManagedObject数组
 */
- (NSArray *)executeFetchRequest:(NSFetchRequest *)request
                           error:(NSError **)error
{
    return [self.managedObjectContext executeFetchRequest:request error:error];
}

/**
 *  条件查询（通过fetchRequest）
 *
 *  @param request 请求条件模型
 *  @param error   错误信息
 *
 *  @return 返回传入NSFetchRequest的NSFetchedResultsController
 */
- (NSFetchedResultsController *)fetchedResultControllerForRequest:(NSFetchRequest *)request
                                                            error:(NSError *)error
{
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

/**
 *  查询NSManagedObject（根据objectID）
 *
 *  @param objectID An object ID.
 *
 *  @return The object for the specified ID.
 */
- (NSManagedObject *)objectWithID:(NSManagedObjectID *)objectID {
    if (objectID != nil) {
        return [self.managedObjectContext objectWithID:objectID];
    } else {
        return nil;
    }
}

/**
 *  删除NSManagedObject（根据objectID）
 *
 *  @param objectID an objectID
 */
- (void)deleteObjectByID:(NSManagedObjectID *)objectID {
    NSManagedObject *object = [self objectWithID:objectID];
    [self deleteObject:object];
}

/**
 *  删除NSManagedObject（根据NSManagedObject）
 *
 *  @param objectID an NSManagedObject
 */
- (void)deleteObject:(NSManagedObject *)object {
    [self.managedObjectContext deleteObject:object];
}

#pragma 本地Document路径
/**
 *  获取Document目录路径
 *
 *  @return Document路径url
 */
- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.bita.CoreDataIntroDemo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - getter Method

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataIntroDemo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataIntroDemo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
//    NSDictionary *options = @{NSInferMappingModelAutomaticallyOption: @YES,NSMigratePersistentStoresAutomaticallyOption: @YES};
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

@end
