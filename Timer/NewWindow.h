//
//  NewWindow.h
//  Timer
//
//  Created by jenkins on 6/23/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NewWindow : NSWindow

@property(strong, atomic) IBOutlet NSTextField *field;

-(IBAction)addClient:(id)sender;
-(IBAction)cancelAdd:(id)sender;

@end
