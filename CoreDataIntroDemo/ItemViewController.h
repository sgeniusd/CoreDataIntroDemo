//
// Created by Chris Eidhof
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FetchedResultsControllerDataSource;
@class Store;
@class Item;


@interface ItemViewController : UIViewController

@property (nonatomic, strong) Item* parent;

@end