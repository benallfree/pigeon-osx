//
//  PreferenceWindow.m
//  Timer
//
//  Created by jenkins on 6/21/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import "PreferenceWindow.h"
#import "AppDelegate.h"
#import "Utilities.h"

@implementation PreferenceWindow

/**
 *  awake from nib
 */
-(void) awakeFromNib
{
    self.values = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 30; i++)
        [self.values addObject:[NSString stringWithFormat:@"%d", i]];
    
}
/**
 *  backup preferences
 */
-(void) makeCopyOfCurrent
{
    self.recent_Values = [[NSUserDefaults standardUserDefaults] persistentDomainForName:[[NSBundle mainBundle] bundleIdentifier ]];
}

-(IBAction) sliderEvent:(id)sender
{
    NSLog(@"slider moved");
    if (sender == self.promo)
        [Utilities playSound:@"start_promo_sound_path" volumeKey:@"start_promo_vol" default:@"start" running:YES];
    else   if (sender == self.sbreak)
        [Utilities playSound:@"short_break_sound_path" volumeKey:@"short_break_vol" default:@"short" running:YES];
    else   if (sender == self.lbreak)
        [Utilities playSound:@"long_break_sound_path" volumeKey:@"long_break_vol" default:@"long" running:YES];
    else   if (sender == self.tick)
        [Utilities playSound:@"tick_sound_path" volumeKey:@"tick_vol" default:@"tick" running:YES];
    else if (sender == self.countdown)
        [Utilities playSound:@"countdown_music_sound_path" volumeKey:@"countdown_music_vol" default:@"countdown" running:YES];
    else if (sender == self.breakEnd)
        [Utilities playSound:@"break_end_sound_path" volumeKey:@"break_end_vol" default:@"break_end" running:YES];
    else if (sender == self.memoPopup)
        [Utilities playSound:@"popup_sound_path" volumeKey:@"popup_vol" default:@"memo" running:YES];
    
    
}


-(IBAction) playPopupSound:(id)sender
{
    [Utilities playSound:@"popup_sound_path" volumeKey:@"popup_vol" default:@"memo"];
}

-(IBAction) play_breakend:(id)sender
{
    [Utilities playSound:@"break_end_sound_path" volumeKey:@"break_end_vol" default:@"break_end"];
}


/**
 *  play promo sond
 *
 *  @param sender
 */
-(IBAction) play_start_promo:(id)sender
{
    [Utilities playSound:@"start_promo_sound_path" volumeKey:@"start_promo_vol" default:@"start"];
}

/**
 *  play short break
 *
 *  @param sender <#sender description#>
 */
-(IBAction) play_short_break:(id)sender
{
    [Utilities playSound:@"short_break_sound_path" volumeKey:@"short_break_vol" default:@"short"];
    
}
/**
 *  play long break
 *
 *  @param sender <#sender description#>
 */
-(IBAction) play_long_break:(id)sender
{
    [Utilities playSound:@"long_break_sound_path" volumeKey:@"long_break_vol" default:@"long"];
    
}

/**
 *  play tick
 *
 *  @param sender <#sender description#>
 */
-(IBAction) play_tick:(id)sender
{
    [Utilities playSound:@"tick_sound_path" volumeKey:@"tick_vol" default:@"tick"];
    
}

/**
 *  browse and setup a path for a mp3.
 *
 *  @param fileKey file key
 *  @param nameKey <#nameKey description#>
 */
-(void) browse_and_set_audio:(NSString *)fileKey nameKey:(NSString *)nameKey
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    // Configure your panel the way you want it
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"mp3"]];
    [panel setLevel:NSFloatingWindowLevel];
    
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            
            for (NSURL *fileURL in [panel URLs]) {
                NSString *filePath = [fileURL path];
                [[NSUserDefaults standardUserDefaults] setObject:filePath forKey:fileKey];
                [self willChangeValueForKey:nameKey];
                [[NSUserDefaults standardUserDefaults] setObject:[filePath lastPathComponent] forKey:nameKey];
                [self didChangeValueForKey:nameKey];
                
            }
        }
    }];

}


