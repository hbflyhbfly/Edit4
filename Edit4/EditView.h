//
//  EditView.h
//  Edit4
//
//  Created by Syuuhi on 15/1/30.
//  Copyright (c) 2015年 Syuuhi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MapObj.h"

@interface EditView : NSView

@property (nonatomic,strong) IBOutlet NSTextField *name;
@property (nonatomic,strong) IBOutlet NSTextField *type;

@property (nonatomic,strong) IBOutlet NSTextField *eventTime;

@property (nonatomic,strong) IBOutlet NSTextField *targetX;
@property (nonatomic,strong) IBOutlet NSTextField *targetY;

@property (nonatomic,assign) MapObj* selfObj;

-(void)setObject:(MapObj*)obj;

@end
