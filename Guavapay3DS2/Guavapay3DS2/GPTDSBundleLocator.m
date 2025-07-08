//
//  GPTDSBundleLocator.m
//  Guavapay3DS2
//  Based on STPBundleLocator.m in Guavapay.framework
//

#import "GPTDSBundleLocator.h"

/**
 Using a private class to ensure that it can't be subclassed, which may
 change the result of `bundleForClass`
 */
@interface GPTDSBundleLocatorInternal : NSObject
@end
@implementation GPTDSBundleLocatorInternal
@end

@implementation GPTDSBundleLocator

// This is copied from SPM's resource_bundle_accessor.m
+ (NSBundle *)gptdsSPMBundle {
    NSString *bundleName = @"Guavapay_Guavapay";

    NSArray<NSURL*> *candidates = @[
        NSBundle.mainBundle.resourceURL,
        [NSBundle bundleForClass:[self class]].resourceURL,
        NSBundle.mainBundle.bundleURL
    ];

    for (NSURL* candiate in candidates) {
        NSURL *bundlePath = [candiate URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle", bundleName]];

        NSBundle *bundle = [NSBundle bundleWithURL:bundlePath];
        if (bundle != nil) {
            return bundle;
        }
    }
    
    return nil;
}

+ (NSBundle *)gptdsResourcesBundle {
    /**
     First, find Guavapay.framework.
     Places to check:
     1. Guavapay_Guavapay3DS2.bundle (for SwiftPM)
     1. Guavapay_Guavapay.bundle (for SwiftPM)
     2. Guavapay.bundle (for manual static installations, Fabric, and framework-less Cocoapods)
     3. Guavapay.framework/Guavapay.bundle (for framework-based Cocoapods)
     4. Guavapay.framework (for Carthage, manual dynamic installations)
     5. main bundle (for people dragging all our files into their project)
     **/
    
    static NSBundle *ourBundle;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#ifdef SWIFTPM_MODULE_BUNDLE
        ourBundle = SWIFTPM_MODULE_BUNDLE;
#endif
      
        if (ourBundle == nil) {
            ourBundle = [GPTDSBundleLocator gptdsSPMBundle];
        }

        if (ourBundle == nil) {
            ourBundle = [NSBundle bundleWithPath:@"Guavapay.bundle"];
        }

        if (ourBundle == nil) {
            // This might be the same as the previous check if not using a dynamic framework
            NSString *path = [[NSBundle bundleForClass:[GPTDSBundleLocatorInternal class]] pathForResource:@"Guavapay" ofType:@"bundle"];
            ourBundle = [NSBundle bundleWithPath:path];
        }

        if (ourBundle == nil) {
            // This will be the same as mainBundle if not using a dynamic framework
            ourBundle = [NSBundle bundleForClass:[GPTDSBundleLocatorInternal class]];
        }

        if (ourBundle == nil) {
            ourBundle = [NSBundle mainBundle];
        }
        
        // Once we've found Guavapay.framework, seek around to find Guavapay3DS2.bundle.
        // Try to find Guavapay3DS2 bundle within our current bundle
        NSString *gptdsBundlePath = [[ourBundle bundlePath] stringByAppendingPathComponent:@"Guavapay3DS2.bundle"];
        NSBundle *gptdsBundle = [NSBundle bundleWithPath:gptdsBundlePath];
        if (gptdsBundle != nil) {
            ourBundle = gptdsBundle;
        }
        // If it's not there, it might be a level up from us?
        // (CocoaPods arranges us this way, as an example.)
        if (gptdsBundle == nil) {
            NSString *gptdsBundlePath = [[[ourBundle bundlePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Guavapay3DS2.bundle"];
            gptdsBundle = [NSBundle bundleWithPath:gptdsBundlePath];
            if (gptdsBundle != nil) {
                ourBundle = gptdsBundle;
            }
        }
    });
    
    return ourBundle;
}

@end
