//
//  DataModelStore.h
//  OnlineGBooks
//
//  Created by Ding Orlando on 2/13/13.
//  Copyright (c) 2013 Ding Orlando. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PersistStatus;

@interface DataModelStore : NSObject{
    PersistStatus *status;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

+ (DataModelStore*) defaultStore;
- (BOOL) saveChanges;
- (PersistStatus*) statusOfDataModel;
- (void) fetchData;

@end
