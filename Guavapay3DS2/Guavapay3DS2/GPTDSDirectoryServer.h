//
//  Header.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, GPTDSDirectoryServer) {
    GPTDSDirectoryServerULTestRSA,
    GPTDSDirectoryServerULTestEC,
    GPTDSDirectoryServerSTPTestRSA,
    GPTDSDirectoryServerSTPTestEC,
    GPTDSDirectoryServerAmex,
    GPTDSDirectoryServerCartesBancaires,
    GPTDSDirectoryServerDiscover,
    GPTDSDirectoryServerMastercard,
    GPTDSDirectoryServerVisa,
    GPTDSDirectoryServerCustom,
    GPTDSDirectoryServerUnknown,
};

static NSString * const kULTestRSADirectoryServerID = @"F055545342";
static NSString * const kULTestECDirectoryServerID = @"F155545342";

static NSString * const kGPTDSTestRSADirectoryServerID = @"ul_test";
static NSString * const kGPTDSTestECDirectoryServerID = @"ec_test";

static NSString * const kGPTDSAmexDirectoryServerID = @"A000000025";
static NSString * const kGPTDSCartesBancairesServerID = @"A000000042";
static NSString * const kGPTDSDiscoverDirectoryServerID = @"A000000324";
static NSString * const kGPTDSDiscoverDirectoryServerID_2 = @"A000000152";
static NSString * const kGPTDSMastercardDirectoryServerID = @"A000000004";
static NSString * const kGPTDSVisaDirectoryServerID = @"A000000003";


/// Returns the typed directory server enum or GPTDSDirectoryServerUnknown if the directoryServerID is not recognized
NS_INLINE GPTDSDirectoryServer GPTDSDirectoryServerForID(NSString *directoryServerID) {
    if ([directoryServerID isEqualToString:kULTestRSADirectoryServerID]) {
        return GPTDSDirectoryServerULTestRSA;
    } else if ([directoryServerID isEqualToString:kULTestECDirectoryServerID]) {
        return GPTDSDirectoryServerULTestEC;
    } else if ([directoryServerID isEqualToString:kGPTDSTestRSADirectoryServerID]) {
        return GPTDSDirectoryServerSTPTestRSA;
    } else if ([directoryServerID isEqualToString:kGPTDSTestECDirectoryServerID]) {
        return GPTDSDirectoryServerSTPTestEC;
    } else if ([directoryServerID isEqualToString:kGPTDSAmexDirectoryServerID]) {
        return GPTDSDirectoryServerAmex;
    } else if ([directoryServerID isEqualToString:kGPTDSDiscoverDirectoryServerID] || [directoryServerID isEqualToString:kGPTDSDiscoverDirectoryServerID_2]) {
        return GPTDSDirectoryServerDiscover;
    } else if ([directoryServerID isEqualToString:kGPTDSMastercardDirectoryServerID]) {
        return GPTDSDirectoryServerMastercard;
    } else if ([directoryServerID isEqualToString:kGPTDSVisaDirectoryServerID]) {
        return GPTDSDirectoryServerVisa;
    } else if ([directoryServerID isEqualToString:kGPTDSCartesBancairesServerID]) {
        return GPTDSDirectoryServerCartesBancaires;
    }
    
    return GPTDSDirectoryServerUnknown;
}

/// Returns the directory server ID or nil for GPTDSDirectoryServerUnknown
NS_INLINE NSString * _Nullable GPTDSDirectoryServerIdentifier(GPTDSDirectoryServer directoryServer) {
    switch (directoryServer) {
        case GPTDSDirectoryServerULTestRSA:
            return kULTestRSADirectoryServerID;
            
        case GPTDSDirectoryServerULTestEC:
            return kULTestECDirectoryServerID;
            
        case GPTDSDirectoryServerSTPTestRSA:
            return kGPTDSTestRSADirectoryServerID;
            
        case GPTDSDirectoryServerSTPTestEC:
            return kGPTDSTestECDirectoryServerID;
            
        case GPTDSDirectoryServerAmex:
            return kGPTDSAmexDirectoryServerID;

        case GPTDSDirectoryServerDiscover:
            return kGPTDSDiscoverDirectoryServerID;

        case GPTDSDirectoryServerMastercard:
            return kGPTDSMastercardDirectoryServerID;

        case GPTDSDirectoryServerVisa:
            return kGPTDSVisaDirectoryServerID;
            
        case GPTDSDirectoryServerCartesBancaires:
            return kGPTDSCartesBancairesServerID;

        case GPTDSDirectoryServerCustom:
            return nil;
            
        case GPTDSDirectoryServerUnknown:
            return nil;
    }
}

/// Returns the directory server image name if one exists
NS_INLINE NSString * _Nullable GPTDSDirectoryServerImageName(GPTDSDirectoryServer directoryServer) {
    switch (directoryServer) {
        case GPTDSDirectoryServerAmex:
            return @"amex-logo";
        case GPTDSDirectoryServerDiscover:
            return @"discover-logo";
        case GPTDSDirectoryServerMastercard:
            return @"mastercard-logo";
        case GPTDSDirectoryServerCartesBancaires:
            return @"cartes-bancaires-logo";
        // just default to an arbitrary logo for the test servers
        case GPTDSDirectoryServerULTestEC:
        case GPTDSDirectoryServerULTestRSA:
        case GPTDSDirectoryServerSTPTestRSA:
        case GPTDSDirectoryServerSTPTestEC:
        case GPTDSDirectoryServerVisa:
            if ([[UITraitCollection currentTraitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark) {
                return @"visa-white-logo";
            }
            return @"visa-logo";
        case GPTDSDirectoryServerCustom:
        case GPTDSDirectoryServerUnknown:
            return nil;

    }
}

NS_ASSUME_NONNULL_END
