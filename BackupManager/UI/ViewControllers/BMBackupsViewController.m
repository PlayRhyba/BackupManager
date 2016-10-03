//
//  BMBackupsViewController.m
//  BackupManager
//


#import "BMBackupsViewController.h"
#import <CoreData/CoreData.h>
#import "BMBackup+CoreDataClass.h"
#import <MagicalRecord/MagicalRecord.h>
#import "NSDate+Additions.h"
#import "BMBackupStorage.h"


@interface BMBackupsViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)fetchData;

@end


@implementation BMBackupsViewController


#pragma mark - Getters/Setters


- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController == nil) {
        NSString *userKey = NSStringFromSelector(@selector(user));
        
        _fetchedResultsController = [BMBackup MR_fetchAllGroupedBy:userKey
                                                     withPredicate:nil
                                                          sortedBy:userKey
                                                         ascending:YES
                                                          delegate:self];
    }
    
    return _fetchedResultsController;
}


#pragma mark - Lifecycle Methods


- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchData];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.fetchedResultsController.sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.name;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"_cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    BMBackup *backup = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = backup.name;
    cell.detailTextLabel.text = [backup.date string];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BMBackup *backup = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSError *error = nil;
        [BMBackupStorage removeBackup:backup error:&error];
        
        if (error) {
            NSLog(@"%@: REMOVING BACKUP ERROR: %@", NSStringFromClass([self class]), error.localizedDescription);
        }
    }
}


#pragma mark - NSFetchedResultsControllerDelegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [_tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert: {
            [_tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                      withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                      withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        default: break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert: {
            [_tableView insertRowsAtIndexPaths:@[newIndexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [_tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [_tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [_tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
            
            [_tableView insertRowsAtIndexPaths:@[newIndexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [_tableView endUpdates];
}


#pragma mark - Internal Logic


- (void)fetchData {
    NSError *error = nil;
    
    if ([self.fetchedResultsController performFetch:&error] == NO) {
        NSLog(@"%@: FETCH DATA ERROR: %@", NSStringFromClass([self class]), error.localizedDescription);
    }
}

@end
