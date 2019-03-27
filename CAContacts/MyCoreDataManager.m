//
//  MyCoreDataManager.m
//  CAContacts
//
//  Created by Cary on 2019/3/19.
//  Copyright © 2019 Cary. All rights reserved.
//

#import "MyCoreDataManager.h"

@implementation MyCoreDataManager

+(MyCoreDataManager *)shareInstace {
    
    static MyCoreDataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MyCoreDataManager alloc]init];
    });
    
    return instance;
}

- (NSManagedObjectContext *)managerContext {
    
    if (_managerContext != nil) {
        return _managerContext;
    }
    
    _managerContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managerContext setPersistentStoreCoordinator:self.managerDinator];
    
    return _managerContext;
}

-(NSManagedObjectModel *)managerModel {
    
    if (_managerModel != nil) {
        return _managerModel;
    }
    
    _managerModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managerModel;
}

-(NSPersistentStoreCoordinator *)managerDinator {
    
    if (_managerDinator !=nil) {
        return _managerDinator;
    }
    
    _managerDinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managerModel];
    NSURL *url = [[self getDocumentUrlPath] URLByAppendingPathComponent:@"sqlit.db" isDirectory:YES];
    [_managerDinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
    
    return _managerDinator;
}

- (NSURL *)getDocumentUrlPath {
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
