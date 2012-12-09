//
//  SecondViewController.m
//  2.7_SingleViewController
//
//  Created by Ding Orlando on 10/2/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

-(void)goBack;
-(void)setTitleView;

@end

@implementation SecondViewController

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
	// Do any additional setup after loading the view. - red
    self.view.backgroundColor = [UIColor colorWithRed:.8 green:.5 blue:.6 alpha:1];
    self.title = @"Second Controller";
    [self setTitleView];
}

//TODO : load titleView
-(void)setTitleView{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 40.0f)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //desc - load an image, Be careful, this image will be cached
//    UIImage *image = [UIImage imageNamed:@""];
//    [imageView setImage:image];
    //desc - set title view
    self.navigationItem.titleView = imageView;
}

-(void)goBack{
    //desc - for just pop-up the topest item
//    [self.navigationController popViewControllerAnimated:YES];
    //desc - for modification of array of view controllers
    NSArray *currentControllers = self.navigationController.viewControllers;
    //desc - create mutable array out of this array
    NSMutableArray *newControllers = [NSMutableArray arrayWithArray:currentControllers];
    int _iLastIndex = [newControllers count] - 1;
    SecondViewController *_item = (SecondViewController*)newControllers[_iLastIndex];
    assert(self == _item);
    //desc - remove the last object from the array
    [newControllers removeLastObject];
    //desc - modification with animation
    [self.navigationController setViewControllers:newControllers animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self performSelector:@selector(goBack) withObject:nil afterDelay:5.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
