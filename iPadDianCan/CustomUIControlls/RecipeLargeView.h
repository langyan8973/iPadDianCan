//
//  RecipeLargeView.h
//  iPadDianCan
//
//  Created by 刘岩 on 13-5-6.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import "RecipeView.h"


@interface RecipeLargeView : UIView{
    
}
@property(nonatomic,assign)Recipe *recipe;
@property(nonatomic) NSInteger recipeCount;
@property(nonatomic) BOOL enabled;
@property(nonatomic,assign) id<ImageClickDelegate> imageDelegate;
@property(nonatomic)BOOL hOrder;
@property(nonatomic,assign)UIImageView *imageView;
@property(nonatomic,retain)UILabel *rNameLabel;
@property(nonatomic,retain)UILabel *priceLabel;
@property(nonatomic,retain)UILabel *countLabel;
@property(nonatomic,assign)UIButton *addRecipeBtn;
@property(nonatomic,assign)UIButton *removeRecipeBtn;

@end
