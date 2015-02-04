/*
     File: DraggableItemView.m 
 Abstract: Part of the DraggableItemView project referenced in the 
 View Programming Guide for Cocoa documentation.
 
  Version: 1.1
 */

#import "DraggableItemView.h"
#import "Context.h"
#import "MapObj.h"
@implementation DraggableItemView

// -----------------------------------
// Initialize the View
// -----------------------------------

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
	// setup the starting location of the
	// draggable item
    }
    return self;
}

-(void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    NSRect screen = [self bounds];
    int SW = screen.size.width;
    int SH = screen.size.height;
    [[NSColor greenColor] set];
    int maxW = MAPWIDTH/RHOMBUSNCOORDINATEWIDTH;
    int maxH = MAPHEIGHT/RHOMBUSNCOORDINATEWIDTH;

    for (int i = 0; i<=maxW; i++) {
        NSPoint  lf =NSMakePoint(0, RHOMBUSNCOORDINATEWIDTH*i);
        NSPoint  rt =NSMakePoint(SW, RHOMBUSNCOORDINATEWIDTH*i);
        [NSBezierPath strokeLineFromPoint:lf toPoint:rt];
    }
    for (int i = 0; i<=maxH; i++) {
        NSPoint  bm =NSMakePoint(RHOMBUSNCOORDINATEWIDTH*i, 0);
        NSPoint  top =NSMakePoint(RHOMBUSNCOORDINATEWIDTH*i, SH);
        [NSBezierPath strokeLineFromPoint:bm toPoint:top];
    }
}

-(void)awakeFromNib{
    _objects = [[NSMutableDictionary alloc]init];
    _routes = [[NSMutableDictionary alloc]init];
    _isAddRoute = NO;
    _isDeleteRoute = NO;
    [self registerForDraggedTypes:[NSArray arrayWithObjects:
                                   NSStringPboardType, nil]];    
}


-(MapObj *)addObjectForMap:(NSDictionary*)data withPoint:(NSPoint)point
{
    if (![self.objects objectForKey:NSStringFromPoint(point)]) {
        MapObj * obj = [[MapObj alloc]init];
        [obj loadData:data];
        [obj setPosition:point];
        [self.map addSubview:obj];
        [self.objects setObject:obj forKey:NSStringFromPoint(point)];
        return obj;
    }
    return nil;
}

-(void)addRoutesforMap:(NSPoint)point
{
    if (![self.routes objectForKey:NSStringFromPoint(point)]) {
        for (NSDictionary* data in [[DataManager sharedDataManager].gameData allValues]) {
            if ([[data objectForKey:@"type"] isEqualToString:@"route"]) {
                MapObj * obj = [[MapObj alloc]init];
                [obj loadData:data];
                [obj setPosition:point];
                [self.routesMap addSubview:obj];
                [self.routes setObject:obj forKey:NSStringFromPoint(point)];
                break;
            }
        }
    }
}

-(void)delRoutesforMap:(NSPoint)point
{
    MapObj* route = [self.routes objectForKey:NSStringFromPoint(point)];
    if (route) {
        [route removeFromSuperview];
    }
    [self.routes removeObjectForKey:NSStringFromPoint(point)];
}

- (BOOL)isPointInItem:(NSPoint)testPoint
{
    BOOL itemHit=NO;
    
    // test first if we're in the rough bounds
    MapObj* obj = [self.objects objectForKey:NSStringFromPoint(testPoint)];
    // yes, lets further refine the testing
    if (obj) {
        itemHit = YES;
        selcetObj = obj;
        
    }else{
        selcetObj = nil;
    }
   
    return itemHit;
}

-(NSMutableDictionary*)mapData
{
    NSMutableDictionary* allData = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary* allObjs = [[NSMutableDictionary alloc]init];
    for (NSString* key in [self.objects allKeys]) {
        MapObj* obj = [self.objects objectForKey:key];
        [allObjs setObject:[obj getData] forKey:key];
    }
    [allData setObject:allObjs forKey:@"objs"];
    
    NSMutableDictionary* allroutes = [[NSMutableDictionary alloc]init];
    for (NSString* key in [self.routes allKeys]) {
        MapObj* obj = [self.routes objectForKey:key];
        [allroutes setObject:[obj getData] forKey:key];
    }
    [allData setObject:allroutes forKey:@"routes"];

    return allData;
}

-(void)loadMap:(NSDictionary*)mapData
{
    NSDictionary* objects = [mapData objectForKey:@"objs"];
    for (NSString* key in [objects allKeys]) {
        NSString* name = [[objects objectForKey:key]objectForKey:@"name"];
        NSDictionary* objData = [[DataManager sharedDataManager].gameData objectForKey:name];
        MapObj* obj = [self addObjectForMap:objData withPoint:NSPointFromString(key)];
        [obj setSave:[objects objectForKey:key]];
    }
    NSDictionary* routes = [mapData objectForKey:@"routes"];
    for (NSString* key in [routes allKeys]) {
        [self addRoutesforMap:NSPointFromString(key)];
    }
}

