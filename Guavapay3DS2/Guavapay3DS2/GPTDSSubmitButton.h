//  GPTDSSubmitButton.h
//  Guavapay3DS2
//
//  Created by Nikolai Kriuchkov on 10.07.2025.
//


#import <UIKit/UIKit.h>

@class GPTDSButtonCustomization;

@interface GPTDSSubmitButton : UIButton

@property (nonatomic) GPTDSButtonCustomization *customization;

- (instancetype)initWithCustomization:(GPTDSButtonCustomization *)customization title:(NSString *)title;

@end
