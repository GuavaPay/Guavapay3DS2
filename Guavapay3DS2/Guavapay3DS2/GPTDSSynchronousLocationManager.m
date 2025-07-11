//
//  GPTDSSynchronousLocationManager.m
//  Guavapay3DS2
//

#import "GPTDSSynchronousLocationManager.h"
#import "GPTDSVisionSupport.h"

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

static const int64_t kLocationFetchTimeoutSeconds = 15;

typedef void (^LocationUpdateCompletionBlock)(CLLocation * _Nullable);

@interface GPTDSSynchronousLocationManager () <CLLocationManagerDelegate>

@end

@implementation GPTDSSynchronousLocationManager
{
    CLLocationManager * _Nullable _locationManager;
    dispatch_queue_t _Nullable _locationFetchQueue;
    NSMutableArray<LocationUpdateCompletionBlock> *_pendingLocationUpdateCompletions;
}

+ (instancetype)sharedManager {
    static GPTDSSynchronousLocationManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[GPTDSSynchronousLocationManager alloc] init];
    });
    return sharedManager;
}

+ (BOOL)hasPermissions {
//    TODO: Revisit this after we drop iOS 13, iOS 14 has a new API for authorizationStatus
#ifdef STP_TARGET_VISION
    if (@available(iOS 14.0, *)) {
        CLAuthorizationStatus authorizationStatus = [[[CLLocationManager alloc] init] authorizationStatus];
        return [CLLocationManager locationServicesEnabled] &&
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse;
    } else {
        // This should never happen
        return NO;
    }
#else
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    return [CLLocationManager locationServicesEnabled] &&
    (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways || authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse);
#endif
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if ([GPTDSSynchronousLocationManager hasPermissions]) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            _locationFetchQueue = dispatch_queue_create("com.guavapay.3ds2locationqueue", DISPATCH_QUEUE_SERIAL);
        }
        _pendingLocationUpdateCompletions = [NSMutableArray array];
    }

    return self;
}

- (nullable CLLocation *)deviceLocation {

    __block CLLocation *location = nil;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [self _fetchDeviceLocation:^(CLLocation * _Nullable latestLocation) {
        location = latestLocation;
        dispatch_group_leave(group);
    }];

    dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * kLocationFetchTimeoutSeconds));
    return location;
}

- (void)_fetchDeviceLocation:(void (^)(CLLocation * _Nullable))completion {

    if (![GPTDSSynchronousLocationManager hasPermissions] || _locationFetchQueue == nil) {
        return completion(nil);
    }

    dispatch_async(_locationFetchQueue, ^{
        [self->_pendingLocationUpdateCompletions addObject:completion];

        if (self->_pendingLocationUpdateCompletions.count == 1) {
            [self->_locationManager requestLocation];
        }
    });
}

- (void)_stopUpdatingLocationAndReportResult:(nullable CLLocation *)location {
    [_locationManager stopUpdatingLocation];

    dispatch_async(_locationFetchQueue, ^{
        for (LocationUpdateCompletionBlock completion in self->_pendingLocationUpdateCompletions) {
            completion(location);
        }
        [self->_pendingLocationUpdateCompletions removeAllObjects];
    });
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self _stopUpdatingLocationAndReportResult:locations.firstObject];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self _stopUpdatingLocationAndReportResult:nil];
}

@end

NS_ASSUME_NONNULL_END
