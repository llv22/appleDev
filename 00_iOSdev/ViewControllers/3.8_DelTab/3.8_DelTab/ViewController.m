//
//  ViewController.m
//  3.8_DelTab
//
//  Created by Ding Orlando on 10/21/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "ViewController.h"

const int iSectionSize = 8;
const int iArraySize = 4;

@interface ViewController ()

//TODO : search table controller
@property (nonatomic, strong) UISearchDisplayController* sbc;
@property (nonatomic, strong) NSMutableArray* states;
@property (nonatomic, strong) NSMutableArray* filteredStates;

- (void) alertForpaste;
- (void) performEditOrDone:(id)paramSender;
- (void) filterData;
- (NSMutableArray *)fetchDataModel:(UITableView *)tableView;

@end

// TODO : Here we refer to /Users/llv22/Documents/01_devsrc/llv22-Programming-iOS-Book-Examples/ch21p632searchableTable/p536p550searchableTable
// 4 for magnifying glass
// #define which 4 // "1" for default ui, try also "2" for scope buttons, "3" for sections, "4" for sections with magnifying glass

@implementation ViewController

- (void)loadView{
    // desc - loadView must be called for loading nib
    [super loadView];
    // desc - arrayOfRows
    self.arrayOfSections = [[NSMutableArray alloc]initWithCapacity:iSectionSize];
    for (int i=0; i<iSectionSize; i++) {
        NSMutableArray *_sectionArray = [[NSMutableArray alloc]initWithCapacity:iArraySize];
        for(int j=0; j<iArraySize; j++){
            _sectionArray[j] = [NSString stringWithFormat:@"Section %d Cell %d", i, j];
        }
        self.arrayOfSections[i] = _sectionArray;
    }
    self.states = self.arrayOfSections;
    self->iScopedSection = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.    
    UIBarButtonItem *pauseBtn = [[UIBarButtonItem alloc]initWithTitle:@"Edit"
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(performEditOrDone:)];
    [self.navigationItem setRightBarButtonItem:pauseBtn animated:YES];
    self.title = @"Table Del/Swap";
    
    // desc - view setting
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTableView = [[UITableView alloc]initWithFrame:self.view.bounds
                                                   style:UITableViewStyleGrouped/*UITableViewStylePlain*/];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    // desc - search header
    UISearchBar *b = [[UISearchBar alloc]init];
    [b sizeToFit];
    b.delegate = self;
    b.scopeButtonTitles = [NSArray arrayWithObjects: @"Starts With", @"Contains", nil];
    UISearchDisplayController *c = [[UISearchDisplayController alloc]initWithSearchBar:b
                                                                     contentsController:self];
    c.delegate = self;
    c.searchResultsDataSource = self;
    c.searchResultsDelegate = self;
    self.sbc = c;
    // desc - customize header or footer view
    [self.myTableView setTableHeaderView:b];
    // desc - just scroll to top of row item, after the setTableHeaderView
    [self.myTableView
     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
     atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    [self.myTableView setTableFooterView:b];
    
    // desc - make sure our table view resizes correctly
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.myTableView];
}

//TODO : edit for table
- (void)performEditOrDone:(id)paramSender{
    if (self->status == Edit) {
        UIBarButtonItem *pauseBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(performEditOrDone:)];
        [self.navigationItem setRightBarButtonItem:pauseBtn animated:YES];
        // Turn off editing mode
        [self setEditing:YES animated:YES];
        self->status = Done;
    }
    else if(self->status == Done) {
        UIBarButtonItem *pauseBtn = [[UIBarButtonItem alloc]initWithTitle:@"Edit"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(performEditOrDone:)];
        [self.navigationItem setRightBarButtonItem:pauseBtn animated:YES];
        // Turn off editing mode
        [self setEditing:NO animated:YES];
        self->status = Edit;

    }
}

#pragma mark - table loading
//TODO : check-up with table size
- (NSMutableArray *)fetchDataModel:(UITableView *)tableView{
    NSMutableArray *tmp = nil;
    // desc - if in searching table, just return filterstate
    if (tableView == self.sbc.searchResultsTableView){
        tmp = self.filteredStates;
    }
    else{
        tmp = self.arrayOfSections;
    }
    return tmp;
}

