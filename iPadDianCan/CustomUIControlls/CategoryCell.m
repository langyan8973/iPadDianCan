//
//  CategoryCell.m
//  iPadDianCan
//
//  Created by 李炜 on 13-4-24.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "CategoryCell.h"
#import "RecipeView.h"
@implementation CategoryCell
@synthesize category=_category;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setCategory:(Category *)category{

    _category=category;
    NSLog(@"name=%@",category.name);
    NSInteger row=_category.allRecipes.count/3;
    for (NSInteger i=0; i<row; i++) {
        RecipeView *recipeView1=[[RecipeView alloc] initWithFrame:CGRectMake(18, i*269+9, 232, 260)];
        Recipe *recipe1=[_category.allRecipes objectAtIndex:3*i];
        recipeView1.recipe=recipe1;
        [self addSubview:recipeView1];
        [recipeView1 release];
        
        RecipeView *recipeView2=[[RecipeView alloc] initWithFrame:CGRectMake(268, i*269+9, 232, 260)];
        Recipe *recipe2=[_category.allRecipes objectAtIndex:3*i+1];
        recipeView2.recipe=recipe2;
        [self addSubview:recipeView2];
        [recipeView2 release];
        
        RecipeView *recipeView3=[[RecipeView alloc] initWithFrame:CGRectMake(518, i*269+9, 232, 260)];
        Recipe *recipe3=[_category.allRecipes objectAtIndex:3*i+2];
        recipeView3.recipe=recipe3;
        [self addSubview:recipeView3];
        [recipeView3 release];
    }
    NSInteger lastRowCount=_category.allRecipes.count%3;
    for (NSInteger i=0; i<lastRowCount; i++) {
        RecipeView *recipeView=[[RecipeView alloc] initWithFrame:CGRectMake(18+250*i, row*269+9, 232, 260)];
        Recipe *recipe=[_category.allRecipes objectAtIndex:(3*row+i)];
        recipeView.recipe=recipe;
        [self addSubview:recipeView];
        [recipeView release];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews {
    [super layoutSubviews];
}

-(void)dealloc{
    [_category release];
    [super dealloc];
}
@end
