//
//  ConversationViewController.h
//  PostagainTask
//
//  Created by uzair on 02/09/2015.
//  Copyright (c) 2015 Postagain. All rights reserved.
//

#import "BaseViewController.h"
#import "XMPPClass.h"

@interface ConversationViewController : BaseViewController<UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, SMMessageDelegate>{

    IBOutlet UITableView *tableViewConversation;
    IBOutlet UITextField *textFieldChat;
    NSMutableArray *chatArray;
    IBOutlet UIView *viewChat;

}

@end
