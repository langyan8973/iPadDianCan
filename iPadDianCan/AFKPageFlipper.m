//
//  AFKPageFlipper.m
//  AFKPageFlipper
//
//  Created by Marco Tabini on 10-10-12.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import "AFKPageFlipper.h"


#pragma mark -
#pragma mark UIView helpers


@interface UIView(Extended) 

- (UIImage *) imageByRenderingView;

@end


@implementation UIView(Extended)


- (UIImage *) imageByRenderingView {
    CGFloat oldAlpha = self.alpha;
    self.alpha = 1;
    UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    self.alpha = oldAlpha;
	return resultingImage;
}

@end


#pragma mark -
#pragma mark Private interface


@implementation AFKPageFlipper
@synthesize tapRecognizer = _tapRecognizer;
@synthesize panRecognizer = _panRecognizer;
@synthesize isInit;
@synthesize flipDirection;
@synthesize hOrder;
@synthesize imageDelegate;

#pragma mark -
#pragma mark Flip functionality
//初始化翻页动画的图层
- (void) initFlip {
	
	// 创建用于翻页的图片
	UIImage *currentImage = [self.currentView imageByRenderingView];
	UIImage *newImage = [self.nextView imageByRenderingView];
	
	// 隐藏实际的试图控件
	self.currentView.alpha = 0;
	self.nextView.alpha = 0;
	
	// 创建图层
	CGRect rect = self.bounds;
	rect.size.width /= 2;
	
    //下面不动的图层
	backgroundAnimationLayer = [CALayer layer];
	backgroundAnimationLayer.frame = self.bounds;
	backgroundAnimationLayer.zPosition = 0;
    
	//左半边图层
	CALayer *leftLayer = [CALayer layer];
	leftLayer.frame = rect;
	leftLayer.masksToBounds = YES;
	leftLayer.contentsGravity = kCAGravityLeft;	
	[backgroundAnimationLayer addSublayer:leftLayer];
    
    //左半边阴影层
    leftopacityLayer = [CALayer layer];
    leftopacityLayer.backgroundColor = [UIColor blackColor].CGColor;
    leftopacityLayer.frame = rect;
    leftopacityLayer.opacity  = 0.0;
    leftopacityLayer.contentsGravity=kCAGravityLeft;
    [backgroundAnimationLayer addSublayer:leftopacityLayer];
    
	//右半边图层
	rect.origin.x = rect.size.width;	
	CALayer *rightLayer = [CALayer layer];
	rightLayer.frame = rect;
	rightLayer.masksToBounds = YES;
	rightLayer.contentsGravity = kCAGravityRight;	
	[backgroundAnimationLayer addSublayer:rightLayer];
    
    //右半边阴影图层
    rightopacityLayer = [CALayer layer];
    rightopacityLayer.backgroundColor = [UIColor blackColor].CGColor;
    rightopacityLayer.frame = rect;
    rightopacityLayer.opacity  = 0.0;
    rightopacityLayer.contentsGravity=kCAGravityLeft;
    [backgroundAnimationLayer addSublayer:rightopacityLayer];
	
	if (flipDirection == AFKPageFlipperDirectionRight) {
		leftLayer.contents = (id) [newImage CGImage];
		rightLayer.contents = (id) [currentImage CGImage];
	} else {
		leftLayer.contents = (id) [currentImage CGImage];
		rightLayer.contents = (id) [newImage CGImage];
	}

	[self.layer addSublayer:backgroundAnimationLayer];
	
	rect.origin.x = 0;
    
	//翻页动画层
	flipAnimationLayer = [CATransformLayer layer];
	flipAnimationLayer.anchorPoint = CGPointMake(1.0, 0.5);
	flipAnimationLayer.frame = rect;
	
	[self.layer addSublayer:flipAnimationLayer];
    
	//背面层
	CALayer *backLayer = [CALayer layer];
	backLayer.frame = flipAnimationLayer.bounds;
	backLayer.doubleSided = NO;
	backLayer.masksToBounds = YES;
	
	[flipAnimationLayer addSublayer:backLayer];
    
	//正面层
	CALayer *frontLayer = [CALayer layer];
	frontLayer.frame = flipAnimationLayer.bounds;
	frontLayer.doubleSided = NO;
	frontLayer.masksToBounds = YES;
	frontLayer.transform = CATransform3DMakeRotation(M_PI, 0, 1.0, 0);
	
	[flipAnimationLayer addSublayer:frontLayer];
	
	if (flipDirection == AFKPageFlipperDirectionRight) {
		backLayer.contents = (id) [currentImage CGImage];
		backLayer.contentsGravity = kCAGravityLeft;
		
		frontLayer.contents = (id) [newImage CGImage];
		frontLayer.contentsGravity = kCAGravityRight;
		
		CATransform3D transform = CATransform3DMakeRotation(0.0, 0.0, 1.0, 0.0);
		transform.m34 = 1.0f / 2500.0f;
		
		flipAnimationLayer.transform = transform;
		
		currentAngle = startFlipAngle = 0;
		endFlipAngle = M_PI;
	} else {
		backLayer.contentsGravity = kCAGravityLeft;
		backLayer.contents = (id) [newImage CGImage];
		
		frontLayer.contents = (id) [currentImage CGImage];
		frontLayer.contentsGravity = kCAGravityRight;
		
		CATransform3D transform = CATransform3DMakeRotation(M_PI / 1.1, 0.0, 1.0, 0.0);
		transform.m34 = 1.0f / 2500.0f;
		
		flipAnimationLayer.transform = transform;
		
		currentAngle = startFlipAngle = M_PI;
		endFlipAngle = 0;
	}
}

