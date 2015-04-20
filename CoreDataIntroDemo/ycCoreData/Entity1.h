//
//  Entity1.h
//  CoreDataIntroDemo
//
//  Created by bita on 15/4/20.
//  Copyright (c) 2015年 bita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Entity1 : NSManagedObject

@property (nonatomic, retain) NSString * ycTitle;
@property (nonatomic) NSInteger  ycOrder;

@end
