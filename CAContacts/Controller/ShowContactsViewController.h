//
//  ShowContactsViewController.h
//  CAContacts
//
//  Created by Cary on 2019/3/21.
//  Copyright © 2019 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsEntity+CoreDataProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShowContactsViewController : UIViewController

@property (nonatomic,strong)ContactsEntity *c;

@end

NS_ASSUME_NONNULL_END
