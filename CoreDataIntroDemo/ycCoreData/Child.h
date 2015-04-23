//
//  Child.h
//  CoreDataIntroDemo
//
//  Created by bita on 15/4/23.
//  Copyright (c) 2015年 bita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entity1;

@interface Child : NSManagedObject

@property (nonatomic, assign) int64_t childID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Entity1 *entity1;

@end