//清空动画图层
- (void) cleanupFlip {
	[backgroundAnimationLayer removeFromSuperlayer];
	[flipAnimationLayer removeFromSuperlayer];
	
	backgroundAnimationLayer = nil;
	flipAnimationLayer = nil;
	
	animating = NO;
	
	if (setNextViewOnCompletion) {
		[self.currentView removeFromSuperview];
		currentView = nextView;
	} else {
		[self.nextView removeFromSuperview];
	}

    setNextViewOnCompletion=NO;
	self.currentView.alpha = 1;
}

//自动翻滚动画
- (void) setFlipProgress:(float) progress setDelegate:(BOOL) setDelegate animate:(BOOL) animate {
    if (animate) {
        animating = YES;
    }
	float newAngle = startFlipAngle + progress * (endFlipAngle - startFlipAngle);
	
	float duration = animate ? 0.5 * fabs((newAngle - currentAngle) / (endFlipAngle - startFlipAngle)) : 0;
	
	currentAngle = newAngle;
	
	CATransform3D endTransform = CATransform3DIdentity;
	endTransform.m34 = 1.0f / 2500.0f;
	endTransform = CATransform3DRotate(endTransform, newAngle, 0.0, 1.0, 0.0);
    CGFloat newShadowOpacity = progress;
	if (endFlipAngle > startFlipAngle) newShadowOpacity = 1.0 - progress;
	[flipAnimationLayer removeAllAnimations];							
	[CATransaction begin];
	[CATransaction setAnimationDuration:duration];	
	flipAnimationLayer.transform = endTransform;
    
    leftopacityLayer.opacity = newShadowOpacity - 0.5;
	rightopacityLayer.opacity = 0.5 - newShadowOpacity;

	[CATransaction commit];
	
	if (setDelegate) {
		[self performSelector:@selector(cleanupFlip) withObject:nil afterDelay:duration];
	}
}


- (void) flipPage {
	[self setFlipProgress:1.0 setDelegate:YES animate:YES];
}


#pragma mark -
#pragma mark Animation management


- (void)animationDidStop:(NSString *) animationID finished:(NSNumber *) finished context:(void *) context {
	[self cleanupFlip];
}

#pragma mark -
#pragma mark Properties

@synthesize allRecipes=_allRecipes;

-(void)setAllRecipes:(NSMutableArray *)allRecipes AndCurrentPage:(NSInteger)value{
    _allRecipes=allRecipes;
    isInit=YES;
    numberOfPages = _allRecipes.count;
    currentPage = -1;
	self.currentPage = value;
}


@synthesize currentView;

//- (void) setCurrentView:(RecipeLargeView *) value {
//	if (currentView) {
//		[currentView release];
//	}
//	currentView =value  ;
//}

@synthesize nextView;

//- (void) setNextView:(RecipeLargeView *) value {
//	if (nextView) {
//		[nextView release];
//	}
//	nextView = [value retain] ;
//}

@synthesize pView;
//-(void)setPView:(RecipeLargeView *) value{
//    if (pView) {
//		[pView release];
//	}
//	pView = value;
//}

@synthesize nView;
//-(void)setNView:(RecipeLargeView *) value{
//    if (nView) {
//		[nView release];
//	}
//	nView = value ;
//}


@synthesize currentPage;

