//
//  GPTDSChallengeSelectionView.m
//  Guavapay3DS2
//

#import "GPTDSLocalizedString.h"
#import "GPTDSBundleLocator.h"
#import "GPTDSChallengeSelectionView.h"
#import "GPTDSStackView.h"
#import "UIView+LayoutSupport.h"
#import "GPTDSSelectionButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSChallengeResponseSelectionRow: GPTDSStackView

typedef NS_ENUM(NSInteger, GPTDSChallengeResponseSelectionRowStyle) {
    
    /// A display style for showing a radio button.
    GPTDSChallengeResponseSelectionRowStyleRadio = 0,
    
    /// A display style for shows a checkbox.
    GPTDSChallengeResponseSelectionRowStyleCheckbox = 1,
};

typedef void (^GPTDSChallengeResponseRowSelectedBlock)(GPTDSChallengeResponseSelectionRow *);

@property (nonatomic, strong, readonly) id<GPTDSChallengeResponseSelectionInfo> challengeSelectInfo;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, strong) GPTDSLabelCustomization *labelCustomization;
@property (nonatomic, strong) GPTDSSelectionCustomization *selectionCustomization;

- (instancetype)initWithChallengeSelectInfo:(id<GPTDSChallengeResponseSelectionInfo>)challengeSelectInfo rowStyle:(GPTDSChallengeResponseSelectionRowStyle)rowStyle rowSelectedBlock:(GPTDSChallengeResponseRowSelectedBlock)rowSelectedBlock;

@end

@interface GPTDSChallengeResponseSelectionRow()

@property (nonatomic, strong) id<GPTDSChallengeResponseSelectionInfo> challengeSelectInfo;
@property (nonatomic, strong) GPTDSChallengeResponseRowSelectedBlock rowSelectedBlock;
@property (nonatomic) GPTDSChallengeResponseSelectionRowStyle rowStyle;
@property (nonatomic, strong) GPTDSSelectionButton *selectionButton;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UITapGestureRecognizer *valueLabelTapRecognizer;

@end

@implementation GPTDSChallengeResponseSelectionRow

- (instancetype)initWithChallengeSelectInfo:(id<GPTDSChallengeResponseSelectionInfo>)challengeSelectInfo rowStyle:(GPTDSChallengeResponseSelectionRowStyle)rowStyle rowSelectedBlock:(GPTDSChallengeResponseRowSelectedBlock)rowSelectedBlock {
    self = [super initWithAlignment:GPTDSStackViewLayoutAxisHorizontal];

    if (self) {
        _challengeSelectInfo = challengeSelectInfo;
        _rowStyle = rowStyle;
        _rowSelectedBlock = rowSelectedBlock;
        self.isAccessibilityElement = YES;
        self.accessibilityIdentifier = @"GPTDSChallengeResponseSelectionRow";

        [self _setupViewHierarchy];
    }
    
    return self;
}

- (void)_setupViewHierarchy {
    self.selectionButton = [[GPTDSSelectionButton alloc] initWithCustomization:self.selectionCustomization];
    self.selectionButton.customization = self.selectionCustomization;
    [self.selectionButton addTarget:self action:@selector(_rowWasSelected) forControlEvents:UIControlEventTouchUpInside];

    if (self.rowStyle == GPTDSChallengeResponseSelectionRowStyleCheckbox) {
        self.selectionButton.isCheckbox = YES;
    }

    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.text = self.challengeSelectInfo.value;
    self.valueLabel.userInteractionEnabled = YES;
    self.valueLabel.numberOfLines = 0;
    self.valueLabelTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_rowWasSelected)];
    [self.valueLabel addGestureRecognizer:self.valueLabelTapRecognizer];

    if (self.rowStyle == GPTDSChallengeResponseSelectionRowStyleRadio) {
        [self addSpacer:10.0];
    } else {
        [self addSpacer:1.0];
    }
    [self addArrangedSubview:self.selectionButton];
    [self addSpacer:15.0];
    [self addArrangedSubview:self.valueLabel];
    [self addArrangedSubview:[UIView new]];
}

- (void)_rowWasSelected {
    self.rowSelectedBlock(self);
}

- (BOOL)isSelected {
    /// Placeholder until visual and interaction design is complete.
    return self.selectionButton.isSelected;
}

- (void)setSelected:(BOOL)selected {
    /// Placeholder until visual and interaction design is complete.
    self.selectionButton.selected = selected;
}

- (void)setLabelCustomization:(GPTDSLabelCustomization *)labelCustomization {
    _labelCustomization = labelCustomization;
    
    self.valueLabel.font = labelCustomization.font;
    self.valueLabel.textColor = labelCustomization.textColor;
}

- (void)setSelectionCustomization:(GPTDSSelectionCustomization *)selectionCustomization {
    _selectionCustomization = selectionCustomization;
    
    self.selectionButton.customization = selectionCustomization;
}

#pragma mark - UIAccessibility

- (BOOL)accessibilityActivate {
    self.rowSelectedBlock(self);
    return YES;
}

- (nullable NSString *)accessibilityLabel {
    return self.valueLabel.text;
}

- (nullable NSString *)accessibilityValue {
    return self.selected ? GPTDSLocalizedString(@"Selected", @"Indicates that a button is selected.") : GPTDSLocalizedString(@"Unselected", @"Indicates that a button is not selected.");
}

- (UIAccessibilityTraits)accessibilityTraits {
    // remove the selected trait since we manually add that as an accessibilityValue above
    return (self.selectionButton.accessibilityTraits & ~UIAccessibilityTraitSelected);
}

