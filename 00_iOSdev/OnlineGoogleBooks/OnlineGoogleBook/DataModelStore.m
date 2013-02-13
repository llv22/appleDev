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

@implementation DataModelStore

// desc - refer to DataModelStore - /Users/llv22/Documents/01_devsrc/08_appleDevs/00_iOSdev/iOSGuideSamples/iOS Programming 3e Solutions/17. Homepwner/Homepwner/Homepwner/BNRItemStore.m
+ (DataModelStore*) defaultStore{
    static DataModelStore *sharedStore = nil;
    if(!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultStore];
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    
    // Get one and only document directory from that list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (id)init{
    if (self = [super init]) {
        self->model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self->model];
        
        // Where does the SQLite file go?
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
        NSLog(@"Error saving: %@", [err localizedDescription]);
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
        if ([result count ] == 0){
            // not valid for initialization
//            PersistStatus *_status = [[PersistStatus alloc]init];
            PersistStatus *_status = [NSEntityDescription insertNewObjectForEntityForName:@"PersistStatus"
                                                                   inManagedObjectContext:self->context];
            self->allItems[0] = _status;
        }
        self->status = self->allItems[0];
    }
}

- (PersistStatus*) statusOfDataModel{
    [self fetchData];
    return self->status;
}

@end
