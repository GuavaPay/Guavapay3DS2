//
//  GPTDSUICustomizationTests.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>
#import "GPTDSUICustomization.h"

@interface GPTDSUICustomizationTests : XCTestCase

@end

@implementation GPTDSUICustomizationTests

// The following helper methods return customization objects with properties different than the default.

- (GPTDSNavigationBarCustomization *)_customNavigationBar {
    GPTDSNavigationBarCustomization *custom = [GPTDSNavigationBarCustomization new];
    custom.font = [UIFont italicSystemFontOfSize:1];
    custom.textColor = UIColor.blueColor;
    custom.barTintColor = UIColor.redColor;
    custom.barStyle = UIBarStyleBlack;
    custom.translucent = NO;
    custom.headerText = @"foo";
    custom.buttonText = @"bar";
    return custom;
}

- (GPTDSLabelCustomization *)_customLabel {
    GPTDSLabelCustomization *custom = [GPTDSLabelCustomization new];
    custom.font = [UIFont italicSystemFontOfSize:1];
    custom.textColor = UIColor.blueColor;
    custom.headingTextColor = UIColor.redColor;
    custom.headingFont = [UIFont italicSystemFontOfSize:2];
    return custom;
}

- (GPTDSTextFieldCustomization *)_customTextField {
    GPTDSTextFieldCustomization *custom = [GPTDSTextFieldCustomization new];
    custom.font = [UIFont italicSystemFontOfSize:1];
    custom.textColor = UIColor.blueColor;
    custom.borderWidth = -1;
    custom.borderColor = UIColor.redColor;
    custom.cornerRadius = -8;
    custom.keyboardAppearance = UIKeyboardAppearanceAlert;
    custom.placeholderTextColor = UIColor.greenColor;
    return custom;
}

- (GPTDSButtonCustomization *)_customButton {
    GPTDSButtonCustomization *custom = [[GPTDSButtonCustomization alloc] initWithBackgroundColor:UIColor.redColor cornerRadius:-1];
    custom.font = [UIFont italicSystemFontOfSize:1];
    custom.textColor = UIColor.blueColor;
    custom.titleStyle = GPTDSButtonTitleStyleLowercase;
    return custom;
}

- (GPTDSFooterCustomization *)_customFooter {
    GPTDSFooterCustomization *custom = [GPTDSFooterCustomization new];
    custom.font = [UIFont italicSystemFontOfSize:1];
    custom.textColor = UIColor.blueColor;
    custom.backgroundColor = UIColor.redColor;
    custom.chevronColor = UIColor.greenColor;
    custom.headingTextColor = UIColor.grayColor;
    custom.headingFont = [UIFont italicSystemFontOfSize:2];
    return custom;
}

- (GPTDSSelectionCustomization *)_customSelection {
    GPTDSSelectionCustomization *custom = [GPTDSSelectionCustomization new];
    custom.primarySelectedColor = UIColor.redColor;
    custom.secondarySelectedColor = UIColor.blueColor;
    custom.unselectedBorderColor = UIColor.brownColor;
    custom.unselectedBackgroundColor = UIColor.cyanColor;
    return custom;
}

#pragma mark - Copying

