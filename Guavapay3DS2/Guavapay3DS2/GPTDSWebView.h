//
//  GPTDSWebView.h
//  Guavapay3DS2
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSWebView : WKWebView

/**
 Convenience method that prepends the given HTML string with a CSP meta tag that disables external resource loading, and passes it to `loadHTMLString:baseURL:`.
 */
- (WKNavigation *)loadExternalResourceBlockingHTMLString:(NSString *)html;

@end

NS_ASSUME_NONNULL_END
