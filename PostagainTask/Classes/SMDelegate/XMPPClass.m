//
//  XMPPClass.m
//  FollowMyNews
//
//  Created by MyApp on 3/4/13.
//  Copyright (c) 2013 MyApp. All rights reserved.
//

#import "XMPPClass.h"

#define XMPPHostName @"xmpp.jp"
#define XMPPServerName @"@xmpp.jp"
#define XMPPPasword @"postagain123"
#define XMPPRoasterName @"mymembers"
#define XMPPHostPort 5222

@interface XMPPClass()

- (void)setupStream;
- (void)goOnline;
- (void)goOffline;

@end

static XMPPClass *sharedXMPP = nil;
@implementation XMPPClass
@synthesize xmppStream, _chatDelegate, _messageDelegate;

+ (XMPPClass*) retrieveXMPP {
    
	@synchronized(self) {
		if (sharedXMPP   == nil) {
			sharedXMPP = [[XMPPClass alloc] init];
		}
	}
	return sharedXMPP;
}

///////// XMPP Methods and Delegates /////////

- (void)setupStream{
    
    if (xmppStream == nil){
        xmppStream = [[XMPPStream alloc]init];
        [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
}

- (BOOL)connect{
    
    if ([[Singleton retrieveSingleton].userName length] > 0) {
        
        [self setupStream];
        
        jabberID = [Singleton retrieveSingleton].userName;
        jabberID = [jabberID stringByAppendingString:XMPPServerName];
        jabberID = [self occurrencesOf:@"@" InString:jabberID];
        NSLog(@"%@",jabberID);
        
        password = XMPPPasword;
        
        if (![xmppStream isDisconnected])
            return YES;
        
        
        if (jabberID == nil || password == nil)
            return NO;
        
        [xmppStream setHostName:XMPPHostName];
        [xmppStream setHostPort:XMPPHostPort];
        [xmppStream setMyJID:[XMPPJID jidWithString:jabberID]];
        
        NSError *error = nil;
        if (![xmppStream connect:&error])
        {
            [Alert show:@"Error" andMessage:[NSString stringWithFormat:@"Can't connect to server %@", [error localizedDescription]]];
            return NO;
        }
        
        return YES;
    }
    else
        return NO;
    
}

- (void)goOnline{
    
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
    
}

- (void)goOffline{
    
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
    
}

- (void)disconnect {
    
    [self goOffline];
    [xmppStream disconnect];
    
}

- (void)xmppStreamDidOpen:(XMPPStream *)sender{
    
    NSLog(@"xmppStreamDidOpen");
    
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    [self didlogin];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"error = %@", error);
    
    [self didregister];
    
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error{
    
    NSLog(@"Error = %@",error);
    
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    
    NSLog(@"xmppStreamDidRegister");
    
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    
    NSLog(@"Error = %@",error);
    
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    NSLog(@"xmppStreamDidAuthenticate");
    
    [self goOnline];
    
    XMPPRosterMemoryStorage *rosterstorage = [[XMPPRosterMemoryStorage alloc] init];
    
    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:rosterstorage];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster setAutoFetchRoster:YES];
    [xmppRoster setAutoAcceptKnownPresenceSubscriptionRequests:YES];
    [xmppRoster activate:xmppStream];
    
}

- (void)addXMPPRoaster:(NSString *)userid{
    
    userid = [userid stringByAppendingString:XMPPServerName];
    userid = [self occurrencesOf:@"@" InString:userid];

    [xmppRoster addUser:[XMPPJID jidWithString:userid] withNickname:XMPPRoasterName];
    [xmppRoster fetchRoster];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    
    if (msg != nil) {
        
        from = [from substringWithRange: NSMakeRange(0, [from rangeOfString: @"@" options:NSBackwardsSearch].location)];
        NSLog(@"%@", from);
        
        if ([[[message attributeForName:@"type"] stringValue] isEqualToString:@"image"]) {
            
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:msg options:0];
            UIImage *img = [UIImage imageWithData:imageData];
            NSDictionary *dict = @{@"img":img,@"sender":from};
            if (![[Singleton retrieveSingleton].userName isEqualToString:from])
                [_messageDelegate newMessageReceived:dict];
            
        }
        else{
            
            NSDictionary *dict = @{@"msg":msg,@"sender":from};
            if (![[Singleton retrieveSingleton].userName isEqualToString:from])
                [_messageDelegate newMessageReceived:dict];
        }
    }
}

- (void)didlogin{
    
    isOpen = YES;
    NSError *error = nil;
    [[self xmppStream] authenticateWithPassword:password error:&error];
}

- (void)didregister{
    
    [[self xmppStream] registerWithPassword:XMPPPasword error:nil];
    [self connect];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1)
        [self didregister];
}

-(BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    
    NSLog(@"---------- xmppStream:didReceiveIQ: ----------");
    return NO;
}

-(void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq{
    
    NSLog(@"---------- xmppStream:didSendIQ: ----------");
    
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
        
    NSString *presenceType = [presence type]; // online/offline
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];
    
    NSLog(@"%@",presenceType);
    NSLog(@"%@",myUsername);
    NSLog(@"%@",presenceFromUser);
    
}

- (void)beginRosterPopulationForXMPPStream:(XMPPStream *)stream{}
- (void)endRosterPopulationForXMPPStream:(XMPPStream *)stream{}

- (void)handleRosterItem:(NSXMLElement *)item xmppStream:(XMPPStream *)stream{}
- (void)handlePresence:(XMPPPresence *)presence xmppStream:(XMPPStream *)stream{}


- (void)clearAllResourcesForXMPPStream:(XMPPStream *)stream{}
- (void)clearAllUsersAndResourcesForXMPPStream:(XMPPStream *)stream{}

- (BOOL)userExistsWithJID:(XMPPJID *)jid xmppStream:(XMPPStream *)stream{
    return YES;
}
- (BOOL)configureWithParent:(XMPPRoster *)aParent queue:(dispatch_queue_t)queue{
    return YES;
}

- (void)sendMessage:(NSString *)messageStr to:(NSArray *)toArray withImage:(UIImage *)image {
    
    for (int i = 0 ; i < [toArray count]; i++) {
        
        NSString *to = [toArray objectAtIndex:i];

        to = [to stringByAppendingString:XMPPServerName];
        to = [self occurrencesOf:@"@" InString:to];
        
        NSString* messageString = messageStr;
        
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:messageString];
        
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:to];
        [message addChild:body];
        
        if (image) {
            NSData *dataF = UIImagePNGRepresentation(image);
            NSString *imgStr=[dataF base64EncodedStringWithOptions:0];
            NSXMLElement *ImgAttachement = [NSXMLElement elementWithName:@"attachement"];
            [message addAttributeWithName:@"type" stringValue:@"image"];
            [ImgAttachement setStringValue:imgStr];
            [message addChild:ImgAttachement];
        }
        
        [[self xmppStream] sendElement:message];
    }
}

- (NSString *)occurrencesOf:(NSString *)str InString:(NSString *)mainString
{
    NSInteger noOfOccurences = [[mainString componentsSeparatedByString:str] count];
    noOfOccurences = noOfOccurences - 1;
    if (noOfOccurences == 2) {
        NSRange replaceRange = [mainString rangeOfString:@"@"];
        mainString = [mainString stringByReplacingCharactersInRange:replaceRange withString:@"[at]"];
        
    }
    return mainString;
}

@end
