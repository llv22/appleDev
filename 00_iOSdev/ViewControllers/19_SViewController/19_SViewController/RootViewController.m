//
//  RootViewController.m
//  19_SViewController
//
//  Created by Ding Orlando on 10/3/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "RootViewController.h"
#import "FlipsideViewController.h"
#import "IndexViewController.h"

//#define ManVCManView 0
//#define ManVCNibView 1
//#define RVNib 2

@interface RootViewController ()

-(void) goPic: (NSNotification*)n;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//TODO : show presentation
- (IBAction)doPresent:(id)sender{
    FlipsideViewController *controller = [[FlipsideViewController alloc]initWithNibName:@"FlipsideViewController" bundle:nil];
//    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    // desc - depercated in iOS 6.0
//    [self presentModalViewController:controller animated:YES];
    [self presentViewController:controller
                       animated:YES
                     completion:^(void){
        NSLog(@"load presetation ui");
    }];
}

//TODO : do notification
- (IBAction)doNotify:(id)sender{
    //desc - goPic: or goPic
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(goPic:)
                                                name:@"goPic"
                                              object:nil];
    IndexViewController *ivc = [[IndexViewController alloc]initWithNibName:@"IndexViewController"
                                                                    bundle:nil];
    [self presentViewController:ivc
                       animated:YES
                     completion:^(void){
                         NSLog(@"load presetation ui");
                     }];
}

- (IBAction)doDelegate:(id)sender{
    ColorPickerController *cpc = [[ColorPickerController alloc]initWithNibName:@"ColorPickerController" bundle:nil];
    cpc.delegate = self;
    cpc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    cpc.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:cpc
                       animated:YES
                     completion:^(void){
                         NSLog(@"load presestation ui");
                     }];
}

- (void) colorPicker:(ColorPickerController*)picker
    didSetColorNamed:(NSString*)theName
             toColor:(UIColor*)theColor{
    //desc - do stuff for color
    [self dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"colorPicker end\n");
    }];
}

-(void) goPic: (NSNotification*)n{
    NSString *pic = [n userInfo] [@"pic"];
    NSLog(@"%@\n", pic);
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"goPic"
                                                 object:nil];
    [self dismissViewControllerAnimated:YES
                             completion:^(void){
                                 NSLog(@"dismissal presetation ui");
                             }];
}

#ifdef ManVCManView

//TODO : Programming iOS4 - chapter 19 [manually loadView must be disabled for loading Nib forcefully]
- (void)loadView{
    UIView *v = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    v.backgroundColor = [UIColor greenColor];
#ifdef ManVCManView
    //desc - page 438 [manual view controller, manual view]
    UILabel *label = [[UILabel alloc]init];
    label.text = @"Hello World";
    [label sizeToFit];
    label.center = CGPointMake(CGRectGetMidX(v.bounds), CGRectGetMidY(v.bounds));
    label.autoresizingMask = (
                              UIViewAutoresizingFlexibleTopMargin |
                              UIViewAutoresizingFlexibleLeftMargin |
                              UIViewAutoresizingFlexibleBottomMargin |
                              UIViewAutoresizingFlexibleRightMargin
                              );
    [v addSubview:label];
    self.view = v;
#elif ManVCNibView
    //desc - page 441 [manual view controller, nib view]
    [[NSBundle mainBundle]loadNibNamed:@"MyNib" owner:self options:nil];
    self.theLabel.center = CGPointMake(CGRectGetMidX(v.bounds), CGRectGetMidY(v.bounds));
    [v addSubview:self.theLabel];
    self.view = v;
#elif RVNib
    RootViewController *theRVC = [[RootViewController alloc]initWithNibName:@"MyNib" bundle:nil];
    self.view = theRVC.view;
#endif
//    [label release];
//    [v release];
}

#endif

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
