//
//  MSDetailViewController.m
//  MeetSocial
//
//  Created by Ding Orlando on 3/19/13.
//  Copyright (c) 2013 Ding Orlando. All rights reserved.
//

#import "SBJson.h"
#import "MSDetailViewController.h"

@interface MSDetailViewController (){
    NSArray *displayItems;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
// desc - methods list
-(NSString*) readResultsFile;
@end

@implementation MSDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"Results"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (UIInterfaceOrientationIsPortrait(interfaceOrientation));
}

#pragma mark - private methods
-(NSString*) readResultsFile{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docmentsDirectory = [path objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/results.json", docmentsDirectory];
    NSError *error;
    NSString *content = [[NSString alloc]initWithContentsOfFile:fileName
                                                   usedEncoding:nil
                                                          error:&error];
    if (error) {
        NSLog(@"read error - %@", error);
        return nil;
    }
    return content;
}

#pragma mark - uicollectionview delegate
-(NSInteger)    collectionView:(UICollectionView *)collectionView
        numberOfItemsInSection:(NSInteger)section{
    NSString* resultString = [self readResultsFile];
    NSDictionary* resultsDict = [resultString JSONValue];
    if (resultsDict) {
        displayItems = [resultsDict objectForKey:@"results"];
    }
    
    return [displayItems count];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
