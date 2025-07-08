//
//  GPTDSWhitelistView.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>
#import "GPTDSChallengeResponseSelectionInfo.h"
#import "GPTDSLabelCustomization.h"
#import "GPTDSSelectionCustomization.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSWhitelistView : UIView

@property (nonatomic, strong, nullable) NSString *whitelistText;
@property (nonatomic, readonly, nullable) id<GPTDSChallengeResponseSelectionInfo> selectedResponse;
@property (nonatomic, strong, nullable) GPTDSLabelCustomization *labelCustomization;
@property (nonatomic, strong, nullable) GPTDSSelectionCustomization *selectionCustomization;

@end

NS_ASSUME_NONNULL_END
