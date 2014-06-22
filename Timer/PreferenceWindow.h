//
//  PreferenceWindow.h
//  Timer
//
//  Created by jenkins on 6/21/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferenceWindow : NSWindow

@property (strong, atomic) NSNumber *value;

-(IBAction) OK:(id)sender;
@end
