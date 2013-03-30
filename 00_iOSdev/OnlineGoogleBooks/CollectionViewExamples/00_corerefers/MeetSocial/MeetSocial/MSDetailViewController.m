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
    NSDictionary *selectedItem;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
// desc - methods list
- (NSString*) readResultsFile;
- (void) share;
- (bool) isAuthorizedForEntityType:(EKEntityType)type;
- (void) createCalItem;
- (void) createReminderItem;
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
    self.restorationClass = [self class];
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

#pragma mark - restoration controller delegate

// desc - must-implementation for restoration class
+ (UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents
                                                             coder:(NSCoder *)coder{
    UIStoryboard *sb = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
    NSString *lastID = [identifierComponents lastObject];
    if (sb) {
        return (MSDetailViewController*)[sb instantiateViewControllerWithIdentifier:lastID];
    }
    return nil;
}

- (NSString*) modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx
                                            inView:(UIView *)view{
    NSDictionary *item = [self->displayItems objectAtIndex:idx.row];
    NSLog(@"modelID: %@", [NSString stringWithFormat:@"%@", [item objectForKey:@"id"]]);
    return [NSString stringWithFormat:@"%@", [item objectForKey:@"id"]];
}

- (NSIndexPath*) indexPathForElementWithModelIdentifier:(NSString *)identifier
                                                 inView:(UIView *)view{
    NSLog(@"ip for model id: %@", identifier);
    int cnt = 0;
    for (NSDictionary *item in self->displayItems) {
        if ([[item objectForKey:@"id"] isEqualToString:identifier]) {
            return [NSIndexPath indexPathForRow:cnt inSection:0];
            cnt++;
        }
    }
    return nil;
}

- (void)    collectionView:(UICollectionView *)collectionView
  didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self->selectedItem = [self->displayItems objectAtIndex:indexPath.row];
    NSString *url = [self->selectedItem objectForKey:@"link"];
    
    UIAlertView *av = nil;
    // desc - delegate to method
    //    -(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
    if (url) {
        av = [[UIAlertView alloc]initWithTitle:@"Details"
                                       message:@"Would you like to..."
                                      delegate:self
                             cancelButtonTitle:@"Cancel"
                             otherButtonTitles:@"See Group Page", @"Share", nil];
    }
    else{
        av = [[UIAlertView alloc]initWithTitle:@"Details"
                                       message:@"Would you like to..."
                                      delegate:self
                             cancelButtonTitle:@"Cancel"
                             otherButtonTitles:@"See Event Page", @"Share", @"Create Cal Item", @"Create Reminder", nil];
    }
    [av show];
}

- (void)    alertView:(UIAlertView *)alertView
 clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        return;
    }
    if (buttonIndex == 2) {
        [self share];
    }
    else{
        NSString *url =  [self->selectedItem objectForKey:@"link"];
        
        if (url) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        else{
            if (buttonIndex == 1) {
                NSString *url = [self->selectedItem objectForKey:@"event_url"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
            else{
                if (buttonIndex == 3) {
                    if ([self isAuthorizedForEntityType:EKEntityTypeEvent]) {
                        [self createCalItem];
                    }
                }
                else{
                    if ([self isAuthorizedForEntityType:EKEntityTypeReminder]) {
                        [self createReminderItem];
                    }
                }
            }
        }
    }
}

#pragma mark - alertView click use functionatility
- (void) share{
    NSString *url = [self->selectedItem objectForKey:@"link"];
    NSString *textToShare = [self->selectedItem objectForKey:@"name"];
    
    UIImage *imageToShare = nil;
    NSArray *activityItems = nil;
    if (url) {
        NSString *photoURL = [self->selectedItem objectForKey:@"photo_url"];
        imageToShare = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]]];
        activityItems = @[textToShare, url, imageToShare];
    }
    else{
        url = [self->selectedItem objectForKey:@"event_url"];
        
        NSDecimalNumber *time = [self->selectedItem objectForKey:@"time"];
        NSDate *eventDate = [NSDate dateWithTimeIntervalSince1970:[time floatValue]/1000];
        NSString *dateStr = [dateFormatter stringFromDate:eventDate];
        
        activityItems = @[textToShare, url, dateStr];
    }
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems
                                                                            applicationActivities:nil];
    [self presentViewController:activityVC
                       animated:YES
                     completion:nil];
}

// desc - if events is authorized
-(bool)isAuthorizedForEntityType:(EKEntityType)type{
    EKAuthorizationStatus authStatus = [EKEventStore authorizationStatusForEntityType:type];
    if (authStatus != EKAuthorizationStatusAuthorized) {
        [[EKEventStore alloc]requestAccessToEntityType:EKEntityTypeEvent
                                            completion:^(BOOL granted, NSError *error) {
            if (granted) {
                if (type == EKEntityTypeEvent) {
                    [self createCalItem];
                }
                else{
                    [self createReminderItem];
                }
            }
            else{
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Permissions"
                                                             message:@"If you deny the app permissions, you can not \
                                                                        create calendar events.\n\nYou can \
                                                                        change your permissiongs in the Settings \
                                                                        app under Privacy."
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"OK", nil];
                [av show];
            }
        }];
        return NO;
    }
    return YES;
}

// desc - calender item
- (void) createCalItem{
    EKEventStore *eStore = [[EKEventStore alloc]init];
    
    EKEvent *event = [EKEvent eventWithEventStore:eStore];
    [event setCalendar:[eStore defaultCalendarForNewEvents]];
    [event setTitle:[self->selectedItem objectForKey:@"name"]];
    
    NSDecimalNumber *time = [self->selectedItem objectForKey:@"time"];
    NSDate *eventDate = [NSDate dateWithTimeIntervalSince1970:[time floatValue]/1000];
    [event setStartDate:eventDate];
    [event setEndDate:eventDate];
    NSError *error = nil;
    [eStore saveEvent:event
                 span:EKSpanThisEvent
               commit:YES
                error:&error];
    
    if (error) {
        NSLog(@"Saving createCalItem: %@", error);
    }
    
    EKEventEditViewController *editEvent = [[EKEventEditViewController alloc]init];
    // desc - delegate to EKEventEditViewController Event delegate line 337
    [editEvent setEditViewDelegate:self];
    [editEvent setEvent:event];
    [self presentViewController:editEvent
                       animated:YES
                     completion:nil];
}

// desc - reminder item
- (void) createReminderItem{
    EKEventStore *eStore = [[EKEventStore alloc]init];
    
    NSDecimalNumber *time = [self->selectedItem objectForKey:@"time"];
    NSDate *eventDate = [NSDate dateWithTimeIntervalSince1970:[time floatValue]/1000];
    
    EKReminder *reminder = [EKReminder reminderWithEventStore:eStore];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)
                                           fromDate:eventDate];
    [comps setDay:[comps day]];
    [comps setMonth:[comps month]];
    [comps setYear:[comps year]];
    
    [reminder setCalendar:[eStore defaultCalendarForNewReminders]];
    [reminder setTitle:[self->selectedItem objectForKey:@"name"]];
    [reminder setDueDateComponents:comps];
    
    NSError *error = nil;
    [eStore saveReminder:reminder
                  commit:YES
                   error:&error];
    if (error) {
        NSLog(@"Saving createReminderItem: %@", error);
    }
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                 message:@"Reminder created!"
                                                delegate:nil
                                       cancelButtonTitle:nil
                                       otherButtonTitles:@"OK", nil];
    [av show];
}

// desc - EKEventEditViewController Event delegate
- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
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
