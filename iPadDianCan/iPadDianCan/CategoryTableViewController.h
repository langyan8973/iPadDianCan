//
//  CategoryTableViewController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//
#import <UIKit/UIKit.h>
@class Recipe;

@protocol LocationToCellDelegate <NSObject>
-(void)locationToCell:(NSIndexPath *)indexPath;
-(void)hideSearchBar;
-(void)refreshCellByRecipe:(Recipe *)recipe;
-(void)locationByRecipe:(Recipe *)recipe;
@end

@interface CategoryTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property(nonatomic,retain)NSMutableArray *allCategores;//所有种类
@property(nonatomic,assign)UITableView *categoreTableView;//菜类列表
@property(nonatomic,assign)id<LocationToCellDelegate> locationToCellDelegate;

@end 

