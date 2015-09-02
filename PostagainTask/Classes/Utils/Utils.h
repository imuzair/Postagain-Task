//
//  Utils.h
//  Ask For Papers
//
//  Created by Uzair on 02/02/2013.
//  Copyright (c) 2013 Axact. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject {
    
}

+ (void)showAlert:(NSString*)title description:(NSString*)description;

+ (BOOL)isEmpty:(NSString *)strng;

+ (void)setUserDefaultValue:(NSString *) value ForKey:(NSString *) key;
+ (id)getUserDefaultValueForKey:(NSString *) key;
+ (void)removeUserDefaultValueForKey:(NSString *) key;

+ (NSDateComponents *) getDateComponents:(NSDate *)startDate EndDate:(NSDate *)endDate;
+ (NSString *) getDuration:(NSDate *) startDate  EndDate:(NSDate *) endDate;
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval;

+ (BOOL)isInternetConnectionAvailable;
+ (BOOL)isInternetConnectionAvailableShowAlert:(BOOL)showAlert;
+ (void)showNoConnectivityAlert;

+ (void) show:(NSString*)title andMessage:(NSString*)message;
+ (void) show:(NSString*)title andMessage:(NSString*)message withDelegate:(id)delegate;

+ (BOOL) isIPad;
+ (BOOL) isSimulator;
+ (BOOL) isIPhone5;

+ (NSString*)ifNull:(NSString*)string;

+ (BOOL) systemVersionGreaterThanOrEqualTo:(NSString *)versionNumber;

#pragma mark
#pragma mark Base 64 encoding

+ (NSString *)encodeBase64:(const uint8_t *)input length:(NSInteger)length;
+ (NSString *)decodeBase64:(NSString *)input length:(NSInteger *)length;

char* base64_encode(const void* buf, size_t size);
void * base64_decode(const char* s, size_t * data_len);


#pragma mark - Receipt Validation

+(NSString *)getUUID;

# pragma mark - Validation

+ (BOOL)isValidEmailAddress:(NSString *)emailAddress;
+ (BOOL)isValidUrl:(NSString *)website;
+ (BOOL)textFieldEmptyValidation:(NSArray *)fieldsArr;
+ (BOOL)textFieldLengthValidation:(NSArray *)fieldsArr withLength:(int)length;
+ (BOOL)isNumeric:(NSString*)inputString;
+ (BOOL)isAlphabets:(NSString*)inputString;

+ (NSArray *)getObjectsfromPlist:(NSString *)plistName;
+ (NSDictionary *)getPlistDictionaryAtIndex:(int)index Inplist:(NSString *)plistName;
+ (NSString *)prettyStringFromDate:(NSDate *)date;
+ (NSString *)prettyStringServerFromDate:(NSDate *)date withServerDate:(NSDate *)serverDate;

+ (UIImage *)scaleAndRotateImage:(UIImage *)image;

+ (NSDate *) dateFromString : (NSString *) dateString withFormat : (NSString *) format isUTC:(BOOL)utc;
+ (NSString *) stringFromDate : (NSDate *) date withFormat : (NSString *) format isUTC:(BOOL)utc;
+ (BOOL) isEmptyOrNull : (NSString *) string;
+ (NSString *)formattedDateTimeWithDate:(NSDate *)date;
+ (NSString *)formattedTimeWithDate:(NSDate *)date;
+ (BOOL) isNull : (id) object;
+(NSString *) getPathWithVideoName:(NSString *)name;
@end
