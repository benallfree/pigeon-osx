//
//  MemoWindow.h
//  Timer
//
//  Created by jenkins on 6/20/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MemoWindow : NSWindow

+ (NSWindowController*) loadMemoWindow;

@property(strong, atomic) NSMutableArray *clients;
@property(strong, atomic) NSString *nClient;
@property(strong, atomic) NSString *selectedClient;
@property(strong, atomic) NSString *selectedLog;
@property(strong, atomic) NSMutableArray *previousLogs;
@property(strong, atomic) NSString *memo;

-(IBAction)clientChanged:(id)sender;
-(IBAction)memoChanged:(id)sender;
-(IBAction)Cancel:(id)sender;
-(IBAction)OK:(id)sender;
@end
