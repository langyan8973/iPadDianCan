//
//  LoginView.m
//  iPadDianCan
//
//  Created by 刘岩 on 13-5-10.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LoginView.h"
#import "Restaurant.h"
#import "MessageView.h"
#import "TextUtil.h"
#import "Waiter.h"

@implementation LoginView
@synthesize loginDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //加背景图片
        UIImageView *ivtbbg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
        [ivtbbg setImage:[UIImage imageNamed:@"restaurantLogin"]];
        [self addSubview:ivtbbg];
        [ivtbbg release];
        
        codeTextView=[[UITextView alloc] initWithFrame:CGRectMake(264, 500, 240,40)];
        [codeTextView setBackgroundColor:[UIColor whiteColor]];
        codeTextView.delegate=self;
        [codeTextView setKeyboardType:UIKeyboardTypeNumberPad];
        codeTextView.layer.borderColor = [UIColor grayColor].CGColor;
        codeTextView.layer.cornerRadius =10.0;
        codeTextView.textColor=[UIColor blackColor];
        codeTextView.font = [UIFont boldSystemFontOfSize:25];
        codeTextView.textAlignment=UITextAlignmentCenter;
         [self addSubview:codeTextView];
        [codeTextView becomeFirstResponder];
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [loginButton setFrame:CGRectMake(309, 560, 150, 150)];
        [loginButton setBackgroundImage:[UIImage imageNamed:@"restaurantloginbtn"]forState:UIControlStateNormal];
        [loginButton setImage:[UIImage imageNamed:@"calledrestaurantloginbtn"] forState:UIControlStateDisabled];        
        [self addSubview:loginButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark -UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text==nil) {
        code=0;
    }
    else{
        NSNumber *num=(NSNumber*)textView.text;
        code=num.integerValue;
    }
    
}

#pragma  mark - 点击按钮
-(void)loginBtnClick{
    if (code==0) {
        codeTextView.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }

    codeTextView.layer.borderColor = [UIColor grayColor].CGColor;
    
    [Restaurant rid:code Restaurant:^(Restaurant *restaurant) {
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        NSNumber *numrid=[NSNumber numberWithInteger:restaurant.rid];
        [ud setValue:numrid forKey:@"rid"];
        [ud setValue:restaurant.name forKey:@"rname"];
        [ud synchronize];
        [loginDelegate closeLoginView];

    } failure:^{
        MessageView *mv=[[[MessageView alloc] initWithMessageText:@"登录失败"] autorelease];
        [mv show];
    }];
}

#pragma mark - 释放内存
-(void)dealloc{
    [codeTextView release];
    [super dealloc];
}
@end
