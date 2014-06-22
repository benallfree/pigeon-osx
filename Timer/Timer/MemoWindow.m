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
    if (![sender isKindOfClass:[NSButton class]]) return;
    //checking if all required fields are filled.
    if ([self.selectedClient length] <=0 ||
        ([self.memo length] <= 0 && [self.selectedLog length] <=0))
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Input are missings. Please review"];
        [alert runModal];
        return;
    }
    
    NSString *client =  nil;
    client = self.selectedClient;
    
    if ([self.memo length] <= 0)
        self.memo = self.selectedLog;
    
    long long clientID = [[TimerDatabase sharedInstance] getClientID:client];
    
    if (clientID <= 0)
    {   //insert or updateclient.
        [[TimerDatabase sharedInstance] insertClient:client];
        clientID = [[TimerDatabase sharedInstance] getClientID:client];
    }
    //insert log into database
    [[TimerDatabase sharedInstance] insertLog:self.memo forClient:clientID];
    
    self.selectedLog = self.memo;
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
    long long ID = [[TimerDatabase sharedInstance] getClientID:[sender stringValue]];
    self.previousLogs = (NSMutableArray *)[[TimerDatabase sharedInstance] getLogsForClient:ID];
    if (![self.previousClient isEqualToString:[sender stringValue]])
        self.selectedLog = nil;
    [self.windowController didChangeValueForKey:@"window.previousLogs"];
    self.previousClient = [sender stringValue];
    
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
    
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if ([keyPath isEqualTo:@"window.memo"] )
    {
        
 
    }
    else    if ([keyPath isEqualTo:@"window.selectedLog"] )
    {
        
        if (self.selectedLog)
            self.memo = self.selectedLog;
  
    }

}

- (BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector
{
    BOOL result = NO;
    
    if (commandSelector == @selector(insertNewline:))
    {
        // new line action:
        // always insert a line-break character and don’t cause the receiver to end editing
        [textView insertNewlineIgnoringFieldEditor:self];
        result = YES;
    }
    else if (commandSelector == @selector(insertTab:))
    {
        // tab action:
        // always insert a tab character and don’t cause the receiver to end editing
        [textView insertTabIgnoringFieldEditor:self];
        result = YES;
    }
    
    return result;
}
@end