@end

@interface GPTDSChallengeSelectionView()

@property (nonatomic, strong) GPTDSStackView *containerView;
@property (nonatomic, strong) NSArray<GPTDSChallengeResponseSelectionRow *> *challengeSelectionRows;

@property (nonatomic) GPTDSChallengeSelectionStyle selectionStyle;

@end

@implementation GPTDSChallengeSelectionView

static const CGFloat kChallengeSelectionViewTopSinglePadding = 27;
static const CGFloat kChallengeSelectionViewTopMultiplePadding = 15;
static const CGFloat kChallengeSelectionViewBottomPadding = 20;
static const CGFloat kChallengeSelectionViewInterRowVerticalPadding = 28;

- (instancetype)initWithChallengeSelectInfo:(NSArray<id<GPTDSChallengeResponseSelectionInfo>> *)challengeSelectInfo selectionStyle:(GPTDSChallengeSelectionStyle)selectionStyle {
    self = [super init];
    
    if (self) {
        _selectionStyle = selectionStyle;
        _challengeSelectionRows = [self _rowsForChallengeSelectInfo:challengeSelectInfo];

        [self _setupViewHierarchy];
    }
    
    return self;
}

- (void)_setupViewHierarchy {
    self.containerView = [[GPTDSStackView alloc] initWithAlignment:GPTDSStackViewLayoutAxisVertical];
    
    for (GPTDSChallengeResponseSelectionRow *selectionRow in self.challengeSelectionRows) {
        [self.containerView addArrangedSubview:selectionRow];
        
        if (selectionRow != self.challengeSelectionRows.lastObject) {
            [self.containerView addSpacer:kChallengeSelectionViewInterRowVerticalPadding];
        }
    }
    
    if (self.challengeSelectionRows.count > 0) {
        CGFloat topPadding = (_selectionStyle == GPTDSChallengeSelectionStyleSingle) ? kChallengeSelectionViewTopSinglePadding : kChallengeSelectionViewTopMultiplePadding;
        self.layoutMargins = UIEdgeInsetsMake(topPadding, 0, kChallengeSelectionViewBottomPadding, 0);
    } else {
        self.layoutMargins = UIEdgeInsetsZero;
    }
    
    [self addSubview:self.containerView];
    [self.containerView _gptds_pinToSuperviewBounds];
}

- (NSArray<GPTDSChallengeResponseSelectionRow *> *)_rowsForChallengeSelectInfo:(NSArray<id<GPTDSChallengeResponseSelectionInfo>> *)challengeSelectInfo {
    NSMutableArray *challengeRows = [NSMutableArray array];
    GPTDSChallengeResponseSelectionRowStyle rowStyle = self.selectionStyle == GPTDSChallengeSelectionStyleSingle ? GPTDSChallengeResponseSelectionRowStyleRadio : GPTDSChallengeResponseSelectionRowStyleCheckbox;
    
    for (id<GPTDSChallengeResponseSelectionInfo> selectionInfo in challengeSelectInfo) {
        __weak typeof(self) weakSelf = self;
        GPTDSChallengeResponseSelectionRow *challengeRow = [[GPTDSChallengeResponseSelectionRow alloc] initWithChallengeSelectInfo:selectionInfo rowStyle:rowStyle rowSelectedBlock:^(GPTDSChallengeResponseSelectionRow * _Nonnull selectedRow) {
            __strong typeof(self) strongSelf = weakSelf;
            
            [strongSelf _rowWasSelected:selectedRow];
        }];
        
        if (selectionInfo == challengeSelectInfo.firstObject && self.selectionStyle == GPTDSChallengeSelectionStyleSingle) {
            challengeRow.selected = YES;
        }
        
        [challengeRows addObject:challengeRow];
    }
    
    return [challengeRows copy];
}

- (void)_rowWasSelected:(GPTDSChallengeResponseSelectionRow *)selectedRow {
    switch (self.selectionStyle) {
        case GPTDSChallengeSelectionStyleSingle:
            for (GPTDSChallengeResponseSelectionRow *row in self.challengeSelectionRows) {
                row.selected = row == selectedRow;
            }
            
            break;
        case GPTDSChallengeSelectionStyleMulti:
            selectedRow.selected = !selectedRow.isSelected;
            break;
    }
}

- (NSArray<id<GPTDSChallengeResponseSelectionInfo>> *)currentlySelectedChallengeInfo {
    NSMutableArray *selectedChallengeInfo = [NSMutableArray array];
    
    for (GPTDSChallengeResponseSelectionRow *selectionRow in self.challengeSelectionRows) {
        if (selectionRow.isSelected) {
            [selectedChallengeInfo addObject:selectionRow.challengeSelectInfo];
        }
    }
    
    return [selectedChallengeInfo copy];
}

- (void)setLabelCustomization:(GPTDSLabelCustomization *)labelCustomization {
    _labelCustomization = labelCustomization;
    
    for (GPTDSChallengeResponseSelectionRow *row in self.challengeSelectionRows) {
        row.labelCustomization = labelCustomization;
    }
}

- (void)setSelectionCustomization:(GPTDSSelectionCustomization *)selectionCustomization {
    _selectionCustomization = selectionCustomization;
    
    for (GPTDSChallengeResponseSelectionRow *row in self.challengeSelectionRows) {
        row.selectionCustomization = selectionCustomization;
    }
}

@end

NS_ASSUME_NONNULL_END
