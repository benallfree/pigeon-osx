//
//  CustomNSField.mm
//  OpenDrive
//
//  Created by Munir Ahmed on 2/12/12.
//  Copyright 2012 geeNian. All rights reserved.
//

#import "CustomNSField.h"


@implementation CustomNSField

/**
 *  this function captures the key actions done on text field, and copy/paste/select all operations
 *
 *  @param event
 *
 *  @return
 */

- (BOOL)performKeyEquivalent:(NSEvent *)event {
	NSLog(@"perform key equivalent");
    if (([event modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask) {
        // The command key is the ONLY modifier key being pressed.
        if ([[event charactersIgnoringModifiers] isEqualToString:@"x"]) {
            return [NSApp sendAction:@selector(cut:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"c"]) {
            return [NSApp sendAction:@selector(copy:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"v"]) {
            return [NSApp sendAction:@selector(paste:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"a"]) {
            return [NSApp sendAction:@selector(selectAll:) to:[[self window] firstResponder] from:self];
        }
    }
    return [super performKeyEquivalent:event];
}
@end


