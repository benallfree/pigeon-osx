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
#import "Utilities.h"

@implementation MemoWindow

/**
 *  adds a new client
 *
 *  @param sender <#sender description#>
 */
-(IBAction)newClient:(id)sender
{
    AppDelegate *delegate = (AppDelegate *) [NSApp delegate];

    if (!delegate.moreClient)
    {
        NSWindowController * controller = [[NSWindowController alloc] initWithWindowNibName:@"NewClient" ];
        delegate.moreClient = (NSWindow *)controller.window;
    }

    [delegate.moreClient center];
    [delegate.moreClient makeKeyAndOrderFront:self];
    [delegate.moreClient setLevel:NSFloatingWindowLevel];
    [NSApp activateIgnoringOtherApps:YES];

}
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

    [item.controller setSelectionIndexes:[NSIndexSet indexSetWithIndex:1]];

    [item.windowController addObserver:item
                            forKeyPath: @"window.selectedLog"
                               options:NSKeyValueObservingOptionNew
                               context:(__bridge void *)(item)];

    [item.windowController addObserver:item
                            forKeyPath: @"window.selectedClient"
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
 
  //  [delegate uncheckActive];
  //  [delegate resetPomoTimer];
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
        [self.memo length] <= 0)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Input are missings. Please review"];
        [alert runModal];
        return;
    }
    
    NSString *client =  nil;
    client = self.selectedClient;
    
    
    long long clientID = [[TimerDatabase sharedInstance] getClientID:client];
    
    if (clientID <= 0)
    {   //insert or updateclient.
        [[TimerDatabase sharedInstance] insertClient:[client stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        clientID = [[TimerDatabase sharedInstance] getClientID:client];
    }
    //insert log into database
    [[TimerDatabase sharedInstance] insertLog:[self.memo  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forClient:clientID];
    
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
    [self.windowController willChangeValueForKey:@"window.values"];
    //get previous logs for the selected client.
    NSString *client = [[(NSPopUpButton*)sender selectedItem] title];
    long long ID = [[TimerDatabase sharedInstance] getClientID:client];
    NSMutableArray *arr = (NSMutableArray *) [[TimerDatabase sharedInstance] getLogsForClient:ID];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"- Today", @"logs", nil];
        [arr insertObject:dict atIndex:0];
        NSMutableArray *tempArray =   (NSMutableArray *)[[TimerDatabase sharedInstance] getRecentLogsForClient:ID];
    
        dict = [NSDictionary dictionaryWithObjectsAndKeys:@"- Recent", @"logs", nil];
        self.recentRowIndex = [arr count];
    
        [arr addObject:dict];
        [arr addObjectsFromArray:tempArray];
        arr = [Utilities unique:arr withIndex:self.recentRowIndex];
    self.values = arr;


    
    if (![self.previousClient isEqualToString:[sender stringValue]])
        self.selectedLog = nil;
    [self.windowController didChangeValueForKey:@"window.values"];
    [self.controller willChangeValueForKey:@"selectionIndexes"];
    [self.controller setSelectionIndexes:[NSIndexSet indexSetWithIndex:1]];
    [self.controller didChangeValueForKey:@"selectionIndexes"];
    if (self.recentRowIndex > 1)
        [self.Tablecontroller selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
    else if ([self.values count] > 2)
        [self.Tablecontroller selectRowIndexes:[NSIndexSet indexSetWithIndex:2] byExtendingSelection:NO];
    else
        [self.Tablecontroller deselectAll:self];
    
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
    
    if ([keyPath isEqualTo:@"window.selectedClient"] )
    {
        if (self.selectedClient == nil) return;
        
        [self.windowController willChangeValueForKey:@"window.values"];
        //get previous logs for the selected client.
        long long ID = [[TimerDatabase sharedInstance] getClientID:self.selectedClient];
        NSMutableArray *arr = (NSMutableArray *) [[TimerDatabase sharedInstance] getLogsForClient:ID];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"- Today", @"logs", nil];
            [arr insertObject:dict atIndex:0];
            NSMutableArray *tempArray =   (NSMutableArray *)[[TimerDatabase sharedInstance] getRecentLogsForClient:ID];
            dict = [NSDictionary dictionaryWithObjectsAndKeys:@"- Recent", @"logs", nil];
            self.recentRowIndex = [arr count];
            
            [arr addObject:dict];
            [arr addObjectsFromArray:tempArray];
        arr = [Utilities unique:arr withIndex:self.recentRowIndex];
        self.values = arr;
        [self.windowController didChangeValueForKey:@"window.values"];
        if (self.recentRowIndex > 1)
            [self.Tablecontroller selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
        else if ([self.values count] > 2)
            [self.Tablecontroller selectRowIndexes:[NSIndexSet indexSetWithIndex:2] byExtendingSelection:NO];
        else
            [self.Tablecontroller deselectAll:self];
        self.previousClient = self.selectedClient;

    }
    else    if ([keyPath isEqualTo:@"window.selectedLog"] )
    {
        
        if (self.selectedLog)
        {
           // self.memo = [self.values objectForKey:self.selectedLog];
            
        }
  
    }

}

-(void) reloadClients
{
    self.clients = (NSMutableArray *)[[TimerDatabase sharedInstance] getClients];
    
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

#pragma -mark
#pragma nstableview protocol

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
    //today header row
    if (rowIndex <= 0)
        return NO;
    
    if (rowIndex == self.recentRowIndex)
        return NO;
    
    return YES;
    
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
 
    @try {
    NSTableView *view = (NSTableView *)aNotification.object;
    NSInteger index = [view selectedRow];
        if (!self.values) return;
    if (index <= 1 || index >= [self.values count]) return;
    if (index == self.recentRowIndex) return;
    NSLog(@"[self.values count] = %lu", (unsigned long)[self.values count]);
    NSLog(@"index = %ld",(long)index);
    NSDictionary *memoDict = [self.values objectAtIndex:index] ;
    NSLog(@"log dictionary = %@", memoDict);
        
        if ([[memoDict objectForKey:@"logs"] hasSuffix:@"Today"] || [[memoDict objectForKey:@"logs"] hasSuffix:@"Recent"])
            return;
        if ([memoDict objectForKey:@"originalLogs"])
            self.memo = [memoDict objectForKey:@"originalLogs"];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
       
}
@end
