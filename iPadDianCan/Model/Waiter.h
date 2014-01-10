//
//  Waiter.h
//  iPadDianCan
//
//  Created by 刘岩 on 13-5-20.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"

@interface Waiter : NSObject{
}
typedef void(^success) (Waiter *waiter);
typedef void(^failure)();
@property (nonatomic) NSInteger wid;
@property (nonatomic,retain) NSString *wname;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,retain) NSString *token;
@property (nonatomic,retain) Restaurant *restaurant;
+(void)code:(NSNumber *)code name:(NSString *)name pass:(NSString *)password Waiter:(success)waiter failure:(failure)failure;
@end
