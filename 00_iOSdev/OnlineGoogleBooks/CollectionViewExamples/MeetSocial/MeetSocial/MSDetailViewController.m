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

static NSString *CellIdentifier = @"ResultsCell";
//desc - for instance based dateformatter
static NSDateFormatter *dateFormatter;

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
	// Do any additional setup after loading the view typically from a nib.
    [self setTitle:@"Results"];
    // desc - set itself as view controller restoration
    self.restorationClass = self;
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
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section{
    NSString* resultString = [self readResultsFile];
    NSDictionary* resultsDict = [resultString JSONValue];
    if (resultsDict) {
        self->displayItems = [resultsDict objectForKey:@"results"];
    }
    
    return [self->displayItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor darkGrayColor];
    NSDictionary *item = [self->displayItems objectAtIndex:indexPath.row];
    NSString *photoURL = [item objectForKey:@"photo_url"];
    NSDecimalNumber *time = [item objectForKey:@"time"];
    
    UIImageView *iv = nil;
    UILabel *lbl = nil;
    
    for (UIView *v in cell.contentView.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            iv = (UIImageView*)v;
            //desc - runtime delegate
            [iv.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        else if ([v isKindOfClass:[UILabel class]]){
            lbl = (UILabel*)v;
        }
    }
    [iv setImage:nil];
    [lbl setText:[item objectForKey:@"name"]];
    
    if (photoURL) {
        if ([photoURL length] > 0) {
            [iv setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]]]];
        }
    }
    else if(time){
        if ([time floatValue] > 0){
            if (!dateFormatter) {
                dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
                [dateFormatter setDateFormat:@"M/d/YY H:MM"];
            }
            // desc - formatted elase time
            NSDate *eventDate = [NSDate dateWithTimeIntervalSince1970:[time floatValue]/1000];
            NSString *dateStr = [dateFormatter stringFromDate:eventDate];
            
            UILabel *lblDate = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
            [lblDate setNumberOfLines:2];
            [lblDate setFont:[UIFont boldSystemFontOfSize:22]];
            [lblDate setLineBreakMode:NSLineBreakByWordWrapping];
            [lblDate setTextAlignment:NSTextAlignmentCenter];
            [lblDate setTextColor:[UIColor whiteColor]];
            [lblDate setBackgroundColor:[UIColor blackColor]];
            [lblDate setText:dateStr];
            [iv addSubview:lblDate];
        }
    }
    return cell;
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
