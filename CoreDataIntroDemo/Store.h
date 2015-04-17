//
// Created by Chris Eidhof
//


#import <Foundation/Foundation.h>

@class Item;
@class NSFetchedResultsController;

@interface Store : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;



- (void)saveContext;

- (Item*)rootItem;

@end