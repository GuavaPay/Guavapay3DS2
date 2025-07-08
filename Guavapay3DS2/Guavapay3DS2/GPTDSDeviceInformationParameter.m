//
//  GPTDSDeviceInformationParameter.m
//  Guavapay3DS2
//

#import "GPTDSDeviceInformationParameter.h"

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

#import "GPTDSIPAddress.h"
#import "GPTDSSynchronousLocationManager.h"
#import "GPTDSVisionSupport.h"

NS_ASSUME_NONNULL_BEGIN

// Code value to use if the parameter is restricted by the region or market
static const NSString * const kParameterRestrictedCode = @"RE01";
// Code value to use if the platform version does not support the parameter or the parameter has been deprecated
static const NSString * const kParameterUnavailableCode = @"RE02";
// Code value to use if parameter collection not possible without prompting the user for permission
static const NSString * const kParameterMissingPermissionsCode = @"RE03";
// Code value to use if parameter value returned is null or blank
static const NSString * const kParameterNilCode = @"RE04";

@implementation GPTDSDeviceInformationParameter
{
    NSString *_identifier;
    BOOL  (^ _Nullable _permissionCheck)(void);
    id (^_valueCheck)(void);
}

- (instancetype)initWithIdentifier:(NSString *)identifier
                   permissionCheck:(nullable BOOL (^)(void))permissionCheck
                        valueCheck:(id (^)(void))valueCheck {
    self = [super init];
    if (self) {
        _identifier = [identifier copy];
        _permissionCheck = [permissionCheck copy];
        _valueCheck = [valueCheck copy];
    }

    return self;
}

- (BOOL)_hasPermissions {
    if (_permissionCheck == nil) {
        return YES;
    }
    return _permissionCheck();
}

- (BOOL)_isRestricted {
    static NSSet<NSString *> *sApprovedParameters = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sApprovedParameters = [NSSet setWithObjects:
                                // platform
                                @"C001",
                                // device model
                                @"C002",
                                // OS name
                                @"C003",
                                // OS version
                                @"C004",
                                // locale
                                @"C005",
                                // time zone
                                @"C006",
                                // advertising id (i.e. hardware id)
                                @"C007",
                                // screen solution
                                @"C008",
                                // SDK App identifier
                                @"C014",
                                nil
                                ];
    });

    return ![sApprovedParameters containsObject:_identifier];
}

- (void)collectIgnoringRestrictions:(BOOL)ignoreRestrictions withHandler:(void (^)(BOOL, NSString *, id))handler {
    if (!ignoreRestrictions && [self _isRestricted]) {
        handler(NO, _identifier, kParameterRestrictedCode);
        return;
    } else if (![self _hasPermissions]) {
        handler(NO, _identifier, kParameterMissingPermissionsCode);
        return;
    }

    NSAssert(_valueCheck != nil, @"GPTDSDeviceInformationParameter should not have nil _valueCheck.");
    id value = _valueCheck != nil ? _valueCheck() : nil;

    handler(value != nil, _identifier, value ?: kParameterUnavailableCode);
}

