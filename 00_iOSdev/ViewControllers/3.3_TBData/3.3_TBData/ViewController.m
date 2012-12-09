//
//  ViewController.m
//  3.3_TBData
//
//  Created by Ding Orlando on 10/8/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

- (void)performExpand:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTableView = [[UITableView alloc]initWithFrame:self.view.bounds
                                                   style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    //desc - make sure our table view resizes correctly
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.myTableView];
}

- (void)performExpand:(id)sender{
    NSLog(@"hero in your heart");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger result = 0;
    if ([tableView isEqual:self.myTableView]) {
        result = 3;
    }
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    NSInteger result = 0;
    if ([tableView isEqual:self.myTableView]) {
        switch (section) {
            case 0:
                result = 3;
                break;
            case 1:
                result = 5;
                break;
            case 2:
                result = 8;
                break;
        }
    }
    return result;
}

- (UITableViewCell*) tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *result = nil;
    if ([tableView isEqual:self.myTableView]) {
        static NSString *TableViewCellIdentifier = @"MyCells";
        result = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
        if (nil == result) {
            result = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:TableViewCellIdentifier];
        }
        
        /* ordinal extension cell
        result.textLabel.text = [NSString stringWithFormat:@"Section %ld, Cell %ld", (long)indexPath.section, (long)indexPath.row];
        if (0 == indexPath.row % 2) {
            result.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }else{
            result.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0.0f, 0.0f, 70.f, 25.0f);
        [button setTitle:@"Expand" forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(performExpand:)
         forControlEvents:UIControlEventTouchUpInside];
        result.accessoryView = button;
         */
    }
    
    result.textLabel.text = [NSString stringWithFormat:@"Section %ld, Cell %ld", (long)indexPath.section, (long)indexPath.row];
    result.indentationLevel = indexPath.row;
    result.indentationWidth = 10.0f;
    
    return result;
}

- (void)       tableView:(UITableView *)tableView
 didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.myTableView]) {
        NSLog(@"%@\n", [NSString stringWithFormat:@"Cell %ld in Section %ld is selected", (long)indexPath.row, (long)indexPath.section]);
    }
}

- (void)                        tableView:(UITableView *)tableView
 accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Accessory button is tapped for cell at index path = %@", indexPath);
    UITableViewCell *ownerCell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Cell Title = %@", ownerCell.textLabel.text);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload{
    [super viewDidUnload];
    self.myTableView = nil;
}

@end
