//
//  RecipeTableViewCell.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-23.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Recipe;
@interface RecipeTableViewCell : UITableViewCell{
    Recipe *_recipe;
}
@property(nonatomic,assign)Recipe *recipe;
@property(nonatomic,assign)UIButton *addRecipeBtn;
@property(nonatomic,retain)UIButton *removeRecipeBtn;
@property(nonatomic,assign)UILabel *countLabel;
@property(nonatomic,assign)UILabel *firstBadgeLabel;
@property(nonatomic,assign)UILabel *secondBadgeLabel;

@property(nonatomic) NSInteger recipeCount;
@property(nonatomic,retain)NSIndexPath *indexPath;
@property(nonatomic) BOOL isAllowRemoveCell;//是否允许UITableView将其移除
@end