+ (NSArray<GPTDSDeviceInformationParameter *> *)allParameters {
    static NSArray<GPTDSDeviceInformationParameter *> *allParameters = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allParameters = @[

#pragma mark - Common Parameters

                          [GPTDSDeviceInformationParameter platform],
                          [GPTDSDeviceInformationParameter deviceModel],
                          [GPTDSDeviceInformationParameter OSName],
                          [GPTDSDeviceInformationParameter OSVersion],
                          [GPTDSDeviceInformationParameter locale],
                          [GPTDSDeviceInformationParameter timeZone],
                          [GPTDSDeviceInformationParameter dateTime],
                          [GPTDSDeviceInformationParameter screenResolution],
                          [GPTDSDeviceInformationParameter deviceName],
                          [GPTDSDeviceInformationParameter IPAddress],
                          [GPTDSDeviceInformationParameter latitude],
                          [GPTDSDeviceInformationParameter longitude],
                          [GPTDSDeviceInformationParameter applicationPackageName],
                          [GPTDSDeviceInformationParameter sdkAppId],
                          [GPTDSDeviceInformationParameter sdkVersion],


#pragma mark - iOS-Specific Parameters

                          [GPTDSDeviceInformationParameter identiferForVendor],
                          [GPTDSDeviceInformationParameter userInterfaceIdiom],
                          [GPTDSDeviceInformationParameter familyNames],
                          [GPTDSDeviceInformationParameter fontNamesForFamilyName],
                          [GPTDSDeviceInformationParameter systemFont],
                          [GPTDSDeviceInformationParameter labelFontSize],
                          [GPTDSDeviceInformationParameter buttonFontSize],
                          [GPTDSDeviceInformationParameter smallSystemFontSize],
                          [GPTDSDeviceInformationParameter systemFontSize],
                          [GPTDSDeviceInformationParameter systemLocale],
                          [GPTDSDeviceInformationParameter availableLocaleIdentifiers],
                          [GPTDSDeviceInformationParameter preferredLanguages],
                          [GPTDSDeviceInformationParameter defaultTimeZone],
                          [GPTDSDeviceInformationParameter appStoreReciptURL],
                          [GPTDSDeviceInformationParameter appStoreReceiptExists],
                          ];


    });

    return allParameters;
}

+ (instancetype)platform {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"C001"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                               return @"iOS";
                                                           }];
}

+ (instancetype)deviceModel {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"C002"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                               return [[UIDevice currentDevice] model];
                                                           }];
}

+ (instancetype)OSName {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"C003"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                               return [[UIDevice currentDevice] systemName];
                                                           }];
}

+ (instancetype)OSVersion {
    return  [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"C004"
                                                       permissionCheck:nil
                                                            valueCheck:^id _Nullable{
                                                                return [[UIDevice currentDevice] systemVersion];
                                                            }];
}

+ (instancetype)locale {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"C005"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                               NSLocale *locale = [NSLocale currentLocale];
                                                               NSString *language = locale.languageCode;
                                                               NSString *country = locale.countryCode;
                                                               if (language != nil && country != nil) {
                                                                   return [@[language, country] componentsJoinedByString:@"-"];
                                                               } else {
                                                                   return nil;
                                                               }
                                                           }];
}

+ (instancetype)timeZone {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"C006"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                                NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
                                                                NSInteger secondsFromGMT = [localTimeZone secondsFromGMT];
                                                                
                                                                // Convert the offset to minutes
                                                                NSInteger minutesFromGMT = secondsFromGMT / 60;
                                                               
                                                                NSString *utcOffsetString = [NSString stringWithFormat:@"%ld", (long)minutesFromGMT];
                                                                
                                                                return utcOffsetString;
                                                           }];
}

+ (instancetype)screenResolution {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"C008"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
#if STP_TARGET_VISION
        // Offer something reasonable
        CGRect boundsInPixels = CGRectMake(0, 0, 512, 342);
#else
        CGRect boundsInPixels = [UIScreen mainScreen].nativeBounds;
#endif
                                                               return [NSString stringWithFormat:@"%ldx%ld", (long)boundsInPixels.size.width, (long)boundsInPixels.size.height];

                                                           }];
}

+ (instancetype)deviceName
{
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"C009"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                               return [UIDevice currentDevice].localizedModel;
                                                           }];
}

+ (instancetype)IPAddress {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"C010"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                               return GPTDSCurrentDeviceIPAddress();
                                                           }];
}

+ (instancetype)latitude {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"C011"
                                                      permissionCheck:^BOOL{
                                                          return [GPTDSSynchronousLocationManager hasPermissions];
                                                      }
                                                           valueCheck:^id _Nullable{
                                                               CLLocation *location = [[GPTDSSynchronousLocationManager sharedManager] deviceLocation];
                                                               return location != nil ? @(location.coordinate.latitude).stringValue : nil;
                                                           }];
}

