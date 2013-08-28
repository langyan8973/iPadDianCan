//
//  RecipeTableViewCell.m
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-23.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "RecipeTableViewCell.h"
#import "Recipe.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "OrderListController.h"
#import "Category.h"
#import "MessageView.h"
#import <QuartzCore/QuartzCore.h>
@implementation RecipeTableViewCell
@synthesize recipe = _recipe,addRecipeBtn,removeRecipeBtn,countLabel,firstBadgeLabel,secondBadgeLabel,recipeCount=_recipeCount,indexPath,isAllowRemoveCell;
-(id)init{
    self=[super init];
    return self;
}

-(void)setRecipeCount:(NSInteger)recipeCount{
    _recipeCount= recipeCount;
    if (_recipeCount<=0) {
        [self.countLabel setText:@""];
        _recipeCount=0;
        if (isAllowRemoveCell) {
            UITableView *tv=(UITableView *)self.superview;
            OrderListController *olCon=(OrderListController *)tv.delegate;
            Category *category=[olCon.orderCategores objectAtIndex:indexPath.section];
            [category.allRecipes removeObjectAtIndex:indexPath.row];
            [tv beginUpdates];
            if (category.allRecipes.count==0) {
                [olCon.orderCategores removeObjectAtIndex:indexPath.section];
                [tv deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
            else{
            [tv deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
            }
            [tv endUpdates];
            [self performSelector:@selector(reloadTableViewData)
                       withObject:nil afterDelay:0.2];
        }
        else{
            [self.removeRecipeBtn removeFromSuperview];
        }
    }
    else{
        if (_recipeCount<=(_recipe.countConfirm+_recipe.countDeposit)) {
            [self.removeRecipeBtn removeFromSuperview];
        }
        else{
            [self.contentView addSubview:self.removeRecipeBtn];

        }
        [self.countLabel setText:[NSString stringWithFormat:@"%d 份",_recipeCount]];
    }

}

-(void)reloadTableViewData{
    UITableView *tv=(UITableView *)self.superview;
    [tv reloadData];
    OrderListController *olCon=(OrderListController *)tv.delegate;
    if (olCon.orderCategores.count==0) {
        [self performSelector:@selector(reloadTableViewData)
                   withObject:nil afterDelay:1.0];
    }
}

-(void)setRecipe:(Recipe *)recipe{
    _recipe=recipe;
    
    if (recipe.status!=0) {
        [addRecipeBtn setHidden:YES];
        [removeRecipeBtn setHidden:YES];
    }
    else{
        [addRecipeBtn setHidden:NO];
        [removeRecipeBtn setHidden:NO];
    }
    self.recipeCount=recipe.countAll;
    self.textLabel.text=recipe.name;
    self.detailTextLabel.text=[NSString stringWithFormat:@"¥ %.2f",recipe.price];
    if (recipe.countNew>0) {
        self.firstBadgeLabel.textColor=[UIColor redColor];
        self.firstBadgeLabel.text=[NSString stringWithFormat:@"未下单%d份",recipe.countNew];
    }
    else{
        self.firstBadgeLabel.textColor=[UIColor grayColor];
        self.firstBadgeLabel.text=[NSString stringWithFormat:@"已下单"];
    }

    if (recipe.countConfirm>0) {
        self.secondBadgeLabel.textColor=[UIColor orangeColor];
        if (recipe.countConfirm==1) {
            self.secondBadgeLabel.text=[NSString stringWithFormat:@"已上桌"];

        }
        else{
            self.secondBadgeLabel.text=[NSString stringWithFormat:@"已上桌%d份",recipe.countConfirm];
        }
    }
    else{
        
    }
    NSString *imageUrlString=SMALLIMAGESERVERADDRESS;
    imageUrlString=[NSString stringWithFormat:@"%@%@",imageUrlString,recipe.imageUrl];
    [self.imageView setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"imageWaiting"]];
//    [self.imageView setImage:[UIImage imageNamed:@"imageWaiting"]];
//    AFImageRequestOperation *ope=[AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrlString]] success:^(UIImage *image) {
//        [self.imageView setImage:image];
//    }];
//    [ope start];
    
    self.textLabel.backgroundColor=[UIColor clearColor];
    self.detailTextLabel.backgroundColor=[UIColor clearColor];
    if(isAllowRemoveCell){
        [self.contentView addSubview:firstBadgeLabel];
        [self.contentView addSubview:secondBadgeLabel];
    }

}

-(void)addRecipe{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *numRid=[ud valueForKey:@"rid"];
    NSNumber *numOid=[ud valueForKey:@"oid"];
    if (numOid==nil) {
        return;
    }
    Recipe *aRecipe=self.recipe;
    aRecipe.countNew++;
    self.recipe=aRecipe;
    UITableView *tv=(UITableView *)self.superview;
    OrderListController *olCon=(OrderListController *)tv.delegate;
    
    [Order addRicpeWithRid:numRid.integerValue RecipeId:self.recipe.rid Oid:numOid.integerValue Order:^(Order *order) {
        if (isAllowRemoveCell) {
            NSInteger newCount=0;
            for (OrderItem *oItem in order.orderItems) {
                newCount+=oItem.countNew;
            }
            if (newCount>0) {
                [olCon.priceLabel setText:[NSString stringWithFormat:@"消费金额:￥%.2f",order.priceAll]];
                [olCon.countLabel setText:[NSString stringWithFormat:@"%d份未下单",newCount]];
                olCon.submitButton.enabled=YES;
            }
            else{
                [olCon.priceLabel setText:[NSString stringWithFormat:@"消费金额:￥%.2f",order.priceAll]];
                [olCon.countLabel setText:@""];
                olCon.submitButton.enabled=NO;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([operation.response statusCode]==409) {
            [olCon.checkOrderDelegate orderChecked];
        }
        else{
            MessageView *mv=[[[MessageView alloc] initWithMessageText:[error localizedDescription]] autorelease];
            [mv show];
        }
        
    }];
    UIImageView *animationImageView=[[UIImageView alloc] initWithImage:self.imageView.image];
    CGPoint point= tv.contentOffset;
    [animationImageView setFrame:CGRectMake(self.frame.origin.x-point.x+50+5,self.frame.origin.y-point.y+45+5, 70, 70)];
    animationImageView.tag=100;
    [tv.superview addSubview:animationImageView];
    float duration=(self.frame.origin.y-point.y+45+5)/960;
    if (duration<0.3) {
        duration=0.3;
    }
    [UIView animateWithDuration:duration animations:^{
        [animationImageView setFrame:CGRectMake(320, -50, 10, 10)];
        [animationImageView setAlpha:0];
    }completion:^(BOOL finished){
        [animationImageView removeFromSuperview];
        [animationImageView release];
    }];

}

-(void)removeRecipe{

    Recipe *aRecipe=self.recipe;
    aRecipe.countNew--;
    self.recipe=aRecipe;
    if (self.recipe.countNew<0) {
        self.recipe.countNew=0;
    }
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *numRid=[ud valueForKey:@"rid"];
    NSNumber *numOid=[ud valueForKey:@"oid"];
    UITableView *tv=(UITableView *)self.superview;
    OrderListController *olCon=(OrderListController *)tv.delegate;
    [Order removeRicpeWithRid:numRid.integerValue RecipeId:self.recipe.rid Oid:numOid.integerValue Order:^(Order *order) {
        

        if (isAllowRemoveCell) {
            NSInteger newCount=0;
            for (OrderItem *oItem in order.orderItems) {
                newCount+=oItem.countNew;
            }
            if (newCount>0) {
                [olCon.priceLabel setText:[NSString stringWithFormat:@"消费金额:￥%.2f，%d份未下单",order.priceAll,newCount]];
                olCon.submitButton.enabled=YES;
                //                [olCon.orderBtn setBadgeValue:newCount];
            }
            else{
                [olCon.priceLabel setText:[NSString stringWithFormat:@"消费金额:￥%.2f",order.priceAll]];
                olCon.title=[NSString stringWithFormat:@"消费金额:￥%.2f",order.priceAll];
                olCon.submitButton.enabled=NO;
                //                [olCon.orderBtn setBadgeValue:0];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([operation.response statusCode]==409) {
            [olCon.checkOrderDelegate orderChecked];
        }
        else{
            MessageView *mv=[[[MessageView alloc] initWithMessageText:[error localizedDescription]] autorelease];
            [mv show];
        }
        
    }];

}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        isAllowRemoveCell=NO;
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restaurantTableCellBg"]];
        self.backgroundView = bgImageView;
        [bgImageView release];
        
        UIView *backView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView = backView;
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        [backView release];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        
        self.addRecipeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [addRecipeBtn setFrame:CGRectMake(270, 45, 40, 40)];
        [addRecipeBtn setBackgroundImage:[UIImage imageNamed:@"addRecipeBtn"] forState:UIControlStateNormal];
        [addRecipeBtn addTarget:self action:@selector(addRecipe) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:addRecipeBtn];
        self.removeRecipeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [removeRecipeBtn setFrame:CGRectMake(170, 45, 40, 40)];
        [removeRecipeBtn setBackgroundImage:[UIImage imageNamed:@"removeRecipeBtn"] forState:UIControlStateNormal];
        [removeRecipeBtn addTarget:self action:@selector(removeRecipe) forControlEvents:UIControlEventTouchUpInside];
        countLabel=[[UILabel alloc] initWithFrame:CGRectMake(210, 45, 60, 40)];
        countLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
        countLabel.backgroundColor=[UIColor clearColor];
        countLabel.textColor=[UIColor redColor];
        countLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:countLabel];
        firstBadgeLabel=[[UILabel alloc] initWithFrame:CGRectMake(240, 0, 70, 20)];
        firstBadgeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
        firstBadgeLabel.backgroundColor=[UIColor clearColor];
        firstBadgeLabel.textColor=[UIColor redColor];
        firstBadgeLabel.textAlignment=NSTextAlignmentRight;
        secondBadgeLabel=[[UILabel alloc] initWithFrame:CGRectMake(240, 20, 70, 20)];
        secondBadgeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
        secondBadgeLabel.backgroundColor=[UIColor clearColor];
        secondBadgeLabel.textColor=[UIColor redColor];
        secondBadgeLabel.textAlignment=NSTextAlignmentRight;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(5.0f, 5.0f, 80.0f, 80.0f);
    self.textLabel.frame = CGRectMake(90.0f, 10.0f, 150.0f, 20.0f);
    self.detailTextLabel.frame = CGRectMake(90.0f, 50.0f, 80.0f, 40.0f);
    self.detailTextLabel.font=[UIFont boldSystemFontOfSize:15];
    self.detailTextLabel.textColor=[UIColor redColor];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    self.textLabel.highlightedTextColor=[UIColor blackColor];
    self.detailTextLabel.highlightedTextColor=[UIColor redColor];
}

-(void)drawRect:(CGRect)rect{

}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([anim isKindOfClass:[CAKeyframeAnimation class]]) {
        UITableView *tv=(UITableView *)self.superview;
        UIImageView *im=(UIImageView *)[tv.superview viewWithTag:100];
        if (im) {
            [im removeFromSuperview];
        }
    }
}

-(void)dealloc{
    [removeRecipeBtn release];
    [indexPath release];
    [super dealloc];
}
@end
