//
//  UIFont+DefaultFonts.m
//  Guavapay3DS2
//

#import "UIFont+DefaultFonts.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UIFont (DefaultFonts)

+ (UIFont *)_gptds_defaultHeadingTextFont {
    UIFontDescriptor *fontDescriptor = [[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    
    return [UIFont fontWithDescriptor:fontDescriptor size:fontDescriptor.pointSize];
}

+ (UIFont *)_gptds_defaultLabelTextFontWithScale:(CGFloat)scale {
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];

    return [UIFont fontWithDescriptor:fontDescriptor size:fontDescriptor.pointSize * scale];
}

+ (UIFont *)_gptds_defaultBoldLabelTextFontWithScale:(CGFloat)scale  {
    UIFontDescriptor *fontDescriptor = [[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    
    return [UIFont fontWithDescriptor:fontDescriptor size:fontDescriptor.pointSize * scale];
}

@end

NS_ASSUME_NONNULL_END
