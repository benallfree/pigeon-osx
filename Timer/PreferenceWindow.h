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
@property (strong, atomic) NSMutableArray *values;
@property (strong, atomic) NSDictionary *recent_Values;

@property (strong, atomic) IBOutlet NSSlider *promo;
@property (strong, atomic) IBOutlet NSSlider *tick;
@property (strong, atomic) IBOutlet NSSlider *sbreak;
@property (strong, atomic) IBOutlet NSSlider *lbreak;


-(IBAction) OK:(id)sender;
-(IBAction) play_start_promo:(id)sender;
-(IBAction) play_short_break:(id)sender;
-(IBAction) play_long_break:(id)sender;
-(IBAction) play_tick:(id)sender;
-(IBAction) browse_start_promo:(id)sender;
-(IBAction) browse_short_break:(id)sender;
-(IBAction) browse_long_break:(id)sender;
-(IBAction) browse_tick:(id)sender;
-(IBAction) default_start_promo:(id)sender;
-(IBAction) default_short_break:(id)sender;
-(IBAction) default_long_break:(id)sender;
-(IBAction) default_tick:(id)sender;
-(void) makeCopyOfCurrent;
-(IBAction) sliderEvent:(id)sender;
@end
