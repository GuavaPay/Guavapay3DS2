//
//  GPTDSWebView.m
//  Guavapay3DS2
//

#import "GPTDSWebView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSWebView

- (instancetype)init {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.preferences.javaScriptEnabled = NO;
    return [super initWithFrame:CGRectZero configuration:configuration];
}

/// Overriden to do nothing per 3DS2 security guidelines.
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler {

}

- (WKNavigation *)loadExternalResourceBlockingHTMLString:(NSString *)html {
    NSString *cspMetaTag = @"<meta http-equiv=\"Content-Security-Policy\" content=\"default-src 'unsafe-inline'; img-src data:\">";
    return [self loadHTMLString:[cspMetaTag stringByAppendingString:html] baseURL:nil];
}

- (nullable NSString *)accessibilityIdentifier {
    return @"GPTDSWebView";
}

@end

NS_ASSUME_NONNULL_END
