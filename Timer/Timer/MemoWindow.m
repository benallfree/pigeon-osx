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


/**
 *  function to load window from nib
 *
 *  @return window
 */
+ (NSWindowController *) loadMemoWindow
{
    NSWindowController * controller = [[NSWindowController alloc] initWithWindowNibName:@"MemoWindow" ];
    MemoWindow * item = (MemoWindow *)controller.window;
    item.clients = (NSMutableArray *)[[TimerDatabase sharedInstance] getClients];
    item.windowController = controller;
    [item.windowController addObserver:item
           forKeyPath: @"window.memo"
              options:NSKeyValueObservingOptionNew
              context:nil];

    [item.windowController addObserver:item
                            forKeyPath: @"window.selectedLog"
                               options:NSKeyValueObservingOptionNew
                               context:(__bridge void *)(item)];

    
    return controller;
}
/**
 *  when cancel button is hit on memo window, thsi function will be called
 *
 *  @param sender object that triggers this function
 */

-(IBAction)Cancel:(id)sender
{
    AppDelegate *delegate = (AppDelegate *) [NSApp delegate];
 
    [delegate startTimer];
    [self orderOut:sender];
}

- (void) close
{
    AppDelegate *delegate = (AppDelegate *) [NSApp delegate];
    
    if ([delegate.active state] == NSOffState)
    {
        [self orderOut:self];
        return;
    }
    [self Cancel:self];
}
/**
 *  function to handle OK button click
 *
 *  @param sender OK button
 */
-(IBAction)OK:(id)sender
{
    //checking if all required fields are filled.
    if ([self.selectedClient length] <=0 ||
        [[self.memoStr string] length] <= 0)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Input are missings. Please review"];
        [alert runModal];
        return;
    }
    
    NSString *client =  nil;
    client = self.selectedClient;
    
    self.memo = [self.memoStr string];
    
    //insert or updateclient.
    [[TimerDatabase sharedInstance] insertClient:client];
    //insert log into database
    [[TimerDatabase sharedInstance] insertLog:self.memo forClient:client];
    
    //close window.
    [self orderOut:sender];
    
    //make app delegate to reset the timer.
    AppDelegate *delegate = (AppDelegate *) [NSApp delegate];
    [delegate startTimer];
}

/**
 *  function to handle when combox selection is changed
 *
 *  @param sender nscombobox
 */
-(IBAction)clientChanged:(id)sender
{
    NSLog(@"client changed");
    [self.windowController willChangeValueForKey:@"window.previousLogs"];
    //get previous logs for the selected client.
    self.previousLogs = (NSMutableArray *)[[TimerDatabase sharedInstance] getLogsForClient:[sender stringValue]];
    self.selectedLog = nil;
    [self.windowController didChangeValueForKey:@"window.previousLogs"];
    
}

/**
 *  this function is called when memo combo box is changed.
 *
 *  @param sender 
 */
-(IBAction)memoChanged:(id)sender
{
   NSString *str = [sender stringValue];
    
  NSArray *arr = [str componentsSeparatedByString:@"\n"];
 
  self.memo = [arr objectAtIndex:0];
    
    int index = [self.box indexOfSelectedItem];
    
    if (index < [self.previousLogs count])
        self.memoStr = [[NSAttributedString alloc] initWithString:[self.previousLogs objectAtIndex:index] ];
    else
        self.memoStr = [[NSAttributedString alloc] initWithString:[sender stringValue] ];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if ([keyPath isEqualTo:@"window.memo"] )
    {
        
 
        //self.memoStr = [[NSAttributedString alloc] initWithString:self.memo];
    }
    else    if ([keyPath isEqualTo:@"window.selectedLog"] )
    {
        
        if (self.selectedLog && context != nil){
            int index = [self.box indexOfSelectedItem];
            
            if (index < [self.previousLogs count])
                self.memoStr = [[NSAttributedString alloc] initWithString:[self.previousLogs objectAtIndex:index] ];
            else
                self.memoStr = [[NSAttributedString alloc] initWithString:self.selectedLog ];
        }
    }

}

@end
