//
//  ImageCell.h
//  PostagainTask
//
//  Created by uzair on 02/09/2015.
//  Copyright (c) 2015 Postagain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UITableViewCell{

    IBOutlet UIImageView *imageViewChat;
    IBOutlet UILabel *labelName;
}

- (void)setValues:(NSDictionary *)dict;


@end
