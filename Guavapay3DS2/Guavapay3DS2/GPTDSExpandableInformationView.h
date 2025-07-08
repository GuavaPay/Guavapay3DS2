//
//  GPTDSExpandableInformationView.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>
#import "GPTDSFooterCustomization.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSExpandableInformationView : UIView

@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) NSString *text;
@property (nonatomic, strong, nullable) GPTDSFooterCustomization *customization;
@property (nonatomic, strong, nullable) void (^didTap)(void);

@end

NS_ASSUME_NONNULL_END
