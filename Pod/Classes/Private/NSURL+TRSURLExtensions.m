//
//  NSURL+TRSURLExtentions.m
//  Pods
//
//  Created by Gero Herkenrath on 16.03.16.
//
//

#import "NSURL+TRSURLExtensions.h"
#import "TRSShop.h"

NSString * const TRSAPIEndPoint = @"cdn1.api.trustedshops.com";
NSString * const TRSTrustcardTemplateURLString = @"https://widgets.trustedshops.com/trustbadgesdk/certificatedialog_%ll_%cccccc.html";
NSString * const TRSAPIEndPointDebug = @"cdn1.api-qa.trustedshops.com";
NSString * const TRSTrustcardTemplateURLStringDebug = @"https://widgets-qa.trustedshops.com/trustbadgesdk/certificatedialog_%ll_%cccccc.html";
NSString * const TRSEndPoint = @"widgets.trustedshops.com";
NSString * const TRSEndPointDebug = @"widgets-qa.trustedshops.com";

@implementation NSURL (TRSURLExtensions)

+ (NSDictionary *)urlList {
	return @{
			 @"DEU_de": @{@"reviewProfile": @"https://www.trustedshops.de/bewertung/info_%s.html"},
			 @"AUT_de": @{@"reviewProfile": @"https://www.trustedshops.at/bewertung/info_%s.html"},
			 @"CHE_de": @{@"reviewProfile": @"https://www.trustedshops.ch/bewertung/info_%s.html"},
			 @"CHE_fr": @{@"reviewProfile": @"https://www.trustedshops.fr/evaluation/info_%s.html"},
			 @"FRA_fr": @{@"reviewProfile": @"https://www.trustedshops.fr/evaluation/info_%s.html"},
			 @"GBR_en": @{@"reviewProfile": @"https://www.trustedshops.co.uk/buyerrating/info_%s.html"},
			 @"POL_pl": @{@"reviewProfile": @"https://www.trustedshops.pl/opinia/info_%s.html"},
			 @"ESP_es": @{@"reviewProfile": @"https://www.trustedshops.es/evaluacion/info_%s.html"},
			 @"NLD_nl": @{@"reviewProfile": @"https://www.trustedshops.nl/verkopersbeoordeling/info_%s.html"},
			 @"BEL_fr": @{@"reviewProfile": @"https://www.trustedshops.be/fr/evaluation/info_%s.html"},
			 @"BEL_nl": @{@"reviewProfile": @"https://www.trustedshops.be/nl/verkopersbeoordeling/info_%s.html"},
			 @"ITA_it": @{@"reviewProfile": @"https://www.trustedshops.it/valutazione-del-negozio/info_%s.html"},
			 @"EUO_en": @{@"reviewProfile": @"https://www.trustedshops.com/buyerrating/info_%s.html"}
			 };

}

+ (NSString *)keyForCountryCode:(NSString *)targetMarketISO3 language:(NSString *)languageISO2 {
	return [NSString stringWithFormat:@"%@_%@", targetMarketISO3.uppercaseString, languageISO2.lowercaseString];
}

+ (NSURL *)profileURLForShop:(TRSShop *)shop {
	NSString *urlWithoutTSID = [NSURL urlList][[NSURL keyForCountryCode:shop.targetMarketISO3 language:shop.languageISO2]][@"reviewProfile"];
	return [NSURL URLWithString:[urlWithoutTSID stringByReplacingOccurrencesOfString:@"%s" withString:shop.tsId]];
}

+ (NSURL *)trustMarkAPIURLForTSID:(NSString *)tsID andAPIEndPoint:(NSString *)apiEndPoint {
	return [NSURL URLWithString:
			[NSString stringWithFormat:@"https://%@/shops/%@/mobiles/v1/sdks/trustmarks.json", apiEndPoint, tsID]];
}

+ (NSURL *)trustMarkAPIURLForTSID:(NSString *)tsID debug:(BOOL)debug {
	if (debug) {
		return [NSURL trustMarkAPIURLForTSID:tsID andAPIEndPoint:TRSAPIEndPointDebug];
	} else {
		return [NSURL trustMarkAPIURLForTSID:tsID andAPIEndPoint:TRSAPIEndPoint];
	}
}

+ (NSURL *)localizedTrustcardURLWithColorString:(NSString *)hexString debug:(BOOL)debug {
	NSString *preferredLocalization = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
	NSDictionary *languageDic = [NSLocale componentsFromLocaleIdentifier:preferredLocalization];
	NSString *langCode = [languageDic objectForKey:((NSString *)kCFLocaleLanguageCode)]; // explicit cast to avoid a pod lint warning...
	// note: In the demo application this will always be simply @"en", because we don't have other (full) localizations.
	
	NSString *urlString;
	urlString = debug ? TRSTrustcardTemplateURLStringDebug : TRSTrustcardTemplateURLString;
	urlString = [urlString stringByReplacingOccurrencesOfString:@"%ll" withString:langCode];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"%cccccc" withString:hexString];
	
	return [NSURL URLWithString:urlString];
}

@end
