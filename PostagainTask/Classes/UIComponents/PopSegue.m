//
//  PopSegue.m
//  VortexSensations
//
//  Created by Uzair on 21/11/2013.
//  Copyright (c) 2013 MyApp. All rights reserved.
//

#import "PopSegue.h"

@implementation PopSegue

- (void) perform
{
    UIViewController *src = (UIViewController *) self.sourceViewController;
    [src.navigationController popViewControllerAnimated:YES];
}

@end
