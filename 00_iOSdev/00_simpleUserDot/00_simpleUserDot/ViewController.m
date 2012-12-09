//
//  ViewController.m
//  00_simpleUserDot
//
//  Created by Ding Orlando on 9/16/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "ViewController.h"
#import "MyView.h"

@interface ViewController ()

-(void)locateMe;
-(void)pageCurl;
-(void)search;
-(void)direction;

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    /** -- manually change logic before --
	 * Do any additional setup after loading the view, typically from a nib.
     * UIWindow* _keyWindow = [[UIApplication sharedApplication]keyWindow];
     **/
//    TODO : full screen for MyView, even overwrite the toolbar
    CGRect _viewSize = [[UIScreen mainScreen]applicationFrame];
    _viewSize.size.height -= self->bottomToolbar.bounds.size.height;
    /** -- manually change logic before --
     * MyView* mv = [[MyView alloc]initWithFrame:_viewSize];
     **/
    MyView* mv = [[MyView alloc]initWithFrame:CGRectMake(0, 0, _viewSize.size.width, _viewSize.size.height)];
    /** -- manually change logic before --
     * MyView* mv = [[MyView alloc]initWithFrame:self->upViewContainer.bounds];//as self.view is full screen size
     * mv.center = _keyWindow.center;
     * //TODO : don't override the view of root view controller, as toolbar instance already exists.
     * self.view = mv;
     **/
    [self.view addSubview:mv];
    /** -- manually change logic before --
     * mv.opaque = NO;
     **/
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(IBAction)buttonPressed:(id)sender{
    if ([sender isKindOfClass:[UIBarButtonItem class] ]) {
        UIBarButtonItem* _clickItem = (UIBarButtonItem*)sender;
        if(_clickItem.tag == 0){
            [self locateMe];
        }
        else if(_clickItem.tag == 1){
            [self pageCurl];
        }
    }
    else if([sender isKindOfClass:[UISegmentedControl class]]){
        UISegmentedControl* _segmentItem = (UISegmentedControl*)sender;
        if(_segmentItem.selectedSegmentIndex == 0){
            [self search];
        }
        else if(_segmentItem.selectedSegmentIndex == 1){
            [self direction];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - private methods
//TODO : invoke heading information
-(void)locateMe{
    NSLog(@"locate me\n");
}

/**
 * temp. left empty functionalities
 **/
-(void)pageCurl{
    NSLog(@"page curl\n");
}
-(void)search{
    NSLog(@"search\n");
}
-(void)direction{
    NSLog(@"direction\n");
}

@end
