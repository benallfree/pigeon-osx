//
//  Utilities.h
//  Timer
//
//  Created by jenkins on 6/20/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+ (NSString *) TimerDbFilePath;
+ (NSString *) PrefFilePath;
+(void) stopSound;
+(void) playSound:(NSString *)filekey volumeKey:(NSString *)volKey default:(NSString *)defaultSound;
+(void) playSoundStripped:(NSString *)filekey volumeKey:(NSString *)volKey default:(NSString *)defaultSound;
+(void) playSound:(NSString *)filekey volumeKey:(NSString *)volKey default:(NSString *)defaultSound running:(BOOL)playIfNotrunning;
+(NSMutableArray *) unique:(NSMutableArray *)array withIndex:(int)recentIndex;
@end
