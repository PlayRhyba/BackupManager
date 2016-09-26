//
//  BMBackup+CoreDataProperties.m
//  BackupManager
//
//  Created by Alexander Snigurskyi on 2016-09-26.
//  Copyright © 2016 Alexander Snigurskyi. All rights reserved.
//

#import "BMBackup+CoreDataProperties.h"

@implementation BMBackup (CoreDataProperties)

+ (NSFetchRequest<BMBackup *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BMBackup"];
}

@dynamic uuid;
@dynamic name;
@dynamic path;
@dynamic date;
@dynamic user;

@end
