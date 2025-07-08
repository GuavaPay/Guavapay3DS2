//
//  NSLayoutConstraint+LayoutSupport.m
//  Guavapay3DS2
//

#import "NSLayoutConstraint+LayoutSupport.h"

@implementation NSLayoutConstraint (LayoutSupport)


+ (NSLayoutConstraint *)_gptds_topConstraintWithItem:(id)view1 toItem:(id)view2 {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeTop multiplier:1 constant:0];
}

+ (NSLayoutConstraint *)_gptds_leftConstraintWithItem:(id)view1 toItem:(id)view2 {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
}

+ (NSLayoutConstraint *)_gptds_rightConstraintWithItem:(id)view1 toItem:(id)view2 {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeRight multiplier:1 constant:0];
}

+ (NSLayoutConstraint *)_gptds_bottomConstraintWithItem:(id)view1 toItem:(id)view2 {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
}

@end
