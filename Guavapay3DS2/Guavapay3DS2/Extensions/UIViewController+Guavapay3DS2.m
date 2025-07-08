//
//  UIViewController+Guavapay3DS2.m
//  Guavapay3DS2
//

#import "UIViewController+Guavapay3DS2.h"

#import "UIButton+CustomInitialization.h"
#import "GPTDSUICustomization.h"

@implementation UIViewController (Guavapay3DS2)

- (void)_gptds_setupNavigationBarElementsWithCustomization:(GPTDSUICustomization *)customization cancelButtonSelector:(SEL)cancelButtonSelector {
    GPTDSNavigationBarCustomization *navigationBarCustomization = customization.navigationBarCustomization;

    self.navigationController.navigationBar.barStyle = customization.navigationBarCustomization.barStyle;

    // Cancel button
    GPTDSButtonCustomization *cancelButtonCustomization = [customization buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeCancel];
    UIButton *cancelButton = [UIButton _gptds_buttonWithTitle:navigationBarCustomization.buttonText customization:cancelButtonCustomization];
    // The cancel button's frame has a size of 0 in iOS 8
    cancelButton.frame = CGRectMake(0, 0, cancelButton.intrinsicContentSize.width, cancelButton.intrinsicContentSize.height);
    cancelButton.accessibilityIdentifier = @"Cancel";
    [cancelButton addTarget:self action:cancelButtonSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.rightBarButtonItem = cancelBarButtonItem;

    // Title
    self.title = navigationBarCustomization.headerText;
    NSMutableDictionary *titleTextAttributes = [NSMutableDictionary dictionary];
    UIFont *headerFont = navigationBarCustomization.font;
    if (headerFont) {
        titleTextAttributes[NSFontAttributeName] = headerFont;
    }
    UIColor *headerColor = navigationBarCustomization.textColor;
    if (headerColor) {
        titleTextAttributes[NSForegroundColorAttributeName] = headerColor;
    }
    self.navigationController.navigationBar.titleTextAttributes = titleTextAttributes;

    // Color
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = navigationBarCustomization.barTintColor;
    appearance.shadowColor = nil;
    self.navigationController.navigationBar.standardAppearance = appearance;
    self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
}

@end
