//
//  InboxViewController.h
//  PostagainTask
//
//  Created by uzair on 02/09/2015.
//  Copyright (c) 2015 Postagain. All rights reserved.
//

#import "BaseViewController.h"
#import "InboxPopup.h"
#import "Singleton.h"

@interface InboxViewController : BaseViewController<inboxPopupDelegate>{

    Singleton *single;
}

@end
