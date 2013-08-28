//
//  RecipeView.m
//  iPadDianCan
//
//  Created by 李炜 on 13-4-24.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "RecipeView.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "AFImageRequestOperation.h"
@implementation RecipeView
@synthesize imageView,rNameLabel,priceLabel,recipe=_recipe,countLabel,recipeCount=_recipeCount;
@synthesize imageDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 185, 185)];
        [self addSubview:imageView];
        rNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 201, 150, 20)];
        [rNameLabel setBackgroundColor:[UIColor clearColor]];
        [rNameLabel setTextColor:[UIColor blackColor]];
        rNameLabel.font=[UIFont boldSystemFontOfSize:18];
        [self addSubview:rNameLabel];
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 225, 100, 15)];
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [priceLabel setTextColor:[UIColor redColor]];
        priceLabel.font=[UIFont boldSystemFontOfSize:14];
        [self addSubview:priceLabel];
        
        countLabel=[[UILabel alloc] initWithFrame:CGRectMake(165, 225, 30, 15)];
        [countLabel setBackgroundColor:[UIColor clearColor]];
        [countLabel setTextColor:[UIColor redColor]];
        countLabel.font=[UIFont boldSystemFontOfSize:14];
        [self addSubview:countLabel];
    }
    return self;
}
-(void)setRecipe:(Recipe *)recipe{
    _recipe=recipe;
    NSString *imageUrlString=IMAGESERVERADDRESS;
    self.recipeCount=recipe.countAll;
    imageUrlString=[NSString stringWithFormat:@"%@%@",imageUrlString,recipe.imageUrl];
    [self.imageView setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"imageWaiting"]];
    imageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [imageView addGestureRecognizer:singleTouch];
    [singleTouch release];

    [rNameLabel setText:recipe.name];
    NSString *pricestr=[NSString stringWithFormat:@"%@%.2f",@"￥",recipe.price];
    [priceLabel setText:pricestr];    
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
}

-(void)changeRecipeCount:(NSInteger)count{
    _recipeCount=count;
    if(_recipeCount<=0){
        _recipeCount=0;
        [countLabel setText:@""];
    }
    else{
        [countLabel setText:[NSString stringWithFormat:@"%d份",_recipeCount]];
    }
    NSLog(@"name=%@,count=%d",self.recipe.name,count);
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, 10, 10);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultImage=[UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    return resultImage;
}

-(void) clickImage{
    [imageDelegate onClickRecipeImageFromView:self];
}

-(void)dealloc{
    [imageView release];
    [rNameLabel release];
    [priceLabel release];
    [countLabel release];
    [super dealloc];
}
@end
