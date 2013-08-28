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
@property(nonatomic,assign)UISearchBar *searchBar;
@property(nonatomic,assign)UITableView *searchResultTable;
@property(nonatomic,assign)UIView *shadowView;
@property(nonatomic,assign)UIView *bgView;
@property(nonatomic,assign)UIView *searchView;
@property(nonatomic,assign)id<LocationToCellDelegate> locationToCellDelegate;
@property(nonatomic) NSInteger displayState;

-(void)displaySearchBar;
-(void)openSearchBar;
-(void)closeSearchBar;
-(void)hideSearchBar;
@end
