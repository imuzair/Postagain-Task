//
//  ConversationViewController.m
//  PostagainTask
//
//  Created by uzair on 02/09/2015.
//  Copyright (c) 2015 Postagain. All rights reserved.
//

#import "ConversationViewController.h"
#import "ConversationCell.h"
#import "ImageCell.h"

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:[Singleton retrieveSingleton].userName];
    chatArray = [[NSMutableArray alloc] init];
    [[XMPPClass retrieveXMPP] connect];
    [XMPPClass retrieveXMPP]._messageDelegate = self;

}

#pragma mark - UITableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [chatArray count] ? [chatArray count] : 0 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([[chatArray objectAtIndex:indexPath.row] objectForKey:@"img"])
        return 135.0;
    else
        return 61.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[chatArray objectAtIndex:indexPath.row] objectForKey:@"img"]) {
        ImageCell * cell = (ImageCell *)[tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
        [cell setValues:[chatArray objectAtIndex:indexPath.row]];
        return cell;
    }
    else{
        ConversationCell * cell = (ConversationCell *)[tableView dequeueReusableCellWithIdentifier:@"ConversationCell"];
        [cell setValues:[chatArray objectAtIndex:indexPath.row]];
        return cell;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    [theTextField resignFirstResponder];
    return YES;
}

# pragma Camera Delegates

- (IBAction)cameraAction:(id)sender{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Take Photo"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Photo Gallery",@"Take a Picture",nil];
    
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
        [self getPicture:@"library"];
    else if(buttonIndex == 1)
        [self getPicture:@"camera"];
}

- (void)getPicture:(NSString*)sender{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    [picker setAllowsEditing:YES];
    
    if([sender isEqual:@"library"]){
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
    else if([sender isEqual:@"camera"]){
        
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            [Alert show:@"No Camera" andMessage:@"Your device does not support camera."];
        
        else{
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *imageToSend = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSArray *friendArr = @[@"postagain",@"postagain2",@"postagain3"];
    [[XMPPClass retrieveXMPP] sendMessage:textFieldChat.text to:friendArr withImage:imageToSend];
    
    NSDictionary *dict = @{@"img":imageToSend,@"sender":@"Me"};
    [chatArray addObject:dict];
    [tableViewConversation reloadData];
}

- (IBAction)sendAction:(id)sender{
    
    NSArray *friendArr = @[@"postagain",@"postagain2",@"postagain3"];
    
    [[XMPPClass retrieveXMPP] sendMessage:textFieldChat.text to:friendArr withImage:nil];
    NSDictionary *dict = @{@"msg":textFieldChat.text,@"sender":@"Me"};
    [chatArray addObject:dict];
    [tableViewConversation reloadData];
    [textFieldChat setText:@""];

}

#pragma SMMessageDelegate

- (void)newMessageReceived:(NSDictionary *)messageContent{

    [chatArray addObject:messageContent];
    [tableViewConversation reloadData];
}

@end
