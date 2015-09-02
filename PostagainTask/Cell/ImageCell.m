//
//  ImageCell.m
//  PostagainTask
//
//  Created by uzair on 02/09/2015.
//  Copyright (c) 2015 Postagain. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell

- (void)setValues:(NSDictionary *)dict{

    [labelName setText:[dict objectForKey:@"sender"]];
    UIImage *img = [dict objectForKey:@"img"];
    [imageViewChat setImage:img];
}

@end
