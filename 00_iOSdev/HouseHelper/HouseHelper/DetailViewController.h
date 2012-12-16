//
//  DetailViewController.h
//  HouseHelper
//
//  Created by Ding Orlando on 12/16/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HouseBase;

@interface DetailViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
                house:(HouseBase*)houseData;

@end
