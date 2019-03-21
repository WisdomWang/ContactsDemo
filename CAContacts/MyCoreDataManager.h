//
//  MyCoreDataManager.h
//  CAContacts
//
//  Created by Cary on 2019/3/19.
//  Copyright © 2019 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCoreDataManager : NSObject

@property (nonatomic,strong) NSManagedObjectContext*managerContext;
@property (nonatomic,strong) NSManagedObjectModel *managerModel;
@property (nonatomic,strong) NSPersistentStoreCoordinator *managerDinator;

+ (MyCoreDataManager *)shareInstace;
- (void) save;

@end

NS_ASSUME_NONNULL_END
