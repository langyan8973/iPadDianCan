//
//  RecipeSearchControllerViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-11.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "RecipeSearchControllerViewController.h"
#import "Category.h"
#import <QuartzCore/QuartzCore.h>
@interface RecipeSearchControllerViewController ()

@end

@implementation RecipeSearchControllerViewController
@synthesize searchBar=_searchBar,searchResultTable,allCategores,locationToCellDelegate,allIndexPaths,allRecipes,shadowView,bgView,displayState,searchView;
-(id)init{
    self=[super init];
    if (self) {
        bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 725, 960)];
        [bgView setBackgroundColor:[UIColor blackColor]];
        [bgView setAlpha:0];
        bgView.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickbgView:)];
        [bgView addGestureRecognizer:singleTouch];
        [singleTouch release];
        [self.view addSubview:bgView];
        
        searchView=[[UIView alloc] initWithFrame:CGRectMake(-350, 10, 300, 40)];
        UIImageView *searchbg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchBarBg"]];
        [searchView addSubview:searchbg];
        [searchbg release];
        
        _searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(40, 0, 250, 40)];
        _searchBar.placeholder=@"输入菜名或简拼";
        [[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
        _searchBar.delegate=self;
        [searchView addSubview:_searchBar];
        displayState=0;
        [self.view addSubview:searchView];
        
        searchResultTable=[[UITableView alloc] init];
        searchResultTable.clipsToBounds=YES;
        searchResultTable.separatorStyle=UITableViewCellSeparatorStyleNone;
        searchResultTable.backgroundColor=[UIColor clearColor]; //colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.6];
        searchResultTable.dataSource=self;
        searchResultTable.delegate=self;
        shadowView =[[UIView alloc] init];
        [shadowView layer].masksToBounds = NO;
        [[shadowView layer] setShadowOffset:CGSizeMake(-5, 5)];
        [[shadowView layer] setShadowRadius:5.0];
        [[shadowView layer] setShadowOpacity:0.6];
        [[shadowView layer] setShadowColor:[UIColor blackColor].CGColor];
        shadowView.backgroundColor=[UIColor clearColor];//colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
        
        [shadowView addSubview:searchResultTable];
        [self.view addSubview:shadowView];
        allRecipes =[[NSMutableArray alloc] init];
        allIndexPaths=[[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UISearchDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [allRecipes removeAllObjects];
    [allIndexPaths removeAllObjects];
    
    for (NSInteger section=0;section<allCategores.count;section++) {
        Category *category =[allCategores objectAtIndex:section];
        for (NSInteger i=0;i<category.allRecipes.count;i++) {
            Recipe *recipe =[category.allRecipes objectAtIndex:i];
            NSRange textRangeName,textRangePinyin;
            textRangeName =[recipe.name rangeOfString:searchText];
            NSString *pinyin=searchText.lowercaseString;
            textRangePinyin=[recipe.pinyin rangeOfString:pinyin];
            if(textRangeName.location != NSNotFound||textRangePinyin.location!=NSNotFound)
            {
                NSInteger row=i/3;
                NSIndexPath *indexPath=[NSIndexPath indexPathForItem:row inSection:section];
                [allIndexPaths addObject:indexPath];
                [allRecipes addObject:recipe];
            }
        }
    }
    [self.searchResultTable reloadData];
    NSInteger height=allRecipes.count;
    if (height>14) {
        height=14;
    }
    double duration=0.2;
    if (searchText.length==0||allRecipes.count==0) {
        duration=0;
    }
    [self.searchResultTable setFrame:CGRectMake(0, 0, self.searchBar.frame.size.width-15,0)];
    [self.shadowView setFrame:CGRectMake(46, 51, self.searchBar.frame.size.width-15,0)];
    [UIView animateWithDuration:duration animations:^{
        [self.shadowView setFrame:CGRectMake(46, 51, self.searchBar.frame.size.width-15,height*45)];
        [self.searchResultTable setFrame:CGRectMake(0, 0, self.searchBar.frame.size.width-15,height*45)];
        [shadowView layer].shadowPath =[UIBezierPath bezierPathWithRect:shadowView.bounds].CGPath;
        } completion:^(BOOL finished) {
            
        }];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    NSInteger height=allRecipes.count;
    if (height>14) {
        height=14;
    }
    double duration=0.3;
    if (searchBar.text.length==0||allRecipes.count==0) {
        duration=0;
    }
    [UIView animateWithDuration:duration animations:^{        
        [self.shadowView setFrame:CGRectMake(46, 51, self.searchBar.frame.size.width-15,height*45)];
        [self.searchResultTable setFrame:CGRectMake(0, 0, self.searchBar.frame.size.width-15,height*45)];
        [shadowView layer].shadowPath =[UIBezierPath bezierPathWithRect:shadowView.bounds].CGPath;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSInteger height=allRecipes.count;
    if (height>14) {
        height=14;
    }
    double duration=0.2;
    if (searchBar.text.length==0||allRecipes.count==0) {
        duration=0;
    }
    shadowView.layer.shadowPath=nil;
    [UIView animateWithDuration:duration animations:^{
        [self.searchResultTable setFrame:CGRectMake(0,0, self.searchBar.frame.size.width-15,height*45)];
        [self.shadowView setFrame:CGRectMake(46, 51, self.searchBar.frame.size.width-15,height*45)];
        [shadowView layer].shadowPath =[UIBezierPath bezierPathWithRect:CGRectMake(46, 51, shadowView.frame.size.width, shadowView.frame.size.height)].CGPath;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (allRecipes.count>0) {
        return 1;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allRecipes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Recipe *recipe=[allRecipes objectAtIndex:indexPath.row];
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SectionsTableIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleValue1
				 reuseIdentifier:SectionsTableIdentifier] autorelease];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchResultCellBg"]];
        cell.backgroundView = bgImageView;
        [bgImageView release];
        UIImageView *selectBgImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"categoryTablecellSelectBg"]];
        cell.selectedBackgroundView=selectBgImageView;
        [selectBgImageView release];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.textLabel.backgroundColor=[UIColor clearColor];
        cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
        cell.detailTextLabel.textColor=[UIColor whiteColor];
        cell.detailTextLabel.backgroundColor=[UIColor clearColor];
        cell.detailTextLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
    }
    [cell.textLabel setText:recipe.name];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%.1f",recipe.price];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}



- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath{
    [self.searchBar resignFirstResponder];
    NSIndexPath *index=[allIndexPaths objectAtIndex:newIndexPath.row];
    [locationToCellDelegate locationToCell:(NSIndexPath *)index];
    
    [self performSelector:@selector(unselectCurrentRow)
               withObject:nil afterDelay:1.0];
    
}

- (void) unselectCurrentRow{
    // Animate the deselection
    [self.searchResultTable deselectRowAtIndexPath:
     [self.searchResultTable indexPathForSelectedRow] animated:YES];
}

#pragma mark -控制搜索框的显示状态

-(void)displaySearchBar{
    [UIView animateWithDuration:0.3 animations:^{
        [searchView setCenter:CGPointMake(150, searchView.center.y)];
        [bgView setAlpha:0.6];
    } completion:^(BOOL finished) {
        [_searchBar becomeFirstResponder];
        displayState=1;
        NSInteger height=allRecipes.count;
        if (height>0) {
            if (height>14) {
                height=14;
            }
            [UIView animateWithDuration:0.3 animations:^{
                [self.searchResultTable setFrame:CGRectMake(0,0, self.searchBar.frame.size.width-15,height*45)];
                [self.shadowView setFrame:CGRectMake(46, 51, self.searchBar.frame.size.width-15,height*45)];
                [shadowView layer].shadowPath =[UIBezierPath bezierPathWithRect:CGRectMake(46, 51, shadowView.frame.size.width, shadowView.frame.size.height)].CGPath;
            } completion:^(BOOL finished) {
                
            }];
        }
    }];
}
-(void)openSearchBar{
    displayState=1;
}
-(void)closeSearchBar{
    [self hideSearchBar];
}
-(void)hideSearchBar{
    NSInteger height=allRecipes.count;
    shadowView.layer.shadowPath=nil;
    [_searchBar resignFirstResponder];
    if (height>0) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.searchResultTable setFrame:CGRectMake(0,0, self.searchBar.frame.size.width-15,0)];
            [self.shadowView setFrame:CGRectMake(46, 51, self.searchBar.frame.size.width-15,0)];
            [shadowView layer].shadowPath =[UIBezierPath bezierPathWithRect:CGRectMake(46, 51, shadowView.frame.size.width, shadowView.frame.size.height)].CGPath;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                [searchView setCenter:CGPointMake(-200, searchView.center.y)];
                [bgView setAlpha:0.0];
            } completion:^(BOOL finished) {
                displayState=0;
                [self.view removeFromSuperview];
            }];
        }];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            [searchView setCenter:CGPointMake(-200, searchView.center.y)];
            [bgView setAlpha:0.0];
        } completion:^(BOOL finished) {
            displayState=0;
            [self.view removeFromSuperview];
        }];
    }
    
}

//点击空白背景
-(void)clickbgView:(id)sender{
    [self closeSearchBar];
}

-(void)dealloc{
    [super dealloc];
}
@end