/**
 *  set custom popup mp3
 *
 *  @param sender <#sender description#>
 */
-(IBAction) browse_popup_sound:(id)sender
{
    [self browse_and_set_audio:@"popup_sound_path" nameKey:@"popup_sound"];
}
/**
 *  set custom promo mp3
 *
 *  @param sender <#sender description#>
 */
-(IBAction) browse_start_promo:(id)sender
{
    [self browse_and_set_audio:@"start_promo_sound_path" nameKey:@"start_promo_sound"];
}

/**
 *  set custom short break
 *
 *  @param sender <#sender description#>
 */
-(IBAction) browse_short_break:(id)sender
{
    [self browse_and_set_audio:@"short_break_sound_path" nameKey:@"short_break_sound"];
}

/**
 *  set custom long break
 *
 *  @param sender <#sender description#>
 */
-(IBAction) browse_long_break:(id)sender
{
    [self browse_and_set_audio:@"long_break_sound_path" nameKey:@"long_break_sound"];
}

/**
 *  set custom tick
 *
 *  @param sender <#sender description#>
 */
-(IBAction) browse_tick:(id)sender
{
    [self browse_and_set_audio:@"tick_sound_path" nameKey:@"tick_sound"];

}

-(IBAction) default_popup_sound:(id)sender
{
    [[NSUserDefaults standardUserDefaults]  setObject:[NSString stringWithFormat:@"default"] forKey:@"popup_sound_path"];
    [[NSUserDefaults standardUserDefaults] setObject:@"default" forKey:@"popup_sound"];
  
}

-(IBAction) default_break_end:(id)sender
{
    [[NSUserDefaults standardUserDefaults]  setObject:[NSString stringWithFormat:@"default"] forKey:@"break_end_sound_path"];
    [[NSUserDefaults standardUserDefaults] setObject:@"default" forKey:@"break_end_sound"];
}


-(IBAction) browse_break_end:(id)sender
{
    [self browse_and_set_audio:@"break_end_sound_path" nameKey:@"break_end_sound"];
    
}

/**
 *  setup default value
 *
 *  @param sender <#sender description#>
 */
-(IBAction) default_start_promo:(id)sender
{
    [[NSUserDefaults standardUserDefaults]  setObject:[NSString stringWithFormat:@"default"] forKey:@"start_promo_sound"];
    [[NSUserDefaults standardUserDefaults] setObject:@"default" forKey:@"start_promo_sound_path"];
}

/**
 *  setup default for short
 *
 *  @param sender <#sender description#>
 */
-(IBAction) default_short_break:(id)sender
{
    [[NSUserDefaults standardUserDefaults]  setObject:[NSString stringWithFormat:@"default"] forKey:@"short_break_sound"];
    [[NSUserDefaults standardUserDefaults] setObject:@"default" forKey:@"short_break_sound_path"];
    
}

/**
 *  setup default long
 *
 *  @param sender <#sender description#>
 */
-(IBAction) default_long_break:(id)sender
{
    [[NSUserDefaults standardUserDefaults]  setObject:[NSString stringWithFormat:@"default"] forKey:@"long_break_sound"];
    [[NSUserDefaults standardUserDefaults] setObject:@"default" forKey:@"long_break_sound_path"];

}

/**
 *  setup default tick
 *
 *  @param sender <#sender description#>
 */
-(IBAction) default_tick:(id)sender
{
    [[NSUserDefaults standardUserDefaults]  setObject:[NSString stringWithFormat:@"default"] forKey:@"tick_sound"];
    [[NSUserDefaults standardUserDefaults] setObject:@"default" forKey:@"tick_sound_path"];
}


/**
 *  ok button
 *
 *  @param sender <#sender description#>
 */
