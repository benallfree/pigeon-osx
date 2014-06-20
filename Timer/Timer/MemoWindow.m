//
//  MemoWindow.m
//  Timer
//
//  Created by jenkins on 6/20/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import "MemoWindow.h"
#import "AppDelegate.h"
#import "TimerDatabase.h"

@implementation MemoWindow


+ (NSWindowController *) loadMemoWindow
{
    NSWindowController * controller = [[NSWindowController alloc] initWithWindowNibName:@"MemoWindow" ];
    MemoWindow * item = (MemoWindow *)controller.window;
    item.clients = (NSMutableArray *)[[TimerDatabase sharedInstance] getClients];
    item.windowController = controller;
    return controller;
}


-(IBAction)Cancel:(id)sender
{
    [self close];
}
-(IBAction)OK:(id)sender
{
    if (([self.nClient length] <= 0 &&  [self.selectedClient length] <=0) ||
        [self.memo length] <= 0)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Input are missings. Please review"];
        [alert runModal];
        return;
    }
    
    NSString *client =  nil;
    
   if ( [self.nClient length] <= 0)
       client = self.selectedClient;
    else
        client = self.nClient;
    
    [[TimerDatabase sharedInstance] insertClient:client];
    [[TimerDatabase sharedInstance] insertLog:self.memo forClient:client];
    
    [self close];
}

-(void) close
{
    AppDelegate *delegate = (AppDelegate *) [NSApp delegate];
    [delegate windowClosed:self];
    [super close];
}


-(IBAction)clientChanged:(id)sender
{
    NSLog(@"client changed");
    [self.windowController willChangeValueForKey:@"window.previousLogs"];
    self.previousLogs = (NSMutableArray *)[[TimerDatabase sharedInstance] getLogsForClient:[sender stringValue]];
    self.selectedLog = nil;
    [self.windowController didChangeValueForKey:@"window.previousLogs"];
    
}

-(IBAction)memoChanged:(id)sender
{
    self.memo = [sender stringValue];
}

@end
