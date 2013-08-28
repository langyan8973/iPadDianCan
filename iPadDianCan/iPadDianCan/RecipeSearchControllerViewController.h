//
//  RecipeSearchControllerViewController.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-11.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryTableViewController.h"

@protocol SearchViewDelegate <NSObject>

-(void)changeSearchViewState;

@end

@interface RecipeSearchControllerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate>
@property(nonatomic,assign)NSMutableArray *allCategores;//所有种类
@property(nonatomic,retain)NSMutableArray *allRecipes;
@property(nonatomic,retain)NSMutableArray *allIndexPaths;
@property(nonatomic,retain)UISearchBar *searchBar;
@property(nonatomic,retain)UITableView *searchResultTable;
@property(nonatomic,retain)UIView *shadowView;
@property(nonatomic,retain)UIView *bgView;
@property(nonatomic,retain)UIView *searchView;
@property(nonatomic,assign)id<LocationToCellDelegate> locationToCellDelegate;
@property(nonatomic) NSInteger displayState;

-(void)displaySearchBar;
-(void)openSearchBar;
-(void)closeSearchBar;
-(void)hideSearchBar;
@end
