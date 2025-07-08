//
//  GPTDSLocalizedString.h
//  Guavapay3DS2
//

#import "GPTDSBundleLocator.h"

#ifndef GPTDSLocalizedString_h
#define GPTDSLocalizedString_h

#define GPTDSLocalizedString(key, comment) \
[[GPTDSBundleLocator gptdsResourcesBundle] localizedStringForKey:(key) value:@"" table:nil]


#endif /* GPTDSLocalizedString_h */
