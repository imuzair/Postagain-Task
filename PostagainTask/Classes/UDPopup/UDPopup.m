//
//  UDPopup.m
//  DoctorsBag
//
//  Created by Uzair Danish on 23/11/2013.
//  Copyright (c) 2013 MyApp. All rights reserved.
//

#import "UDPopup.h"
#import "Constants.h"

#define HEIGHT_OF_SCREEN [[UIScreen mainScreen] bounds].size.height
#define NAVIGATION_BAR_HEIGHT 60

static UDPopup *popupSingleton = nil;

@interface UDPopup(){

    UIView *viewToAnimate;
    NSTimeInterval timeDuration;
    BOOL isAnimating;
    int animationTypeNo;
}

@end

@implementation UDPopup

+ (UDPopup *)popupSingleton{
   	@synchronized(self) {
		if (popupSingleton == nil)
			popupSingleton = [[self alloc] init];
	}
	return popupSingleton;
}

- (void)popupAnimationOnView:(UIView *)view withDuration:(NSTimeInterval)duration withAnimationType:(popupAnimationType)animationType{
    
    viewToAnimate = view;
    timeDuration = duration;

    if (!isAnimating){
                
        if (animationType == 0)
            [self popupBounceAnimation];
        else if (animationType == 1)
            [self popupSlideFromTopAnimation];
        else
            [self popupSlideFromBottomAnimation];
    }
}

- (void)popupRemoveAnimationOnView:(UIView *)view withDuration:(NSTimeInterval)duration withAnimationType:(popupAnimationType)animationType{
    
    viewToAnimate = view;
    timeDuration = duration;
    
    if (!isAnimating){
        
        if (animationType == 0)
            [self removeBouncPopup];
        else if (animationType == 1)
            [self popupRemoveSlideFromTopAnimation];
        else
            [self popupRemoveSlideFromBottomAnimation];
    }
}


- (void)popupBounceAnimation{
    
    //isAnimating = YES;
    animationTypeNo = 0;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.2), @(1.5), @(0.7), @(1)];
    animation.keyTimes = @[@(0), @(0.4), @(0.8), @(1)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setValue:viewToAnimate forKey:@"object"];
    animation.duration = timeDuration;
    [viewToAnimate.layer addAnimation:animation forKey:@"bounce"];
    
}

- (void)popupSlideFromTopAnimation{
    
    isAnimating = YES;
    animationTypeNo = 1;

    CGFloat heightOfView = viewToAnimate.frame.size.height;

    [viewToAnimate setFrame:CGRectMake(0, 0 - heightOfView, viewToAnimate.frame.size.width, viewToAnimate.frame.size.height)];

    [UIView animateWithDuration:timeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         [viewToAnimate setFrame:CGRectMake(0, 0, viewToAnimate.frame.size.width, viewToAnimate.frame.size.height)];
                         
                     }
                     completion:^(BOOL finished) {
                         isAnimating = NO;
                     }];
}

- (void)popupRemoveSlideFromTopAnimation{
    
    isAnimating = YES;
    
    CGFloat heightOfView = viewToAnimate.frame.size.height;
    
    [viewToAnimate setFrame:CGRectMake(0, 0, viewToAnimate.frame.size.width, viewToAnimate.frame.size.height)];
    
    [UIView animateWithDuration:timeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         [viewToAnimate setFrame:CGRectMake(0, 0 - heightOfView, viewToAnimate.frame.size.width, viewToAnimate.frame.size.height)];
                         
                     }
                     completion:^(BOOL finished) {
                         [self hideView];
                     }];
    
}

- (void)popupSlideFromBottomAnimation{

    isAnimating = YES;
    animationTypeNo = 2;
    
    CGFloat heightOfScreen;
    
    if (IS_OS_7_OR_LATER)
        heightOfScreen = HEIGHT_OF_SCREEN;
    else
        heightOfScreen = HEIGHT_OF_SCREEN - 64;
    CGFloat heightOfView = viewToAnimate.frame.size.height;
    [viewToAnimate setFrame:CGRectMake(0, heightOfScreen, viewToAnimate.frame.size.width, viewToAnimate.frame.size.height)];
    
    [UIView animateWithDuration:timeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         [viewToAnimate setFrame:CGRectMake(0, viewToAnimate.frame.origin.y - heightOfView - NAVIGATION_BAR_HEIGHT, viewToAnimate.frame.size.width, viewToAnimate.frame.size.height)];
                         
                     }
                     completion:^(BOOL finished) {
                         isAnimating = NO;
                     }];
}

- (void)popupRemoveSlideFromBottomAnimation{
    
    isAnimating = YES;
    
    CGFloat heightOfScreen = HEIGHT_OF_SCREEN;
    CGFloat heightOfView = viewToAnimate.frame.size.height;
    [viewToAnimate setFrame:CGRectMake(0, heightOfScreen  - heightOfView, viewToAnimate.frame.size.width, viewToAnimate.frame.size.height)];

    [UIView animateWithDuration:timeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         [viewToAnimate setFrame:CGRectMake(0, heightOfScreen, viewToAnimate.frame.size.width, viewToAnimate.frame.size.height)];

                     }
                     completion:^(BOOL finished) {
                         [self hideView];
                     }];
    
}

- (void)removeBouncPopup{

    isAnimating = YES;

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(1), @(1.5), @(0.7), @(0.2)];
    animation.keyTimes = @[@(0), @(0.2), @(0.6), @(1)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setValue:viewToAnimate forKey:@"object"];
    animation.duration = 1.0;
    [viewToAnimate.layer addAnimation:animation forKey:@"bounce"];
    
    [self performSelector:@selector(hideView) withObject:nil afterDelay:timeDuration];

}

- (void)hideView{

    [viewToAnimate setHidden:YES];
    isAnimating = NO;

}


@end
