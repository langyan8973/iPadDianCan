//
//  HHFullScreenViewController.m
//  Here
//
//  Created by here004 on 11-12-30.
//  Copyright (c) 2011年 Tian Tian Tai Mei Net Tech (Bei Jing) Lt.d. All rights reserved.
//

#import "HHFullScreenViewController.h"
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)


#import <QuartzCore/QuartzCore.h>
#import "AFKPageFlipper.h"

static CATransform3D CATransform3DMakePerspective(CGFloat z) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = - 1.0 / z;
    return t;
}

@interface HHFullScreenViewController() {
}
@end

@implementation HHFullScreenViewController
@synthesize fromView,toView,oPened,isEnabled=_isEnabled,locationToCellDelegate,refreshOrderDelegate;


- (void)dealloc
{
//    [fromView release];
//    [toView release];
    [super dealloc];
}

-(id)init{
    self=[super init];
    if (self) {
        isHorizontal = NO;
        oPened = NO;
        _isEnabled = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setIsEnabled:(BOOL)isEnabled{
    _isEnabled=isEnabled;
    if (oPened) {
        AFKPageFlipper *largeview=(AFKPageFlipper *)self.toView;
        largeview.disabled=!_isEnabled;
    }
}


-(IBAction)viewDismiss:(id)sender
{
    oPened=NO;
    if (animationSyte == 1)
    {
        toView.center = cerr;
        fromView.center = cerr;
        [self.view bringSubviewToFront:toView];  
        
        float direction = 0;
        direction = -1;
        
        CAAnimation *animation=[self getAnimation:scaleX toScaleX:1.0 fromScaleY:scaleY tofromScaleY:1.0 fromTranslationX:translationX toTranslationX:0.0 fromTranslationY:translationY toTranslationY:0.0 fromTranslationZ:0.0 toTranslationZ:2.0 fromRotation:direction * 180.0 toRotation:0.0 removedOnCompletion:YES];
        [self.fromView.layer addAnimation:animation forKey:@"endfromView"];
        [self.fromView.layer addAnimation:[self getOpacityAnimation:1.0 toOpacity:1.0] forKey:@"opacity"];
        
        CAAnimation *animation1=[self getAnimation:1.0 toScaleX:1.0/scaleX fromScaleY:1.0 tofromScaleY:1.0/scaleY fromTranslationX:translationX toTranslationX:0.0 fromTranslationY:translationY toTranslationY:0.0 fromTranslationZ:0.0 toTranslationZ:1.0 fromRotation:direction * 360.0 toRotation:direction * 180.0 removedOnCompletion:NO];
        animation1.delegate=self;
        [self.toView.layer addAnimation:animation1 forKey:@"endtoView"];
        [self.toView.layer addAnimation:[self getOpacityAnimation:1.0 toOpacity:0.0] forKey:@"opacity"];
        [opacityLayer addAnimation:[self getOpacityAnimation:0.5
                                                   toOpacity:0.0] forKey:@"opacity"];
        animationSyte = 2;
    }
    
}
#pragma mark - CountChangeDelegate
-(void)changeCountByRecipe:(Recipe *)recipe{
    
    RecipeView *recipeView=(RecipeView *)self.fromView;
    recipeView.recipeCount=recipe.countAll;
}
-(void)onClickRecipeImageFromView:(id)view{
    
    if (animationSyte == 1)
    {
        [self changeFromView];
        
        toView.center = cerr;
        fromView.center = cerr;
        [self.view bringSubviewToFront:toView];
        float direction = 0;
        direction = -1;
       
        CAAnimation *animation=[self getAnimation:scaleX toScaleX:1.0 fromScaleY:scaleY tofromScaleY:1.0 fromTranslationX:translationX toTranslationX:0.0 fromTranslationY:translationY toTranslationY:0.0 fromTranslationZ:0.0 toTranslationZ:2.0 fromRotation:direction * 180.0 toRotation:0.0 removedOnCompletion:YES];
        [self.fromView.layer addAnimation:animation forKey:@"endfromView"];
        [self.fromView.layer addAnimation:[self getOpacityAnimation:1.0 toOpacity:1.0] forKey:@"opacity"];
        
        CAAnimation *animation1=[self getAnimation:1.0 toScaleX:1.0/scaleX fromScaleY:1.0 tofromScaleY:1.0/scaleY fromTranslationX:translationX toTranslationX:0.0 fromTranslationY:translationY toTranslationY:0.0 fromTranslationZ:0.0 toTranslationZ:1.0 fromRotation:direction * 360.0 toRotation:direction * 180.0 removedOnCompletion:NO];
        animation1.delegate=self;
        [self.toView.layer addAnimation:animation1 forKey:@"endtoView"];
        [self.toView.layer addAnimation:[self getOpacityAnimation:1.0 toOpacity:0.0] forKey:@"opacity"];
        [opacityLayer addAnimation:[self getOpacityAnimation:0.5
                                                   toOpacity:0.0] forKey:@"opacity"];
        animationSyte = 2;
    }
}

- (void)dismiss
{
    NSLog(@"viewDismiss");
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    
    [self.toView removeFromSuperview];
    [toView release];
    [self.view removeFromSuperview];
    oPened = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 100, 100, 100);
    self.view.layer.sublayerTransform = CATransform3DMakePerspective(1000);
    
}


- (void)startFirstAnimation
{
    float direction = 0;
    direction = -1;
    [self.fromView.layer addAnimation:[self getAnimation:1.0 toScaleX:scaleX fromScaleY:1.0 tofromScaleY:scaleY fromTranslationX:-translationX toTranslationX:0.0 fromTranslationY:-translationY toTranslationY:0.0 fromTranslationZ:0.0 toTranslationZ:1.0 fromRotation:0.0 toRotation:direction * 180.0 removedOnCompletion:YES] forKey:@"startfromView"];
    [self.fromView.layer addAnimation:[self getOpacityAnimation:1.0 toOpacity:0.0] forKey:@"opacity"];
    
    CAAnimation *toviewStartAnimation=[self getAnimation:1.0/scaleX toScaleX:1.0 fromScaleY:1.0/scaleY tofromScaleY:1.0 fromTranslationX:-translationX toTranslationX:0.0 fromTranslationY:-translationY toTranslationY:0.0 fromTranslationZ:0.0 toTranslationZ:2.0 fromRotation:direction * 180.0 toRotation:direction * 360.0  removedOnCompletion:YES];
    toviewStartAnimation.delegate=self;
    [self.toView.layer addAnimation:toviewStartAnimation forKey:@"starttoView"];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    [opacityLayer addAnimation:[self getOpacityAnimation:0.0
                                            toOpacity:0.5] forKey:@"opacity"];
    animationSyte = 0;
}

- (void)setFromView:(UIView *)fView toView:(AFKPageFlipper *)tView withX:(float)x withY:(float)y
{
    oPened = YES;
    _isEnabled = YES;
    OriginalFrame = fView.frame;
    superView = fView.superview;
    
    opacityLayer = [CALayer layer];
    opacityLayer.backgroundColor = [UIColor blackColor].CGColor;
    opacityLayer.frame = CGRectMake(0.0, 0.0,776, 960);
    opacityLayer.opacity  = 0.0;
    opacityLayer.transform = CATransform3DScale(CATransform3DMakeTranslation(-308,0.0,-200),2,2,1);
    [self.view.layer insertSublayer:opacityLayer atIndex:0];

    fromView = fView;
    fromViewSize = fView.frame.size;
    startX = x;
    startY = y;
    fromView.frame = CGRectMake(x, y, fView.frame.size.width, fView.frame.size.height);
    NSLog(@"%@",NSStringFromCGRect(fromView.frame));
   cerr = fView.center;
    toViewSize = tView.frame.size;
    self.toView = tView;

    fromView.center = CGPointMake(384, 480);
    toView.center =fromView.center;
    
    scaleX = toViewSize.width/fromViewSize.width;
    scaleY = toViewSize.height/fromViewSize.height;

    [self.view addSubview:toView];
    [self.view addSubview:fromView];    
    
    translationX =  (768 - toViewSize.width)/2.0 - startX + (scaleX - 1) * (fromViewSize.width/2.0);
    translationY =  (960 - toViewSize.height)/2.0 - startY+ (scaleY - 1) * (fromViewSize.height/2.0);
}

-(void)resetFromView:(UIView *)fView withX:(float)x withY:(float)y{
    oPened = YES;
    _isEnabled = YES;
    OriginalFrame = fView.frame;
    superView = fView.superview;
    
    fromView = fView;
    fromViewSize = fView.frame.size;
    startX = x;
    startY = y;
    fromView.frame = CGRectMake(x, y, fView.frame.size.width, fView.frame.size.height);
    
    cerr = fView.center;
    
    fromView.center = CGPointMake(384, 480);
    [self.view insertSubview:fromView atIndex:1];
    
    translationX =  (768 - toViewSize.width)/2.0 - startX + (scaleX - 1) * (fromViewSize.width/2.0);
    translationY =  (960 - toViewSize.height)/2.0 - startY+ (scaleY - 1) * (fromViewSize.height/2.0);
}



- (CAAnimation *)getOpacityAnimation:(CGFloat)fromOpacity
                           toOpacity:(CGFloat)toOpacity
{
    CABasicAnimation *pulseAnimationx = [CABasicAnimation animationWithKeyPath:@"opacity"];
    pulseAnimationx.duration = 0.6;
    pulseAnimationx.fromValue = [NSNumber numberWithFloat:fromOpacity];
    pulseAnimationx.toValue = [NSNumber numberWithFloat:toOpacity];
    
    pulseAnimationx.autoreverses = NO;
    pulseAnimationx.fillMode=kCAFillModeForwards;
    pulseAnimationx.removedOnCompletion = NO;
    pulseAnimationx.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    return pulseAnimationx;
    
}

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
          removedOnCompletion:(BOOL)isRemove
{
    
    CAAnimationGroup *anim;
    
    CABasicAnimation *pulseAnimationx = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    //  CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
    pulseAnimationx.duration = 0.6;
    pulseAnimationx.fromValue = [NSNumber numberWithFloat:fromScaleX];
    pulseAnimationx.toValue = [NSNumber numberWithFloat:toScaleX];
    
    CABasicAnimation *pulseAnimationy = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    //  CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
    pulseAnimationy.duration = 0.6;
    pulseAnimationy.fromValue = [NSNumber numberWithFloat:fromScaleY];
    pulseAnimationy.toValue = [NSNumber numberWithFloat:toScaleY];
    
    CABasicAnimation *translationx = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationx.duration = 0.6;
    translationx.fromValue = [NSNumber numberWithFloat:fromTranslationX];
    translationx.toValue = [NSNumber numberWithFloat:toTranslationX];
    
    CABasicAnimation *translationy = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    translationy.duration = 0.6;
    translationy.fromValue = [NSNumber numberWithFloat:fromTranslationY];
    translationy.toValue = [NSNumber numberWithFloat:toTranslationY];
    
    CABasicAnimation *pulseAnimationz = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
    pulseAnimationz.duration = 0.6;
    pulseAnimationz.beginTime = 0.3;
    pulseAnimationz.fromValue = [NSNumber numberWithFloat:fromTranslationZ];
    pulseAnimationz.toValue = [NSNumber numberWithFloat:toTranslationZ];
    
    
    CABasicAnimation *rotateLayerAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotateLayerAnimation.duration = 0.6;
    rotateLayerAnimation.beginTime = 0.0;
    rotateLayerAnimation.fillMode = kCAFillModeBoth;
    rotateLayerAnimation.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(fromRotation)];
    rotateLayerAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(toRotation)];
    
    anim = [CAAnimationGroup animation];
    anim.animations = [NSArray arrayWithObjects:pulseAnimationx,pulseAnimationy,translationx,translationy,pulseAnimationz, rotateLayerAnimation, nil];
    anim.duration = 0.6;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    anim.autoreverses = NO;
    anim.fillMode=kCAFillModeForwards;
    anim.removedOnCompletion = isRemove;
    //[self.view bringSubviewToFront:faceView];
    return anim;
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag&&animationSyte == 0)
    {
        toView.layer.transform = CATransform3DIdentity;
        fromView.layer.transform = CATransform3DIdentity;
        toView.center = CGPointMake(384,480);
        fromView.center = CGPointMake(384,480);
        [self.view bringSubviewToFront:toView];  
        animationSyte = 1;
    }
    else if(flag&&animationSyte == 2)
    {
        [self dismiss];
        fromView.frame = OriginalFrame;
        [superView addSubview:fromView];
        [self.view removeFromSuperview];
        oPened = NO;
        [self.refreshOrderDelegate refreshFoodTableByOrder];
    }
    
}

-(void)changeFromView{
    fromView.frame = OriginalFrame;
    RecipeView *recipeView=(RecipeView *)fromView;
    [superView addSubview:fromView];
    [self.locationToCellDelegate refreshCellByRecipe:recipeView.recipe];
    
    AFKPageFlipper *fliper=(AFKPageFlipper *)toView;
    RecipeLargeView *laview=(RecipeLargeView *)fliper.currentView;
    [self.locationToCellDelegate locationByRecipe:laview.recipe];
}




@end
