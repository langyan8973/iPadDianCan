//
//  RecipeRowCell.m
//  iPadDianCan
//
//  Created by 刘岩 on 13-4-28.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "RecipeRowCell.h"
#import "RecipeView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RecipeRowCell

@synthesize recipes = _recipes;
@synthesize imgDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        RecipeView *recipeView1=[[RecipeView alloc] initWithFrame:CGRectMake(18, 9, 217, 245)];
        [recipeView1 setTag:100];
        [self addSubview:recipeView1];
        [recipeView1 release];
        
        RecipeView *recipeView2=[[RecipeView alloc] initWithFrame:CGRectMake(253, 9, 217, 245)];
        [recipeView2 setTag:101];
        [self addSubview:recipeView2];
        [recipeView2 release];
        
        RecipeView *recipeView3=[[RecipeView alloc] initWithFrame:CGRectMake(488, 9, 217, 245)];
        [recipeView3 setTag:102];
        [self addSubview:recipeView3];
        [recipeView3 release];
    }
    return self;
}
-(void)setRecipes:(NSMutableArray *)recipes{
    _recipes=recipes;
    if (_recipes.count<1) {
        return;
    }
    RecipeView *recipeView1=(RecipeView *)[self viewWithTag:100];
    recipeView1.recipe=[_recipes objectAtIndex:0];
    recipeView1.imageDelegate = imgDelegate;
    
    RecipeView *recipeView2=(RecipeView *)[self viewWithTag:101];
    RecipeView *recipeView3=(RecipeView *)[self viewWithTag:102];
    
    if (_recipes.count<2) {
        [recipeView2 setHidden:YES];
        [recipeView3 setHidden:YES];
    }
    else if(_recipes.count<3){
        [recipeView2 setHidden:NO];
        recipeView2.recipe=[_recipes objectAtIndex:1];
        recipeView2.imageDelegate = imgDelegate;
        [recipeView3 setHidden:YES];
    }
    else{
        [recipeView2 setHidden:NO];
        recipeView2.recipe=[_recipes objectAtIndex:1];
        recipeView2.imageDelegate = imgDelegate;
        [recipeView3 setHidden:NO];
        recipeView3.recipe=[_recipes objectAtIndex:2];
        recipeView3.imageDelegate = imgDelegate;
    }
}

-(RecipeView *)getRecipeViewByRecipe:(Recipe *)recipe{
    RecipeView *recipeView1=(RecipeView *)[self viewWithTag:100];
    RecipeView *recipeView2=(RecipeView *)[self viewWithTag:101];
    RecipeView *recipeView3=(RecipeView *)[self viewWithTag:102];
    
    if (!recipeView1.hidden&&[recipeView1.recipe.name isEqual:recipe.name]) {
        return recipeView1;
    }
    if (!recipeView2.hidden&&[recipeView2.recipe.name isEqual:recipe.name]) {
        return recipeView2;
    }
    if (!recipeView3.hidden&&[recipeView3.recipe.name isEqual:recipe.name]) {
        return recipeView3;
    }
    
    return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) layoutSubviews{
    [super layoutSubviews];
}
-(void)dealloc{
    [_recipes release];
    [imgDelegate release];
    [super dealloc];
}
@end