// -----------------------------------
// Handle Mouse Events 
// -----------------------------------

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

#pragma move obj
-(void)mouseDown:(NSEvent *)event
{
    
    NSPoint clickLocation;
    BOOL itemHit=NO;
    
    // convert the click location into the view coords
    clickLocation = [self convertPoint:[event locationInWindow]
			      fromView:nil];

    NSPoint p = [self convertPoint:clickLocation];
    NSLog(@"mouseDown%@",NSStringFromPoint(p));

    itemHit = [self isPointInItem:p];
    
    if (itemHit) {
        dragging=YES;
        selcetObj.lastLoc = p;
    }
}

-(void)mouseDragged:(NSEvent *)event
{
    NSPoint newDragLocation=[self convertPoint:[event locationInWindow] fromView:nil];
    
    // save the new drag location for the next drag event
    NSPoint p = [self convertPoint:newDragLocation];

    if (self.isAddRoute) {
        [self addRoutesforMap:p];
        return;
    }
    if (self.isDeleteRoute) {
        [self delRoutesforMap:p];
        return;
    }
    if (dragging) {
        int maxW = MAPWIDTH/RHOMBUSNCOORDINATEWIDTH;
        int maxH = MAPHEIGHT/RHOMBUSNCOORDINATEWIDTH;
        if (selcetObj) {
            if (p.x>=0 && p.x<= maxW && p.y>=0 && p.y<= maxH) {
                [selcetObj setPosition:p];
            }
        }
        return;
    }
}

-(void)mouseUp:(NSEvent *)event
{
    NSPoint clickLocation = [self convertPoint:[event locationInWindow]
                              fromView:nil];
    NSLog(@"mouseUp%@",NSStringFromPoint([self convertPoint:clickLocation]));
    dragging=NO;
    if (selcetObj) {
        MapObj* obj = [self.objects objectForKey:NSStringFromPoint(selcetObj.loc)];
        if (obj && obj != selcetObj) {
            [selcetObj setPosition:selcetObj.lastLoc];
        }else{
            [self.objects removeObjectForKey:NSStringFromPoint(selcetObj.lastLoc)];
            [self.objects setObject:selcetObj forKey:NSStringFromPoint(selcetObj.loc)];
            [self.edit setObject:selcetObj];
        }
    }
}

-(void)rightMouseDown:(NSEvent *)theEvent
{
    NSPoint clickLocation;
    BOOL itemHit=NO;
    
    // convert the click location into the view coords
    clickLocation = [self convertPoint:[theEvent locationInWindow]
                              fromView:nil];
    
    NSPoint p = [self convertPoint:clickLocation];
    NSLog(@"rightMouseUp%@",NSStringFromPoint(p));
    
    itemHit = [self isPointInItem:p];
    if (itemHit) {
        dragging=NO;
    }
    
    [[self nextResponder] rightMouseDown:theEvent];
//    [self.superview rightMouseDown:theEvent];

}

-(void)rightMouseUp:(NSEvent *)theEvent
{
    NSPoint clickLocation = [self convertPoint:[theEvent locationInWindow]
                                      fromView:nil];
    NSLog(@"rightMouseUp%@",NSStringFromPoint([self convertPoint:clickLocation]));
    if (selcetObj) {
        MapObj* obj = [self.objects objectForKey:NSStringFromPoint([self convertPoint:clickLocation])];
        if (obj && obj == selcetObj) {
            [selcetObj removeFromSuperview];
            [self.objects removeObjectForKey:NSStringFromPoint(selcetObj.loc)];
            [self.edit setObject:nil];
            selcetObj = nil;
        }
    }
    [[self nextResponder] rightMouseUp:theEvent];

//    [self.superview rightMouseUp:theEvent];
}

#pragma drag in
- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSStringPboardType] ) {
        if (sourceDragMask & NSDragOperationCopy) {
            return NSDragOperationCopy;
        }
    }
    return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSStringPboardType] ) {
        NSString *name = [pboard propertyListForType:NSStringPboardType];
        NSDictionary* data = [[DataManager sharedDataManager].gameData objectForKey:name];
        NSPoint newDragLocation=[self convertPoint:[sender draggingLocation] fromView:nil];
        NSPoint p = [self convertPoint:newDragLocation];

        [self addObjectForMap:data withPoint:p];
    }
    return YES;
}

-(void)clearAll
{
    for (MapObj* obj in [self.objects allValues]){
        [obj removeFromSuperview];
    }
    [self.objects removeAllObjects];
    for (MapObj* route in [self.routes allValues]){
        [route removeFromSuperview];
    }
    [self.routes removeAllObjects];
    self.isAddRoute = NO;
    self.isDeleteRoute = NO;
}

@end
