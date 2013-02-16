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
    NSMutableArray *allItems;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    
    // desc - serial queue to persist filed, *** not in main thread queue ***
    dispatch_queue_t queue;
}

@property (nonatomic, getter = getiCurrentPage) int32_t iCurrentPage;

+ (DataModelStore*) defaultStore;
- (BOOL) saveChanges;
- (PersistStatus*) statusOfDataModel;
- (void) fetchData;
// desc - should be have callback delegate from external for pesisted status
- (void) savePageNumber : (int)iCurrentPage
               callback :(void (^)(BOOL))mycallback;
- (int32_t) getiCurrentPage;

@end
