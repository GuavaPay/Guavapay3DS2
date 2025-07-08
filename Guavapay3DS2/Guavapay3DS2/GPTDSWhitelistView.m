//
//  GPTDSWhitelistView.m
//  Guavapay3DS2
//

#import "GPTDSLocalizedString.h"
#import "GPTDSWhitelistView.h"
#import "GPTDSStackView.h"
#import "GPTDSChallengeResponseSelectionInfoObject.h"
#import "NSString+EmptyChecking.h"
#import "UIView+LayoutSupport.h"
#import "GPTDSSelectionButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSWhitelistView()

@property (nonatomic, strong) UILabel *whitelistLabel;
@property (nonatomic, strong) GPTDSSelectionButton *selectionButton;

@end

@implementation GPTDSWhitelistView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self _setupViewHierarchy];
    }
    
    return self;
}

- (void)_setupViewHierarchy {
    self.layoutMargins = UIEdgeInsetsZero;
    
    GPTDSStackView *containerView = [[GPTDSStackView alloc] initWithAlignment:GPTDSStackViewLayoutAxisVertical];
    [self addSubview:containerView];
    [containerView _gptds_pinToSuperviewBounds];
    
    self.whitelistLabel = [[UILabel alloc] init];
    self.whitelistLabel.numberOfLines = 0;
    
    self.selectionButton = [[GPTDSSelectionButton alloc] initWithCustomization:self.selectionCustomization];
    self.selectionButton.isCheckbox = YES;
    [self.selectionButton addTarget:self action:@selector(_selectionButtonWasTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIStackView *stackView = [self _buildStackView];
    [stackView addArrangedSubview:self.selectionButton];
    [stackView addArrangedSubview:self.whitelistLabel];

    [containerView addArrangedSubview:stackView];
}

- (void)setWhitelistText:(NSString * _Nullable)whitelistText {
    _whitelistText = whitelistText;
    
    self.whitelistLabel.text = whitelistText;
    self.whitelistLabel.hidden = [NSString _gptds_isStringEmpty:whitelistText];
    self.selectionButton.hidden = self.whitelistLabel.hidden;
}

- (id<GPTDSChallengeResponseSelectionInfo> _Nullable)selectedResponse {
    if (self.selectionButton.selected) {
        return [[GPTDSChallengeResponseSelectionInfoObject alloc] initWithName:@"Y" value:GPTDSLocalizedString(@"Yes", @"The yes answer to a yes or no question.")];;
    }
    
    return [[GPTDSChallengeResponseSelectionInfoObject alloc] initWithName:@"N" value:GPTDSLocalizedString(@"No", @"The no answer to a yes or no question.")];
}

- (void)setLabelCustomization:(GPTDSLabelCustomization * _Nullable)labelCustomization {
    _labelCustomization = labelCustomization;
    
    self.whitelistLabel.font = labelCustomization.font;
    self.whitelistLabel.textColor = labelCustomization.textColor;
}

- (void)setSelectionCustomization:(GPTDSSelectionCustomization * _Nullable)selectionCustomization {
    _selectionCustomization = selectionCustomization;
    self.selectionButton.customization = selectionCustomization;
}

- (UIStackView *)_buildStackView {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFillProportionally;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 20;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    return stackView;
}

- (void)_selectionButtonWasTapped {
    self.selectionButton.selected = !self.selectionButton.selected;
}

@end

NS_ASSUME_NONNULL_END
