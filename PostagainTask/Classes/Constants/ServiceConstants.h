//
//  ServiceConstants.h
//  DoctorsBag
//
//  Created by uzairdanish-MAC on 16/11/2013.
//  Copyright (c) 2013 MyApp. All rights reserved.
//

#ifndef DoctorsBag_ServiceConstants_h
#define DoctorsBag_ServiceConstants_h

#define REACHIBILITY_URL                        @"www.google.com"

//#define KWEBSERVICE_BASE                        @"http://54.186.147.144/WorkingApp/"
//#define KWEBSERVICE_BASE_URL                    @"http://54.186.147.144/WorkingApp/"
//#define KWEBSERVICE_BASE_URL_IMAGE              @"http://54.186.147.144/WorkingApp/"

#define KWEBSERVICE_BASE                        @"http://54.186.147.144/WorkingApp/"
#define KWEBSERVICE_BASE_URL                    @"http://54.186.147.144/WorkingApp/"
#define KWEBSERVICE_BASE_URL_IMAGE              @"http://54.186.147.144/WorkingApp/"

#define kWEBSERVICE_SIGNIN                      @"User/login"
#define kWEBSERVICE_SIGNIN_FACEBOOK             @"User/facebookLogin"
#define kWEBSERVICE_SIGNUP                      @"User/createAccount"
#define kWEBSERVICE_SET_COVER                   @"User/updateCover"
#define kWEBSERVICE_FORGET_PASSWORD             @"User/forgotpassword"
#define kWEBSERVICE_CHANGE_PASSWORD             @"Users/changePassword"
#define kWEBSERVICE_UPDATE_PROFILE              @"User/updateProfile"

#define kWEBSERVICE_DELETE_ACCOUNT              @"Users/deleteAccount"

#define kWEBSERVICE_SEND_FRIEND_REQUEST         @"Invitation/addUser"
#define kWEBSERVICE_GET_REQUEST                 @"Invitation/getInvitations"
#define kWEBSERVICE_UPDATING_INVITATION         @"Invitation/approvedRejectInvitations"
#define kWEBSERVICE_GET_CHAT_SESSION            @"message/getSessions/"

#define kWEBSERVICE_GET_FRIENDS                 @"Friend/getFriends"
#define kWWEBSERVICE_GET_OFFLINE_MSGS           @"message/receiveMessage"
#define kWEBSERVICE_VERIFY_CODE                 @"User/verifyCode"
#define kWEBSERVICE_SEND_IMAGE                  @"Message/addmedia"

#define kWEBSERVICE_UPDATE_LOCATION             @"locations/addlocation"
#define kWEBSERVICE_UPDATE_LOCATION_SETTINGS    @"locations/locationSetting"

#endif
