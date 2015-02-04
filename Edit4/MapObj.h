//
//  MapObj.h
//  Edit4
//
//  Created by Syuuhi on 15/1/29.
//  Copyright (c) 2015年 Syuuhi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MapObj : NSImageView

@property (nonatomic,assign) NSString *name;
@property (nonatomic,assign) NSString *type;
@property (nonatomic,assign) int targetX;
@property (nonatomic,assign) int targetY;
@property (nonatomic,assign) NSString *icon;

@property (nonatomic,assign) NSPoint lastLoc;

@property (nonatomic,assign) NSPoint loc;
@property (nonatomic,assign) double eventTime;


-(void)loadData:(NSDictionary*)data;
-(void)setPosition:(NSPoint )point;
-(NSDictionary*)getData;
-(void)setSave:(NSDictionary*)save;
@end
