//
//  SecondViewController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Order.h"

@protocol CheckOrderDelegate <NSObject>

-(void) orderChecked;

@end

@protocol BgClickDelegate <NSObject>

-(void) bgClicked;

@end

@interface OrderListController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    BOOL canClickPop;
}

@property(nonatomic,assign)UITableView *table;
@property(nonatomic,assign)Order *currentOrder;
@property(nonatomic,assign)NSMutableArray *allCategores;
@property(nonatomic,assign)NSMutableArray *orderCategores;//所有已点种类
@property(nonatomic)BOOL isUpdating;
@property(nonatomic)BOOL oPend;
@property(nonatomic,assign)UIButton *submitButton;
@property(nonatomic,assign)UILabel *priceLabel;
@property(nonatomic,assign)UILabel *countLabel;
@property(nonatomic,assign)UIView *bgView;
@property(nonatomic,assign)UIView *orderContainer;
@property(nonatomic,assign)UIButton *checkButton;
@property(nonatomic,assign)UIButton *refreshButton;
@property(nonatomic,assign)UIButton *callButton;
@property(nonatomic,assign)UILabel *deskLabel;

@property(nonatomic,assign) id<CheckOrderDelegate> checkOrderDelegate;
@property(nonatomic,assign) id<BgClickDelegate> bgClickDelegate;
-(void) displayOrderList;
-(void)refreshClick;
-(void)startAnimationChangeOrderState;
@end
