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

static NSString* const selectItemSegue = @"selectItem";

@interface FetchedItemController () <FetchedResultsControllerDataSourceDelegate, UITextFieldDelegate>

@property (nonatomic, strong) FetchedResultsControllerDataSource* fetchedResultsControllerDataSource;
@property (nonatomic, strong) UITextField* titleField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FetchedItemController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"FetchedResultsController";
    
    [self setupFetchedResultsController];
    [self setupNewItemField];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.tableView numberOfRowsInSection:0] > 0) {
        [self hideNewItemField];
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
    NSString* actionName = [NSString stringWithFormat:NSLocalizedString(@"Delete \"%@\"", @"Delete undo action name"), item.ycTitle];
    [self.undoManager setActionName:actionName];
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
    NSString* actionName = [NSString stringWithFormat:NSLocalizedString(@"add item \"%@\"", @"Undo action name of add item"), title];
    [self.undoManager setActionName:actionName];
    
    Entity1 *entity = [Entity1 insertNewObject];
    entity.ycTitle = title;
    entity.parent = self.parent;
//    [Item insertItemWithTitle:title parent:self.parent inManagedObjectContext:self.managedObjectContext];
    textField.text = @"";
    [textField resignFirstResponder];
    [self hideNewItemField];
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

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (-scrollView.contentOffset.y > self.titleField.bounds.size.height) {
        [self showNewItemField];
    } else if (scrollView.contentOffset.y > 0) {
        [self hideNewItemField];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView*)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint*)targetContentOffset
{
    BOOL itemFieldVisible = self.tableView.contentInset.top == 0;
    if (itemFieldVisible) {
        [self.titleField becomeFirstResponder];
    }
}

- (void)showNewItemField
{
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.top = 0;
    self.tableView.contentInset = insets;
}

- (void)hideNewItemField
{
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.top = -self.titleField.bounds.size.height;
    self.tableView.contentInset = insets;
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