//
//  HHFullScreenViewController.h
//  Here
//
//  Created by here004 on 11-12-30.
//  Copyright (c) 2011年 Tian Tian Tai Mei Net Tech (Bei Jing) Lt.d. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <QuartzCore/QuartzCore.h>
#import "RecipeView.h"
#import "RecipeLargeView.h"
#import "CategoryTableViewController.h"
@class AFKPageFlipper;

@protocol RefreshOrderDelegate <NSObject>

-(void)refreshFoodTableByOrder;

@end

@interface HHFullScreenViewController : UIViewController<ImageClickDelegate>
{
    BOOL isHorizontal ;
    CGFloat _width;
    CGFloat _height;
    CGFloat startX;
    CGFloat startY;
    
    CGPoint cerr;
    
    CGSize toViewSize;
    CGSize fromViewSize;
    
    CGFloat scaleX;
    CGFloat scaleY;
    CGFloat translationX;
    CGFloat translationY;
    CGFloat translationZ;
    
    CALayer *opacityLayer;
    
    CGRect OriginalFrame;
    UIView *superView;
    
    int animationSyte;
}
@property (nonatomic, assign) UIView *fromView;
@property (nonatomic, assign) AFKPageFlipper *toView;
@property (nonatomic)BOOL oPened;
@property (nonatomic)BOOL isEnabled;
@property(nonatomic,assign)id<LocationToCellDelegate> locationToCellDelegate;
@property(nonatomic,assign)id<RefreshOrderDelegate> refreshOrderDelegate;

-(IBAction)viewDismiss:(id)sender;
- (void)setFromView:(UIView *)fromView toView:(UIView *)toView withX:(float)x withY:(float)y;
- (void)resetFromView:(UIView *)fromView withX:(float)x withY:(float)y;
- (void)startFirstAnimation;
- (CAAnimation *)getAnimation:(float)fromScaleX 
                     toScaleX:(float)toScaleX
                   fromScaleY:(float)fromScaleY
                 tofromScaleY:(float)toScaleY
             fromTranslationX:(float)fromTranslationX 
               toTranslationX:(float)toTranslationX 
             fromTranslationY:(float)fromTranslationY
               toTranslationY:(float)toTranslationY
             fromTranslationZ:(float)fromTranslationZ
               toTranslationZ:(float)toTranslationZ
                 fromRotation:(float)fromRotation
                   toRotation:(float)toRotation
          removedOnCompletion:(BOOL)isRemove;
- (CAAnimation *)getOpacityAnimation:(CGFloat)fromOpacity
                           toOpacity:(CGFloat)toOpacity;
- (void)dismiss;
@end
