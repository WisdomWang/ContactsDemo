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


#define xStatusBarHeight    ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define xNavBarHeight       44.0f
#define xTopHeight          (xStatusBarHeight + xNavBarHeight)


// 十六进制颜色

#define COLOR_WITH_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]


#endif /* TheHeaderFile_h */
