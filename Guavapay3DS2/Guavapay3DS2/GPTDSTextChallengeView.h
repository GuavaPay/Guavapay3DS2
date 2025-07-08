//
//  GPTDSTextChallengeView.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>
#import "GPTDSTextFieldCustomization.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSTextField: UITextField

@end

@interface GPTDSTextChallengeView : UIView

@property (nonatomic, strong, nullable) GPTDSTextFieldCustomization *textFieldCustomization;
@property (nonatomic, copy, readonly, nullable) NSString *inputText;
@property (nonatomic, strong) GPTDSTextField *textField;

@end

NS_ASSUME_NONNULL_END
