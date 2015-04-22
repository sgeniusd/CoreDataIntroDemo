//
//  Child.h
//  CoreDataIntroDemo
//
//  Created by bita on 15/4/22.
//  Copyright (c) 2015年 bita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entity1;

@interface Child : NSManagedObject

@property (nonatomic) int64_t childID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Entity1 *entity1;

@end

@interface Child (CoreDataGeneratedAccessors)

- (void)addEntity1Object:(Entity1 *)value;
- (void)removeEntity1Object:(Entity1 *)value;

@end