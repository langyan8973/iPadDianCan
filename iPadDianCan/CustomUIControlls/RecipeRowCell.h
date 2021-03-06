//
//  RecipeRowCell.h
//  iPadDianCan
//
//  Created by 刘岩 on 13-4-28.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import "RecipeView.h"
@interface RecipeRowCell : UITableViewCell
@property(nonatomic,retain) NSMutableArray *recipes;
@property(nonatomic,retain) id<ImageClickDelegate> imgDelegate;
-(RecipeView *)getRecipeViewByRecipe:(Recipe *)recipe;
@end
