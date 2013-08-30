//
//  FoldingView.h
//  iPadDianCan
//
//  Created by 刘岩 on 13-5-8.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryTableViewController.h"
#import "RecipeSearchControllerViewController.h"
@interface FoldingView : UIView
@property(nonatomic,retain)UITableView *categoriesTable;
@property(nonatomic,retain)CategoryTableViewController *categoryTableViewController;
@property(nonatomic,assign)NSMutableArray *allCategores;//所有种类
@property(nonatomic,assign) UITableView *foodTable;
@property(nonatomic)BOOL oPened;
@property(nonatomic,assign) id<SearchViewDelegate> searchDelegate;
@property(nonatomic,assign)id<LocationToCellDelegate> locationToCellDelegate;
@end
