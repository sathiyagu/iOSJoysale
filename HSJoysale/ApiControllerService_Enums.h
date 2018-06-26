#import <Foundation/Foundation.h>


#ifndef _SoapProtocolVersion_
#define _SoapProtocolVersion_
typedef enum {
    	kSoapProtocolVersionDefault = 0,
    	kSoapProtocolVersionSoap11 = 1,
    	kSoapProtocolVersionSoap12 = 2,
} SoapProtocolVersion;
#endif
@interface ApiControllerService_Enums : NSObject
{
}
+(NSString*)SoapProtocolVersionToString:(SoapProtocolVersion)soapVersion;
+(SoapProtocolVersion)StringToSoapProtocolVersion:(NSString*)str;
@end
