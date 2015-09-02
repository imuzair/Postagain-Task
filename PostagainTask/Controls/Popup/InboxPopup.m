//
//  InboxPopup.m
//  PostagainTask
//
//  Created by uzair on 02/09/2015.
//  Copyright (c) 2015 Postagain. All rights reserved.
//

#import "InboxPopup.h"
#import "UDPopup.h"

@implementation InboxPopup
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSArray *nibs = nil;
        
        nibs = [[NSBundle mainBundle] loadNibNamed:@"InboxPopup" owner:nil options:nil];
        
        for (id currentObject in nibs) {
            if ([currentObject isKindOfClass:[UIView class]]) {
                self = (InboxPopup *)currentObject;
                CGRect frameOfView = [self frame];
                frameOfView.size.width = [UIScreen mainScreen].bounds.size.width;
                frameOfView.size.height = [UIScreen mainScreen].bounds.size.height;
                [self setFrame:frameOfView];
                [[UDPopup popupSingleton] popupAnimationOnView:viewPopup withDuration:0.3 withAnimationType:popupBounceAnimation];
                break;
            }
        }
    }
    return self;
}

- (IBAction)confirmAction:(id)sender{

    [delegate confirmButtonAction:textFieldName.text];
    [self removeFromSuperview];
}

- (IBAction)dismissAction:(id)sender{

    [self removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

@end
