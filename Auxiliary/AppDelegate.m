//
//  AppDelegate.m
//  Auxiliary.app
//
//  Created by Lars Jørgen Aas on 24/07/16.
//  Copyright © 2016 Lars Jørgen Aas. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (assign, nonatomic) BOOL debug;

@end

// TODO: trigger on any the following Bundle IDs:
//   "tv.openpht.openpht"
//   "com.plexapp.plexhometheater"
//   "com.plexapp.plex"

// TODO: organize these as configurable properties or something:
// - "com.apple.audio.aulab"
// - "/Users/larsa/Documents/test.trak"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    self.debug = NO;
    if (self.debug) NSLog(@"initializing");
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [[self.statusItem button] setImage:[NSImage imageNamed:@"loud"]];
    [[[self.statusItem button] image] setTemplate:YES];
    [self.statusItem setAction:@selector(itemClicked:)];
    
    NSNotificationCenter *nc = [[NSWorkspace sharedWorkspace] notificationCenter];
    [nc addObserver:self selector:@selector(appLaunched:) name:NSWorkspaceDidLaunchApplicationNotification object:NULL];
    [nc addObserver:self selector:@selector(appQuit:) name:NSWorkspaceDidTerminateApplicationNotification object:NULL];
}

- (void)itemClicked:(id)sender {
    NSEvent *event = [NSApp currentEvent];
    if([event modifierFlags] & NSControlKeyMask) {
        [[NSApplication sharedApplication] terminate:self];
        return;
    }
}

- (void)appLaunched:(id)sender {
    NSDictionary<id,id> *info = [sender userInfo];
    NSRunningApplication* app = [info objectForKey:NSWorkspaceApplicationKey];
    if (self.debug) NSLog(@"app launched: %@", [app bundleIdentifier]);
    if ([[app bundleIdentifier] isEqualToString:@"tv.openpht.openpht"]) {
        if (self.debug) NSLog(@"PleX launched - launching AU Lab");
        [[NSWorkspace sharedWorkspace] openFile:@"/Users/larsa/Documents/test.trak"];
        sleep(2);
        [self hideAppWithBundleID:@"com.apple.audio.aulab"];
    }
}

- (BOOL) hideAppWithBundleID:(NSString *)bundleID
{
    NSArray *apps = [NSRunningApplication runningApplicationsWithBundleIdentifier:bundleID];
    if ([apps count] == 0) return NO;
    return [(NSRunningApplication *)[apps objectAtIndex:0] hide];
}

- (void)appQuit:(id)sender {
    NSDictionary<id,id> *info = [sender userInfo];
    NSRunningApplication *app = [info objectForKey:NSWorkspaceApplicationKey];
    if (self.debug) NSLog(@"app quit: %@", [app bundleIdentifier]);
    if ([[app bundleIdentifier] isEqualToString:@"tv.openpht.openpht"]) {
        if (self.debug) NSLog(@"PleX quit - terminating AU Lab");
        for (id object in [[NSWorkspace sharedWorkspace] runningApplications]) {
            NSRunningApplication* rApp = (NSRunningApplication*) object;
            if ([[rApp bundleIdentifier] isEqualToString:@"com.apple.audio.aulab"]) {
                [rApp terminate];
            }
        }
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    if (self.debug) NSLog(@"exiting");
    NSNotificationCenter* nc = [[NSWorkspace sharedWorkspace] notificationCenter];
    [nc removeObserver:self name:NSWorkspaceDidLaunchApplicationNotification object:NULL];
    [nc removeObserver:self name:NSWorkspaceDidTerminateApplicationNotification object:NULL];
}

@end
