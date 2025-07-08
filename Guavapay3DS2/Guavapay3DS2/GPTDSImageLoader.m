//
//  GPTDSImageLoader.m
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>
#import "GPTDSImageLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSImageLoader()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation GPTDSImageLoader

- (instancetype)initWithURLSession:(NSURLSession *)session {
    self = [super init];
    
    if (self) {
        _session = session;
    }
    
    return self;
}

- (void)loadImageFromURL:(NSURL *)URL completion:(GPTDSImageDownloadCompletionBlock)completion {
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image;
        
        if (data != nil) {
            image =  [UIImage imageWithData:data];
        }
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            completion(image);
        }];
    }];
    
    [dataTask resume];
}

@end

NS_ASSUME_NONNULL_END
