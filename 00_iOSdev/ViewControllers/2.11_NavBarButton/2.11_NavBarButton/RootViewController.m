//
//  RootViewController.m
//  2.11_NavBarButton
//
//  Created by Ding Orlando on 10/3/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "RootViewController.h"
#import "SecondViewController.h"

//TODO : see DispatchTimer - http://developer.apple.com/library/mac/#documentation/General/Conceptual/ConcurrencyProgrammingGuide/GCDWorkQueues/GCDWorkQueues.html
dispatch_source_t CreateDispatchTimer(uint64_t interval,
                                      uint64_t leeway,
                                      dispatch_queue_t queue,
                                      dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                     0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval, leeway);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}

@interface RootViewController ()

- (void)pushSecondController;
- (void)performAdd:(id)paramSender;
- (void)switchIsChanged:(UISwitch*)paramSender;
- (void)segmentedControlTapped:(UISegmentedControl*)paramSender;
- (void)sendButton:(UIButton*)paramSender;
- (void)performPause:(id)paramSender;
- (void)performContinue:(id)paramSender;
- (void)resetToPlayStart;
- (void)resetToPlayStop;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib. - green color
    self.view.backgroundColor = [UIColor colorWithRed:0 green:.5 blue:.6 alpha:1];
    self.title = @"First Controller";
    // desc - page 155 of cookbook - common style
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Add"
//                                                                             style:UIBarButtonItemStylePlain
//                                                                            target:self
//                                                                            action:@selector(performAdd:)];
    // desc - page 157 of cookbook - system style
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//                                                                                          target:self
//                                                                                          action:@selector(performAdd:)];
    // desc - page 158 of cookbook - customview
//    UISwitch *simpleSwitch = [[UISwitch alloc]init];
//    simpleSwitch.on = YES;
//    [simpleSwitch addTarget:self
//                     action:@selector(switchIsChanged:)
//           forControlEvents:UIControlEventValueChanged];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:simpleSwitch];
    // desc - page 160 of cookbook - segmentcontrol
//    NSArray *items = @[@"Up", @"Down"];
////    NSArray *_items = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"D1.png"], [UIImage imageNamed:@"D2.png"], nil];
//    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:items];
//    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
//    segmentedControl.momentary = YES;
//    [segmentedControl addTarget:self
//                         action:@selector(segmentedControlTapped:)
//               forControlEvents:UIControlEventValueChanged];
    
    //desc - don't need to animated property parameter - method parameter/input parameter
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:segmentedControl];
//    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:segmentedControl];
    
    //desc - for just page 472 of stop and continue
    UIBarButtonItem *pauseBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                             target:self
                                                                             action:@selector(performContinue:)];
                                       
    [self.navigationItem setRightBarButtonItem:pauseBtn animated:YES];
    self->status = Continue;
    UIButton *send = [UIButton buttonWithType:UIButtonTypeInfoLight];
    send.frame = CGRectMake(10.0f, 10.0f, 150.0f, 28.0f);
    [send setTitle:@"Send" forState:UIControlStateNormal];
    [send setTitle:@"IsPressed" forState:UIControlStateHighlighted];
    send.enabled = YES;
    [send setShowsTouchWhenHighlighted:YES];
    send.backgroundColor = [UIColor redColor];
    [send addTarget:self action:@selector(sendButton:) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:send];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self performSelector:@selector(pushSecondController) withObject:nil afterDelay:2.0f];
}

-(void)pushSecondController{
    //desc - with object reference
    SecondViewController *_secondController = [[SecondViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:_secondController animated:YES];
}

- (void)resetToPlayStart {
    NSLog(@"%s %d\n", __func__, __LINE__);
    UIBarButtonItem *playBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                            target:self
                                                                            action:@selector(performContinue:)];
    [self.navigationItem setRightBarButtonItem:playBtn animated:YES];
    // desc - trigger repeat to set, then next setting will lead to invalid UI status during next runloop stage
    self->status = Stop;
}

- (void)resetToPlayStop {
    NSLog(@"%s %d\n", __func__, __LINE__);
    UIBarButtonItem *pauseBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause
                                                                             target:self
                                                                             action:@selector(performPause:)];
    [self.navigationItem setRightBarButtonItem:pauseBtn animated:YES];
    self->status = Continue;
}

-(void)sendButton:(UIButton*)paramSender{
    self->progView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
//    desc - invalid scale line
//    [self->progView setFrame:CGRectMake(0.0f, 0.0f, 70.0f, 28.0f)];
    [self->progView setContentMode:UIViewContentModeCenter];
    self.navigationItem.titleView = self->progView;
    if (self.navigationItem.rightBarButtonItem){
        if(self->status == Continue) {
            [self resetToPlayStop];
            // desc - timer - http://stackoverflow.com/questions/10522928/run-repeating-nstimer-with-gcd
            // http://developer.apple.com/library/mac/#documentation/General/Conceptual/ConcurrencyProgrammingGuide/GCDWorkQueues/GCDWorkQueues.html
            if(!self->aTimer){
                self->aTimer = CreateDispatchTimer(40ull * NSEC_PER_MSEC,
                                                   1ull * NSEC_PER_SEC,
                                                   dispatch_get_main_queue(),
                                                   ^{
                                                       if (self->progView) {
                                                           self->progView.progress += 0.01;
                                                           [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                                                           
                                                           if (self->progView.progress == 1.0) {
                                                               dispatch_suspend(self->aTimer);
                                                               //desc - if progress == 1.0, then this repeat starting
                                                               [self resetToPlayStart];
                                                               self.navigationItem.titleView = nil;
                                                               self.title = @"First Controller";
                                                               //TODO : http://www.fieryrobot.com/blog/2010/07/10/a-watchdog-timer-in-gcd/
                                                               dispatch_source_cancel(self->aTimer);
                                                               self->aTimer = nil;
                                                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                               self->status = Continue;
//                                                               if (self->progView) {
//                                                                   self->progView.progress = 0;
//                                                               }
                                                           }
                                                       }
                                                   });
            }else{
                dispatch_resume(self->aTimer);
            }
        }
        else if(self->status == Stop) {
            if (self->progView) {
                self->progView.progress = 0;
            }
            [self resetToPlayStart];
        }
    }
}

-(void)performPause:(id)paramSender{
    if(aTimer){
        dispatch_suspend(self->aTimer);
        [self resetToPlayStart];
    }
}

-(void)performContinue:(id)paramSender{
    if(aTimer){
        dispatch_resume(self->aTimer);
        [self resetToPlayStop];
    }
// with bugs for alloc
    else{
        [self sendButton:nil];
    }
}

-(void)performAdd:(id)paramSender{
    NSLog(@"Action method got called.");
}

-(void)switchIsChanged:(UISwitch*)paramSender{
    if ([paramSender isOn]) {
        NSLog(@"Switch is on.");
    }else{
        NSLog(@"Switch is off.");
    }
}

-(void)segmentedControlTapped:(UISegmentedControl*)paramSender{
    if ([paramSender selectedSegmentIndex] == 0) {
        //desc - up button
        NSLog(@"Up");
    }
    else if([paramSender selectedSegmentIndex] == 1){
        //desc - down button
        NSLog(@"Down");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