-(void) OK:(id)sender
{
    NSLog(@"preferences changed");
    AppDelegate *app = (AppDelegate *)[NSApp delegate];
    
    if ([app.window isVisible])
    {
        [app alertMemoBox];
    }

    if ([app.active state] == NSOnState)
    {
        if (app.timer){
            [app.timer invalidate];
            app.timer = [NSTimer scheduledTimerWithTimeInterval:[[[NSUserDefaults standardUserDefaults] objectForKey:@"log_interval"] intValue] * 60  target:app selector:@selector(alertMemoBox) userInfo:nil repeats:NO];
        }
    }
    
    int log_interval = [[[NSUserDefaults standardUserDefaults] objectForKey:@"log_interval"] intValue];
    int pomo_interval = [[[NSUserDefaults standardUserDefaults] objectForKey:@"pomodor_interval"] intValue];
    int count_down = [[[NSUserDefaults standardUserDefaults] objectForKey:@"count_down_minutes"] intValue];
    
    if (count_down > pomo_interval)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[self.recent_Values objectForKey:@"log_interval"] forKey:@"log_interval"];
        [[NSUserDefaults standardUserDefaults] setObject:[self.recent_Values objectForKey:@"count_down_minutes"] forKey:@"count_down_minutes"];
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Countdown interval cannot be greater than pomodoro interval."];
        [alert runModal];
        [self makeKeyAndOrderFront:self];
        return;
    }

    if (log_interval > pomo_interval)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[self.recent_Values objectForKey:@"log_interval"] forKey:@"log_interval"];
        [[NSUserDefaults standardUserDefaults] setObject:[self.recent_Values objectForKey:@"pomodor_interval"] forKey:@"pomodor_interval"];

        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Log interval cannot be greater than pomodoro interval."];
        [alert runModal];
        [self makeKeyAndOrderFront:self];
        return;
    }

    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"log_interval"] isEqualToString: [self.recent_Values objectForKey:@"log_interval"]])
        [app alertMemoBox];
   
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"pomodor_interval"] isEqualToString: [self.recent_Values objectForKey:@"pomodor_interval"]] && app.currentStatus == kPomoInProgress)
    {
        NSAlert *alert = [NSAlert alertWithMessageText:@" Pomodoro in progress. Restart?" defaultButton:@"OK" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@""];
        
        
        NSInteger returnCode = [alert runModal ];
        [self makeKeyAndOrderFront:self];

        if (returnCode != NSAlertDefaultReturn)
        {
           [self close];
            return;
        }
        else
        {
            [app resetPomoTimer];
            
        }

    }
    
    app.preferencesWindowClosed = YES;
    
    [app update];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.recent_Values = nil;
    [self orderOut:self];
}

/**
 *  plays the countdown music file
 *
 *  @param sender
 */
-(IBAction) play_coundown:(id)sender
{
    [Utilities playSound:@"countdown_music_sound_path" volumeKey:@"countdown_music_vol" default:@"countdown"];
}

/**
 *  changes the file for coundown.
 *
 *  @param sender
 */
-(IBAction) browse_coundown:(id)sender
{
    [self browse_and_set_audio:@"countdown_music_sound_path" nameKey:@"countdown_music_sound"];
}

/**
 *  default count down
 *
 *  @param sender
 */
-(IBAction) default_countdown:(id)sender
{
    [[NSUserDefaults standardUserDefaults]  setObject:[NSString stringWithFormat:@"default"] forKey:@"countdown_music_sound"];
    [[NSUserDefaults standardUserDefaults] setObject:@"default" forKey:@"countdown_music_sound_path"];
}

/**
 *  close window
 */
-(void) close
{
    AppDelegate *app = [NSApp delegate];
    app.preferencesWindowClosed = YES;

    NSLog(@"Reverting..");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (id key in self.recent_Values)
        [defaults setObject:[self.recent_Values objectForKey:key] forKey:key];
    [self orderOut:self];
}
@end
 