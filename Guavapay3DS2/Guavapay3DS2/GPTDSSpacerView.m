//
//  GPTDSSpacerView.m
//  Guavapay3DS2
//

#import "GPTDSSpacerView.h"

@implementation GPTDSSpacerView

- (instancetype)initWithLayoutAxis:(GPTDSStackViewLayoutAxis)layoutAxis dimension:(CGFloat)dimension {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        NSLayoutConstraint *constraint;

        switch (layoutAxis) {
            case GPTDSStackViewLayoutAxisHorizontal:
                constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dimension];
                break;
            case GPTDSStackViewLayoutAxisVertical:
                constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dimension];
                break;
        }
        
        [NSLayoutConstraint activateConstraints:@[constraint]];
    }
    
    return self;
}

@end
