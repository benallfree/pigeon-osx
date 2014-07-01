//
//  Utilities.m
//  Timer
//
//  Created by jenkins on 6/20/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import "Utilities.h"
#import "PomodoroSound.h"

@implementation Utilities


/**
 *  finds or create application support folder
 *
 *  @param searchPathDirectory search path directory
 *  @param domainMask          domain mask
 *  @param appendComponent     appent component
 *  @param errorOut            error object
 *
 *  @return nsstring
 */

+ (NSString *)findOrCreateDirectory:(NSSearchPathDirectory)searchPathDirectory
                           inDomain:(NSSearchPathDomainMask)domainMask
                appendPathComponent:(NSString *)appendComponent
                              error:(NSError **)errorOut
{
    // Search for the path
    NSArray* paths = NSSearchPathForDirectoriesInDomains(
                                                         searchPathDirectory,
                                                         domainMask,
                                                         YES);
    if ([paths count] == 0)
    {
        // *** creation and return of error object omitted for space
        return nil;
    }
    
    // Normally only need the first path
    NSString *resolvedPath = [paths objectAtIndex:0];
    
    if (appendComponent)
    {
        resolvedPath = [resolvedPath
                        stringByAppendingPathComponent:appendComponent];
    }
    
    // Create the path if it doesn't exist
    NSError *error;
    BOOL success = [[NSFileManager defaultManager]
                    createDirectoryAtPath:resolvedPath
                    withIntermediateDirectories:YES
                    attributes:nil
                    error:&error];
    if (!success)
    {
        if (errorOut)
        {
            *errorOut = error;
        }
        return nil;
    }
    
    // If we've made it this far, we have a success
    if (errorOut)
    {
        *errorOut = nil;
    }
    return resolvedPath;
}


/**
 *  get path to the peference file path
 *
 *  @return preferences file path
 */
+ (NSString *) PrefFilePath
{
    
    NSString *dbFolder = [NSString stringWithFormat:@"%@/TimerDb",
                          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"]];
    NSError *error;
    NSString *result =
    [Utilities
     findOrCreateDirectory:NSApplicationSupportDirectory
     inDomain:NSUserDomainMask
     appendPathComponent:dbFolder
     error:&error];
    if (error)
    {
        NSLog(@"Unable to find or create application support directory:\n%@", error);
    }
    return [NSString stringWithFormat:@"%@/Timer_pref.plist", result];
    

}



/**
 *  play a sound
 *
 *  @param filekey      filepath key
 *  @param volKey       volume key
 *  @param defaultSound default filename
 */
+(void) playSound:(NSString *)filekey volumeKey:(NSString *)volKey default:(NSString *)defaultSound
{
    NSString *file = [[NSUserDefaults standardUserDefaults] objectForKey:filekey];
    NSNumber *volume = [[NSUserDefaults standardUserDefaults] objectForKey:volKey];
    
    if ([file isEqualToString:@"default"])
    {
        file = defaultSound;
    }
    else
    {
        BOOL isDir;
        BOOL foundFile = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:file isDirectory:&isDir])
        {
            if (!isDir){
                foundFile = YES;
            }
        }
        
        if (!foundFile)
        {
            //run default
            file = defaultSound;
        }
    }
    
 
    PomodoroSound *sound = [PomodoroSound shared];
    [sound playSong:file volKey:volKey];
}

+(void) playSound:(NSString *)filekey volumeKey:(NSString *)volKey default:(NSString *)defaultSound running:(BOOL)playIfNotrunning
{
    PomodoroSound *sound = [PomodoroSound shared];

    if (!playIfNotrunning)
    {
        [Utilities playSound:filekey volumeKey:volKey default:defaultSound];
    }
    else
    {
        if ([sound isFinished:volKey])
        {
            [Utilities playSound:filekey volumeKey:volKey default:defaultSound];
        }
    }
}

/**
 *  play a sound
 *
 *  @param filekey      filepath key
 *  @param volKey       volume key
 *  @param defaultSound default filename
 */
+(void) playSoundStripped:(NSString *)filekey volumeKey:(NSString *)volKey default:(NSString *)defaultSound
{
    NSString *file = [[NSUserDefaults standardUserDefaults] objectForKey:filekey];
    NSNumber *volume = [[NSUserDefaults standardUserDefaults] objectForKey:volKey];
    
    NSSound *sound = nil;
    if ([file isEqualToString:@"default"])
    {
        sound = [NSSound soundNamed:defaultSound];
    }
    else
    {
        BOOL isDir;
        BOOL foundFile = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:file isDirectory:&isDir])
        {
            if (!isDir){
                sound = [[NSSound alloc] initWithContentsOfFile:file byReference:YES];
                foundFile = YES;
            }
        }
        
        if (!foundFile)
        {
            //run default
            [[NSUserDefaults standardUserDefaults] setObject:@"default" forKey:filekey];
            sound = [NSSound soundNamed:defaultSound];
        }
    }
    
    if (volume)
    {
        float val = [volume floatValue] / 100.0;
        [sound setVolume:val];
    }
    
    [sound setCurrentTime:1.0];
    [sound play];
}


/**
 *  get timer db file path
 *
 *  @return return path to database file
 */
+ (NSString *) TimerDbFilePath
{
    
    NSString *dbFolder = [NSString stringWithFormat:@"%@/TimerDb",
                          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"]];
    NSError *error;
    NSString *result =
    [Utilities
     findOrCreateDirectory:NSApplicationSupportDirectory
     inDomain:NSUserDomainMask
     appendPathComponent:dbFolder
     error:&error];
    if (error)
    {
        NSLog(@"Unable to find or create application support directory:\n%@", error);
    }
    return [NSString stringWithFormat:@"%@/TimerDB.db", result];
    
    
}

/**
 *  removes those logs from under -Recent, if they are also in -Today
 *
 *  @param array       arra
 *  @param recentIndex recent entry log
 *
 *  @return <#return value description#>
 */
+(NSMutableArray *) unique:(NSMutableArray *)array withIndex:(int)recentIndex
{
    
    int count = [array count];
    
    for (int i = count -1; i > recentIndex; i--)
    {
        NSString *logs = [[array objectAtIndex:i] objectForKey:@"logs"];
        if ([logs isEqualToString:@"- Recent"])
            break;
        for (int j = recentIndex - 1; j >= 0; j--)
        {
            
            NSString *compareLogs = [[array objectAtIndex:j] objectForKey:@"logs"];
            
            if ([compareLogs isEqualToString:logs])
            {
                [array removeObjectAtIndex:i];
            }
            
        }
    }
    return array;
}



@end
