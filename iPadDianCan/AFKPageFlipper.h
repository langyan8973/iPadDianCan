//
//  AFKPageFlipper.h
//  AFKPageFlipper
//
//  Created by Marco Tabini on 10-10-11.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RecipeLargeView.h"

@class AFKPageFlipper;


typedef enum {
	AFKPageFlipperDirectionLeft,
	AFKPageFlipperDirectionRight,
} AFKPageFlipperDirection;



@interface AFKPageFlipper : UIView {
	NSInteger currentPage;
	NSInteger numberOfPages;	
//	RecipeLargeView *currentView;
//	RecipeLargeView *nextView;
//    RecipeLargeView *pView;
//    RecipeLargeView *nView;
	CALayer *backgroundAnimationLayer;
    CALayer *leftopacityLayer;
    CALayer *rightopacityLayer;
	CALayer *flipAnimationLayer;
	
	float startFlipAngle;
	float endFlipAngle;
	float currentAngle;
	BOOL setNextViewOnCompletion;
	BOOL animating;	
	BOOL disabled;
}

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) RecipeLargeView *currentView;
@property (nonatomic,retain) RecipeLargeView *nextView;
@property (nonatomic,retain) RecipeLargeView *pView;
@property (nonatomic,retain) RecipeLargeView *nView;
@property (nonatomic,assign)AFKPageFlipperDirection flipDirection;
@property (nonatomic, retain) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, retain) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic,assign) BOOL disabled;
@property (nonatomic,assign) BOOL isInit;
@property(nonatomic,assign) BOOL hOrder;
@property (nonatomic,assign)NSMutableArray *allRecipes;
@property(nonatomic,retain) id<ImageClickDelegate> imageDelegate;

- (void) setCurrentPage:(NSInteger) value animated:(BOOL) animated;
-(void)setAllRecipes:(NSMutableArray *)allRecipes AndCurrentPage:(NSInteger) value;

@end
