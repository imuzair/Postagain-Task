//
//  Singleton.m
//  MyApp
//
//  Created by MyApp on 16/08/12.
//  Copyright 2012 MyApp. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton
static Singleton *sharedSingleton = nil;
@synthesize userName;

+ (Singleton*) retrieveSingleton {

	@synchronized(self) {
		if (sharedSingleton == nil) {
			sharedSingleton = [[Singleton alloc] init];
		}
	}
    
	return sharedSingleton;
}

-(id)init {
    
	self = [super init];
	if (self) {
	}
    
	return self;
}

+ (id) allocWithZone:(NSZone *) zone {
    
	@synchronized(self) {
		if (sharedSingleton == nil) {
			sharedSingleton = [super allocWithZone:zone];
			return sharedSingleton;
		}
	}
    
	return nil;
}

@end
