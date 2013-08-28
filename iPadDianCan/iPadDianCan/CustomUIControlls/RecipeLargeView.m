//
//  RecipeLargeView.m
//  iPadDianCan
//
//  Created by 刘岩 on 13-5-6.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "RecipeLargeView.h"
#import "AFImageRequestOperation.h"
#import "UIImageView+AFNetworking.h"
#import "Order.h"
#import "MessageView.h"

@implementation RecipeLargeView
@synthesize recipe=_recipe,recipeCount=_recipeCount,enabled=_enabled;
@synthesize imageDelegate;
@synthesize hOrder;
@synthesize imageView,rNameLabel,priceLabel,countLabel,addRecipeBtn,removeRecipeBtn;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(34, 34, 700, 700)];
        [self addSubview:iv];
        imageView=iv;
        [iv release];
        rNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 754, 400, 40)];
        [rNameLabel setBackgroundColor:[UIColor clearColor]];
        [rNameLabel setTextColor:[UIColor blackColor]];
        rNameLabel.font=[UIFont boldSystemFontOfSize:30];
        [self addSubview:rNameLabel];
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 804, 300, 30)];
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [priceLabel setTextColor:[UIColor redColor]];
        priceLabel.font=[UIFont boldSystemFontOfSize:20];
        [self addSubview:priceLabel];
        
        countLabel=[[UILabel alloc] initWithFrame:CGRectMake(534, 884, 100, 50)];
        [countLabel setBackgroundColor:[UIColor clearColor]];
        [countLabel setTextColor:[UIColor redColor]];
        countLabel.font=[UIFont boldSystemFontOfSize:20];
        [countLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:countLabel];
        
        
        addRecipeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addRecipeBtn setFrame:CGRectMake(634, 884, 50, 50)];
        [addRecipeBtn setBackgroundImage:[UIImage imageNamed:@"addRecipeBtn"] forState:UIControlStateNormal];
        [addRecipeBtn addTarget:self action:@selector(addRecipe) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addRecipeBtn];
        
        removeRecipeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [removeRecipeBtn setFrame:CGRectMake(484, 884, 50, 50)];
        [removeRecipeBtn setBackgroundImage:[UIImage imageNamed:@"removeRecipeBtn"] forState:UIControlStateNormal];
        [removeRecipeBtn addTarget:self action:@selector(removeRecipe) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:removeRecipeBtn];
    }
    return self;
}

-(void)setRecipe:(Recipe *)recipe{
    _recipe=recipe;
    NSString *imageUrlString=LARGEIMAGESERVERADDRESS;
    self.recipeCount=recipe.countAll;
    imageUrlString=[NSString stringWithFormat:@"%@%@",imageUrlString,recipe.imageUrl];
    imageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [imageView addGestureRecognizer:singleTouch];
    [singleTouch release];
    UIImage *img=[UIImage imageNamed:@"imageWaiting"];
    [imageView setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:img];
    [rNameLabel setText:recipe.name];
    NSString *pricestr=[NSString stringWithFormat:@"%@%.2f",@"￥",recipe.price];
    [priceLabel setText:pricestr];
    
    if (!hOrder) {
        [addRecipeBtn setHidden:YES];
        [removeRecipeBtn setHidden:YES];
    }
    else{
        if (recipe.countNew>0) {
            [removeRecipeBtn setHidden:NO];
        }
        else{
            [removeRecipeBtn setHidden:YES];
        }
        [addRecipeBtn setHidden:NO];
    }
}

-(void)setRecipeCount:(NSInteger)recipeCount{
    _recipeCount=recipeCount;
    if(_recipeCount<=0){
        _recipeCount=0;
        [countLabel setText:@""];
    }
    else{
        [countLabel setText:[NSString stringWithFormat:@"%d份",_recipeCount]];
    }
    
    if (!hOrder) {
        [addRecipeBtn setHidden:YES];
        [removeRecipeBtn setHidden:YES];
    }
    else{
        if (self.recipe.countNew>0) {
            [removeRecipeBtn setHidden:NO];
        }
        else{
            [removeRecipeBtn setHidden:YES];
        }
        [addRecipeBtn setHidden:NO];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void) clickImage{
    if (!self.enabled) {
        return;
    }
    [imageDelegate onClickRecipeImageFromView:self];
}

-(void) addRecipe{
    if (!self.enabled) {
        return;
    }
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *numRid=[ud valueForKey:@"rid"];
    NSNumber *numOid=[ud valueForKey:@"oid"];
    if (numOid==nil) {
        return;
    }
    Recipe *aRecipe=self.recipe;
    
    [Order addRicpeWithRid:numRid.integerValue RecipeId:self.recipe.rid Oid:numOid.integerValue Order:^(Order *order) {
        for (OrderItem *oItem in order.orderItems) {
            if (aRecipe.rid==oItem.recipe.rid) {
                self.recipe.countAll=oItem.countAll;
                self.recipe.countConfirm=oItem.countConfirm;
                self.recipe.countDeposit=oItem.countDeposit;
                self.recipe.countNew=oItem.countNew;
                self.recipeCount=self.recipe.countAll;
                break;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([operation.response statusCode]==409) {
            [self orderCancel];
        }
        else{
            MessageView *mv=[[[MessageView alloc] initWithMessageText:[error localizedDescription]] autorelease];
            [mv show];
        }
        
    }];
    UIImageView *animationImageView=[[UIImageView alloc] initWithImage:imageView.image];
    animationImageView.frame=imageView.frame;
    animationImageView.tag=100;
    [self addSubview:animationImageView];
    float duration=0.6;
    
    [UIView animateWithDuration:duration animations:^{
        [animationImageView setFrame:CGRectMake(750, -50, 10, 10)];
        [animationImageView setAlpha:0];
    }completion:^(BOOL finished){
        [animationImageView removeFromSuperview];
        [animationImageView release];
    }];
}

-(void) removeRecipe{
    if (!self.enabled) {
        return;
    }
    Recipe *aRecipe=self.recipe;
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *numRid=[ud valueForKey:@"rid"];
    NSNumber *numOid=[ud valueForKey:@"oid"];
    [Order removeRicpeWithRid:numRid.integerValue RecipeId:self.recipe.rid Oid:numOid.integerValue Order:^(Order *order) {
        BOOL finded = NO;
        for (OrderItem *oItem in order.orderItems) {
            if (aRecipe.rid==oItem.recipe.rid) {
                finded = YES;
                self.recipe.countAll=oItem.countAll;
                self.recipe.countConfirm=oItem.countConfirm;
                self.recipe.countDeposit=oItem.countDeposit;
                self.recipe.countNew=oItem.countNew;
                self.recipeCount=self.recipe.countAll;
                break;
            }
        }
        if (!finded) {
            self.recipe.countAll=0l;
            self.recipe.countConfirm=0;
            self.recipe.countDeposit=0;
            self.recipe.countNew=0;
            self.recipeCount=0;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([operation.response statusCode]==409) {
            [self orderCancel];
        }
        else{
            MessageView *mv=[[[MessageView alloc] initWithMessageText:[error localizedDescription]] autorelease];
            [mv show];
        }
    }];
}

-(void)orderCancel{
    hOrder=NO;
    self.recipeCount=0;
    [imageDelegate onClickRecipeImageFromView:self];
}


-(void)dealloc{
    [rNameLabel release];
    [priceLabel release];
    [countLabel release];
    [super dealloc];
}
@end
