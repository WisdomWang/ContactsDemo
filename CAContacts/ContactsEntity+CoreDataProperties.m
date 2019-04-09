//
//  ContactsEntity+CoreDataProperties.m
//  CAContacts
//
//  Created by Cary on 2019/3/19.
//  Copyright © 2019 Cary. All rights reserved.
//
//

#import "ContactsEntity+CoreDataProperties.h"

@implementation ContactsEntity (CoreDataProperties)

+ (NSFetchRequest<ContactsEntity *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ContactsEntity"];
}

@dynamic name;
@dynamic namepinyin;
@dynamic phone;
@dynamic email;
@dynamic sectionName;

@end
