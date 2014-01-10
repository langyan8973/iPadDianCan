//
//  TextUtil.m
//  iPadDianCan
//
//  Created by 刘岩 on 13-5-20.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "TextUtil.h"

@implementation TextUtil
+(BOOL)isEmptyOrNull:(NSString *) str{
    if (!str) {
        // null object
        return true;
    } else {
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            // empty string
            return true;
        } else {
            // is neither empty nor null
            return false;
        }
    }
}
@end
