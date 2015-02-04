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
    self.icon = [data objectForKey:@"icon"];
    self.targetX = -1;
    self.targetY = -1;
    self.name = [data objectForKey:@"name"];
    self.type = [data objectForKey:@"type"];
    if ([self.type isEqualToString:@"route"]) {
        [self setFrameSize:NSSizeFromCGSize(CGSizeMake(RHOMBUSNCOORDINATEWIDTH, RHOMBUSNCOORDINATEWIDTH))];
    }else{
        [self setFrameSize:NSSizeFromCGSize(CGSizeMake(RHOMBUSNCOORDINATEWIDTH/2, RHOMBUSNCOORDINATEWIDTH/2))];
    }
}

-(NSDictionary*)getData
{
    /**
     name,
     target,
     loc
     */
    return [NSDictionary dictionaryWithObjectsAndKeys:self.name,@"name",NSStringFromPoint(NSPointFromCGPoint(CGPointMake(self.targetX, self.targetY))),@"target",NSStringFromPoint(self.loc),@"loc", nil];
}

-(void)setPosition:(NSPoint )point
{
    self.loc = point;
    self.frame = NSRectFromCGRect(CGRectMake((point.x)*RHOMBUSNCOORDINATEWIDTH, (point.y)*RHOMBUSNCOORDINATEWIDTH,self.frame.size.width,self.frame.size.height));
}

-(NSPoint)convertPoint:(NSPoint)point
{
    NSPoint p = NSPointFromCGPoint(CGPointMake(-1, -1));
    if (point.x > MAPWIDTH || point.x < 0) {
        return p;
    }
    if (point.y > MAPHEIGHT || point.y < 0) {
        return p;
    }
    int x = point.x/RHOMBUSNCOORDINATEWIDTH;
    int y = point.y/RHOMBUSNCOORDINATEWIDTH;
    p = NSPointFromCGPoint(CGPointMake(x,y));
    return p;
}

-(void)setSave:(NSDictionary*)save
{
    self.loc = NSPointFromString([save objectForKey:@"loc"]);
    NSPoint target = NSPointFromString([save objectForKey:@"target"]);
    self.targetX = (int)target.x;
    self.targetY = (int)target.y;
}
@end
