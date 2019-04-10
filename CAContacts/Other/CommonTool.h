//
//  CommonTool.h
//  CAContacts
//
//  Created by Cary on 2019/4/9.
//  Copyright © 2019 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonTool : NSObject

/**
 *  汉语转拼音
 */
+ (NSString *)getPinYinFromString:(NSString *)string;
+(BOOL)JudgeString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
