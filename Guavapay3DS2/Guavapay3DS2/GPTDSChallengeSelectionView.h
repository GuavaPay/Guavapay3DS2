//
//  GPTDSChallengeSelectionView.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>
#import "GPTDSChallengeResponseSelectionInfo.h"
#import "GPTDSLabelCustomization.h"
#import "GPTDSSelectionCustomization.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GPTDSChallengeSelectionStyle) {
    
    /// A display style for selecting a single option.
    GPTDSChallengeSelectionStyleSingle = 0,
    
    /// A display style for selection multiple options.
    GPTDSChallengeSelectionStyleMulti = 1,
};

@interface GPTDSChallengeSelectionView : UIView

@property (nonatomic, strong, readonly) NSArray<id<GPTDSChallengeResponseSelectionInfo>> *currentlySelectedChallengeInfo;
@property (nonatomic, strong) GPTDSLabelCustomization *labelCustomization;
@property (nonatomic, strong) GPTDSSelectionCustomization *selectionCustomization;

- (instancetype)initWithChallengeSelectInfo:(NSArray<id<GPTDSChallengeResponseSelectionInfo>> *)challengeSelectInfo selectionStyle:(GPTDSChallengeSelectionStyle)selectionStyle;

@end

NS_ASSUME_NONNULL_END
