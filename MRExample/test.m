//
//  test.m
//  WMDGx
//
//  Created by Tim Jones on 2/21/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import "test.h"

@implementation test



-(NSFetchedResultsController*)fetchedResultsController {
    if (fetchedResultsController_ != nil)
        return fetchedResultsController_;
    NSManagedObjectContext *moc = [order_ managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [sortDescriptors release];
    [sortDescriptor release];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc]
                                              initWithFetchRequest:fetchRequest
                                              managedObjectContext:moc
                                              sectionNameKeyPath:@"category.name"
                                              cacheName:nil];
    controller.delegate = self;
    self.fetchedResultsController = controller;
    [controller release];
    [fetchRequest release];
    
    NSError *error = nil;
    if (![fetchedResultsController_ performFetch:&error]) {
        // Error handling
    }
    return fetchedResultsController_;
}




////////////////////////////


- (NSInteger)numberOfSections {
    return [[self.fetchedResultsController fetchedObjects] count];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    Category* category = [[self.fetchedResultsController fetchedObjects] objectAtIndex:section];
    return [[category items] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Category* category = [[self.fetchedResultsController fetchedObjects] objectAtIndex:section];
    return category.name;
}


@end
