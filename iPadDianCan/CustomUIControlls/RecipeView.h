//
//  RecipeView.h
//  iPadDianCan
//
//  Created by 李炜 on 13-4-24.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@protocol ImageClickDelegate <NSObject>

-(void)onClickRecipeImageFromView:(id)view;

@end

@interface RecipeView : UIView
@property(nonatomic,assign)Recipe *recipe;
@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain)UILabel *rNameLabel;
@property(nonatomic,retain)UILabel *priceLabel;
@property(nonatomic,retain)UILabel *countLabel;
@property(nonatomic) NSInteger recipeCount;
@property(nonatomic,retain) id<ImageClickDelegate> imageDelegate;
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size;
- (void)changeRecipeCount:(NSInteger)count;
@end