- (void) setCurrentPage:(NSInteger) value {
	if (![self doSetCurrentPage:value]) {
		return;
	}
	
	setNextViewOnCompletion = YES;
	animating = YES;
	
	self.nextView.alpha = 0;
	
	[UIView beginAnimations:@"" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
	self.nextView.alpha = 1;
	[UIView commitAnimations];
}


- (void) setCurrentPage:(NSInteger) value animated:(BOOL) animated {
	if (![self doSetCurrentPage:value]) {
		return;
	}
	
	setNextViewOnCompletion = YES;
	animating = YES;
	
	if (animated) {
		[self initFlip];
		[self performSelector:@selector(flipPage) withObject:nil afterDelay:0.001];
	} else {
		[self animationDidStop:nil finished:[NSNumber numberWithBool:NO] context:nil];
	}
    
}

- (BOOL) doSetCurrentPage:(NSInteger) value {
    if (currentPage!=-1) {
        if (value == currentPage) {
            return FALSE;
        }
    }
	
	
	flipDirection = value < currentPage ? AFKPageFlipperDirectionRight : AFKPageFlipperDirectionLeft;
	
	currentPage = value;
	
	[self setAllViews];
    NSLog(@"===========%@",self.nextView);
	[self addSubview:self.nextView];
	
	return TRUE;
}	


@synthesize disabled;
- (void) setDisabled:(BOOL) value {
	disabled = value;
	
	self.userInteractionEnabled = !value;
	
	for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
		recognizer.enabled = !value;
	}
    
    if (currentView) {
        currentView.enabled = !value;
    }
}

//设置视图控件包括缓存的
-(void)setAllViews{
    if (self.isInit) {
        self.isInit=NO;
        nextView=[[RecipeLargeView alloc] initWithFrame:self.bounds];
        Recipe *pRecipe=[self.allRecipes objectAtIndex:self.currentPage];
        nextView.enabled=YES;
        nextView.hOrder=self.hOrder;
        nextView.imageDelegate=self.imageDelegate;
        nextView.backgroundColor=[UIColor whiteColor];
        nextView.clipsToBounds = NO;
        nextView.autoresizesSubviews = YES;
        nextView.recipe=pRecipe;
//        self.nextView=view;
//        [view release];
//        [pView release];
        [NSThread detachNewThreadSelector:@selector(initcacheViews:) toTarget:self withObject:nil];
    }
    else{
        if (flipDirection==AFKPageFlipperDirectionRight) {
            if (self.currentPage!=_allRecipes.count-2) {
                if(nView){
                    [nView release];
                }
                nView = currentView;
            }
            nextView = pView ;
        }
        else if(flipDirection==AFKPageFlipperDirectionLeft){
            if (self.currentPage!=1) {
                if (pView) {
                    [pView release];
                }
                pView = currentView;
            }
            nextView = nView ;
        }
        [NSThread detachNewThreadSelector:@selector(createViewTaskMethod:) toTarget:self withObject:nil];
    }
}

//重置视图控件
-(void)resetViews{
    if (nextView) {
        [nextView release];
    }
    [NSThread detachNewThreadSelector:@selector(initcacheViews:) toTarget:self withObject:nil];
}

//设置缓存视图
-(void)initcacheViews:(NSObject *)object{
    if (self.currentPage>0) {
        pView=[[RecipeLargeView alloc] initWithFrame:self.bounds];
        Recipe *pRecipe=[self.allRecipes objectAtIndex:self.currentPage-1];
        pView.enabled=YES;
        pView.hOrder=self.hOrder;
        pView.imageDelegate=self.imageDelegate;
        pView.backgroundColor=[UIColor whiteColor];
        pView.clipsToBounds = NO;
        pView.autoresizesSubviews = YES;
        pView.recipe=pRecipe;
    }
    else{
        [pView release] ;
        self.pView = nil;
    }
    
    if (self.currentPage<_allRecipes.count-1) {
        nView=[[RecipeLargeView alloc] initWithFrame:self.bounds];
        Recipe *nRecipe=[self.allRecipes objectAtIndex:self.currentPage+1];
        nView.enabled=YES;
        nView.hOrder=self.hOrder;
        nView.imageDelegate=self.imageDelegate;
        nView.backgroundColor=[UIColor whiteColor];
        nView.clipsToBounds = NO;
        nView.autoresizesSubviews = YES;
        nView.recipe=nRecipe;
       
    }
    else{
        [nView release];
        self.nView = nil;
    }
}

