//
//  GPTDSSelectionButton.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>

@class GPTDSSelectionCustomization;

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSSelectionButton : UIButton

@property (nonatomic) GPTDSSelectionCustomization *customization;

/// This control can either be styled as a radio button or a checkbox
@property (nonatomic) BOOL isCheckbox;

- (instancetype)initWithCustomization:(GPTDSSelectionCustomization *)customization;

@end

NS_ASSUME_NONNULL_END
