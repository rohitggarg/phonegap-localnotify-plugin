
#import "LocalNotify.h"
#import <Cordova/CDV.h>

@implementation LocalNotify

-(void)notice:(CDVInvokedUrlCommand*)command {

  NSMutableDictionary *repeatDict = [[NSMutableDictionary alloc ]init];
  [repeatDict setObject:[NSNumber numberWithInt:NSSecondCalendarUnit] forKey:@"second"];
  [repeatDict setObject:[NSNumber numberWithInt:NSMinuteCalendarUnit] forKey:@"minute"];
  [repeatDict setObject:[NSNumber numberWithInt:NSHourCalendarUnit] forKey:@"hourly"];
  [repeatDict setObject:[NSNumber numberWithInt:NSDayCalendarUnit] forKey:@"daily"];
  [repeatDict setObject:[NSNumber numberWithInt:NSWeekCalendarUnit] forKey:@"weekly"];
  [repeatDict setObject:[NSNumber numberWithInt:NSMonthCalendarUnit] forKey:@"monthly"];
  [repeatDict setObject:[NSNumber numberWithInt:NSYearCalendarUnit] forKey:@"yearly"];
  [repeatDict setObject:[NSNumber numberWithInt:0] forKey:@""];

  UILocalNotification* note = [[UILocalNotification alloc] init];

  double fireDate             = [[command.arguments objectAtIndex:0] doubleValue];
  NSString *alertBody         =  [command.arguments objectAtIndex:1];
  NSString *action            =  [command.arguments objectAtIndex:2];
  NSNumber *repeatInterval    =  [command.arguments objectAtIndex:3];
  NSString *soundName         =  [command.arguments objectAtIndex:4];
  NSString *notificationId    =  [command.arguments objectAtIndex:5];
  NSInteger badge             = [[command.arguments objectAtIndex:6] intValue];

  note.alertBody         = ([alertBody isEqualToString:@""])?nil:alertBody;
  note.alertAction       = ([action isEqualToString:@""])?nil:action;
  note.hasAction         = (note.alertAction==nil)?0:1;
  note.fireDate          = [NSDate dateWithTimeIntervalSince1970:fireDate];
  note.repeatInterval    = [[repeatDict objectForKey: repeatInterval] intValue];
  note.soundName         = soundName;
  note.timeZone          = [NSTimeZone defaultTimeZone];
  note.applicationIconBadgeNumber = badge;

  [[UIApplication sharedApplication] scheduleLocalNotification:note];
  UIApplicationState state = [[UIApplication sharedApplication] applicationState];
  NSString* stateStr = (state == UIApplicationStateActive ? @"foreground" : @"background");

  NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
  [params setObject:stateStr forKey:@"appState"];
  [params setObject:notificationId forKey:@"notificationId"];

  [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:params] callbackId:command.callbackId];
}

- (void)cancel:(CDVInvokedUrlCommand*)command {
  NSString *notificationId    = [command.arguments objectAtIndex:0];
  NSArray *notifications      = [[UIApplication sharedApplication] scheduledLocalNotifications];

  for (UILocalNotification *notification in notifications) {
    NSString *noteId = [notification.userInfo objectForKey:@"notificationId"];
    if ([notificationId isEqualToString:noteId]) {
      [[UIApplication sharedApplication] cancelLocalNotification: notification];
    }
  }
  [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:nil] callbackId:command.callbackId];
}

- (void)cancelAll:(CDVInvokedUrlCommand*)command {
  [[UIApplication sharedApplication] cancelAllLocalNotifications];
  [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:nil] callbackId:command.callbackId];
}

- (void)setBadgeNumber:(CDVInvokedUrlCommand*) command {
  int badgeNumber = [[command.arguments objectAtIndex:0] intValue];
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
}
@end
