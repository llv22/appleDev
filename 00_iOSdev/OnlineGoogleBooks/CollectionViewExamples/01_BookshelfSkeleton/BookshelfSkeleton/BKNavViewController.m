//
//  BKViewController.m
//  BookshelfSkeleton
//
//  Created by Ding Orlando on 3/30/13.
//  Copyright (c) 2013 Ding Orlando. All rights reserved.
//

#import "BKNavViewController.h"

NSString* const strShelfTitle = @"BookShelf";

@interface BKNavViewController ()

- (void)editAction:(id)leftButtonItem;
- (void)catalogAction:(id)rightButtonItem;

@end

@implementation BKNavViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar"] forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *leftEdit = [[UIBarButtonItem alloc]initWithTitle:@"Edit"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(editAction:)];
    self.navigationItem.leftBarButtonItem = leftEdit;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor brownColor]];
    UIBarButtonItem *rightCatalog = [[UIBarButtonItem alloc]initWithTitle:@"Catalog"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(catalogAction:)];
    self.navigationItem.rightBarButtonItem = rightCatalog;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor brownColor]];
    
    self.title = strShelfTitle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIBarButtonItem delegate

- (void)editAction:(id)leftButtonItem{
    
}

- (void)catalogAction:(id)rightButtonItem{
    
}

@end
