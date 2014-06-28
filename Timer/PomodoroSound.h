//
//  PomodoroSound.h
//  Pigeon Timer
//
//  Created by jenkins on 6/28/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PomodoroSound : NSObject<NSSoundDelegate>

@property (atomic, strong) NSSound *sound;
@property (atomic, strong) NSString *volKey;
+(id) shared;
-(void) playSong:(NSString *)fileName volKey:(NSString *)volKey;
-(BOOL) isFinished:(NSString *)volKey;
@end
