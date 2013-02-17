//
//  DataModelStore.m
//  OnlineGBooks
//
//  Created by Ding Orlando on 2/13/13.
//  Copyright (c) 2013 Ding Orlando. All rights reserved.
//

#import "DataModelStore.h"
#import "PersistStatus.h"
#import <CoreData/CoreData.h>

const char* _queueName = "com.orlando.backqueue";

@implementation DataModelStore

@dynamic iCurrentPage;

// desc - refer to DataModelStore - /Users/llv22/Documents/01_devsrc/08_appleDevs/00_iOSdev/iOSGuideSamples/iOS Programming 3e Solutions/17. Homepwner/Homepwner/Homepwner/BNRItemStore.m
+ (DataModelStore*) defaultStore{
    static DataModelStore *sharedStore = nil;
    if(!sharedStore){
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultStore];
}

+ (dispatch_queue_t) sharedBackgroundQueue{
    static dispatch_queue_t _sharedqueue = nil;
    if (_sharedqueue) {
        _sharedqueue = dispatch_queue_create(_queueName, DISPATCH_QUEUE_SERIAL);
    }
    return _sharedqueue;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Get one and only document directory from that list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (id)init{
    if (self = [super init]) {
        //desc - not suitable for asynchronization model
        self->model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self->model];
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        NSError *error = nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                                configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
        }
        self->context = [[NSManagedObjectContext alloc]init];
        [self->context setPersistentStoreCoordinator:psc];
        [self->context setUndoManager:nil];
        [self fetchData];
    }
    
    return self;
}

- (BOOL) saveChanges{
    NSError *err = nil;
    BOOL successful = [self->context save:&err];
    if (!successful) {
        [NSException raise:@"Failed saving" format:@"Reason: %@", [err localizedDescription]];
    }
    return successful;
}

- (void) fetchData{
    if (!self->status) {
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        NSEntityDescription *e = [[self->model entitiesByName]objectForKey:@"PersistStatus"];
        [request setEntity:e];
        NSError *error;
        NSArray *result = [self->context executeFetchRequest:request error:&error];
        if (!request) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        self->allItems = [result mutableCopy];
        if ([self->allItems count ] == 0){
            // desc - not valid for initialization
//            PersistStatus *_status = [[PersistStatus alloc]init];
            PersistStatus *_status = [NSEntityDescription insertNewObjectForEntityForName:@"PersistStatus"
                                                                   inManagedObjectContext:self->context];
            self->allItems[0] = _status;
        }
        self->status = self->allItems[0];
    }
}

- (PersistStatus*) statusOfDataModel{
    return self->status;
}

- (void) savePageNumber : (int)iCurrentPage
               callback :(void (^)(BOOL))mycallback {
    dispatch_async([DataModelStore sharedBackgroundQueue], ^{
        PersistStatus* _status = [[DataModelStore defaultStore] statusOfDataModel];
        _status.iCurrentPage = iCurrentPage;
        BOOL successful = [[DataModelStore defaultStore] saveChanges];
        dispatch_async(dispatch_get_main_queue(), ^{
            mycallback(successful);
        });
    });
}

// desc - synchronized read operation, but it's faster, not required for item GCD queue thread
- (int32_t) getiCurrentPage{
    return [[DataModelStore defaultStore] statusOfDataModel].iCurrentPage;
}

@end