//滑动中新线程调用该方法设置前后视图缓存
-(void)createViewTaskMethod:(NSObject *)object{
    if (flipDirection==AFKPageFlipperDirectionRight){
        if (self.currentPage>0) {
            pView=[[RecipeLargeView alloc] initWithFrame:self.bounds];
            Recipe *pRecipe=[self.allRecipes objectAtIndex:self.currentPage-1];
            pView.enabled=YES;
            pView.hOrder=self.hOrder;
            pView.imageDelegate=self.imageDelegate;
            pView.backgroundColor=[UIColor whiteColor];
            pView.clipsToBounds = NO;
            pView.autoresizesSubviews = YES;
            pView.recipe=pRecipe;
        }
        else{
//            [pView release];;
        }
    }
    else if(flipDirection==AFKPageFlipperDirectionLeft){
        if (self.currentPage<_allRecipes.count-1) {
            nView=[[RecipeLargeView alloc] initWithFrame:self.bounds];
            Recipe *nRecipe=[self.allRecipes objectAtIndex:self.currentPage+1];
            nView.enabled=YES;
            nView.hOrder=self.hOrder;
            nView.imageDelegate=self.imageDelegate;
            nView.backgroundColor=[UIColor whiteColor];
            nView.clipsToBounds = NO;
            nView.autoresizesSubviews = YES;
            nView.recipe=nRecipe;
        }
        else{
//            [nView release];;
        }
    }
}

#pragma mark -
#pragma mark Touch management

- (void) tapped:(UITapGestureRecognizer *) recognizer {
//	if (animating || self.disabled) {
//		return;
//	}
//	
//	if (recognizer.state == UIGestureRecognizerStateRecognized) {
//		NSInteger newPage;
//		
//		if ([recognizer locationInView:self].x < (self.bounds.size.width - self.bounds.origin.x) / 2) {
//			newPage = MAX(0, self.currentPage - 1);
//		} else {
//			newPage = MIN(self.currentPage + 1, numberOfPages-1);
//            
//		}
//		
//		[self setCurrentPage:newPage animated:YES];
//	}
}

- (void) panned:(UIPanGestureRecognizer *) recognizer {
    static BOOL hasFailed;
	static BOOL initialized;
    if (animating) {
        hasFailed=YES;
        return;
    }
	
	static NSInteger oldPage;

	float translation = [recognizer translationInView:self].x;
	
	float progress = translation / self.bounds.size.width;
	
	if (flipDirection == AFKPageFlipperDirectionLeft) {
		progress = MIN(progress, 0);
	} else {
		progress = MAX(progress, 0);
	}
	
	switch (recognizer.state) {
		case UIGestureRecognizerStateBegan:
            if (!animating) {
                hasFailed = FALSE;
                initialized = FALSE;
                animating = NO;
                setNextViewOnCompletion = NO;
            }			
			break;
			
			
		case UIGestureRecognizerStateChanged:
			if (hasFailed) {
				return;
			}
			if (!initialized) {
				oldPage = self.currentPage;
				
				if (translation > 0) {
					if (self.currentPage > 0) {
						[self doSetCurrentPage:self.currentPage - 1];
					} else {
						hasFailed = TRUE;
						return;
					}
				} else {
					if (self.currentPage < numberOfPages-1) {
						[self doSetCurrentPage:self.currentPage + 1];
					} else {
						hasFailed = TRUE;
						return;
					}
				}
				
				hasFailed = NO;
				initialized = TRUE;
				setNextViewOnCompletion = NO;
				
				[self initFlip];
			}
			[self setFlipProgress:fabs(progress) setDelegate:NO animate:NO];			
			
			break;
			
			
		case UIGestureRecognizerStateFailed: 
			[self setFlipProgress:0.0 setDelegate:YES animate:YES];
			currentPage = oldPage;
			break;
			
		case UIGestureRecognizerStateRecognized:
            if (initialized) {
				if (hasFailed) {                   
                    return;
                }
                if (fabs((translation + [recognizer velocityInView:self].x / 4) / self.bounds.size.width) > 0.2) {
                    setNextViewOnCompletion = YES;
                    [self setFlipProgress:1.0 setDelegate:YES animate:YES];
                } else {
                    [self setFlipProgress:0.0 setDelegate:YES animate:YES];
                    currentPage = oldPage;
                    [self resetViews];
                }
			}

			break;
		default:
			break;
	}
}


#pragma mark -
#pragma mark Frame management


- (void) setFrame:(CGRect) value {
	super.frame = value;

	numberOfPages = _allRecipes.count;
	
	if (self.currentPage > numberOfPages) {
		self.currentPage = numberOfPages;
	}
	
}

#pragma mark -
#pragma mark Initialization and memory management

+ (Class) layerClass {
	return [CATransformLayer class];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		_panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
		[_panRecognizer setMaximumNumberOfTouches:1];
		[_tapRecognizer requireGestureRecognizerToFail:_panRecognizer];
		
        [self addGestureRecognizer:_tapRecognizer];
		[self addGestureRecognizer:_panRecognizer];
    }
    return self;
}

- (void)dealloc {
	[nextView release];
    [pView release];
    [nView release];
	[_tapRecognizer release];
	[_panRecognizer release];
    [super dealloc];
}


@end
