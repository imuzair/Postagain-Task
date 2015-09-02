//
//  Constants.h
//  DoctorsBag
//
//  Created by uzairdanish-MAC on 16/11/2013.
//  Copyright (c) 2013 MyApp. All rights reserved.
//

#import "ServiceConstants.h"
#import "StringConstants.h"
#import "ImageConstants.h"

#ifndef DoctorsBag_Constants_h
#define DoctorsBag_Constants_h


#define MESSAGE_LOADING                     @"Loading....."
#define APPLICATION_BOLD_FONT               @"Helvetica-bold"
#define APPLICATION_REGULAR_FONT            @"Helvetica"

#define PLACEHOLDER_SILHOUETTE_DOCUMENT              @"collectionViewbg.png"

#define WINDOW_FRAME [UIScreen mainScreen].bounds;
#define WINDOW_WIDTH [UIScreen mainScreen].bounds.size.width;
#define WINDOW_HEIGHT [UIScreen mainScreen].bounds.size.height;


#define APPC_STORYBOARD_NAME        (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad) ? @"Main_iPad" : @"Main"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568) ? NO:YES)
#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.height-480) ? NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define NOTIFICATION_COVER_UPDATED          @"coverUpdated"
#define NOTIFICATION_PROFILE_UPDATED        @"profileUpdated"

//Segues
#define SEGUE_BROADCAST                     @"segueBroadcast"
#define SEGUE_CHAT_SCREEN                   @"ChatScreen"
#define SEGUE_GROUP_CHAT                    @"GroupChat"

#endif
