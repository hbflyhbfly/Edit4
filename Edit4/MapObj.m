//
//  MapObj.m
//  Edit4
//
//  Created by Syuuhi on 15/1/29.
//  Copyright (c) 2015年 Syuuhi. All rights reserved.
//

#import "MapObj.h"
#import "Context.h"

@implementation MapObj

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)loadData:(NSDictionary*)data{
    [self setImage:[NSImage imageNamed:[data objectForKey:@"icon"]]];
    self.name = [data objectForKey:@"name"];
    self.type = [data objectForKey:@"type"];

    
    if ([self.type isEqualToString:@"ground"]) {
        [self setFrameSize:NSSizeFromCGSize(CGSizeMake(RHOMBUSNCOORDINATEWIDTH, RHOMBUSNCOORDINATEWIDTH))];
    }else{
        [self setFrameSize:NSSizeFromCGSize(CGSizeMake(RHOMBUSNCOORDINATEWIDTH/2, RHOMBUSNCOORDINATEWIDTH/2))];
    }
}

-(void)setPosition:(NSPoint )point
{
    self.loc = point;
    self.frame = NSRectFromCGRect(CGRectMake((point.x)*RHOMBUSNCOORDINATEWIDTH, (point.y)*RHOMBUSNCOORDINATEWIDTH,self.frame.size.width,self.frame.size.height));
}

-(NSPoint)convertPoint:(NSPoint)point
{
    
    NSPoint p = NSPointFromCGPoint(CGPointMake(-1, -1));
    if (point.x > RHOMBUSNLAYERWIDTH || point.x < 0) {
        return p;
    }
    if (point.y > RHOMBUSNLAYERWIDTH || point.y < 0) {
        return p;
    }
    int x = point.x/RHOMBUSNCOORDINATEWIDTH;
    int y = point.y/RHOMBUSNCOORDINATEWIDTH;
    p = NSPointFromCGPoint(CGPointMake(x,y));
    return p;
}

@end
