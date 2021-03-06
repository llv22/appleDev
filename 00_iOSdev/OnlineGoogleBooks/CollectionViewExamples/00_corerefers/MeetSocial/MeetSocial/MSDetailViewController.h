//
//  MSDetailViewController.h
//  MeetSocial
//
//  Created by Ding Orlando on 3/19/13.
//  Copyright (c) 2013 Ding Orlando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface MSDetailViewController : UICollectionViewController <UISplitViewControllerDelegate, EKEventEditViewDelegate, UIViewControllerRestoration, UIDataSourceModelAssociation>


@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
