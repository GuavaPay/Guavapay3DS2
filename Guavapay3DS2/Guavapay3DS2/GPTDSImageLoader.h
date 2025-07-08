//
//  GPTDSImageLoader.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^GPTDSImageDownloadCompletionBlock)(UIImage * _Nullable);

@interface GPTDSImageLoader: NSObject

/**
 Initializes an `GPTDSImageLoader` with the given parameters.

 @param session The session to initialize the loader with.
 @return Returns an initialized `GPTDSImageLoader` object.
 */
- (instancetype)initWithURLSession:(NSURLSession *)session;

/**
 Attempts to load an image from the specified URL.

 @param URL The URL to load an image for.
 @param completion A completion block that is called when the image loading has finished. This will be called on the main queue.
 */
- (void)loadImageFromURL:(NSURL *)URL completion:(GPTDSImageDownloadCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
