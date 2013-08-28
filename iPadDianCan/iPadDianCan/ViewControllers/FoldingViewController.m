//
//  FoldingViewController.m
//  iPadDianCan
//
//  Created by 刘岩 on 13-5-8.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FoldingViewController.h"
#import "DisplayUtils.h"

@implementation FoldingViewController

@synthesize categoriesTable,categoryTableViewController,allCategores=_allCategores,foodTable,oPened,searchDelegate,locationToCellDelegate=_locationToCellDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        oPened = NO;
        
        UIImageView *cTableBg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 960)];
        [cTableBg setImage:[UIImage imageNamed:@"leftBarBg"]];
        //为背景图添加触摸监听，为了隐藏键盘
        cTableBg.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
        [cTableBg addGestureRecognizer:singleTouch];
        [singleTouch release];
        [self addSubview:cTableBg];
        [cTableBg release];
        
        UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setFrame:CGRectMake(5, 15, 35, 35)];
        [searchBtn setBackgroundImage:[UIImage imageNamed:@"searchButton"] forState:UIControlStateNormal];
        [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:searchBtn];
        
        categoryTableViewController=[[CategoryTableViewController alloc] init];
        categoriesTable=[[UITableView alloc] initWithFrame:CGRectMake(5, 60, 35, 902)];
        categoriesTable.delegate=categoryTableViewController;
        categoriesTable.dataSource=categoryTableViewController;
        categoriesTable.backgroundColor=[UIColor clearColor];
        [DisplayUtils setExtraCellLineHidden:categoriesTable];

        [self addSubview:categoriesTable];
    }
    return self;
}


-(void)setAllCategores:(NSMutableArray *)allCategores{
    _allCategores=allCategores;
    categoryTableViewController.allCategores = _allCategores;
    categoryTableViewController.categoreTableView = categoriesTable;
    
    [categoriesTable reloadData];
}

-(void)setLocationToCellDelegate:(id<LocationToCellDelegate>)locationToCellDelegate{
    categoryTableViewController.locationToCellDelegate=locationToCellDelegate;
}

-(void)dismissKeyboard:(id)sender{
//    [self hideSearchBar];
}


#pragma mark -点击按钮
-(void)searchBtnClick{
    [searchDelegate changeSearchViewState];
}


#pragma mark - 释放内存

-(void)dealloc{
    [categoryTableViewController release];
    [categoriesTable release];
    [super dealloc];
}
@end
