//
//  PomodoroSound.m
//  Pigeon Timer
//
//  Created by jenkins on 6/28/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import "PomodoroSound.h"

@implementation PomodoroSound

static PomodoroSound *soundPlay=nil;

+(id) shared
{
    
    if (!soundPlay)
    {
        soundPlay = [[PomodoroSound alloc] init];
    }
    
    return soundPlay;
}

-(void) stop
{
    if (self.sound && [self.sound isPlaying])
    {
        [self.sound stop];
        self.sound = nil;
    // [self removeObserver:self forKeyPath:self.volKey context:nil];
    }
}

-(void) playSong:(NSString *)fileName volKey:(NSString *)volKey
{
   @synchronized(self)
    {
        if (self.sound && [self.sound isPlaying])
        {
            [self.sound stop];
            self.sound = nil;
           // [self removeObserver:self forKeyPath:self.volKey context:nil];
        }
    
        self.volKey = volKey;
        NSNumber *volume = [[NSUserDefaults standardUserDefaults] objectForKey:volKey];
        if ([[fileName pathComponents] count] > 1)
            self.sound = [[NSSound alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fileName] byReference:YES];
        else
            self.sound = [NSSound soundNamed:fileName];
        [self.sound setDelegate:self];
        [self.sound setVolume:[volume floatValue]/100];
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:self.volKey options:NSKeyValueObservingOptionNew context:nil];
        [self.sound play];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if ([keyPath isEqualTo:self.volKey] )
    {
        NSNumber *volume = [[NSUserDefaults standardUserDefaults] objectForKey:self.volKey];
        if (self.sound && [self.sound isPlaying])
            [self.sound setVolume:[volume floatValue]/100];
        
    }
}
- (void)sound:(NSSound *)sound didFinishPlaying:(BOOL)finishedPlaying
{
    if (sound == self.sound)
        self.sound = nil;
}

-(BOOL) isFinished:(NSString *)volKey
{
    return ((!self.sound) || (self.sound && ![self.sound isPlaying] )||  ![volKey isEqualToString: self.volKey]);
}


@end
