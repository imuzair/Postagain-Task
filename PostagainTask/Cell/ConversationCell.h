//
//  ConversationCell.h
//  PostagainTask
//
//  Created by uzair on 02/09/2015.
//  Copyright (c) 2015 Postagain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationCell : UITableViewCell{
    
    IBOutlet UILabel *labelName;
    IBOutlet UILabel *labelDescription;

}

- (void)setValues:(NSDictionary *)dict;

@end
