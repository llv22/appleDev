//
//  RMDocument.m
//  08_RaiseMan
//
//  Created by Ding Orlando on 10/20/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "RMDocument.h"
#import "Person.h"

@interface RMDocument (PrivateMethods)

- (void)changeKeyPath:(NSString *)keyPath
			 ofObject:(id)obj
			  toValue:(id)newValue;

@end

@implementation RMDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        employees = [NSMutableArray new];
//		employees = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setEmployees:(NSMutableArray *)a
{
    if (a == self->employees) {
        return;
    }
    
	for (Person *person in employees) {
		[self stopObservingPerson:person];
	}
	
    self->employees = a;
	
	for (Person *person in employees) {
		[self startObservingPerson:person];
	}
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"RMDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

// TODO : 2012-10-21 10:33:17.531 08_RaiseMan[1109:303] dataOfType:error: is unimplemented
- (NSData *)dataOfType:(NSString *)typeName
                 error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
//    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
//    @throw exception;
//    return nil;
    
    // desc - end editing action
    [[self->tableView window]endEditingFor:nil];
    // desc - from employee queue to create NSData Object
    return [NSKeyedArchiver archivedDataWithRootObject:self->employees];
}

- (BOOL)readFromData:(NSData *)data
              ofType:(NSString *)typeName
               error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
//    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
//    @throw exception;
//    return YES;
    
    NSLog(@"About to read data of type %@", typeName);
    NSMutableArray *newArray = nil;
    @try {
        newArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *e) {
        NSLog(@"exception = %@", e);
        if (outError) {
            NSDictionary *d = [NSDictionary dictionaryWithObject:@"The data is corrupted"
                                                          forKey:NSLocalizedFailureReasonErrorKey];
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain
                                            code:unimpErr
                                        userInfo:d];
        }
        return NO;
    }
    [self setEmployees:newArray];
    return YES;
}

#pragma undo invocation stack hook

//TODO : KVO for full path 
- (void)insertObject:(Person *)p
  inEmployeesAtIndex:(NSInteger)index {
    NSLog(@"adding %@ to %@", p, employees);
    // desc - the reverse operations added into undo stack
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self]removeObjectFromEmployeesAtIndex:index];
    if (![undo isUndoing]) {
        [undo setActionName:@"Add Person"];
    }
    // desc - add person into list
    [self startObservingPerson:p];
    [self->employees insertObject:p atIndex:index];
}

- (void)removeObjectFromEmployeesAtIndex:(NSInteger)index{
    Person *p = [employees objectAtIndex:index];
    NSLog(@"removing %@ to %@", p, employees);
    // desc - the reverse operation added into undo stack
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self]insertObject:p inEmployeesAtIndex:index];
    if (![undo isUndoing]) {
        [undo setActionName:@"Remove Person"];
    }
    // desc - remove person in list
    [self stopObservingPerson:p];
    [self->employees removeObjectAtIndex:index];
}

#pragma undo editing operation
// RMDocumentKVOContext - this class could clarify its own KVO message or message to parent class
// RMDocumentKVOContext enables this class to differentiate
// between its KVO messages and those intended for a superclass:
static void *RMDocumentKVOContext;

- (void)startObservingPerson:(Person*)person{
    [person addObserver:self
             forKeyPath:@"personName"
                options:NSKeyValueObservingOptionOld
                context:&RMDocumentKVOContext];
    [person addObserver:self
             forKeyPath:@"expectedRaise"
                options:NSKeyValueObservingOptionOld
                context:&RMDocumentKVOContext];
}

- (void)stopObservingPerson:(Person*)person
{
	[person removeObserver:self
				forKeyPath:@"personName"
				   context:&RMDocumentKVOContext];
	[person removeObserver:self
				forKeyPath:@"expectedRaise"
				   context:&RMDocumentKVOContext];
}

#pragma edit and undo method
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if (context != &RMDocumentKVOContext) {
        // desc - if context not match , the message will be sent out to parent class
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
        return;
    }
    
    NSUndoManager *undo = [self undoManager];
    id oldvalue = [change objectForKey:NSKeyValueChangeOldKey];
    // desc - NSNull object is used in dictionary for nil
    if ([NSNull null] == oldvalue) {
        oldvalue = nil;
    }
    NSLog(@"oldValue = %@", oldvalue);
    // desc - observe the reverse undo for editing
    [[undo prepareWithInvocationTarget:self]changeKeyPath:keyPath ofObject:object toValue:oldvalue];
    [undo setActionName:@"Edit"];
}

- (void)changeKeyPath:(NSString *)keyPath
			 ofObject:(id)obj
			  toValue:(id)newValue
{
	// setValue:forKeyPath: will cause the key-value observing method
    // to be called, which takes care of the undo stuff
    [obj setValue:newValue forKeyPath:keyPath];
}

#pragma insert and edit immediately
- (IBAction)createEmployee:(id)sender{
    NSWindow *w = [self->tableView window];
    // desc - prepare to stop the happending edit action
    BOOL editingEnded = [w makeFirstResponder:w];
    if (!editingEnded) {
        NSLog(@"Unable to end editing");
        return;
    }
    
    NSUndoManager *undo = [self undoManager];
    // desc - if this event already happened one editing action
    if ([undo groupingLevel] > 0) {
        // desc - close the last group
        [undo endUndoGrouping];
        // desc - oepn new group
        [undo beginUndoGrouping];
    }
    // desc - create new object
    Person *p = [employeeController newObject];
    // desc - insert into employeeController
    [employeeController addObject:p];
    // desc - re-sorting by user column
    [employeeController rearrangeObjects];
    // desc - get new list after sorting
    NSArray *a = [employeeController arrangedObjects];
    // desc - get the object just inserted
    NSUInteger row = [a indexOfObjectIdenticalTo:p];
    NSLog(@"starting edit of %@ in row %lu", p, row);
    // desc - starting edit in the first line
    [self->tableView editColumn:0
                            row:row
                      withEvent:nil
                         select:YES];
}

@end
