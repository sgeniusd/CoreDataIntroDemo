//
//  FetchedItemController.m
//  CoreDataIntroDemo
//
//  Created by bita on 15/4/22.
//  Copyright (c) 2015年 bita. All rights reserved.
//

#import "FetchedItemController.h"
#import "FetchedResultsControllerDataSource.h"
#import "Store.h"
#import "Item.h"
#import "Entity1.h"
#import "NSManagedObject+ActiveRecord.h"
#import "YCStore.h"

static NSString* const selectItemSegue = @"selectItem";

@interface FetchedItemController () <FetchedResultsControllerDataSourceDelegate, UITextFieldDelegate>

@property (nonatomic, strong) FetchedResultsControllerDataSource* fetchedResultsControllerDataSource;
@property (nonatomic, strong) UITextField* titleField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FetchedItemController
{
    NSInteger _count;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"FetchedResultsController";
    
    _count = 1;
    
    [self setupFetchedResultsController];
    [self setupNewItemField];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.tableView numberOfRowsInSection:0] > 0) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    self.fetchedResultsControllerDataSource.paused = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.fetchedResultsControllerDataSource.paused = YES;
}

- (void)setupFetchedResultsController
{
    self.fetchedResultsControllerDataSource = [[FetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    self.fetchedResultsControllerDataSource.fetchedResultsController = self.parent.childrenFetchedResultsController;
    self.fetchedResultsControllerDataSource.delegate = self;
    self.fetchedResultsControllerDataSource.reuseIdentifier = @"Cell";
}

- (void)setupNewItemField
{
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    self.titleField.backgroundColor = [UIColor greenColor];
    self.titleField.delegate = self;
    self.titleField.placeholder = NSLocalizedString(@"Add a new item", @"Placeholder text for adding a new item");
    self.tableView.tableHeaderView = self.titleField;
}

#pragma mark Fetched Results Controller Delegate

- (void)configureCell:(id)theCell withObject:(id)object
{
    UITableViewCell* cell = theCell;
    Entity1* item = object;
    cell.textLabel.text = item.ycTitle;
}

- (void)deleteObject:(id)object
{
    Entity1* item = object;
//    NSString* actionName = [NSString stringWithFormat:NSLocalizedString(@"Delete \"%@\"", @"Delete undo action name"), item.ycTitle];
//    [self.undoManager setActionName:actionName];
    [item deleteSelf];
}

#pragma mark Segues

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:selectItemSegue]) {
        [self presentSubItemViewController:segue.destinationViewController];
    }
}

- (void)presentSubItemViewController:(FetchedItemController*)subItemViewController
{
    Entity1* item = [self.fetchedResultsControllerDataSource selectedItem];
    subItemViewController.parent = item;
}


- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSString* title = textField.text;
//    NSString* actionName = [NSString stringWithFormat:NSLocalizedString(@"add item \"%@\"", @"Undo action name of add item"), title];
//    [self.undoManager setActionName:actionName];
    
    Entity1 *entity = [Entity1 insertNewObject];
    entity.ycTitle = title;
    entity.ycOrder = _count++;
    entity.parent = self.parent;
    [YCStore saveContext];
    
//    [Item insertItemWithTitle:title parent:self.parent inManagedObjectContext:self.managedObjectContext];
    textField.text = @"";
    [textField resignFirstResponder];
//    [self hideNewItemField];
    return NO;
}

- (NSManagedObjectContext*)managedObjectContext
{
    return self.parent.managedObjectContext;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)setParent:(Entity1*)parent
{
    _parent = parent;
    self.navigationItem.title = parent.ycTitle;
}

#pragma mark Undo

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (NSUndoManager*)undoManager
{
    return self.managedObjectContext.undoManager;
}

@end
