//
//  GPTDSDeviceInformation.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSDeviceInformation : NSObject

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)deviceInformationDict;

@property (nonatomic, copy, readonly) NSDictionary<NSString *, id> *dictionaryValue;

@end

NS_ASSUME_NONNULL_END
