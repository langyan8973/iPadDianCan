//
//  LoginView.h
//  iPadDianCan
//
//  Created by 刘岩 on 13-5-10.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LoginDelegate <NSObject>

-(void)closeLoginView;

@end

@interface LoginView : UIView<UITextViewDelegate>{
    UITextView *codeTextView;
//    UITextView *userTextView;
//    UITextView *passTextView;
    NSInteger code;
}
@property(nonatomic,assign) id<LoginDelegate> loginDelegate;
@end
