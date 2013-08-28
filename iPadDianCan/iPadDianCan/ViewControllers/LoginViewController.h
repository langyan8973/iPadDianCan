//
//  LoginViewController.h
//  iPadDianCan
//
//  Created by 刘岩1 on 13-8-19.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"

@interface LoginViewController : UIViewController<LoginDelegate>
@property(nonatomic,retain) LoginView *loginView;
@end
