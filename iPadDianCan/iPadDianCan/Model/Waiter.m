//
//  Waiter.m
//  iPadDianCan
//
//  Created by 刘岩 on 13-5-20.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "Waiter.h"
#import "AFRestAPIClient.h"
#import "AFHTTPRequestOperation.h"

@implementation Waiter
@synthesize restaurant,wid,wname,password,token;


+(void)code:(NSNumber *)code name:(NSString *)name pass:(NSString *)password Waiter:(success)waiter failure:(failure)failure{
    NSString *path=[NSString stringWithFormat:@"waiter/login"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            code, @"restaurant",
                            name, @"username",
                            password, @"password",
                            nil];
    
    [[AFRestAPIClient sharedClient] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *contentDic=(NSDictionary *)responseObject;
        Waiter *lwaiter = [[[Waiter alloc] init] autorelease];
        NSNumber *numWid=[contentDic valueForKey:@"wid"];
        lwaiter.wid = numWid.integerValue;
        lwaiter.wname = name;
        lwaiter.password = password;
        NSDictionary *dictionary = [operation.response  allHeaderFields];
        lwaiter.token=[dictionary valueForKey:@"Authorization"];
        NSNumber *numRid=[contentDic valueForKey:@"rid"];
        [Restaurant rid:numRid.integerValue Restaurant:^(Restaurant *restaurant) {
            lwaiter.restaurant = restaurant;
            waiter(lwaiter);
        } failure:^{
            failure();
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误: %@", error);
        failure();
    }];
}

-(void)dealloc{
    [restaurant release];
    [wname release];
    [password release];
    [token release];
    [super dealloc];
}
@end
