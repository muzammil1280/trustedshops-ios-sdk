//
//  NSURL+TRSURLExtensions.h
//  Pods
//
//  Created by Gero Herkenrath on 16.03.16.
//
//

FOUNDATION_EXPORT NSString * const TRSAPIEndPoint;
FOUNDATION_EXPORT NSString * const TRSTrustcardTemplateURLString;
FOUNDATION_EXPORT NSString * const TRSAPIEndPointDebug;
FOUNDATION_EXPORT NSString * const TRSTrustcardTemplateURLStringDebug;
FOUNDATION_EXPORT NSString * const TRSEndPoint; // this is used by the checkout process
FOUNDATION_EXPORT NSString * const TRSEndPointDebug; // dito

#import <Foundation/Foundation.h>
@class TRSShop;

@interface NSURL (TRSURLExtensions)

+ (NSURL *)profileURLForShop:(TRSShop *)shop;

+ (NSURL *)trustMarkAPIURLForTSID:(NSString *)tsID debug:(BOOL)debug;

+ (NSURL *)localizedTrustcardURLWithColorString:(NSString *)hexString debug:(BOOL)debug;
@end
