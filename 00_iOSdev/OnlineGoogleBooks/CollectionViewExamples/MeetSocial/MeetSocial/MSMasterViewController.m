//
//  MSMasterViewController.m
//  MeetSocial
//
//  Created by Ding Orlando on 3/19/13.
//  Copyright (c) 2013 Ding Orlando. All rights reserved.
//

#import "MSMasterViewController.h"

const NSString* apiKey = @"6c274f6254523d5f2b10174a68761031";

@interface MSMasterViewController () {
}

- (void)doSearch;
- (void)writeToResultsFile:(NSString*)stringToStore;

@end

@implementation MSMasterViewController
@synthesize segSearchZipOrKeyword;
@synthesize segSearchGroupsOrEvents;
@synthesize tfSearchText;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Search"];
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

#pragma mark - searchTextField search and activate focus
//desc - make focus on the tfSearchText control
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tfSearchText becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [self doSearch];
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - private method (doSearch and store string into local file)
- (void)doSearch{
    NSString *groupsOrEvents = self.segSearchGroupsOrEvents.selectedSegmentIndex == 0 ? @"groups" : @"2/open_events";
    NSString *zipOrKeyword = self.segSearchZipOrKeyword.selectedSegmentIndex == 0 ? @"zip" : @"topic";
    NSString *query = [NSString stringWithFormat:
                       @"https://api.meetup.com/%@?key=%@&sign=true&%@=%@",
                       groupsOrEvents,
                       apiKey,
                       zipOrKeyword,
                       tfSearchText.text];
    NSError *error = nil;
    NSURL *url = [NSURL URLWithString:query];
    NSHTTPURLResponse *retRep = nil;
    NSData *respData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url]
                                             returningResponse:&retRep
                                                         error:&error];
    if (error) {
        NSLog(@"ERROR: %@", error);
    }
    else{
        NSString *resultsJSON = [[NSString alloc]initWithData:respData encoding:NSASCIIStringEncoding];
        [self writeToResultsFile:resultsJSON];
    }
}

- (void)writeToResultsFile:(NSString *)stringToStore{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *path = documentsDirectoryPath;
    
    NSError *error = nil;
    [[NSFileManager defaultManager]createDirectoryAtPath:path
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:&error];
    if (error) {
        NSLog(@"Dir Error: %@", error);
    }
    // desc - path content : /Users/llv22/Library/Application Support/iPhone Simulator/6.1/Applications/7E3E22BC-8A84-4976-97FC-47FC42D358CE/Documents/results.json
    path = [NSString stringWithFormat:@"%@/%@", path, @"results.json"];
    [stringToStore writeToFile:path
                    atomically:YES
                      encoding:NSUTF8StringEncoding
                         error:&error];
    if (error) {
        NSLog(@"Write Error: %@", error);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
    }
}

@end
