//
//  InboxViewController.m
//  PostagainTask
//
//  Created by uzair on 02/09/2015.
//  Copyright (c) 2015 Postagain. All rights reserved.
//

#import "InboxViewController.h"

@interface InboxViewController ()

@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    single = [Singleton retrieveSingleton];
    [self setTitle:@"Real IM"];
}

- (IBAction)joinRoomAction:(id)sender{

    InboxPopup *inboxPopup = [[InboxPopup alloc] initWithFrame:CGRectZero];
    inboxPopup.delegate = self;
    [self.navigationController.view addSubview:inboxPopup];

}

#pragma mark - InboxPopup Delegate

- (void)confirmButtonAction:(NSString *)name{

    if ([name isEqualToString:@"postagain"] || [name isEqualToString:@"postagain2"] || [name isEqualToString:@"postagain3"]) {
        single.userName = name;
        [self performSegueWithIdentifier:@"ConversationIdentifier" sender:nil];
    }
    else
        [Alert show:@"Alert" andMessage:@"Please enter username 'postagain' or 'postagain2' or 'postagain3' as only these accounts are registered in the server"];
}

@end
