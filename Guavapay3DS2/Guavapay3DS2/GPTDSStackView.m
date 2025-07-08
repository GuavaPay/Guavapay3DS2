//
//  GPTDSStackView.m
//  Guavapay3DS2
//

#import "GPTDSStackView.h"
#import "GPTDSSpacerView.h"
#import "NSLayoutConstraint+LayoutSupport.h"
#import "UIColor+DefaultColors.h"

@interface GPTDSStackView()

@property (nonatomic) GPTDSStackViewLayoutAxis layoutAxis;
@property (nonatomic, strong) NSMutableArray<UIView *> *arrangedSubviews;
@property (nonatomic, strong, readonly) NSArray<UIView *> *visibleArrangedSubviews;

@end

@implementation GPTDSStackView

static NSString *UIViewHiddenKeyPath = @"hidden";

- (instancetype)initWithAlignment:(GPTDSStackViewLayoutAxis)layoutAxis {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        _layoutAxis = layoutAxis;
        _arrangedSubviews = [NSMutableArray array];
    }
    
    return self;
}

- (NSArray<UIView *> *)visibleArrangedSubviews {
    return [self.arrangedSubviews filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *object, NSDictionary *bindings) {
        return !object.isHidden;
    }]];
}

- (void)addArrangedSubview:(UIView *)view {
    view.translatesAutoresizingMaskIntoConstraints = false;
    
    [self _deactivateExistingConstraints];
    
    [self.arrangedSubviews addObject:view];
    [self addSubview:view];
    
    [self _applyConstraints];
    
    [view addObserver:self forKeyPath:UIViewHiddenKeyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeArrangedSubview:(UIView *)view {
    if (![self.arrangedSubviews containsObject:view]) {
        return;
    }
    
    [self _deactivateExistingConstraints];
    
    [view removeObserver:self forKeyPath:UIViewHiddenKeyPath];
    
    [self.arrangedSubviews removeObject:view];
    [view removeFromSuperview];
    
    [self _applyConstraints];
}

- (void)addSpacer:(CGFloat)dimension {
    GPTDSSpacerView *spacerView = [[GPTDSSpacerView alloc] initWithLayoutAxis:self.layoutAxis dimension:dimension];
    
    [self addArrangedSubview:spacerView];
}

- (void)addLine:(CGFloat)inset {
    UIView *borderView = [UIView new];
    UIView *border = [UIView new];
    border.backgroundColor = [UIColor _gptds_borderColor];
    border.translatesAutoresizingMaskIntoConstraints = NO;
    [borderView addSubview:border];
    [NSLayoutConstraint activateConstraints:@[
        [border.heightAnchor constraintEqualToConstant:1.5],
        [border.leadingAnchor constraintEqualToAnchor:borderView.leadingAnchor constant:inset],
        [border.trailingAnchor constraintEqualToAnchor:borderView.trailingAnchor constant:-inset],
        [border.bottomAnchor constraintEqualToAnchor:borderView.bottomAnchor]
    ]];

    [self addArrangedSubview:borderView];
}

- (void)dealloc {
    for (UIView *view in self.arrangedSubviews) {
        [view removeObserver:self forKeyPath:UIViewHiddenKeyPath];
    }
}

- (void)_applyConstraints {
    if (self.layoutAxis == GPTDSStackViewLayoutAxisHorizontal) {
        [self _applyHorizontalConstraints];
    } else {
        [self _applyVerticalConstraints];
    }
}

- (void)_deactivateExistingConstraints {
    [NSLayoutConstraint deactivateConstraints:self.constraints];
}

- (void)_applyVerticalConstraints {
    UIView *previousView;
    
    for (UIView *view in self.visibleArrangedSubviews) {
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint _gptds_leftConstraintWithItem:view toItem:self];
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint _gptds_rightConstraintWithItem:view toItem:self];
        NSLayoutConstraint *topConstraint;
        
        if (previousView == nil) {
            topConstraint = [NSLayoutConstraint _gptds_topConstraintWithItem:view toItem:self];
        } else {
            topConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        }
        
        [NSLayoutConstraint activateConstraints:@[topConstraint, leftConstraint, rightConstraint]];
        
        if (view == self.visibleArrangedSubviews.lastObject) {
            NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint _gptds_bottomConstraintWithItem:view toItem:self];
            
            [NSLayoutConstraint activateConstraints:@[bottomConstraint]];
        }
        
        previousView = view;
    }
}

- (void)_applyHorizontalConstraints {
    UIView *previousView;
    NSLayoutConstraint *previousRightConstraint;
    
    for (UIView *view in self.visibleArrangedSubviews) {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint _gptds_topConstraintWithItem:view toItem:self];
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint _gptds_bottomConstraintWithItem:view toItem:self];
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint _gptds_rightConstraintWithItem:view toItem:self];
        
        if (previousView == nil) {
            NSLayoutConstraint *leftConstraint = [NSLayoutConstraint _gptds_leftConstraintWithItem:view toItem:self];
            
            [NSLayoutConstraint activateConstraints:@[topConstraint, leftConstraint, rightConstraint, bottomConstraint]];
        } else {
            NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
            
            if (previousRightConstraint != nil) {
                [NSLayoutConstraint deactivateConstraints:@[previousRightConstraint]];
            }
            
            NSLayoutConstraint *previousConstraint = [NSLayoutConstraint constraintWithItem:previousView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
            
            [NSLayoutConstraint activateConstraints:@[topConstraint, leftConstraint, rightConstraint, previousConstraint, bottomConstraint]];
        }
        
        previousView = view;
        previousRightConstraint = rightConstraint;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:[UIView class]] && [keyPath isEqualToString:UIViewHiddenKeyPath]) {
        BOOL hiddenStatusChanged = [change[NSKeyValueChangeNewKey] boolValue] != [change[NSKeyValueChangeOldKey] boolValue];

        if (hiddenStatusChanged) {
            [self _deactivateExistingConstraints];
            
            [self _applyConstraints];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