//TODO : number of sections in table - if in searching view, just return 1 section
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger result = 0;
    if ([tableView isEqual:self.myTableView] || [tableView isEqual:self.sbc.searchResultsTableView]) {
        result = [[self fetchDataModel:tableView] count];
    }
    return result;
}

//TODO : number of row for specific section
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    NSInteger result = 0;
    if ([tableView isEqual:self.myTableView] || [tableView isEqual:self.sbc.searchResultsTableView]) {
        NSMutableArray *tmp = [self fetchDataModel:tableView];
        // desc - always true for sections
        if ([tmp count] > section) {
            NSMutableArray *sectionArray = tmp[section];
            result = [sectionArray count];
        }
    }
    return result;
}

- (UITableViewCell*) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *result = nil;
    if ([tableView isEqual:self.myTableView] || [tableView isEqual:self.sbc.searchResultsTableView]) {
        static NSString *MyCellIdentifier = @"SimpleCell";
        result = [self.myTableView dequeueReusableCellWithIdentifier:MyCellIdentifier];
        if (nil == result) {
            result = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:MyCellIdentifier];
        }
        // desc - for section items for segement
        NSMutableArray *tmp = [self fetchDataModel:tableView];
        NSMutableArray *sectionArray = tmp[indexPath.section];
        result.textLabel.text = sectionArray[indexPath.row];
//        result.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    return  result;
}

#pragma mark - deletion
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
    if ([tableView isEqual:self.myTableView]) {
        result = UITableViewCellEditingStyleDelete;
    }
    return result;
}

- (void)setEditing:(BOOL)editing
          animated:(BOOL)animated{
    [super setEditing:editing
             animated:animated];
    [self.myTableView setEditing:editing
                        animated:animated];
}

- (void)    tableView:(UITableView *)tableView
   commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        NSMutableArray *tmp = [self fetchDataModel:tableView];
        NSMutableArray *sectionArray = tmp[indexPath.section];
        if (indexPath.row < [sectionArray count]) {
            // desc - first remove the object from the source
            [sectionArray removeObjectAtIndex:indexPath.row];
            // desc - then remove the assciated cell from the table view
            [self.myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                    withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

#pragma mark - header and footer
- (UIView*)     tableView:(UITableView *)tableView
   viewForHeaderInSection:(NSInteger)section{
    UIView *result = nil;
    if ([tableView isEqual:self.myTableView]) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.text = [NSString stringWithFormat:@"Section %d Header", section];
        label.backgroundColor = [UIColor clearColor];
        [label sizeToFit];
        
        // desc - move to alignment of title, moving to 10.0f, - 5.0f
        label.frame = CGRectMake(label.frame.origin.x + 10.0f, 5.0f, label.frame.size.width, label.frame.size.height);
        CGRect resultFrame = CGRectMake(0.0f, 0.0f, label.frame.size.width + 10.0f * section, label.frame.size.height);
        result = [[UIView alloc]initWithFrame:resultFrame];
        [result addSubview:label];
    }
    return result;
}

- (UIView*)     tableView:(UITableView *)tableView
   viewForFooterInSection:(NSInteger)section{
    UIView *result = nil;
    if ([tableView isEqual:self.myTableView]) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.text = [NSString stringWithFormat:@"Section %d Footer", section];
        label.backgroundColor = [UIColor clearColor];
        [label sizeToFit];
        
        // desc - move to alignment of title, moving to 10.0f, - 5.0f
        label.frame = CGRectMake(label.frame.origin.x + 10.0f, 5.0f, label.frame.size.width, label.frame.size.height);
        CGRect resultFrame = CGRectMake(0.0f, 0.0f, label.frame.size.width + 10.0f, label.frame.size.height);
        result = [[UIView alloc]initWithFrame:resultFrame];
        [result addSubview:label];
    }
    return result;
}

#pragma mark - header and footer alignment heightForHeaderInSection and heightForFooterInSection for each section
- (CGFloat)     tableView:(UITableView *)tableView
 heightForHeaderInSection:(NSInteger)section{
    CGFloat result = 0.0f;
    if ([tableView isEqual:self.myTableView]) {
        result = 30.0f;
    }
    return result;
}

- (CGFloat)     tableView:(UITableView *)tableView
 heightForFooterInSection:(NSInteger)section{
    CGFloat result = 0.0f;
    if ([tableView isEqual:self.myTableView]) {
        result = 30.0f;
    }
    return result;
}

