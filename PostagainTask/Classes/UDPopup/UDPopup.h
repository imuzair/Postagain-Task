//
//  UDPopup.h
//  DoctorsBag
//
//  Created by Uzair Danish on 23/11/2013.
//  Copyright (c) 2013 MyApp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    popupBounceAnimation = 0,
    popupSlideFromTopAnimation = 1,
    popupSlideFromBottomAnimation = 2
} popupAnimationType;

@interface UDPopup : UIView{

}

+ (UDPopup *)popupSingleton;
- (void)popupAnimationOnView:(UIView *)view withDuration:(NSTimeInterval)duration withAnimationType:(popupAnimationType)animationType;
- (void)popupRemoveAnimationOnView:(UIView *)view withDuration:(NSTimeInterval)duration withAnimationType:(popupAnimationType)animationType;

@end
