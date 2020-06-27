//
//  MemoWindow.h
//  Timer
//
//  Created by jenkins on 6/20/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MemoWindow : NSWindow<NSTableViewDelegate>

+ (NSWindowController*) loadMemoWindow;


@property(strong, atomic) NSMutableArray *clients;
@property(strong, atomic) NSString *nClient;
@property(strong, atomic) NSString *selectedClient;
@property(strong, atomic) NSString *previousClient;
@property(strong, atomic) NSString *selectedLog;
@property(strong, atomic) NSMutableArray *previousLogs;
@property(atomic, readwrite) NSInteger recentRowIndex;
@property(strong, atomic) NSString *memo;
@property(strong, atomic) IBOutlet NSTextView *memoBox;
@property(strong, atomic) IBOutlet NSButton *okbutton;
@property(strong, atomic) IBOutlet NSComboBox *box;
@property(strong, atomic) IBOutlet NSMutableArray *values;
@property(strong, atomic) IBOutlet NSArrayController *controller;
@property(strong, atomic) IBOutlet NSTableView *Tablecontroller;
@property(strong, atomic) NSString *memoCountDownTime;

-(IBAction)clientChanged:(id)sender;
-(IBAction)memoChanged:(id)sender;
-(IBAction)Cancel:(id)sender;
-(IBAction)OK:(id)sender;
-(IBAction)newClient:(id)sender;
-(void) reloadClients;

@end
