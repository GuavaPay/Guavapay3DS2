//
//  GPTDSChallengeInformationView.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>
#import "GPTDSLabelCustomization.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSChallengeInformationView: UIView

@property (nonatomic, strong, nullable) NSString *headerText;
@property (nonatomic, strong, nullable) UIImage *textIndicatorImage;
@property (nonatomic, strong, nullable) NSString *challengeInformationText;
@property (nonatomic, strong, nullable) NSString *challengeInformationLabel;

@property (nonatomic, strong, nullable) GPTDSLabelCustomization *labelCustomization;

@end

NS_ASSUME_NONNULL_END