- (void)testUICustomizationDeepCopy {
    // Make a GPTDSUICustomization instance with all non-default properties
    GPTDSButtonCustomization *submitButtonCustomization = [self _customButton];
    GPTDSButtonCustomization *continueButtonCustomization = [self _customButton];
    continueButtonCustomization.cornerRadius = -2;
    GPTDSButtonCustomization *nextButtonCustomization = [self _customButton];
    nextButtonCustomization.cornerRadius = -3;
    GPTDSButtonCustomization *cancelButtonCustomization = [self _customButton];
    cancelButtonCustomization.cornerRadius = -4;
    GPTDSButtonCustomization *resendButtonCustomization = [self _customButton];
    resendButtonCustomization.cornerRadius = -5;
    
    GPTDSNavigationBarCustomization *navigationBarCustomization = [self _customNavigationBar];
    GPTDSLabelCustomization *labelCustomization = [self _customLabel];
    GPTDSTextFieldCustomization *textFieldCustomization = [self _customTextField];
    GPTDSFooterCustomization *footerCustomization = [self _customFooter];
    GPTDSSelectionCustomization *selectionCustomization = [self _customSelection];
    
    GPTDSUICustomization *uiCustomization = [[GPTDSUICustomization alloc] init];
    uiCustomization.footerCustomization = footerCustomization;
    uiCustomization.selectionCustomization = selectionCustomization;
    [uiCustomization setButtonCustomization:submitButtonCustomization forType:GPTDSUICustomizationButtonTypeSubmit];
    [uiCustomization setButtonCustomization:continueButtonCustomization forType:GPTDSUICustomizationButtonTypeContinue];
    [uiCustomization setButtonCustomization:nextButtonCustomization forType:GPTDSUICustomizationButtonTypeNext];
    [uiCustomization setButtonCustomization:cancelButtonCustomization forType:GPTDSUICustomizationButtonTypeCancel];
    [uiCustomization setButtonCustomization:resendButtonCustomization forType:GPTDSUICustomizationButtonTypeResend];
    uiCustomization.navigationBarCustomization = navigationBarCustomization;
    uiCustomization.labelCustomization = labelCustomization;
    uiCustomization.textFieldCustomization = textFieldCustomization;
    uiCustomization.backgroundColor = UIColor.redColor;
    uiCustomization.activityIndicatorViewStyle = UIActivityIndicatorViewStyleLarge;
    uiCustomization.blurStyle = UIBlurEffectStyleDark;
    uiCustomization.preferredStatusBarStyle = UIStatusBarStyleLightContent;
    
    GPTDSUICustomization *copy = [uiCustomization copy];
    XCTAssertNotNil([copy buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeNext]);
    XCTAssertNotNil(copy.navigationBarCustomization);
    XCTAssertNotNil(copy.labelCustomization);
    XCTAssertNotNil(copy.textFieldCustomization);
    XCTAssertNotNil(copy.footerCustomization);
    XCTAssertNotNil(copy.selectionCustomization);
    
    /// The pointers do not reference the same objects.
    XCTAssertNotEqual([uiCustomization buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeSubmit], [copy buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeSubmit]);
    XCTAssertNotEqual([uiCustomization buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeContinue], [copy buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeContinue]);
    XCTAssertNotEqual([uiCustomization buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeNext], [copy buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeNext]);
    XCTAssertNotEqual([uiCustomization buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeCancel], [copy buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeCancel]);
    XCTAssertNotEqual([uiCustomization buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeResend], [copy buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeResend]);
    XCTAssertNotEqual(uiCustomization.navigationBarCustomization, copy.navigationBarCustomization);
    XCTAssertNotEqual(uiCustomization.labelCustomization, copy.labelCustomization);
    XCTAssertNotEqual(uiCustomization.textFieldCustomization, copy.textFieldCustomization);
    XCTAssertNotEqual(uiCustomization.footerCustomization, copy.footerCustomization);
    XCTAssertNotEqual(uiCustomization.selectionCustomization, copy.selectionCustomization);
    
    /// The properties have been successfully copied.
    XCTAssertEqualObjects(uiCustomization.backgroundColor, copy.backgroundColor);
    XCTAssertEqual(uiCustomization.activityIndicatorViewStyle, copy.activityIndicatorViewStyle);
    XCTAssertEqual(uiCustomization.blurStyle, copy.blurStyle);
    // A different test case will cover that our custom classes implemented copy correctly; just sanity check one property here
    XCTAssertEqual([uiCustomization buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeSubmit].cornerRadius, submitButtonCustomization.cornerRadius);
    XCTAssertEqual([uiCustomization buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeContinue].cornerRadius, continueButtonCustomization.cornerRadius);
    XCTAssertEqual([uiCustomization buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeNext].cornerRadius, nextButtonCustomization.cornerRadius);
    XCTAssertEqual([uiCustomization buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeCancel].cornerRadius, cancelButtonCustomization.cornerRadius);
    XCTAssertEqual([uiCustomization buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeResend].cornerRadius, resendButtonCustomization.cornerRadius);
    XCTAssertEqualObjects(uiCustomization.navigationBarCustomization.font, copy.navigationBarCustomization.font);
    XCTAssertEqualObjects(uiCustomization.labelCustomization.font, copy.labelCustomization.font);
    XCTAssertEqualObjects(uiCustomization.textFieldCustomization.font, copy.textFieldCustomization.font);
    XCTAssertEqualObjects(uiCustomization.footerCustomization.font, copy.footerCustomization.font);
    XCTAssertEqualObjects(uiCustomization.selectionCustomization.primarySelectedColor, copy.selectionCustomization.primarySelectedColor);
    XCTAssertEqual(uiCustomization.preferredStatusBarStyle, copy.preferredStatusBarStyle);
}

- (void)testButtonCustomizationIsCopied {
    GPTDSButtonCustomization *buttonCustomization = [self _customButton];

    /// The pointers do not reference the same objects.
    GPTDSButtonCustomization *copy = [buttonCustomization copy];
    XCTAssertNotEqual(buttonCustomization, copy);

    /// The properties have been successfully copied.
    XCTAssertEqual(buttonCustomization.cornerRadius, copy.cornerRadius);
    XCTAssertEqual(buttonCustomization.backgroundColor, copy.backgroundColor);
    XCTAssertEqual(buttonCustomization.font, copy.font);
    XCTAssertEqual(buttonCustomization.textColor, copy.textColor);
    XCTAssertEqual(buttonCustomization.titleStyle, buttonCustomization.titleStyle);
}

