//
//  GPTDSSpacerView.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>
#import "GPTDSStackView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSSpacerView : UIView

- (instancetype)initWithLayoutAxis:(GPTDSStackViewLayoutAxis)layoutAxis dimension:(CGFloat)dimension;

@end

NS_ASSUME_NONNULL_END
