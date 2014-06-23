//
//  NewWindow.m
//  Timer
//
//  Created by jenkins on 6/23/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import "NewWindow.h"
#import "AppDelegate.h"
#import "TimerDatabase.h"
#import "MemoWindow.h"

@implementation NewWindow

-(IBAction)addClient:(id)sender
{
    if ([[self.field stringValue] length] <=0)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Please enter a client name."];
        [alert runModal];
        return;
    }
    
    NSString *clientname = [[self.field stringValue]   stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    long long clientID = [[TimerDatabase sharedInstance] getClientID:clientname];
    

    if (clientID <= 0)
    {   //insert or updateclient.
        [[TimerDatabase sharedInstance] insertClient:clientname];
        clientID = [[TimerDatabase sharedInstance] getClientID:clientname];
    }
    else
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:[NSString stringWithFormat:@"Client %@ already exists.", clientname]];
        [alert runModal];
        return;

    }
    AppDelegate *delegate = (AppDelegate *) [NSApp delegate];
    delegate.moreClient = nil;
    [(MemoWindow *)delegate.window reloadClients];
    ((MemoWindow *)delegate.window).selectedClient = clientname;

    [self close];
}

-(IBAction)cancelAdd:(id)sender
{
    AppDelegate *delegate = (AppDelegate *) [NSApp delegate];
    delegate.moreClient = nil;
    [self close];
}
@end
