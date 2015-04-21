//
//  ViewController.m
//  CoreDataIntroDemo
//
//  Created by bita on 15/4/17.
//  Copyright (c) 2015年 bita. All rights reserved.
//

#import "ViewController.h"
#import "Entity1.h"
#import "NSManagedObject+ActiveRecord.h"
#import "YCStore.h"

@interface ViewController ()
{
    __weak IBOutlet UITextField *_titleTextField;
    __weak IBOutlet UITextField *_orderTextField;
    
    __weak IBOutlet UITextView *_outputTextView;
}

@property (nonatomic, copy) NSString *currentLog;

- (void)addSaveButtonItem;

- (void)addGlobalNotificationObserver;

- (void)addLogInfo:(NSString *)logInfo;

- (NSString *)fetchPredicate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.currentLog = @"";
    
    //保存按钮
    [self addSaveButtonItem];
    
    [self addGlobalNotificationObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark -
- (void)addSaveButtonItem
{
//    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveClicked:)];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

/**
 *  添加通知的监听
 */
- (void)addGlobalNotificationObserver
{
    /**
     *  进行数据持久化同步的监听，object为nil时，表示监听所有context的save，若只监听个别数据，
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(managedObjectContextWillSaveNotification:) name:NSManagedObjectContextWillSaveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(managedObjectContextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
}

- (void)addLogInfo:(NSString *)logInfo
{
    if (logInfo.length > 0) {
        logInfo = [logInfo stringByAppendingString:@"---------------------\n"];
        self.currentLog = [logInfo stringByAppendingString:self.currentLog];
        _outputTextView.text = self.currentLog;
    }
}

- (NSString *)fetchPredicate
{
    NSString *fPredicate = @"";
    if (_titleTextField.text.length > 0) {
        fPredicate = [[NSString alloc]initWithFormat:@"title=%@", _titleTextField.text];
    }
    return fPredicate;
}

#pragma mark - Notification Callback

- (void)managedObjectContextWillSaveNotification:(NSNotification *)notification
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    //保存之前，没有userInfo dictionary
}

- (void)managedObjectContextDidSaveNotification:(NSNotification *)notification
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
//    NSDictionary *dbChangedUserInfo = notification.userInfo;
//    //插入
//    NSArray *insertedObjects = dbChangedUserInfo[NSInsertedObjectsKey];
//    if ([insertedObjects count] > 0) {
//        self.currentLog = [self.currentLog stringByAppendingString:@"插入：\n"];
//    }
//    for (Entity1 *insertedMob in insertedObjects) {
//        self.currentLog = [self.currentLog stringByAppendingFormat:@"ycTitle = %@, fault = %d, faultingState = %lu\n", insertedMob.ycTitle, insertedMob.fault, insertedMob.faultingState];
//    }
//    NSLog(@"NSInsertedObjectsKey = %@", NSInsertedObjectsKey);
//    
//    //更新
//    NSArray *updatedObjects = dbChangedUserInfo[NSUpdatedObjectsKey];
//    if ([updatedObjects count] > 0) {
//        self.currentLog = [self.currentLog stringByAppendingString:@"更新：\n"];
//    }
//    for (Entity1 *updatedMob in updatedObjects) {
//        self.currentLog = [self.currentLog stringByAppendingFormat:@"ycTitle = %@, fault = %d, faultingState = %lu\n", updatedMob.ycTitle, updatedMob.fault, updatedMob.faultingState];
//    }
//    
//    //删除
//    NSArray *deletedObjects = dbChangedUserInfo[NSUpdatedObjectsKey];
//    if ([deletedObjects count] > 0) {
//        self.currentLog = [self.currentLog stringByAppendingString:@"删除：\n"];
//    }
//    for (Entity1 *deletedMob in deletedObjects) {
//        self.currentLog = [self.currentLog stringByAppendingFormat:@"ycTitle = %@, fault = %d, faultingState = %lu\n", deletedMob.ycTitle, deletedMob.fault, deletedMob.faultingState];
//    }
//    
//    [self addLogInfo];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Button Callback

/**
 *  保存
 */
- (void)saveClicked:(id)sendr
{
    [YCStore saveContext];
}

/**
 *  插入
 */
- (IBAction)insertClicked:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    Entity1 *entity = [Entity1 insertNewObject];
    entity.ycTitle = _titleTextField.text;
    if (entity > 0) {
        entity.ycOrder = [_orderTextField.text integerValue];
    }
    entity.ycCreateTime = [NSDate date];
    entity.ycColor = [UIColor blueColor];
    entity.ycValues = @[@"10", @"J", @"Q", @"K", @"A"];
    
//    Car *car = [[Car alloc]init];
//    car.name = @"toyota";
//    car.price = 200000;
}

/**
 *  删除
 */
- (IBAction)deleteClicked:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [Entity1 deleteObjectByPredicate:@"ycTitle=%@", _titleTextField.text];
}

/**
 *  查询
 */
- (IBAction)queryClicked:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSArray *result = [Entity1 fetchByPredicate:@"ycOrder==%ld", [_orderTextField.text integerValue]];
    if ([result count] > 0) {
        Entity1 *entity = result[0];
        NSLog(@"one### title = %@ fault = %d", entity.ycTitle, entity.fault);
        _orderTextField.text = [@(entity.ycOrder)stringValue];
        if (entity.ycColor) {
            _orderTextField.textColor = entity.ycColor;
        }
    } else {
        [self addLogInfo:@"查询无结果\n"];
    }
    
    for (Entity1 *entity in result) {
        NSLog(@"two### %p # title = %@ fault = %d", entity, entity.ycTitle, entity.fault);
        
        NSString *logInfo = [[NSString alloc]initWithFormat:@"order = %ld title = %@ createTime = %@ values= %@\n", entity.ycOrder, entity.ycTitle, entity.formateDate, entity.ycValues];
        [self addLogInfo:logInfo];
    }
    
//    for (Entity1 *entity in result) {
//        NSLog(@"second %p # title = %@ fault = %d", entity, entity.ycTitle, entity.fault);
//    }
    
    [self queryAgain];
}

- (void)queryAgain
{
    NSArray *result = [Entity1 fetchByPredicate:@"ycOrder==%ld", [_orderTextField.text integerValue]];
    if ([result count] > 0) {
        Entity1 *entity = result[0];
        NSLog(@"again### title = %@ fault = %d", entity.ycTitle, entity.fault);
    }
}

@end
