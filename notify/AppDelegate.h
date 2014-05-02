#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>

@property (assign) IBOutlet NSWindow *window;

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification;
- (void) sendMessage:(NSString *)message afterDelay:(NSTimeInterval)delay;
- (void)printAll;

@end
