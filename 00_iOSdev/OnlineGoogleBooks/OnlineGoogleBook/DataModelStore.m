//
//  DataModelStore.m
//  OnlineGBooks
//
//  Created by Ding Orlando on 2/13/13.
//  Copyright (c) 2013 Ding Orlando. All rights reserved.
//

#import "DataModelStore.h"
#import <CoreData/CoreData.h>

@implementation DataModelStore

- (id)init{
    if ([DataModelStore defaultStore]) {
        return [DataModelStore defaultStore];
    }
    if (self = [super init]) {
        self->model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
        // desc - http://ken.bokele.com/?ArticleID=86399
        NSString *path = [NSString stringWithFormat:@"%@\%@", NSHomeDirectory(), @"store.data"];
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
        if (!request || [result count] < 1) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        self->status = result[0];
    }
}

- (PersistStatus*) statusOfDataModel{
    [self fetchData];
    return self->status;
}

+ (DataModelStore*) defaultStore{
    if (self) {
    }
    return self;
}


@end
