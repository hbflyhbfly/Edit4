//
//  MapObj.h
//  Edit4
//
//  Created by Syuuhi on 15/1/29.
//  Copyright (c) 2015年 Syuuhi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MapObj : NSImageView
{
    NSPoint lastLoc;
}

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,assign) NSPoint loc;
@property (nonatomic,assign) double eventTime;


-(void)loadData:(NSDictionary*)data;
-(void)setPosition:(NSPoint )point;
@end
