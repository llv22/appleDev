//
//  RMDocument.h
//  08_RaiseMan
//
//  Created by Ding Orlando on 10/20/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Person;

@interface RMDocument : NSDocument{
    NSMutableArray *employees;
	IBOutlet NSTableView *tableView;
	IBOutlet NSArrayController *employeeController;

}

- (void)setEmployees:(NSMutableArray*)a;
- (void)insertObject:(Person *)p inEmployeesAtIndex:(NSInteger)index;
- (void)removeObjectFromEmployeesAtIndex:(NSInteger)index;
- (IBAction)createEmployee:(id)sender;

@end
