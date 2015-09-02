//
//  BaseViewController.m
//  WorkingApp
//
//  Created by Uzair Danish on 17/10/2014.
//  Copyright (c) 2014 MyApp. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadControls];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)loadControls {
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"topbar"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    
}

- (void)setTitleToHeader:(NSString *)title{
    
    [self.navigationItem setTitle:title];
}

- (void)showTitleLogo{
    
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 113, 18)];
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    [image setFrame:CGRectMake(0, 0, 113, 18)];
    [myView addSubview:image];
    self.navigationItem.titleView = myView;
}

@end
