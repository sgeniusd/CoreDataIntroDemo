//
//  Entity1.m
//  CoreDataIntroDemo
//
//  Created by bita on 15/4/20.
//  Copyright (c) 2015年 bita. All rights reserved.
//

#import "Entity1.h"

static NSDateFormatter *_dateFormatter = nil;

@implementation Entity1

@dynamic ycTitle;
@dynamic ycOrder;
@dynamic ycCreateTime;
@dynamic ycColor;
@dynamic ycValues;
@dynamic ycExtra;

@synthesize formateDate = _formateDate;

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
}

- (BOOL)validateValue:(id *)value forKey:(NSString *)key error:(NSError **)error
{
    
    return YES;
}

//- (BOOL)validateForInsert:(NSError *__autoreleasing *)error
//{
//    return YES;
//}

#pragma mark - Get Method

- (NSString *)formateDate
{
    NSString *fDate = @"";
    if (self.ycCreateTime) {
        if (_dateFormatter == nil) {
            _dateFormatter = [[NSDateFormatter alloc]init];
        }
        [_dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        [_dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        fDate = [_dateFormatter stringFromDate:self.ycCreateTime];
    }
    return fDate;
}

@end
