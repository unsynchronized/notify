#import "AppDelegate.h"
#include <unistd.h>

@implementation AppDelegate
void usage() {
    NSLog(@"usage: ");
    NSLog(@"        notify delaysecs msg");
    NSLog(@"          or");
    NSLog(@"        notify -d (cancels all outstanding/delivered)");
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSUserNotification *userNotification = aNotification.userInfo[NSApplicationLaunchUserNotificationKey];
    if(userNotification) {
        [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
    } else {
        NSTimeInterval delay = 0;
        
        NSArray *args = [[NSProcessInfo processInfo] arguments];
        if([args count] < 2) {
            usage();
        } else {
            NSString *str = [args objectAtIndex:1];
            if([str isEqualToString:@"-d"]) {
                [self printAll];
            } else {
                if([args count] < 3) {
                    usage();
                } else {
                    delay = [str longLongValue];
                    [self sendMessage:[args objectAtIndex:2] afterDelay:delay];
                }
            }
        }
    }
}

- (void)printAll {
    for(NSUserNotification *not in [[NSUserNotificationCenter defaultUserNotificationCenter] scheduledNotifications]) {
        NSLog(@"removeing scheduled: informativeText: '%@'  description: %@", not.informativeText, [not description]);
        [[NSUserNotificationCenter defaultUserNotificationCenter] removeScheduledNotification:not];
    }
    for(NSUserNotification *not in [[NSUserNotificationCenter defaultUserNotificationCenter] deliveredNotifications]) {
        NSLog(@"removeing delivered: informativeText: '%@'  description: %@", not.informativeText, [not description]);
        [[NSUserNotificationCenter defaultUserNotificationCenter] removeDeliveredNotification:not];
    }
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

- (void) sendMessage:(NSString *)message afterDelay:(NSTimeInterval)delay {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"notify";
    notification.deliveryRepeatInterval = nil;
    notification.soundName = NSUserNotificationDefaultSoundName;
    notification.informativeText = message;
    [notification setDeliveryDate:[NSDate dateWithTimeIntervalSinceNow:delay]];
    
    NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
    [center setDelegate:self];
    [center scheduleNotification:notification];
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification {
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeDeliveredNotification:notification];
}
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

@end