+ (instancetype)longitude {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"C012"
                                                      permissionCheck:^BOOL{
                                                          return [GPTDSSynchronousLocationManager hasPermissions];
                                                      }
                                                           valueCheck:^id _Nullable{
                                                               CLLocation *location = [[GPTDSSynchronousLocationManager sharedManager] deviceLocation];
                                                               return location != nil ? @(location.coordinate.longitude).stringValue : nil;
                                                           }];
}

+ (instancetype)applicationPackageName {
    /*
     The unique package name/bundle identifier of the application in which the
     3DS SDK is embedded.
     • iOS: obtained from the [NSBundle mainBundle] bundleIdentifier
     property.
     */
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"C013"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                               return [[NSBundle mainBundle] bundleIdentifier];
                                                           }];
}


+ (instancetype)sdkAppId {
    /*
     Universally unique ID that is created for each installation of the 3DS
     Requestor App on a Consumer Device.
     Note: This should be the same ID that is passed to the Requestor App in
     the AuthenticationRequestParameters object (Refer to Section
     4.12.1 in the EMV 3DS SDK Specification).
     */
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"C014"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                            return [GPTDSDeviceInformationParameter sdkAppIdentifier];
                                                           }];
}


+ (instancetype)sdkVersion {
    /*
     3DS SDK version as applied by the implementer and stored securely in the
     SDK (refer to Req 58 in the EMV 3DS SDK Specification).
     */
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"C015"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                               return @"2.2.0";
                                                           }];
}



+ (instancetype)dateTime {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"C017"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                                NSDate *currentDate = [NSDate date];
                                                                
                                                                // Create a date formatter
                                                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                                                
                                                                // Set the time zone to UTC
                                                                [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                                                                
                                                                // Set the desired date format: YYYYMMDDHHMMSS
                                                                [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
                                                                
                                                                // Convert the current date to the formatted string
                                                                NSString *utcDateString = [dateFormatter stringFromDate:currentDate];
                                                                
                                                                return utcDateString;
                                                           }];
}

+ (instancetype)identiferForVendor {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"I001"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                               // N.B. This can return nil if the device is locked
                                                               // We've decided to mark this case and similar as parameter unavailable,
                                                               // even though we have permission and the device _can_ provide it when
                                                               // it's in a different state
                                                               return [UIDevice currentDevice].identifierForVendor.UUIDString;
                                                           }];
}

+ (instancetype)userInterfaceIdiom {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"I002"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                                switch ([UIDevice currentDevice].userInterfaceIdiom) {
                                                                    case UIUserInterfaceIdiomUnspecified:
                                                                    case UIUserInterfaceIdiomVision:
                                                                        return @"Unspecified";
                                                                    case UIUserInterfaceIdiomPhone:
                                                                        return @"iPhone";
                                                                    case UIUserInterfaceIdiomPad:
                                                                        return @"iPad";
                                                                    case UIUserInterfaceIdiomTV:
                                                                        return @"TV";
                                                                    case UIUserInterfaceIdiomCarPlay:
                                                                        return @"carPlay";
                                                                    case UIUserInterfaceIdiomMac:
                                                                        return @"Mac";
                                                                }
                                                           }];
}

+ (instancetype)familyNames {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"I003"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                               return UIFont.familyNames;
                                                           }];
}

+ (instancetype)fontNamesForFamilyName {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"I004"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                               NSArray *fontNames = [UIFont fontNamesForFamilyName:[UIFont systemFontOfSize:[UIFont systemFontSize]].familyName];
                                                               if (fontNames.count == 0) {
                                                                   return @[@""]; // Workaround for TC_SDK_10176_001
                                                               }
                                                               return fontNames;
                                                           }];
}

+ (instancetype)systemFont {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"I005"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                               return [UIFont systemFontOfSize:[UIFont systemFontSize]].fontName;
                                                           }];
}

