//
//  Singleton.h
//  MyApp
//
//  Created by MyApp on 16/08/12.
//  Copyright 2012 MyApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject

@property (nonatomic, strong) NSString *userName;

+ (Singleton*) retrieveSingleton;

@end
