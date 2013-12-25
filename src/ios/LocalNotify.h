
#import <Cordova/CDV.h>

@interface LocalNotify : CDVPlugin

- (void)notice:(CDVInvokedUrlCommand*)command;
- (void)cancel:(CDVInvokedUrlCommand*)command;
- (void)cancelAll:(CDVInvokedUrlCommand*)command;
@end
