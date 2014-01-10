//
//  CategoryTableViewController.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-3-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "Category.h"
#import "RecipeCategoryCell.h"
@interface CategoryTableViewController ()

@end

@implementation CategoryTableViewController
@synthesize allCategores,categoreTableView=_categoreTableView,locationToCellDelegate;
- (id)initWithNibName:(NSString *)nibNameOrnil bundle:(NSBundle *)nibBundleOrnil{
    self = [super initWithNibName:nibNameOrnil bundle:nibBundleOrnil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init{
    self=[super init];
    if (self) {
    }
    return self;

}


- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (allCategores.count>0) {
        return 1;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    return allCategores.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Category *category=[allCategores objectAtIndex:indexPath.row];
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    RecipeCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SectionsTableIdentifier];
    if (cell == nil) {
        cell = [[[RecipeCategoryCell alloc]
				 initWithStyle:UITableViewCellStyleValue1
				 reuseIdentifier:SectionsTableIdentifier] autorelease];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"categoryCell"]];
        cell.backgroundView = bgImageView;
        [bgImageView release];
        UIImageView *selectBgImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"categorySelectCell"]];
        cell.selectedBackgroundView=selectBgImageView;
        [selectBgImageView release];

    }
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    cell.textLabel.shadowColor=[UIColor blackColor];
    cell.textLabel.shadowOffset=CGSizeMake(0, -1);
    
    NSInteger length=category.name.length;
    cell.textLabel.numberOfLines=length;
    [cell.textLabel setText:category.name];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Category *category=[allCategores objectAtIndex:indexPath.row];
    NSInteger length=category.name.length;    
    return 50*length;
}

- (void) unselectCurrentRow{
    // Animate the deselection
    [self.categoreTableView deselectRowAtIndexPath:
     [self.categoreTableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath{
    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:newIndexPath.row];
    [locationToCellDelegate locationToCell:(NSIndexPath *)index];

    [self performSelector:@selector(unselectCurrentRow)
               withObject:nil afterDelay:1.0];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [locationToCellDelegate hideSearchBar];
}
-(void)dealloc{
    [allCategores release];
    [super dealloc];
}
@end
