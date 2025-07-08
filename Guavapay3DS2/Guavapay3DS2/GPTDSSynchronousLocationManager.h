//
//  GPTDSSynchronousLocationManager.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

@class CLLocation;

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSSynchronousLocationManager : NSObject

+ (instancetype)sharedManager;

+ (BOOL)hasPermissions;

// May be long running. Will return nil on failure or if app lacks permissions
- (nullable CLLocation *)deviceLocation;

@end

NS_ASSUME_NONNULL_END
