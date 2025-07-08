//
//  GPTDSSelectionButton.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>
#import "GPTDSResendButton.h"
#import "GPTDSButtonCustomization.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSResendButton : UIButton

@property (nonatomic) GPTDSButtonCustomization *customization;

- (instancetype)initWithCustomization:(GPTDSButtonCustomization *)customization title:(NSString *)title;

- (void)resetCounter;

@end

NS_ASSUME_NONNULL_END