- (void)testNavigationBarCustomizationIsCopied {
    GPTDSNavigationBarCustomization *navigationBarCustomization = [self _customNavigationBar];
    
    /// The pointers do not reference the same objects.
    GPTDSNavigationBarCustomization *copy = [navigationBarCustomization copy];
    XCTAssertNotEqual(navigationBarCustomization, copy);

    /// The properties have been successfully copied.
    XCTAssertEqualObjects(navigationBarCustomization.headerText, copy.headerText);
    XCTAssertEqualObjects(navigationBarCustomization.buttonText, copy.buttonText);
    XCTAssertEqualObjects(navigationBarCustomization.barTintColor, copy.barTintColor);
    XCTAssertEqualObjects(navigationBarCustomization.font, copy.font);
    XCTAssertEqualObjects(navigationBarCustomization.textColor, copy.textColor);
    XCTAssertEqual(navigationBarCustomization.barStyle, copy.barStyle);
    XCTAssertEqual(navigationBarCustomization.translucent, copy.translucent);
}

- (void)testLabelCustomizationIsCopied {
    GPTDSLabelCustomization *labelCustomization = [self _customLabel];

    /// The pointers do not reference the same objects.
    GPTDSLabelCustomization *copy = [labelCustomization copy];
    XCTAssertNotEqual(labelCustomization, copy);

    /// The properties have been successfully copied.
    XCTAssertEqualObjects(labelCustomization.headingTextColor, copy.headingTextColor);
    XCTAssertEqualObjects(labelCustomization.headingFont, copy.headingFont);
    XCTAssertEqualObjects(labelCustomization.font, copy.font);
    XCTAssertEqualObjects(labelCustomization.textColor, copy.textColor);
}

- (void)testTextFieldCustomizationIsCopied {
    GPTDSTextFieldCustomization *textFieldCustomization = [self _customTextField];

    /// The pointers do not reference the same objects.
    GPTDSTextFieldCustomization *copy = [textFieldCustomization copy];
    XCTAssertNotEqual(textFieldCustomization, copy);
    
    /// The properties have been successfully copied.
    XCTAssertEqual(textFieldCustomization.borderWidth, copy.borderWidth);
    XCTAssertEqualObjects(textFieldCustomization.borderColor, copy.borderColor);
    XCTAssertEqual(textFieldCustomization.cornerRadius, copy.cornerRadius);
    XCTAssertEqualObjects(textFieldCustomization.font, copy.font);
    XCTAssertEqualObjects(textFieldCustomization.textColor, copy.textColor);
    XCTAssertEqual(textFieldCustomization.keyboardAppearance, copy.keyboardAppearance);
    XCTAssertEqualObjects(textFieldCustomization.placeholderTextColor, copy.placeholderTextColor);
}

- (void)testFooterCustomizationIsCopied {
    GPTDSFooterCustomization *footerCustomization = [self _customFooter];
    
    /// The pointers do not reference the same objects.
    GPTDSFooterCustomization *copy = [footerCustomization copy];
    XCTAssertNotEqual(footerCustomization, copy);
    
    /// The properties have been successfully copied.
    XCTAssertEqualObjects(footerCustomization.textColor, copy.textColor);
    XCTAssertEqualObjects(footerCustomization.font, copy.font);
    XCTAssertEqualObjects(footerCustomization.backgroundColor, copy.backgroundColor);
    XCTAssertEqualObjects(footerCustomization.chevronColor, copy.chevronColor);
    XCTAssertEqualObjects(footerCustomization.headingTextColor, copy.headingTextColor);
    XCTAssertEqualObjects(footerCustomization.headingFont, copy.headingFont);
}

- (void)testSelectionCustomizationIsCopied {
    GPTDSSelectionCustomization *customization = [self _customSelection];
    
    /// The pointers do not reference the same objects.
    GPTDSSelectionCustomization *copy = [customization copy];
    XCTAssertNotEqual(customization, copy);
    
    /// The properties have been successfully copied.
    XCTAssertEqualObjects(customization.primarySelectedColor, copy.primarySelectedColor);
    XCTAssertEqualObjects(customization.secondarySelectedColor, copy.secondarySelectedColor);
    XCTAssertEqualObjects(customization.unselectedBorderColor, copy.unselectedBorderColor);
    XCTAssertEqualObjects(customization.unselectedBackgroundColor, copy.unselectedBackgroundColor);

}

@end
