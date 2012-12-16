//
//  DetailViewController.m
//  HouseHelper
//
//  Created by Ding Orlando on 12/16/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    // desc - only edit button is valid, as navigation should be only used in iphone version
    UIBarButtonItem* edit = [[UIBarButtonItem alloc]initWithTitle:@"编辑"
                                                            style:UIBarButtonItemStylePlain
                                                           target:nil
                                                           action:nil];
    [self.navigationItem setRightBarButtonItem:edit animated:YES];
}

#pragma mark - table view initialization
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

//TODO : number of row for specific section
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    NSInteger result = 0;
    return result;
}

- (UITableViewCell*) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *result = nil;
    return  result;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
