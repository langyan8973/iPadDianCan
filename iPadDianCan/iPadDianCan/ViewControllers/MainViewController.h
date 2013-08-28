//
//  MainViewController.h
//  iPadDianCan
//
//  Created by 李炜 on 13-4-24.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryTableViewController.h"
#import "RecipeSearchControllerViewController.h"
#import "Order.h"
#import "OrderListController.h"
#import "RecipeView.h"
#import "HHFullScreenViewController.h"
#import "FoldingViewController.h"
#import "BadgeButton.h"
#import "LoginView.h"
#import "AFKPageFlipper.h"

@interface MainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,ImageClickDelegate,UIGestureRecognizerDelegate,CheckOrderDelegate,SearchViewDelegate,LocationToCellDelegate,RefreshOrderDelegate,BgClickDelegate>{
    NSInteger pageCount;
    HHFullScreenViewController *viewController;
    NSMutableArray *allIndexPaths;
    NSMutableArray *allRecipes;
}
@property(nonatomic,retain)RecipeSearchControllerViewController *recipeSearchController;
@property(nonatomic,retain)UITableView *foodTable;
@property(nonatomic,retain)FoldingViewController *foldingViewController;
@property(nonatomic,retain)UIView *mainContentView;
@property(nonatomic,retain)NSMutableArray *allCategores;//所有种类
@property(nonatomic,assign) BadgeButton *rightButton;
@property NSInteger rid;
@property(nonatomic,retain)OrderListController *orderListController;
@property(nonatomic,retain)Order *currentOrder;


- (void)synchronizeOrder:(Order *)order ;
@end
