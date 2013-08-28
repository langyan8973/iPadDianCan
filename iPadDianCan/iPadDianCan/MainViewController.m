//
//  MainViewController.m
//  iPadDianCan
//
//  Created by 李炜 on 13-4-24.
//  Copyright (c) 2013年 ztb. All rights reserved.


#import "MainViewController.h"
#import "AFRestAPIClient.h"
#import "AFHTTPRequestOperation.h"
#import "Category.h"
#import "CategoryCell.h"
#import "RecipeRowCell.h"
#import <QuartzCore/QuartzCore.h>
#import "TextAlertView.h"
#import "Order.h"
#import "MessageView.h"
#import "MyAlertView.h"
#import "RecipeLargeView.h"
#import "LoginView.h"
#import "RecipeTableViewCell.h"
#import "DisplayUtils.h"
@interface MainViewController ()

@end

@implementation MainViewController
@synthesize foodTable;
@synthesize foldingViewController;
@synthesize mainContentView;
@synthesize orderListController;
@synthesize allCategores;
@synthesize rightButton;
@synthesize rid;
@synthesize currentOrder;


-(id)init{
    self=[super init];
    if (self) {
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        titleLabel.backgroundColor=[UIColor clearColor];
        [titleLabel setTextColor:[UIColor whiteColor]];
        titleLabel.shadowColor=[UIColor blackColor];
        titleLabel.shadowOffset=CGSizeMake(0, -0.5);
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
        self.navigationItem.titleView=titleLabel;
        [titleLabel release];
        self.title=[NSString stringWithFormat:@"%@",@"微特"];
        
        
        orderListController=[[OrderListController alloc] init];
        orderListController.checkOrderDelegate=self;
        orderListController.bgClickDelegate = self;
        [orderListController.view setFrame:CGRectMake(0,-960,768,960)];
        
        recipeSearchController = [[RecipeSearchControllerViewController alloc] init];
        [recipeSearchController.view setFrame:CGRectMake(45, 0, 721, 960)];
        recipeSearchController.locationToCellDelegate=self;
        
        foodTable=[[UITableView alloc] initWithFrame:CGRectMake(45, 0, 723, 960)];
        UIImageView *ivtbbg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 702, 960)];
        [ivtbbg setImage:[UIImage imageNamed:@"MainViewBg"]];
        ivtbbg.tag=100;
        [foodTable setBackgroundView:ivtbbg];
        [ivtbbg release];
        allCategores=[[NSMutableArray alloc] init];
        allIndexPaths=[[NSMutableArray alloc] init];
        foodTable.delegate=self;
        foodTable.dataSource=self;
        [DisplayUtils setExtraCellLineHidden:foodTable];
        
        viewController = [[HHFullScreenViewController alloc] init];
        [viewController.view setFrame:CGRectMake(0, 0, 702, 960)];
        viewController.locationToCellDelegate=self;
        viewController.refreshOrderDelegate=self;
        foldingViewController=[[FoldingViewController alloc] initWithFrame:CGRectMake(0, 0, 45, 960)];
        [self addTableShadow];
        foldingViewController.foodTable=self.foodTable;
        foldingViewController.searchDelegate=self;
        foldingViewController.locationToCellDelegate=self;
        
        mainContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
        [mainContentView addSubview:foldingViewController];
        [mainContentView addSubview:foodTable];
        [self.view addSubview:mainContentView];        
        
        rightButton = [BadgeButton buttonWithType:UIButtonTypeCustom];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"navRightBtn"]forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setFrame:CGRectMake(0, 0, 100, 35)];
        [rightButton setTitle:@"开台" forState:UIControlStateNormal];
        rightButton.titleLabel.shadowColor=[UIColor blackColor];
        rightButton.titleLabel.shadowOffset=CGSizeMake(0, -1);
        [rightButton setTag:100];        
        UIBarButtonItem *btnItem =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem=btnItem;
        [btnItem release];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setBackgroundImage:[UIImage imageNamed:@"navRightBtn"]forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [backButton setFrame:CGRectMake(0, 0, 80, 35)];
        [backButton setTitle:@"退出" forState:UIControlStateNormal];
        backButton.titleLabel.shadowColor=[UIColor blackColor];
        backButton.titleLabel.shadowOffset=CGSizeMake(0, -1);
        [backButton setTag:100];
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
        self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
        [temporaryBarButtonItem release];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadge:) name:KBadgeNotification object:nil];
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    UILabel *lable=(UILabel *)self.navigationItem.titleView;
    [lable setText:title];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        return YES;
        
    }
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *ridNum=[ud valueForKey:@"rid"];
    if (ridNum!=nil) {
        self.rid=ridNum.integerValue;
        [self initAllCategoriesAndAllRecipes];
    }
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


