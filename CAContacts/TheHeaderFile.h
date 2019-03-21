//
//  TheHeaderFile.h
//  CAContacts
//
//  Created by Cary on 2019/3/21.
//  Copyright © 2019 Cary. All rights reserved.
//

#ifndef TheHeaderFile_h
#define TheHeaderFile_h



#define xScreenWidth        ([UIScreen mainScreen].bounds.size.width)
#define xScreenHeight       ([UIScreen mainScreen].bounds.size.height)

#define xNullString(string) ((![string isKindOfClass:[NSString class]]) || [string isEqualToString:@""] || (string == nil) || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)


#endif /* TheHeaderFile_h */