+ (instancetype)labelFontSize {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"I006"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                               return @([UIFont labelFontSize]).stringValue;
                                                           }];
}

+ (instancetype)buttonFontSize {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"I007"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                               return @([UIFont buttonFontSize]).stringValue;
                                                           }];
}

+ (instancetype)smallSystemFontSize {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"I008"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                               return @([UIFont smallSystemFontSize]).stringValue;
                                                           }];
}

+ (instancetype)systemFontSize {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"I009"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                               return @([UIFont systemFontSize]).stringValue;
                                                           }];
}

+ (instancetype)systemLocale {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"I010"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                                NSLocale *locale = [NSLocale systemLocale];
                                                                NSString *language = locale.languageCode;
                                                                NSString *country = locale.countryCode;
                                                                if (language != nil && country != nil) {
                                                                    return [@[language, country] componentsJoinedByString:@"-"];
                                                                } else {
                                                                    return nil;
                                                                }
                                                           }];
}

+ (instancetype)availableLocaleIdentifiers {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"I011"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                               return [NSLocale availableLocaleIdentifiers];
                                                           }];
}

+ (instancetype)preferredLanguages {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"I012"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                               return [NSLocale preferredLanguages];
                                                           }];
}

+ (instancetype)defaultTimeZone {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"I013"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable{
                                                            NSTimeZone *defaultTimeZone = [NSTimeZone defaultTimeZone];
                                                            NSInteger secondsFromGMT = [defaultTimeZone secondsFromGMT];
                                                            
                                                            // Convert the offset to minutes
                                                            NSInteger minutesFromGMT = secondsFromGMT / 60;
                                                           
                                                            NSString *utcOffsetString = [NSString stringWithFormat:@"%ld", (long)minutesFromGMT];
                                                            
                                                            return utcOffsetString;
                                                           }];
}

+ (instancetype)appStoreReciptURL {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"I014"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable {
                                                                NSString *appStoreReceiptURL = [[NSBundle mainBundle] appStoreReceiptURL].absoluteString;
                                                                if (appStoreReceiptURL) {
                                                                    return appStoreReceiptURL;
                                                                }
                                                                return kParameterNilCode;
                                                           }];
}

+ (instancetype)appStoreReceiptExists {
    return [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"I015"
                                                      permissionCheck:nil
                                                           valueCheck:^id _Nullable {
                                                                // Get the receipt file URL from the app's bundle
                                                                NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
                                                                
                                                                // Check if the file exists and is non-empty
                                                                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[receiptURL path]];
                                                                BOOL isFileNonEmpty = [[[NSFileManager defaultManager] attributesOfItemAtPath:[receiptURL path] error:nil] fileSize] > 0;
                                                                
                                                                // Return "true" if the receipt file exists and is non-empty, otherwise "false"
                                                                if (fileExists && isFileNonEmpty) {
                                                                    return @"true";
                                                                } else {
                                                                    return @"false";
                                                                }
                                                           }];
}

+ (NSString *)sdkAppIdentifier {
    static NSString * const appIdentifierKeyPrefix = @"GPTDSGuavapay3DS2AppIdentifierKey";
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] ?: @"";
    NSString *appIdentifierUserDefaultsKey = [appIdentifierKeyPrefix stringByAppendingString:appVersion];
    NSString *appIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:appIdentifierUserDefaultsKey];
    if (appIdentifier == nil) {
        appIdentifier = [[NSUUID UUID] UUIDString].lowercaseString;
        // Clean up any previous app identifiers
        NSSet *previousKeys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] keysOfEntriesPassingTest:^BOOL (NSString *key, id obj, BOOL *stop) {
            return [key hasPrefix:appIdentifierKeyPrefix] && ![key isEqualToString:appIdentifierUserDefaultsKey];
        }];
        for (NSString *key in previousKeys) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:appIdentifier forKey:appIdentifierUserDefaultsKey];
    return appIdentifier;
}

@end

NS_ASSUME_NONNULL_END
