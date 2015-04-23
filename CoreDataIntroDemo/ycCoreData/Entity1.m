//
//  Entity1.m
//  CoreDataIntroDemo
//
//  Created by bita on 15/4/20.
//  Copyright (c) 2015年 bita. All rights reserved.
//

#import "Entity1.h"

static NSDateFormatter *_dateFormatter = nil;

@interface Entity1 ()

@property (nonatomic, assign) BOOL valueIsValid;

@end

@implementation Entity1

@dynamic ycTitle;
@dynamic ycOrder;
@dynamic ycCreateTime;
@dynamic ycColor;
@dynamic ycValues;
@dynamic ycExtra;
@dynamic parent;
@dynamic otherchild;

@synthesize formateDate = _formateDate;
@synthesize valueIsValid = _valueIsValid;

- (void)awakeFromFetch
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)awakeFromInsert
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)awakeFromSnapshotEvents:(NSSnapshotEventType)flags
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)willSave
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)didSave
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)willChange:(NSKeyValueChange)changeKind valuesAtIndexes:(NSIndexSet *)indexes forKey:(NSString *)key
{
    
}

- (void)willTurnIntoFault
{
}

- (void)didTurnIntoFault
{
    self.valueIsValid = NO;
}

//- (BOOL)validateValue:(id *)value forKey:(NSString *)key error:(NSError **)error
//{
//    
//    return YES;
//}

//- (BOOL)validateForInsert:(NSError *__autoreleasing *)error
//{
//    return YES;
//}

#pragma mark - Get Method

- (NSString *)formateDate
{
    if (!self.valueIsValid && self.ycCreateTime) {
        self.valueIsValid = YES;
        
        if (_dateFormatter == nil) {
            _dateFormatter = [[NSDateFormatter alloc]init];
        }
        [_dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        [_dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        _formateDate = [_dateFormatter stringFromDate:self.ycCreateTime];
    }
    return _formateDate;
}

- (NSFetchedResultsController *)childrenFetchedResultsController
{
    NSFetchedResultsController *fetchedResultsController = nil;
    fetchedResultsController = [Entity1 fetchedResultsControllerBySortKey:@"ycOrder" ascending:YES predicate:@"parent = %@",self];
    return fetchedResultsController;
}

/**
 *  无parent的Entity1
 */
+ (Entity1 *)rootItem
{
    Entity1 *aItem = nil;
    NSArray *items = [Entity1 fetchByPredicate:@"parent = %@", nil];
    if ([items count] > 0) {
        aItem = items[0];
    } else {
        aItem = [Entity1 insertNewObject];
    }
    return aItem;
}

@end
