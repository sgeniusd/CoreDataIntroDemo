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
    __weak IBOutlet UITextField *_recordTextField;
    
    __weak IBOutlet UITextView *_outputTextView;
}

- (void)addSaveButtonItem;

- (void)addGlobalNotificationObserver;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //保存按钮
    [self addSaveButtonItem];
    
    [self addGlobalNotificationObserver];
    
    Entity1 *entity = [Entity1 insertNewObject];
    entity.ycTitle = @"myFirstInsert";
    entity.ycOrder = 123456;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark -
- (void)addSaveButtonItem
{
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveClicked:)];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

/**
 *  添加通知的监听
 */
- (void)addGlobalNotificationObserver
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(managedObjectContextWillSaveNotification:) name:NSManagedObjectContextWillSaveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(managedObjectContextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
}

- (void)saveClicked:(id)sendr
{
    [YCStore saveContext];
}

#pragma mark - Notification Callback

- (void)managedObjectContextWillSaveNotification:(NSNotification *)notification
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)managedObjectContextDidSaveNotification:(NSNotification *)notification
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - Button Callback

/**
 *  插入
 */
- (IBAction)insertClicked:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

/**
 *  删除
 */
- (IBAction)deleteClicked:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

/**
 *  查询
 */
- (IBAction)queryClicked:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
