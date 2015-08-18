//
//  ViewController.m
//  CoreDataIntroDemo
//
//  Created by bita on 15/4/17.
//  Copyright (c) 2015年 bita. All rights reserved.
//

#import "ViewController.h"
#import "Entity1.h"
#import "Child.h"
#import "NSManagedObject+ActiveRecord.h"
#import "YCStore.h"
#import "FetchedItemController.h"

@interface ViewController ()
{
    __weak IBOutlet UITextField *_titleTextField;
    __weak IBOutlet UITextField *_orderTextField;
    
    __weak IBOutlet UITextView *_outputTextView;
    
    NSMutableArray         *_toAddChildren;
}

@property (nonatomic, copy) NSString *currentLog;

- (void)addSaveButtonItem;

- (void)addGlobalNotificationObserver;

- (void)addLogInfo:(NSString *)logInfo;

- (void)insertTestChildren;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.currentLog = @"";
    
    /**
     *  OSX上默认不为nil，iOS上需要重新初始化
     */
    [YCStore sharedInstance].managedObjectContext.undoManager = [[NSUndoManager alloc]init];
    [[[YCStore sharedInstance].managedObjectContext undoManager]registerUndoWithTarget:self selector:@selector(undoCompleted:) object:nil];
    [[[YCStore sharedInstance].managedObjectContext undoManager]setActionName:@"ManagedObjectContextUndo"];
    
    //保存按钮
    [self addSaveButtonItem];
    
    [self addGlobalNotificationObserver];
    
    /**
     *  添加测试child数据
     */
    [self insertTestChildren];
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

- (void)insertTestChildren
{
    NSArray *resultChildren = [Child fetchBySortKey:@"childID" ascending:YES];
    if ([resultChildren count] > 0) {
        _toAddChildren = [resultChildren mutableCopy];
    } else {
        _toAddChildren = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i = 0; i < 5; i++) {
            Child *child = [Child insertNewObject];
            child.childID = i+1;
            child.name = [[NSString alloc]initWithFormat:@"child %d", i+1];
            [_toAddChildren addObject:child];
        }
        [YCStore saveContext];
    }
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

- (void)undoCompleted:(id)sender
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, [sender description]);
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
    
//    for (int i = 0; i < 100000; i ++) {
//        entity.ycTitle = _titleTextField.text;
//        if (entity > 0) {
//            entity.ycOrder = [_orderTextField.text integerValue];
//        }
//        entity.ycCreateTime = [NSDate date];
//        entity.ycColor = [UIColor blueColor];
//        entity.ycValues = @[@"10", @"J", @"Q", @"K", @"A"];
    
//        [[YCStore sharedInstance].managedObjectContext refreshObject:entity mergeChanges:YES];
//    }
//    NSString *logInfo = [[NSString alloc]initWithFormat:@"插入：order = %ld title = %@ createTime = %@ values= %@\n", entity.ycOrder, entity.ycTitle, entity.formateDate, entity.ycValues];
//    [self addLogInfo:logInfo];
}

/**
 *  删除
 */
- (IBAction)deleteClicked:(id)sender {
    if (_orderTextField.text.length == 0) {
        //delete today
        [Entity1 deleteObjectByPredicate:@"ycColor = %@", @"blue"];
    } else {
        [Entity1 deleteObjectByPredicate:@"ycOrder = %ld", [_orderTextField.text integerValue]];
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

/**
 *  查询
 */
- (IBAction)queryClicked:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSArray *result = nil;
    if (_orderTextField.text.length == 0) {
        result = [Entity1 fetchBySortKey:@"ycOrder" ascending:NO];
    } else {
        __weak ViewController *controller = self;
        __weak UITextField *titleTxtField = _titleTextField;
        result = [Entity1 fetchByPredicate:@"ycOrder==%ld", [_orderTextField.text integerValue]];
        if ([result count] > 0) {
            Entity1 *entity = result[0];
            titleTxtField.text = entity.ycTitle;
            if (entity.ycColor) {
                titleTxtField.textColor = entity.ycColor;
            }
        } else {
            [controller addLogInfo:@"查询无结果\n"];
        }
//        result = [Entity1 fetchByPredicate:@"ycOrder==%ld", [_orderTextField.text integerValue]];
    }
    if ([result count] > 0) {
        Entity1 *entity = result[0];
        _titleTextField.text = entity.ycTitle;
        if (entity.ycColor) {
//            _titleTextField.textColor = entity.ycColor;
        }
    } else {
        [self addLogInfo:@"查询无结果\n"];
    }
    
    for (Entity1 *entity in result) {
        NSLog(@"two### %p # title = %@ fault = %d", entity, entity.ycTitle, entity.fault);
        
        NSString *logInfo = [[NSString alloc]initWithFormat:@"查询结果：order = %ld title = %@ createTime = %@ values= %@\n", entity.ycOrder, entity.ycTitle, entity.formateDate, entity.ycValues];
        [self addLogInfo:logInfo];
        
//        [[YCStore sharedInstance].managedObjectContext refreshObject:entity mergeChanges:NO];
    }
    
//    for (Entity1 *entity in result) {
//        NSLog(@"second %p # title = %@ fault = %d", entity, entity.ycTitle, entity.fault);
//    }
    
    //验证缓存机制
    [self queryAgain];
}

- (void)queryAgain
{
    NSArray *result = [Entity1 fetchByPredicate:@"ycOrder==%ld", [_orderTextField.text integerValue]];
    if ([result count] > 0) {
        Entity1 *entity = result[0];
        NSLog(@"again### %p title = %@ fault = %d", entity, entity.ycTitle, entity.fault);
        NSLog(@"How old are you?");
    }
}

/**
 *  undo上一次
 */
- (IBAction)undoPrevious:(id)sender {
    [[YCStore sharedInstance].managedObjectContext undo];
//    [[[YCStore sharedInstance].managedObjectContext undoManager]undo]; //等价
}

/**
 *  undo全部(包括单次undo操作)
 */
- (IBAction)undoAll:(id)sender {
    [[YCStore sharedInstance].managedObjectContext rollback];
}

- (IBAction)clearLog:(id)sender {
    self.currentLog = @"";
    _outputTextView.text = @"";
}

- (IBAction)enterFetchedResultsController:(id)sender {
    FetchedItemController *itemController = [[FetchedItemController alloc]init];
    itemController.parent = [Entity1 rootItem];
    [self.navigationController pushViewController:itemController animated:YES];
}

/**
 *  添加child relationship
 */
- (IBAction)addChildren:(id)sender {
    NSArray *result = [Entity1 fetchByPredicate:@"ycOrder < 100"];
    if ([result count] > 0) {
        for (Entity1 *entity in result) {
            entity.otherchild = [NSSet setWithArray:_toAddChildren];
        }
    }
}

/**
 *  移除child relationship
 */
- (IBAction)removeChildren:(id)sender {
    NSArray *result = [Entity1 fetchByPredicate:@"ycOrder < 100"];
    if ([result count] > 0) {
        for (Entity1 *entity in result) {
            entity.otherchild = nil;
        }
    }
}

@end
