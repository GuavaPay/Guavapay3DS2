//
//  GPTDSVisionSupport.h
//  Guavapay3DS2
//
//

#ifndef GPTDSVisionSupport_h
#define GPTDSVisionSupport_h

#ifdef TARGET_OS_VISION
#if TARGET_OS_VISION
#define STP_TARGET_VISION 1
#else
#endif
#else
#define STP_TARGET_VISION 0
#endif


#endif /* GPTDSVisionSupport_h */
