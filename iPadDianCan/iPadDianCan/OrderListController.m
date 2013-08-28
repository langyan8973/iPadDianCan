//
//  SecondViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "OrderListController.h"
#import "AFRestAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "Category.h"
#import "OrderItem.h"
#import "Category.h"
#import "AppDelegate.h"
#import "Recipe.h"
#import <QuartzCore/QuartzCore.h>
#import "MessageView.h"
#import "RecipeTableViewCell.h"
#import "MyAlertView.h"
#import "DisplayUtils.h"
@implementation OrderListController
@synthesize table,currentOrder=_currentOrder,allCategores,isUpdating,priceLabel,submitButton,orderCategores,checkOrderDelegate,bgClickDelegate,oPend,countLabel,bgView,orderContainer,checkButton,refreshButton,callButton,deskLabel;

-(id)init{
    self=[super init];
    if (self) {
        isUpdating=NO;
        oPend = NO;
        canClickPop = YES;
        
        bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
        [bgView setBackgroundColor:[UIColor blackColor]];
        [bgView setAlpha:0];
        bgView.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickbgView:)];
        [bgView addGestureRecognizer:singleTouch];
        [singleTouch release];
        [self.view addSubview:bgView];
        
        orderContainer=[[UIView alloc] initWithFrame:CGRectMake(448, -740, 320, 740)];
        [self.view addSubview:orderContainer];
        
        UIImageView *ivtbbg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 740)];
        [ivtbbg setImage:[UIImage imageNamed:@"orderBg"]];
        [orderContainer addSubview:ivtbbg];
        [ivtbbg release];
        
        table=[[UITableView alloc] initWithFrame:CGRectMake(1, 99, 318, 547)];
        table.delegate=self;
        table.dataSource=self;
        [DisplayUtils setExtraCellLineHidden:table];
        
        UIView *buttonbg=[[UIView alloc] initWithFrame:CGRectMake(1, 646, 318, 55)];
        [orderContainer addSubview:buttonbg];
        [buttonbg release];
        
        submitButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [submitButton setBackgroundImage:[UIImage imageNamed:@"orderBtnBg"] forState:UIControlStateNormal];
        [submitButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [submitButton setTitleColor:[UIColor colorWithRed:1 green:102/255.0 blue:0 alpha:1] forState:UIControlStateNormal];
        [submitButton setFrame:CGRectMake(50, 2.5, 50, 50)];
        [submitButton setTitle:@"下单" forState:UIControlStateNormal];
        [submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
        [buttonbg addSubview:submitButton];
        
        checkButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [checkButton setFrame:CGRectMake(105, 2.5, 50, 50)];
        [checkButton setBackgroundImage:[UIImage imageNamed:@"orderBtnBg"] forState:UIControlStateNormal];
        [checkButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [checkButton setTitleColor:[UIColor colorWithRed:1 green:102/255.0 blue:0 alpha:1] forState:UIControlStateNormal];
        [checkButton setTitle:@"结账" forState:UIControlStateNormal];
        [checkButton addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
        [buttonbg addSubview:checkButton];
        
        refreshButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [refreshButton setFrame:CGRectMake(160, 2.5, 50, 50)];
        [refreshButton setBackgroundImage:[UIImage imageNamed:@"orderBtnBg"] forState:UIControlStateNormal];
        [refreshButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [refreshButton setTitleColor:[UIColor colorWithRed:1 green:102/255.0 blue:0 alpha:1] forState:UIControlStateNormal];
        [refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
        [refreshButton addTarget:self action:@selector(refreshClick) forControlEvents:UIControlEventTouchUpInside];
        [buttonbg addSubview:refreshButton];
        
        callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [callButton setFrame:CGRectMake(215, 2.5, 50, 50)];
        [callButton setBackgroundImage:[UIImage imageNamed:@"orderBtnBg"] forState:UIControlStateNormal];
        [callButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [callButton setTitleColor:[UIColor colorWithRed:1 green:102/255.0 blue:0 alpha:1] forState:UIControlStateNormal];
        [callButton setTitle:@"呼叫" forState:UIControlStateNormal];
        [callButton addTarget:self action:@selector(callWaiterClick) forControlEvents:UIControlEventTouchUpInside];
        [buttonbg addSubview:callButton];
        
        UIView *otbg=[[UIView alloc] initWithFrame:CGRectMake(1, 0, 318, 95)];
        [orderContainer addSubview:otbg];
        [otbg release];
        
        deskLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        [deskLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        deskLabel.textColor=[UIColor whiteColor];
        deskLabel.shadowColor=[UIColor blackColor];
        deskLabel.shadowOffset=CGSizeMake(0, -1);
        [deskLabel setBackgroundColor:[UIColor clearColor]];
        [otbg addSubview:deskLabel];
        countLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        [countLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        countLabel.textColor=[UIColor whiteColor];
        countLabel.shadowColor=[UIColor blackColor];
        countLabel.shadowOffset=CGSizeMake(0, -1);
        [countLabel setBackgroundColor:[UIColor clearColor]];
        [otbg addSubview:countLabel];
        priceLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        [priceLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        priceLabel.textColor=[UIColor whiteColor];
        priceLabel.shadowColor=[UIColor blackColor];
        priceLabel.shadowOffset=CGSizeMake(0, -1);
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [otbg addSubview:priceLabel];
        
        [orderContainer addSubview:table];
        
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - 设置订单

-(void)setCurrentOrder:(Order *)currentOrder{
    _currentOrder=currentOrder;
    if (orderCategores==nil) {
        orderCategores=[[NSMutableArray alloc] init];
    }
    else{
        [orderCategores removeAllObjects];
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for(Category *category in allCategores){
        Category *ca=[[Category alloc] init];
        [ca setCid:category.cid];
        [ca setName:category.name];
        NSMutableArray *allrecipes=[[NSMutableArray alloc] init];
        [ca setAllRecipes:allrecipes];
        [allrecipes release];
        
        for(Recipe *recipe in category.allRecipes){
            if([recipe countAll]>0){
                [ca.allRecipes addObject:recipe];
            }
        }
        
        [tempArray addObject:ca];
        [ca release];
    }
    
    for(Category *category in tempArray){
        if (category.allRecipes.count>0) {
            [orderCategores addObject:category];
        }
    }
    [tempArray release];
    isUpdating = YES;
    [self displayOrderList];
}

-(void) refreshAllCategoriesByOrder:(Order *)order{
    for (Category *category in self.allCategores) {
        for (Recipe *recipe in category.allRecipes) {
            recipe.countNew=0;
            recipe.countDeposit=0;
            recipe.countConfirm=0;
        }
    }
    
    for (Category *category in self.allCategores) {
        for (Recipe *recipe in category.allRecipes) {
            for (OrderItem *oItem in order.orderItems) {
                if (recipe.rid==oItem.recipe.rid) {
                    recipe.countNew=oItem.countNew;
                    recipe.countDeposit=oItem.countDeposit;
                    recipe.countConfirm=oItem.countConfirm;
                }
            }
        }
    }
}

-(void) displayOrderList{
    [deskLabel setText:[NSString stringWithFormat:@"%@",self.currentOrder.desk.name]];
    [deskLabel sizeToFit];
    CGRect rRect=deskLabel.frame;
    NSInteger px=(320-rRect.size.width)/2;
    rRect.origin.x = px;
    rRect.origin.y = 17;
    deskLabel.frame = rRect;
    
    [priceLabel setText:[NSString stringWithFormat:@"消费金额：%.2f",self.currentOrder.priceAll]];
    [priceLabel sizeToFit];
    CGRect pRect=priceLabel.frame;
    NSInteger px1=(320-pRect.size.width)/2;
    pRect.origin.x = px1;
    pRect.origin.y = 52;
    priceLabel.frame = pRect;
    
    NSInteger newCount=0;
    for (OrderItem *oItem in self.currentOrder.orderItems) {
        newCount+=oItem.countNew;
    }
    
    if (newCount>0) {
        [countLabel setText:[NSString stringWithFormat:@"%d例未下单",newCount]];
        [submitButton setEnabled:YES];
    }
    else{
        [countLabel setText:[NSString stringWithFormat:@""]];
        [submitButton setEnabled:NO];
    }
    
    [countLabel sizeToFit];
    CGRect cRect=countLabel.frame;
    NSInteger cx=(320-cRect.size.width)/2;
    cRect.origin.x = cx;
    cRect.origin.y = 72;
    countLabel.frame = cRect;
    
    
    [table reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!isUpdating) {
        return 0;
    }
    NSLog(@"secion=%d",orderCategores.count);
    return orderCategores.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    Category *category=[orderCategores objectAtIndex:section];
    NSLog(@"row=%d",category.allRecipes.count);
    return category.allRecipes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Category *category=[orderCategores objectAtIndex:indexPath.section];
    Recipe *recipe=[category.allRecipes objectAtIndex:indexPath.row];
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 SectionsTableIdentifier];
    if (cell == nil) {
        cell = [[[RecipeTableViewCell alloc]
				 initWithStyle:UITableViewCellStyleSubtitle
				 reuseIdentifier:SectionsTableIdentifier] autorelease];

    }
    cell.indexPath =indexPath;
    cell.isAllowRemoveCell=YES;
    cell.recipe=recipe;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView=[[[UIView alloc] init] autorelease];
    UIImageView* customView = [[UIImageView alloc] init];
    [customView setImage:[UIImage imageNamed:@"CategoryHeadBg"]];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    Category *category=[orderCategores objectAtIndex:section];
    NSInteger recipeCount=0;
    for (Recipe *aRecipe in category.allRecipes) {
        recipeCount=recipeCount+aRecipe.countAll;
    }
    headerLabel.text=[NSString stringWithFormat:@"%@(%d份)",category.name,recipeCount];
    [headerLabel sizeToFit];
    CGRect rect=headerLabel.frame;
    rect.origin.x=(320.0f-rect.size.width)/2;
    rect.size.width+=10;
    headerLabel.frame=rect;
    rect.origin.x-=5;
    [customView setFrame:rect];
    [headerView addSubview:customView];
    [headerView addSubview:headerLabel];
    [customView release];
    [headerLabel release];
    return headerView;
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startAnimationChangeOrderState{
    if (!self.oPend) {
        [UIView animateWithDuration:0.3 animations:^{
            [orderContainer setCenter:CGPointMake(orderContainer.center.x, 370)];
            [bgView setAlpha:0.6];
        } completion:^(BOOL finished) {
            self.oPend = YES;
            self.isUpdating=YES;
            canClickPop = YES;
            [self refreshClick];
        }];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            [orderContainer setCenter:CGPointMake(orderContainer.center.x, -370)];
            [bgView setAlpha:0];
        } completion:^(BOOL finished) {
            [self.view setCenter:CGPointMake(self.view.center.x, -480)];
            self.oPend = NO;
            canClickPop = YES;
        }];
    }
}

//点击空白背景
-(void)clickbgView:(id)sender{
    [bgClickDelegate bgClicked];
}

#pragma mark - 按钮点击
-(void) submitClick{
    if (!canClickPop) {
        return;
    }
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *oidNum=[ud valueForKey:@"oid"];
    NSNumber *ridNum=[ud valueForKey:@"rid"];
    canClickPop = NO;
    [Order rid:ridNum.integerValue Oid:oidNum.integerValue Order:^(Order *order) {
        if (order.status==3||order.status==4) {
             canClickPop = YES;
            [self.view setCenter:CGPointMake(self.view.center.x, -480)];
            self.oPend = NO;
            [checkOrderDelegate orderChecked];
        }
        else{
            NSString *message=@"";
            for (OrderItem *oItem in order.orderItems) {
                if (oItem.countNew>0) {
                    message=[NSString stringWithFormat:@"%@%@ ---%d份\n",message,oItem.recipe.name,oItem.countNew];
                }
            }
            MyAlertView *myAlert=[[MyAlertView alloc] initWithTitle:@"下单确认" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下单" ,nil];
            [myAlert setTag:1];
            [myAlert show];
            [myAlert release];
        }
        
    } failure:^{
        canClickPop = YES;
    }];
}

-(void) checkClick{
    if (!canClickPop) {
        return;
    }
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *oidNum=[ud valueForKey:@"oid"];
    NSNumber *ridNum=[ud valueForKey:@"rid"];
    canClickPop = NO;
    [Order rid:ridNum.integerValue Oid:oidNum.integerValue Order:^(Order *order) {
        if (order.status==3||order.status==4) {
            canClickPop = YES;
            [self.view setCenter:CGPointMake(self.view.center.x, -480)];
            self.oPend = NO;
            [checkOrderDelegate orderChecked];
        }
        else{
            NSString *message=[NSString stringWithFormat:@"您总共消费￥%.2f",order.priceDeposit];
            MyAlertView *myAlert=[[MyAlertView alloc] initWithTitle:@"结账确认" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"结账" ,nil];
            [myAlert setTag:2];
            [myAlert show];
            [myAlert release];
        }
        
    } failure:^{
        canClickPop = YES;
    }];
}

-(void)refreshClick{
    if (!canClickPop) {
        return;
    }
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *oidNum=[ud valueForKey:@"oid"];
    NSNumber *ridNum=[ud valueForKey:@"rid"];
    canClickPop = NO;
    [Order rid:ridNum.integerValue Oid:oidNum.integerValue Order:^(Order *order) {
        if (order.status==3||order.status==4) {
            [self.view setCenter:CGPointMake(self.view.center.x, -480)];
            self.oPend = NO;
            [checkOrderDelegate orderChecked];
        }
        else{
            [self refreshAllCategoriesByOrder:order];
            self.currentOrder=order;
            canClickPop = YES;
        }
       
    } failure:^{
        canClickPop = YES;
    }];
    [table reloadData];
}


-(void)callWaiterClick{
    if (!canClickPop) {
        return;
    }
    MyAlertView *myAlert=[[MyAlertView alloc] initWithTitle:@"提示" message:@"您是要呼叫服务员吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫" ,nil];
    [myAlert setTag:3];
    [myAlert show];
    canClickPop = NO;
    [myAlert release];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    canClickPop = YES;
    if (buttonIndex==1) {
        //下单确定
        if (alertView.tag==1) {
            NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
            NSNumber *oidNum=[ud valueForKey:@"oid"];
            NSNumber *ridNum=[ud valueForKey:@"rid"];
            canClickPop = NO;
            [Order OrderWithRid:ridNum.integerValue Oid:oidNum.integerValue Order:^(Order *order) {
                [self refreshAllCategoriesByOrder:order];
                self.currentOrder=order;
                canClickPop = YES;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                canClickPop = YES;
                if (operation.response.statusCode==400) {
                    [self.view setCenter:CGPointMake(self.view.center.x, -480)];
                    self.oPend = NO;
                    [checkOrderDelegate orderChecked];
                }
                else{
                    MessageView *mv=[[[MessageView alloc] initWithMessageText:@"下单失败"] autorelease];
                    [mv show];
                }
            }];
        }
        //结账确定
        if (alertView.tag==2) {
            NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
            NSNumber *oidNum=[ud valueForKey:@"oid"];
            NSNumber *ridNum=[ud valueForKey:@"rid"];
            [Order CheckOrderWithRid:ridNum.integerValue Oid:oidNum.integerValue Order:^(Order *order) {
                canClickPop = YES;
                [UIView animateWithDuration:0.3 animations:^{
                    [orderContainer setCenter:CGPointMake(orderContainer.center.x, -370)];
                    [bgView setAlpha:0];
                } completion:^(BOOL finished) {
                    [self.view setCenter:CGPointMake(self.view.center.x, -480)];
                    self.oPend = NO;
                    [checkOrderDelegate orderChecked];
                }];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                canClickPop = YES;
                if (operation.response.statusCode==400) {
                    [self.view setCenter:CGPointMake(self.view.center.x, -480)];
                    self.oPend = NO;
                    [checkOrderDelegate orderChecked];
                }
                else{
                    MessageView *mv=[[[MessageView alloc] initWithMessageText:@"请求结账失败"] autorelease];
                    [mv show];
                }
                
            }];
            
        }
        //呼叫服务员确定
        if (alertView.tag==3) {
            [self callWaiter];
        }
    }
}

//呼叫服务员
-(void)callWaiter{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *oidNum=[ud valueForKey:@"oid"];
    NSNumber *ridNum=[ud valueForKey:@"rid"];
    
    NSString *path=[NSString stringWithFormat:@"restaurants/%d/orders/%d/assistent",ridNum.integerValue,oidNum.integerValue];
    [[AFRestAPIClient sharedClient] postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callButton.enabled=NO;
        [self performSelector:@selector(setWaiterBtnState) withObject:nil afterDelay:10];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误: %@", error);
    }];
}


//设置呼叫服务员按钮状态
-(void)setWaiterBtnState{
    callButton.enabled=YES;
}

#pragma mark -释放内存
-(void)dealloc{
    [orderCategores release];
    [priceLabel release];
    [countLabel release];
    [deskLabel release];
    [bgView release];
    [orderContainer release];
    [table release];
    [super dealloc];
}
@end
