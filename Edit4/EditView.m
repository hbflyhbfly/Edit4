//
//  EditView.m
//  Edit4
//
//  Created by Syuuhi on 15/1/30.
//  Copyright (c) 2015年 Syuuhi. All rights reserved.
//

#import "EditView.h"
#import "DraggableItemView.h"

@implementation EditView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)setObject:(MapObj*)obj
{
    if (obj) {
        self.selfObj = obj;
        self.name.stringValue = obj.name;
        self.type.stringValue = obj.type;
        self.targetX.stringValue = [NSString stringWithFormat:@"%d",obj.targetX ];
        self.targetY.stringValue = [NSString stringWithFormat:@"%d",obj.targetY ];
    }else{
        self.selfObj = obj;
        self.name.stringValue = @"";
        self.type.stringValue = @"";
        self.targetX.stringValue = @"";
        self.targetY.stringValue = @"";
    }
}

@end
