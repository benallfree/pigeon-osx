//
//  Utilities.m
//  Timer
//
//  Created by jenkins on 6/20/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities


/**
 *  finds or create application support folder for EgnyteDrive
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
 *  returns the path to the egnyte drive database file.
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

@end
