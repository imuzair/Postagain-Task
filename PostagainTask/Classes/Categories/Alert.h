//
//  Alert.h
//  
//
//  Created by Uzair on 1/11/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alert : NSObject{}

+(void) show:(NSString*)title andMessage:(NSString*)message;
+(void) show:(NSString*)title andMessage:(NSString*)message withDelegate:(id)delegate;
+(void) show:(NSString*)title andMessage:(NSString*)message withTag:(NSInteger)tag withDelegate:(id)delegate;
+(void) show:(NSString*)title andMessage:(NSString*)message withCancelButtonTitle:(NSString*)cancelmsg withotherButtonTitles:(NSArray*)othermsg withTag:(NSInteger)tag withDelegate:(id)delegate;
+(void) show:(NSString*)title andMessage:(NSString*)message withCancelButtonTitle:(NSString*)cancelmsg withotherButtonTitles:(NSArray*)othermsg;
+(void) show:(NSString*)title andMessage:(NSString*)message withCancelButtonTitle:(NSString*)cancelmsg withotherButtonTitles:(NSArray*)othermsg withDelegate:(id)delegate;
+(void)showErrorMessageForCode:(int)code;

@end
