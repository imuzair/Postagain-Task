//
//  ConversationCell.m
//  PostagainTask
//
//  Created by uzair on 02/09/2015.
//  Copyright (c) 2015 Postagain. All rights reserved.
//

#import "ConversationCell.h"

@implementation ConversationCell

- (void)setValues:(NSDictionary *)dict{

    [labelName setText:[dict objectForKey:@"sender"]];
    [labelDescription setText:[dict objectForKey:@"msg"]];
}

@end
