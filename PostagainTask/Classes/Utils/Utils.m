//
//  Utils.m
//  Ask For Papers
//
//  Created by Uzair on 02/02/2013.
//  Copyright (c) 2013 Axact. All rights reserved.
//

#import "Utils.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "Constants.h"
#import "Reachability.h"
#import "UIView+TKGeometry.h"
#import "Alert.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation Utils

+ (void)showAlert:(NSString*)title description:(NSString*)description{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

+ (BOOL)isEmpty:(NSString *)strng
{
	if([[strng stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
		return TRUE;
	else return FALSE;
	
}

+(void) setUserDefaultValue:(NSString *) value ForKey:(NSString *) key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(id) getUserDefaultValueForKey:(NSString *) key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(void) removeUserDefaultValueForKey:(NSString *) key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

+(NSDateComponents *)getDateComponents:(NSDate *)startDate EndDate:(NSDate *)endDate
{
	NSCalendar *sysCalendar = [NSCalendar currentCalendar];
	
	unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	
	NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:startDate  toDate:endDate  options:0];
	
	return conversionInfo;
}

+(NSString *) getDuration:(NSDate *) startDate  EndDate:(NSDate *) endDate
{
    NSDateComponents *conversionInfo = [Utils getDateComponents:startDate EndDate:endDate];
    
	NSString *recordingLength = [NSString stringWithFormat:@"%02ld:%02ld" ,(long)[conversionInfo minute], (long)[conversionInfo second]];
    
    
    if(conversionInfo.hour)
    {
        recordingLength = [NSString stringWithFormat:@"%02ld:%@",(long)conversionInfo.hour, recordingLength];
    }
    
    return recordingLength;
}

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval
{
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds =  ceil(ti % 60) ;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    NSString *recordingLength = [NSString stringWithFormat:@"%02ld:%02ld" ,(long)minutes, (long)seconds];
    
    if(hours > 0)
    {
        recordingLength = [NSString stringWithFormat:@"%02ld:%@",(long)hours, recordingLength];
    }
    
    return recordingLength;
    
}

+ (BOOL)isInternetConnectionAvailable{
    Reachability *r = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus netWorkStatus = [r currentReachabilityStatus];
    
    if((netWorkStatus != ReachableViaWiFi) && (netWorkStatus != ReachableViaWWAN)) {
        [Utils show:@"Connection Failure" andMessage:@"No Internet Connectivity Available"];
        return NO;
    }
    return YES;
}

+ (BOOL)isInternetConnectionAvailableShowAlert:(BOOL)showAlert{
    
    Reachability *r = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus netWorkStatus = [r currentReachabilityStatus];
    
    if((netWorkStatus != ReachableViaWiFi) && (netWorkStatus != ReachableViaWWAN)) {
        if (showAlert)
            [Utils show:@"Connection Failure" andMessage:@"No Internet Connectivity Available"];
        return NO;
    }
    return YES;
}

+ (void) showNoConnectivityAlert {
    [[[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You require an internet connection via Wi-Fi or cellular network." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

+(void) show:(NSString*)title andMessage:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

+(void) show:(NSString*)title andMessage:(NSString*)message withDelegate:(id)delegate{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

+ (BOOL) isIPad {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? YES : NO;
}

+ (BOOL) isSimulator {
    NSString *device = [[UIDevice currentDevice] model];
    return ([device hasSuffix:@"Simulator"]);
}

+ (NSString*)ifNull:(NSString*)string{
    if ([string isKindOfClass:[NSString class]]) {
        return string;
    }
    return @"";
}

#pragma mark
#pragma mark Base 64 encoding

+ (NSString *)encodeBase64:(const uint8_t *)input length:(NSInteger)length
{
    return [NSString stringWithUTF8String:base64_encode(input, (size_t)length)];
}


+ (NSString *)decodeBase64:(NSString *)input length:(NSInteger *)length
{
    size_t retLen;
    uint8_t *retStr = base64_decode([input UTF8String], &retLen);
    if (length)
        *length = (NSInteger)retLen;
    NSString *st = [[NSString alloc] initWithBytes:retStr
                                            length:retLen
                                          encoding:NSUTF8StringEncoding];
    free(retStr);    // If base64_decode returns dynamically allocated memory
    return st;
}

char* base64_encode(const void* buf, size_t size)
{
    static const char base64[] =  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    char* str = (char*) malloc((size+3)*4/3 + 1);
    
    char* p = str;
    unsigned char* q = (unsigned char*) buf;
    size_t i = 0;
    
    while(i < size) {
        int c = q[i++];
        c *= 256;
        if (i < size) c += q[i];
        i++;
        
        c *= 256;
        if (i < size) c += q[i];
        i++;
        
        *p++ = base64[(c & 0x00fc0000) >> 18];
        *p++ = base64[(c & 0x0003f000) >> 12];
        
        if (i > size + 1)
            *p++ = '=';
        else
            *p++ = base64[(c & 0x00000fc0) >> 6];
        
        if (i > size)
            *p++ = '=';
        else
            *p++ = base64[c & 0x0000003f];
    }
    
    *p = 0;
    
    return str;
    //    return NULL;
}

void * base64_decode(const char* s, size_t * data_len)
{
    size_t len = strlen(s);
    
    if (len % 4)
        [NSException raise:@"Invalid input in base64_decode" format:@"%zd is an invalid length for an input string for BASE64 decoding", len];
    
    unsigned char* data = (unsigned char*) malloc(len/4*3);
    
    int n[4];
    unsigned char* q = (unsigned char*) data;
    
    for(const char*p=s; *p; )
    {
        n[0] = POS(*p++);
        n[1] = POS(*p++);
        n[2] = POS(*p++);
        n[3] = POS(*p++);
        
        if (n[0]==-1 || n[1]==-1)
            [NSException raise:@"Invalid input in base64_decode" format:@"Invalid BASE64 encoding"];
        
        if (n[2]==-1 && n[3]!=-1)
            [NSException raise:@"Invalid input in base64_decode" format:@"Invalid BASE64 encoding"];
        
        q[0] = (n[0] << 2) + (n[1] >> 4);
        if (n[2] != -1) q[1] = ((n[1] & 15) << 4) + (n[2] >> 2);
        if (n[3] != -1) q[2] = ((n[2] & 3) << 6) + n[3];
        q += 3;
    }
    
    // make sure that data_len_ptr is not null
    //    if (!data_len_ptr)
    //        [NSException raise:@"Invalid input in base64_decode" format:@"Invalid destination for output string length"];
    
    *data_len = q-data - (n[2]==-1) - (n[3]==-1);
    
    return data;
    //    return NULL;
}

static int POS(char c)
{
    if (c>='A' && c<='Z') return c - 'A';
    if (c>='a' && c<='z') return c - 'a' + 26;
    if (c>='0' && c<='9') return c - '0' + 52;
    if (c == '+') return 62;
    if (c == '/') return 63;
    if (c == '=') return -1;
    
    [NSException raise:@"invalid BASE64 encoding" format:@"Invalid BASE64 encoding"];
    return 0;
}

+(NSString *)getUUID
{
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    NSString * uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);
    
    return uuidString;
}

+ (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

+ (BOOL) isIPhone5{
    
    return (CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 1136)));
}

+ (BOOL)isValidEmailAddress:(NSString *)emailAddress {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailAddress];
}

+ (BOOL)isValidUrl:(NSString *)website{
    
    NSString *urlRegEx =
    @"(http://|https://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:website];
}

+ (BOOL)textFieldEmptyValidation:(NSArray *)fieldsArr{
    
    for (UITextField* mytextfield in fieldsArr){
    
        BOOL check = [self validateFieldErrors:mytextfield];
        if (check == NO)
            return check;
    }
    return YES;
}

+ (BOOL)validateFieldErrors:(UITextField *)field{
    
    int fieldLength = VALIDATION_FIELD_LENGTH;
    NSString *validationType = [field valueForKeyPath:@"validationType"];
    NSString *rawString = [field text];
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0 || [rawString isEqualToString:@""]){
        [Alert show:@"Error" andMessage:VALIDATION_ALL_FIELDS];
        return NO;
    }
    
    if ([field.text length] >= fieldLength && ![validationType isEqualToString:@"Description"]){
        [Alert show:@"Error" andMessage:VALIDATION_MAX_FIELD_LENGTH];
        return NO;
    }

    if ([validationType isEqualToString:@"Name"])
        if (![self isAlphabets:field.text]){
            [Alert show:@"Error" andMessage:VALIDATION_VALID_NAME];
            return NO;
        }
    
    if ([validationType isEqualToString:@"EmailAddress"])
        if (![self isValidEmailAddress:field.text]){
            [Alert show:@"Error" andMessage:VALIDATION_VALID_EMAIL];
            return NO;
        }
    
    if ([validationType isEqualToString:@"Password"])
        if ([field.text length] < VALIDATION_PASSWORD_LENGTH){
            [Alert show:@"Error" andMessage:VALIDATION_PASSWORD_MIN];
            return NO;
        }
    if ([validationType isEqualToString:@"Phone Number"])
        if ([field.text length] > VALIDATION_PHONE_LENGTH){
            [Alert show:@"Error" andMessage:VALIDATION_NUMERIC_PHONE];
            return NO;
        }

    
    return YES;
}

+ (BOOL)textFieldLengthValidation:(NSArray *)fieldsArr withLength:(int)length{
    
    for (UITextField* mytextfield in fieldsArr){
        
        NSString *rawString = [mytextfield text];
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
        if ([trimmed length] == 0 || [rawString length] >= length) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)isNumeric:(NSString*)inputString{
    
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    return [alphaNumbersSet isSupersetOfSet:stringSet];
}

+ (BOOL)isAlphabets:(NSString*)inputString{
    
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ "] invertedSet];
    
    if ([inputString rangeOfCharacterFromSet:set].location != NSNotFound)
        return NO;
    else
        return YES;
}

+ (NSArray *)getObjectsfromPlist:(NSString *)plistName{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray *array      = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    return array;
}

+ (NSDictionary *)getPlistDictionaryAtIndex:(int)index Inplist:(NSString *)plistName{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray *array      = [[NSArray alloc] initWithContentsOfFile:plistPath];
    NSDictionary *dict  = (NSDictionary *)[array objectAtIndex:index];
    
    return dict;
}

+ (BOOL) systemVersionGreaterThanOrEqualTo:(NSString *)versionNumber{
    
    return (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(versionNumber));
    
}

+ (NSString *)prettyStringFromDate:(NSDate *)date{
    NSString * prettyTimestamp;
    
    float delta = [date timeIntervalSinceNow] * -1;
    
    if (delta < 60)
        prettyTimestamp = @"Just Now";
    else if (delta < 120)
        prettyTimestamp = @"One Min Ago";
    else if (delta < 3600)
        prettyTimestamp = [NSString stringWithFormat:@"%d Min Ago", (int) floor(delta/60.0)];
    else if (delta < 7200)
        prettyTimestamp = @"One Hour Ago";
    else if (delta < 86400)
        prettyTimestamp = [NSString stringWithFormat:@"%d Hours Ago", (int) floor(delta/3600.0)];
    else if (delta < ( 86400 * 2 ) )
        prettyTimestamp = @"One Day Ago";
    else if (delta < ( 86400 * 60 ))
        prettyTimestamp = [NSString stringWithFormat:@"%d Days Ago", (int) floor(delta/86400.0)];
    else {
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        
        prettyTimestamp = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    }
    return prettyTimestamp;
}

+ (NSString *)prettyStringServerFromDate:(NSDate *)date withServerDate:(NSDate *)serverDate{
    NSString * prettyTimestamp;
    
    float delta = [date timeIntervalSinceDate:serverDate] * -1;
    
    if (delta < 60)
        prettyTimestamp = @"Just Now";
    else if (delta < 120)
        prettyTimestamp = @"One Min Ago";
    else if (delta < 3600)
        prettyTimestamp = [NSString stringWithFormat:@"%d Min Ago", (int) floor(delta/60.0)];
    else if (delta < 7200)
        prettyTimestamp = @"One Hour Ago";
    else if (delta < 86400)
        prettyTimestamp = [NSString stringWithFormat:@"%d Hours Ago", (int) floor(delta/3600.0)];
    else if (delta < ( 86400 * 2 ) )
        prettyTimestamp = @"One Day Ago";
    else if (delta < ( 86400 * 60 ))
        prettyTimestamp = [NSString stringWithFormat:@"%d Days Ago", (int) floor(delta/86400.0)];
    else {
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        
        prettyTimestamp = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    }
    return prettyTimestamp;
}

+ (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 2000;
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

+ (NSDate *) dateFromString : (NSString *) dateString withFormat : (NSString *) format isUTC:(BOOL)utc{
    
    if (dateString == nil) {
        return nil;
    }
    
    NSDate *date = [NSDate date];
    
    if ([dateString isKindOfClass:[NSNull class]]) {
        return date;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    if(utc)
    {
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];
    }
    
    date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSString *) stringFromDate : (NSDate *) date withFormat : (NSString *) format isUTC:(BOOL)utc {
    
    NSString *dateString           = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if(utc)
    {
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];
    }
    
    if (format) {
        [dateFormatter setDateFormat:format];
    }
    
    
    dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (BOOL) isEmptyOrNull : (NSString *) string {
    if ([Utils isNull:string] || [Utils isEmpty:string]) {
        return TRUE;
    } else {      return FALSE; }
}

+ (BOOL) isNull : (id) object {
    return (object == nil ||  [object isKindOfClass:[NSNull class]] );
}

+ (NSString *)formattedDateTimeWithDate:(NSDate *)date {

    NSDate *someDateInUTC = date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:DATE_FORMAT_NORMAL];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    //[timeFormat setDateFormat:DATE_FORMAT_TIME];

    NSString *nowDate = [dateFormat stringFromDate:[NSDate date]];
    NSString *theDate = [dateFormat stringFromDate:someDateInUTC];
    NSString *theTime = [timeFormat stringFromDate:someDateInUTC];
    
    NSLog(@"\n"
          "theDate: |%@| \n"
          "theTime: |%@| \n"
          , theDate, theTime);
    
    if ([theDate isEqualToString:nowDate]) {
        return theTime;
    }
    return theDate;
}

+ (NSString *)formattedTimeWithDate:(NSDate *)date {
    
    NSDate *someDateInUTC = date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:DATE_FORMAT_NORMAL];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    //[timeFormat setDateFormat:DATE_FORMAT_TIME];
    
    NSString *theDate = [dateFormat stringFromDate:someDateInUTC];
    NSString *theTime = [timeFormat stringFromDate:someDateInUTC];
    
    NSLog(@"\n"
          "theDate: |%@| \n"
          "theTime: |%@| \n"
          , theDate, theTime);
    
    return theTime;

}

+(NSString *) getPathWithVideoName:(NSString *)name {
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *myVideosFolderPath = [cachesPath stringByAppendingString:@"Assets"];
    NSError *error;
    NSString *cacheFile;
    if (![[NSFileManager defaultManager] fileExistsAtPath:myVideosFolderPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:myVideosFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    //cacheFile = [cachesPath stringByAppendingPathComponent:MY_VIDEOS_FOLDER_NAME];
    cacheFile = [myVideosFolderPath stringByAppendingPathComponent:name];
    
    NSLog(@"Cache File: %@", cacheFile);
    cacheFile = [cacheFile stringByReplacingOccurrencesOfString:@":" withString:@"-"];
    return cacheFile;
}

@end
