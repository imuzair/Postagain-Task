//
//  XMPPClass.h
//  FollowMyNews
//
//  Created by MyApp on 3/4/13.
//  Copyright (c) 2013 MyApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "SMChatDelegate.h"
#import "SMMessageDelegate.h"
#import "XMPPRosterMemoryStorage.h"
#import "XMPPRoster.h"
#import "Singleton.h"

@interface XMPPClass : NSObject<XMPPRosterDelegate, XMPPRosterStorage, XMPPStreamDelegate>{

    XMPPRoster *xmppRoster;
    
    NSObject <SMChatDelegate> *_chatDelegate;
    NSObject <SMMessageDelegate> *_messageDelegate;
    NSString *jabberID;
    NSString *password;
    BOOL isOpen;
    NSString *IDWithoutDomain;
}

- (BOOL)connect;
- (void)disconnect;
- (void)didlogin;
- (void)didregister;
- (void)addXMPPRoaster:(NSString *)userid;
- (NSString *)occurrencesOf:(NSString *)str InString:(NSString *)mainString;
- (void)sendMessage:(NSString *)messageStr to:(NSArray *)toArray withImage:(UIImage *)image;
+ (XMPPClass*) retrieveXMPP;

@property (nonatomic, readonly) XMPPStream *xmppStream;

@property (nonatomic, strong) id  _chatDelegate;
@property (nonatomic, strong) id  _messageDelegate;


@end
