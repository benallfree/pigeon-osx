//
//  ReportTableCellView.h
//  Pigeon Timer
//
//  Created by Munir Ahmed on 05/04/2015.
//  Copyright (c) 2015 GreatBasinGroup. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ReportTableCellView : NSTableCellView
    @property(strong, nonatomic) IBOutlet NSButton *buttonStatus;
    @property(strong, nonatomic)  NSNumber *selected;
    @property(strong, nonatomic)  NSString *title;
@end