////显示登录视图
//-(void)displayLoginView{
//    [mainContentView addSubview:loginView];
//    [loginView setCenter:CGPointMake(loginView.center.x, 480)];
//}


//初始化菜类及所有菜的列表
-(void)initAllCategoriesAndAllRecipes{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *ridNum=[ud valueForKey:@"rid"];
    self.rid = ridNum.integerValue;
    NSString *rname=[ud objectForKey:@"rname"];
    self.title=[NSString stringWithFormat:@"%@-%@",@"微特",rname];
    [self.navigationItem.titleView setFrame:CGRectMake(0, 0, rname.length*24, 40)];
    
    NSString *pathCategory=[NSString stringWithFormat:@"restaurants/%d/categories",self.rid];
    NSString *pathRepice=[NSString stringWithFormat:@"restaurants/%d/recipes",self.rid];
    NSString *udid=[ud objectForKey:@"udid"];
    [[AFRestAPIClient sharedClient] setDefaultHeader:@"X-device" value:udid];
    
    [[AFRestAPIClient sharedClient] getPath:pathCategory parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"返回内容: %@", responseObject);
        NSArray *list = (NSArray*)responseObject;
        for (int i=0; i<list.count;i++) {
            NSDictionary *dn=[list objectAtIndex:i];
            Category *category=[[Category alloc] initWithDictionary:dn];
            [allCategores addObject:category];
            [category release];
        }
        
        
        [[AFRestAPIClient sharedClient] getPath:pathRepice parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *list = (NSArray*)responseObject;
            pageCount=list.count;
            allRecipes=[[NSMutableArray alloc] init];
            for (int i=0; i<list.count;i++) {
                NSDictionary *dn=[list objectAtIndex:i];
                Recipe *recipe=[[Recipe alloc] initWithDictionary:dn];
                for (NSInteger a=0; a<allCategores.count; a++) {
                    Category *category=(Category *)[allCategores objectAtIndex:a];
                    if (recipe.cid==category.cid) {
                        [category.allRecipes addObject:recipe];
                        NSInteger row=(category.allRecipes.count-1)/3;
                        NSIndexPath *indexpath=[NSIndexPath indexPathForItem:row inSection:a];
                        [allIndexPaths addObject:indexpath];
                        [allRecipes addObject:recipe];
                    }
                }
                [recipe release];
            }
            
            orderListController.allCategores=self.allCategores;
            foldingViewController.allCategores=self.allCategores;
            recipeSearchController.allCategores=self.allCategores;
            [foodTable reloadData];
            
            NSNumber *oidNum=[ud valueForKey:@"oid"];
            if (oidNum==0) {
                return;
            }
            
            [Order rid:ridNum.integerValue Oid:oidNum.integerValue Order:^(Order *order) {
                
                [rightButton setTitle:@"我的订单" forState:UIControlStateNormal];
                [rightButton setTag:101];
                [self synchronizeOrder:order];
                
                [self.view insertSubview:orderListController.view atIndex:2];
                [self.view bringSubviewToFront:orderListController.view];
                [orderListController.view bringSubviewToFront:orderListController.table];
                orderListController.isUpdating=NO;
                orderListController.currentOrder=self.currentOrder;
            } failure:^{
                
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            MessageView *mv=[[[MessageView alloc] initWithMessageText:@"无法连接到服务器"] autorelease];
            [mv show];
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MessageView *mv=[[[MessageView alloc] initWithMessageText:@"无法连接到服务器"] autorelease];
        [mv show];
    }];
}


#pragma mark -UITableSouceDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return allCategores.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    Category *category=[allCategores objectAtIndex:section];
    NSInteger count = category.allRecipes.count/3;
    if(category.allRecipes.count%3>0){
        count+=1;
    }
    return count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Category *category=[allCategores objectAtIndex:indexPath.section];
    NSString *SectionsTableIdentifier =[NSString stringWithFormat:@"%@",@"RecipeRowCell"];
    RecipeRowCell *cell=[tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier];
    if(cell==nil){
        cell=[[[RecipeRowCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SectionsTableIdentifier] autorelease];
        cell.imgDelegate=self;
    }
    NSInteger row = indexPath.row;
    NSMutableArray *recipes=[[NSMutableArray alloc] init];
    for(NSInteger i=3*row;i<3*row+3;i++){
        if(i>=category.allRecipes.count){
            break;
        }
        Recipe *recipe=[category.allRecipes objectAtIndex:i];
        [recipes addObject:recipe];
    }
    
    cell.recipes=recipes;
    [recipes release];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 263;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView=[[[UIView alloc] init] autorelease];
    UIImageView* customView = [[UIImageView alloc] init];
    [customView setImage:[UIImage imageNamed:@"CategoryHeadBg"]];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    Category *category=[allCategores objectAtIndex:section];
    headerLabel.text=[NSString stringWithFormat:@"%@(%d)", category.name,category.allRecipes.count];
    [headerLabel sizeToFit];
    CGRect rect=headerLabel.frame;
    rect.origin.x=(702-rect.size.width)/2;
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


//#pragma mark - LoginDelegate
//-(void)closeLoginView{
//    
//    [self initAllCategoriesAndAllRecipes];
//    [UIView animateWithDuration:0.3 animations:^{
//        [loginView setCenter:CGPointMake(loginView.center.x, -482)];
//    } completion:^(BOOL finished) {
//        self.navigationItem.leftBarButtonItem.enabled=YES;
//        self.navigationItem.rightBarButtonItem.enabled=YES;
//        [loginView removeFromSuperview];
//    }];
//}

//退出餐厅
-(void)restaurantLogout:(NSNotification *)notification{
    if (self.rid==0) {
        return;
    }
    else if(self.currentOrder!=nil){
        return;
    }
    
    MyAlertView *myAlert=[[MyAlertView alloc] initWithTitle:@"提示" message:@"退出餐厅吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" ,nil];
    [myAlert setTag:1];
    [myAlert show];
    [myAlert release];
    
}

#pragma mark - 加阴影

- (void)addTableShadow {
//    [foodTable layer].shadowPath =[UIBezierPath bezierPathWithRect:foodTable.bounds].CGPath;
//    [foodTable layer].masksToBounds = NO;
//    [[foodTable layer] setShadowOffset:CGSizeMake(-5.0, 0)];
//    [[foodTable layer] setShadowRadius:5.0];
//    [[foodTable layer] setShadowOpacity:0.5];
//    [[foodTable layer] setShadowColor:[UIColor blackColor].CGColor];
    
//    [orderListController.view layer].shadowPath=[UIBezierPath bezierPathWithRect:orderListController.view.bounds].CGPath;
//    [orderListController.view layer].masksToBounds=NO;
//    [[orderListController.view layer] setShadowOffset:CGSizeMake(-5.0, 0)];
//    [[orderListController.view layer] setShadowRadius:5.0];
//    [[orderListController.view layer] setShadowOpacity:0.5];
//    [[orderListController.view layer] setShadowColor:[UIColor blackColor].CGColor];
}

#pragma mark - 刷新订单

-(void) refreshOrder{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *oidNum=[ud valueForKey:@"oid"];
    NSNumber *ridNum=[ud valueForKey:@"rid"];
    [Order rid:ridNum.integerValue Oid:oidNum.integerValue Order:^(Order *order) {
        if (order.status==3||order.status==4) {
            [self orderChecked];
        }
        else{
            [self synchronizeOrder:order];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
}


-(void)synchronizeOrder:(Order *)order{
    self.currentOrder=order;
    if (viewController.oPened) {
        [self synchronizeLargeView];
    }
    [self refreshFoodTable];
}


//同步大图状态
-(void)synchronizeLargeView{
    AFKPageFlipper *flipper=(AFKPageFlipper *)viewController.toView;
    RecipeLargeView *largeView=(RecipeLargeView *)flipper.currentView;
    Recipe *recipe=largeView.recipe;
    BOOL finded=NO;
    for (OrderItem *oItem in self.currentOrder.orderItems) {
        if (recipe.rid==oItem.recipe.rid) {
            finded=YES;
            recipe.countNew=oItem.countNew;
            recipe.countDeposit=oItem.countDeposit;
            recipe.countConfirm=oItem.countConfirm;
            recipe.countAll=oItem.countAll;
            largeView.hOrder = YES;
            [largeView setRecipeCount:oItem.countAll];
            break;
        }
    }
    
    if (!finded) {
        recipe.countNew=0;
        recipe.countDeposit=0;
        recipe.countConfirm=0;
        recipe.countAll=0;
        largeView.hOrder = YES;
        [largeView setRecipeCount:0];
    }
}

//刷新列表
-(void) refreshFoodTable{
    for (Category *category in self.allCategores) {
        for (Recipe *recipe in category.allRecipes) {
            recipe.countNew=0;
            recipe.countDeposit=0;
            recipe.countConfirm=0;
        }
    }
    
    for (Category *category in self.allCategores) {
        for (Recipe *recipe in category.allRecipes) {
            for (OrderItem *oItem in self.currentOrder.orderItems) {
                if (recipe.rid==oItem.recipe.rid) {
                    recipe.countNew=oItem.countNew;
                    recipe.countDeposit=oItem.countDeposit;
                    recipe.countConfirm=oItem.countConfirm;
                }
            }
        }
    }
    [foodTable reloadData];
}


#pragma mark - 按钮点击
-(void) backButtonClick{
    if (self.rid==0) {
        return;
    }
    else if(self.currentOrder!=nil){
        MessageView *mv=[[[MessageView alloc] initWithMessageText:@"当前有未完成的订单，不能退出餐厅"] autorelease];
        [mv show];
        return;
    }
    
    MyAlertView *myAlert=[[MyAlertView alloc] initWithTitle:@"提示" message:@"退出餐厅吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" ,nil];
    [myAlert setTag:1];
    [myAlert show];
    [myAlert release];
}

- (void) rightButtonClick{
    if (self.rid==0) {
        return;
    }
    if ([rightButton tag]==100) {
        TextAlertView *tat=[[TextAlertView alloc] init];
        [tat setDelegate:self];
        [tat show];
        [tat release];
    }
    else{
        if (!orderListController.oPend) {
            foodTable.scrollEnabled=NO;
            if (viewController!=nil) {
                viewController.isEnabled=NO;
            }
            [self.view bringSubviewToFront:orderListController.view];
            [orderListController.view setCenter:CGPointMake(orderListController.view.center.x, 480)];
            [orderListController startAnimationChangeOrderState];
        }
        else{
            [orderListController startAnimationChangeOrderState];
            foodTable.scrollEnabled=YES;
            if (viewController!=nil) {
                viewController.isEnabled=YES;
            }
            [self refreshOrder];
        }
        
    }
}

#pragma  mark - BgClickDelegate
-(void)bgClicked{
    if (orderListController.oPend) {
        [self rightButtonClick];
    }
}

#pragma mark - ImageClickDelegate
//点击图片查看大图
-(void)onClickRecipeImageFromView:(id)view{
    
    if(viewController.oPened){
        return;
    }
    if (!viewController.isEnabled) {
        return;
    }
    
    RecipeView *recipeView=(RecipeView *)view;
    CGRect frame =[foodTable convertRect:foodTable.frame
                                       fromView:recipeView];
    CGPoint point= foodTable.contentOffset;
    NSInteger currentpage=0;
    for (NSInteger i=0; i<allRecipes.count; i++) {
        Recipe *recipe=(Recipe *)[allRecipes objectAtIndex:i];
        if ([recipe.name isEqual:recipeView.recipe.name]) {
            currentpage=i;
            break;
        }
    }

    AFKPageFlipper *flipper = [[AFKPageFlipper alloc] initWithFrame:self.view.bounds];
    flipper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (self.currentOrder!=nil) {
        flipper.hOrder=YES;
    }
    else{
        flipper.hOrder=NO;
    }
    [flipper setImageDelegate:viewController];
    [flipper setAllRecipes:allRecipes AndCurrentPage:currentpage];
    [viewController setFromView:recipeView toView:flipper withX:frame.origin.x-point.x withY:frame.origin.y-point.y];
    foodTable.scrollEnabled=NO;
    [viewController startFirstAnimation];
    [mainContentView insertSubview:viewController.view atIndex:2];
    [mainContentView bringSubviewToFront:viewController.view];
}


#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        //开台
        if ([alertView isKindOfClass:[TextAlertView class]]) {
            TextAlertView *tav=(TextAlertView *)alertView;
            [Order rid:self.rid Code:tav.code Order:^(Order *order) {
                NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
                NSNumber *numoid=[NSNumber numberWithInteger:order.oid];
                [ud setValue:numoid forKey:@"oid"];
                [ud synchronize];
                [rightButton setTitle:@"我的订单" forState:UIControlStateNormal];
                [rightButton setTag:101];
                [self synchronizeOrder:order];
                
                [self.view insertSubview:orderListController.view atIndex:2];
                [self.view bringSubviewToFront:orderListController.view];
                [orderListController.view bringSubviewToFront:orderListController.table];
                orderListController.currentOrder=self.currentOrder;
            } failure:^{
                MessageView *mv=[[[MessageView alloc] initWithMessageText:@"开台码错误"] autorelease];
                [mv show];
            }];
        }
        //退出餐厅
        if ([alertView isKindOfClass:[MyAlertView class]]) {
            NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
            [ud setValue:0 forKey:@"rid"];
            [ud synchronize];
            
            [self.navigationController popViewControllerAnimated:YES];
            [self release];
        }
        
    }
}


#pragma mark - CheckOrderDelegate
//结账完成
-(void)orderChecked{
    MessageView *mv=[[[MessageView alloc] initWithMessageText:@"该订单已经申请结账"] autorelease];
    [mv show];
    foodTable.scrollEnabled=YES;
    viewController.isEnabled = YES;
    self.currentOrder=nil;
    [orderListController.view removeFromSuperview];
    [rightButton setTag:100];
    [rightButton setTitle:@"开台" forState:UIControlStateNormal];
    rightButton.badgeValue=0;
    for (Category *category in self.allCategores) {
        for (Recipe *recipe in category.allRecipes) {
            recipe.countNew=0;
            recipe.countDeposit=0;
            recipe.countConfirm=0;
        }
    }
    [foodTable reloadData];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setValue:0 forKey:@"oid"];
    [ud synchronize];
}

#pragma mark - SearchViewDelegate
//显示隐藏搜索框
-(void)changeSearchViewState{
    if (recipeSearchController.displayState==0) {
        [mainContentView addSubview:recipeSearchController.view];
        [mainContentView bringSubviewToFront:recipeSearchController.view];
        [recipeSearchController displaySearchBar];
    }
    else{
        [recipeSearchController hideSearchBar];
    }
}

#pragma mark -LocationToCellDelegate
//根据indexpath定位
-(void)locationToCell:(NSIndexPath *)indexPath{
    if (recipeSearchController.displayState==1) {
        [recipeSearchController hideSearchBar];
    }
    [foodTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}

//根据recipe刷新指定的行
-(void)refreshCellByRecipe:(Recipe *)recipe{
    [foodTable reloadData];
}

//根据recipe定位
-(void)locationByRecipe:(Recipe *)recipe{
    NSInteger currentpage=0;
    for (NSInteger i=0; i<allRecipes.count; i++) {
        Recipe *r=(Recipe *)[allRecipes objectAtIndex:i];
        if ([r.name isEqual:recipe.name]) {
            currentpage=i;
            break;
        }
    }
    
    NSIndexPath *path=(NSIndexPath *)[allIndexPaths objectAtIndex:currentpage];
    [foodTable selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionTop];
    foodTable.scrollEnabled=YES;
    RecipeRowCell *reciperow=(RecipeRowCell*)[foodTable cellForRowAtIndexPath:path];    
    RecipeView *recipeview=[reciperow getRecipeViewByRecipe:recipe];
    CGRect frame =[foodTable convertRect:foodTable.frame
                                fromView:recipeview];
    CGPoint point= foodTable.contentOffset;
    [viewController resetFromView:recipeview withX:frame.origin.x-point.x withY:frame.origin.y-point.y ];
}

-(void)hideSearchBar{
    
}

#pragma mark - RefreshOrderDelegate
//大图收回后刷新列表
-(void)refreshFoodTableByOrder{
    if (currentOrder) {
        [self refreshOrder];
    }
}


-(void)updateBadge:(NSNotification *)notification{
    NSNumber *num=(NSNumber *)notification.object;
    self.rightButton.badgeValue=num.integerValue;
}

-(void)dealloc{
    [mainContentView release];
    [foldingViewController release];
    [foodTable release];
    [allCategores release];
    [allIndexPaths release];
    [recipeSearchController release];
    [allRecipes release];
    [viewController release];
    [orderListController release];
    [super dealloc];
}
@end