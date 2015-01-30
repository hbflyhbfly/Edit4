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
    int max = RHOMBUSNLAYERWIDTH/RHOMBUSNCOORDINATEWIDTH;
    for (int i = 0; i<=max; i++) {
        NSPoint  lf =NSMakePoint(0, RHOMBUSNCOORDINATEWIDTH*i);
        NSPoint  rt =NSMakePoint(SW, RHOMBUSNCOORDINATEWIDTH*i);
        NSPoint  bm =NSMakePoint(RHOMBUSNCOORDINATEWIDTH*i, 0);
        NSPoint  top =NSMakePoint(RHOMBUSNCOORDINATEWIDTH*i, SH);
        [NSBezierPath strokeLineFromPoint:bm toPoint:top];
        [NSBezierPath strokeLineFromPoint:lf toPoint:rt];
    }
}

-(void)awakeFromNib{
    _objects = [[NSMutableDictionary alloc]init];
    [self registerForDraggedTypes:[NSArray arrayWithObjects:
                                   NSStringPboardType, nil]];
}


-(void)addObjectForMap:(NSDictionary*)data withPoint:(NSPoint)point
{
    NSPoint p = [self convertPoint:point];
    MapObj * obj = [[MapObj alloc]init];
    [obj loadData:data];
    [obj setPosition:p];
    
    [self.map addSubview:obj];
    [self.objects setObject:obj forKey:NSStringFromPoint(p)];
    
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

// -----------------------------------
// Handle Mouse Events 
// -----------------------------------

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
    
	lastDragLocation = p;
	
    }
}

-(void)mouseDragged:(NSEvent *)event
{
    if (dragging) {
        NSPoint newDragLocation=[self convertPoint:[event locationInWindow] fromView:nil];
	
        // save the new drag location for the next drag event
        NSPoint p = [self convertPoint:newDragLocation];
        int max = RHOMBUSNLAYERWIDTH/RHOMBUSNCOORDINATEWIDTH;
        if (selcetObj) {
            if (p.x>=0 && p.x<= max && p.y>=0 && p.y<= max) {
                [selcetObj setPosition:p];
            }
        }
    }
}

-(void)mouseMoved:(NSEvent *)theEvent{
    NSLog(@"mouseMoved");
}
-(void)mouseUp:(NSEvent *)event
{
    NSPoint clickLocation = [self convertPoint:[event locationInWindow]
                              fromView:nil];
    NSLog(@"mouseUp%@",NSStringFromPoint([self convertPoint:clickLocation]));
    dragging=NO;
    if (selcetObj) {
        [self.objects setObject:selcetObj forKey:NSStringFromPoint(selcetObj.loc)];
    }
    selcetObj = nil;
}

-(void)mouseExited:(NSEvent *)theEvent
{
    NSLog(@"mouseExited!");
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

        [self addObjectForMap:data withPoint:newDragLocation];
    }
    return YES;
}

@end
