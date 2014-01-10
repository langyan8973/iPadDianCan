//
//  TextAlertView.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-26.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "TextAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"


@implementation TextAlertView
@synthesize codeTexView,code,contentView;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame= CGRectMake(0, 0, 768, 1024);
        self.backgroundColor=[UIColor clearColor];
        UIView *backgroundView=[[UIView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor=[UIColor blackColor];
        backgroundView.alpha=0.5;
        [self addSubview:backgroundView];
        [backgroundView release];
        contentView=[[UIView alloc] initWithFrame:CGRectMake(234, -320, 300,150)];
        codeTexView=[[UITextView alloc] initWithFrame:CGRectMake(90.0f, 55.0f, 120.0f, 30.0f)];
        codeTexView.delegate=self;
        [codeTexView setKeyboardType:UIKeyboardTypeNumberPad];
        codeTexView.textColor=[UIColor orangeColor];
        codeTexView.font = [UIFont boldSystemFontOfSize:28];
        codeTexView.layer.borderColor = [UIColor grayColor].CGColor;
        codeTexView.layer.cornerRadius =10.0;
        codeTexView.textAlignment=UITextAlignmentCenter;
        [self.contentView addSubview:codeTexView];
        [codeTexView becomeFirstResponder];
        [self addSubview:contentView];
    }
    return self;
}

-(void)codeYesBtnClick{
    [self.textAlertViewDelegate checkIn:self.code];
    [self codeNoBtnClick];
}
-(void)codeNoBtnClick{
    UIViewController *sc=(UIViewController *)self.textAlertViewDelegate;
    sc.navigationItem.rightBarButtonItem.enabled=YES;
    [self removeFromSuperview];
}
-(void)layoutSubviews{
    //屏蔽系统的ImageView 和 UIButton
    UIImageView *imageBgView=[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 150.0f)];
    [imageBgView setImage:[UIImage imageNamed:@"alertViewBg"]];
    [self.contentView addSubview:imageBgView];
    [imageBgView release];
    [self.contentView bringSubviewToFront:codeTexView];
    UILabel *codeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 30, 300, 20)];
    codeLabel.backgroundColor=[UIColor clearColor];
    codeLabel.font = [UIFont boldSystemFontOfSize:18];
    codeLabel.textColor=[UIColor whiteColor];
    codeLabel.textAlignment=UITextAlignmentCenter;
    codeLabel.text=@"请向服务员询问开台码";
    [self.contentView addSubview:codeLabel];
    [codeLabel release];
    UIButton *codeNoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    codeNoBtn.tag=0;
    [codeNoBtn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [codeNoBtn setBackgroundImage:[UIImage imageNamed:@"alertYesNoBtn"] forState:UIControlStateNormal];
    codeNoBtn.titleLabel.font=[UIFont boldSystemFontOfSize:20];
    [codeNoBtn setTitle:@"取消" forState:UIControlStateNormal];
    [codeNoBtn setFrame:CGRectMake(20, 90, 120, 45)];
    [codeNoBtn addTarget:self action:@selector(codeNoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:codeNoBtn];
    UIButton *codeYesBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    codeYesBtn.tag=1;
    [codeYesBtn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [codeYesBtn setBackgroundImage:[UIImage imageNamed:@"alertYesNoBtn"] forState:UIControlStateNormal];
    codeYesBtn.titleLabel.font=[UIFont boldSystemFontOfSize:20];
    [codeYesBtn setTitle:@"开台" forState:UIControlStateNormal];
    [codeYesBtn setFrame:CGRectMake(160, 90, 120, 45)];
    [codeYesBtn addTarget:self action:@selector(codeYesBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:codeYesBtn];
}

-(void)buttonTouch:(UIButton *)sender{
//    [self.delegate alertView:self clickedButtonAtIndex:sender.tag];
//    [self dismissWithClickedButtonIndex:sender.tag animated:YES];
}

- (void) show {
//    [super show];
    UIViewController *sc=(UIViewController *)self.textAlertViewDelegate;
    self.contentView.frame = CGRectMake(234, -320, 300,150);
    [sc.view addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.frame = CGRectMake(234, 437, 300,150);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark -
#pragma mark UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text==nil) {
        self.code=0;
    }
    else{
        NSNumber *num=(NSNumber*)textView.text;
        self.code=num.integerValue;
    }
}

-(void)dealloc{
    [contentView release];
    [codeTexView release];
    [super dealloc];
}
@end
