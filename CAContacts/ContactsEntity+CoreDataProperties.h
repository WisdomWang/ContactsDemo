//
//  ContactsEntity+CoreDataProperties.h
//  CAContacts
//
//  Created by Cary on 2019/3/19.
//  Copyright © 2019 Cary. All rights reserved.
//
//

#import "ContactsEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ContactsEntity (CoreDataProperties)

+ (NSFetchRequest<ContactsEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *namepinyin;
@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *sectionName;

@end

NS_ASSUME_NONNULL_END
