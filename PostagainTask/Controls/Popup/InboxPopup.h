//
//  InboxPopup.h
//  PostagainTask
//
//  Created by uzair on 02/09/2015.
//  Copyright (c) 2015 Postagain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol inboxPopupDelegate <NSObject>

@required
@optional
- (void)confirmButtonAction:(NSString *)name;
@end

@interface InboxPopup : UIView<UITextFieldDelegate>{
    
    IBOutlet UIView *viewPopup;
    IBOutlet UITextField *textFieldName;

}

- (id)initWithFrame:(CGRect)frame;

@property (nonatomic, retain) id <inboxPopupDelegate>delegate;

@end