#pragma mark - title
- (NSString*)   tableView:(UITableView *)tableView
  titleForHeaderInSection:(NSInteger)section{
    NSString *result = nil;
    if ([tableView isEqual:self.myTableView]) {
        result = [NSString stringWithFormat:@"Section %d Header", section];
    }
    return result;
}

- (NSString*)   tableView:(UITableView *)tableView
  titleForFooterInSection:(NSInteger)section{
    NSString *result = nil;
    if ([tableView isEqual:self.myTableView]) {
        result = [NSString stringWithFormat:@"Section %d Footer", section];
    }
    return result;
}

#pragma mark - paste context menu
- (BOOL)                tableView:(UITableView *)tableView
  shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL) tableView:(UITableView *)tableView
  canPerformAction:(SEL)action
 forRowAtIndexPath:(NSIndexPath *)indexPath
        withSender:(id)sender{
    // desc - print performAction list
//    NSLog(@"%@", NSStringFromSelector(action));
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}

- (void) tableView:(UITableView *)tableView
     performAction:(SEL)action
 forRowAtIndexPath:(NSIndexPath *)indexPath
        withSender:(id)sender{
    if (action == @selector(copy:)) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        [pasteBoard setString:cell.textLabel.text];
        [self performSelector:@selector(alertForpaste) withObject:nil afterDelay:1.0f];
    }
}

- (void)alertForpaste{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Not so fast!"
                                                   message:[UIPasteboard generalPasteboard].string
                                                  delegate:nil
                                         cancelButtonTitle:@"YES"
                                         otherButtonTitles:@"NO", @"Maybe", nil];
    [alert show];
}

#pragma mark - sorting by row in section
//TODO : reordering control can be prevented for delegate
- (BOOL)    tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.arrayOfSections count] && indexPath.section < [self.arrayOfSections count]) {
        return YES;
    }
    return NO;
}
- (NSIndexPath *)               tableView:(UITableView *)tableView
 targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
                      toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    [tableView endEditing:YES];
    return proposedDestinationIndexPath;
}

- (void)    tableView:(UITableView *)tableView
   moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
          toIndexPath:(NSIndexPath *)destinationIndexPath{
    // desc - change the data order in response to a user interaction
    NSLog(@"MOVE ITEM");
}

#pragma mark - search table content
//TODO : searching filter on table
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    [self.filteredStates addObjectsFromArray:self.states];
}

//TODO : text content for searching table
- (void) searchBar:(UISearchBar *)searchBar
     textDidChange:(NSString *)searchText{
    [self filterData];
}

//TODO : update the sections in dictionary for self.filteredStates
- (void) filterData{
    NSPredicate* p = [NSPredicate predicateWithBlock:
                      ^BOOL(id obj, NSDictionary *d) {
                          NSString* s = obj;
                          NSStringCompareOptions options = NSCaseInsensitiveSearch;
                          // desc - header search
                          if (self.sbc.searchBar.selectedScopeButtonIndex == 0)
                              options |= NSAnchoredSearch;
                          // desc - fix-bug
                          return ([s rangeOfString:self.sbc.searchBar.text
                                           options:options].location != NSNotFound);
                      }];
    [self.filteredStates removeAllObjects];
    // desc - should be filtered by different group
    for (NSObject *item in self.states) {
        NSMutableArray *mutableArray = (NSMutableArray*)item;
        NSMutableArray *_array = (NSMutableArray *)[mutableArray filteredArrayUsingPredicate:p];
        [self.filteredStates addObject:_array];
    }
}

//TODO : invoke search via button click
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}

//TODO : index of searching changed
- (void)                searchBar:(UISearchBar *)searchBar
selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    // desc - switch to selectedScope
    self->iScopedSection = selectedScope;
    [self filterData];
}

//TODO : GCD to invoke search result later
- (BOOL)    searchDisplayController:(UISearchDisplayController *)controller
   shouldReloadTableForSearchString:(NSString *)searchString{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.001);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (UIView* v in self.sbc.searchResultsTableView.subviews) {
            if ([v isKindOfClass: [UILabel class]] && [[(UILabel*)v text] isEqualToString:@"No Results"]) {
                [(UILabel*)v setText: @""];
                break;
            }
        }
    });
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
