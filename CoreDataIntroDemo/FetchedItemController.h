//
//  FetchedItemController.h
//  CoreDataIntroDemo
//
//  Created by bita on 15/4/22.
//  Copyright (c) 2015年 bita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FetchedResultsControllerDataSource;
@class Store;
@class Entity1;

@interface FetchedItemController : UIViewController

@property (nonatomic, strong) Entity1* parent;

@end