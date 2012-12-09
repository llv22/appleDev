//
//  ViewController.h
//  3.8_DelTab
//
//  Created by Ding Orlando on 10/21/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <UIKit/UIKit.h>

enum TableEditStatus {
    Edit = 0,
    Done = 1
};

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>{
    enum TableEditStatus status;
    int iScopedSection;
}

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *arrayOfSections;

@end
