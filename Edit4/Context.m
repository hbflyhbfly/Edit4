//
//  Context.m
//  Edit4
//
//  Created by Syuuhi on 15/1/29.
//  Copyright (c) 2015年 Syuuhi. All rights reserved.
//
#import "GTMBase64.h"
#import "Context.h"

@interface Context ()

@end

@implementation Context

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.objectsTable setDraggingSourceOperationMask:NSDragOperationCopy forLocal:YES];
    [self.objectsTable registerForDraggedTypes:[NSArray arrayWithObjects:NSStringPboardType,nil]];
    [self createObjectData];
}

-(void)createObjectData{
    self.objectsTableData =  [[NSMutableArray alloc]init];
    NSMutableDictionary* allDatas = [DataManager sharedDataManager].gameData;
    for (NSDictionary* data in [allDatas allValues]) {
        if ([[data objectForKey:@"type"] isEqualToString:@"route"]) {
            continue;
        }
        [self.objectsTableData addObject:[NSDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"name"],@"name",[NSImage imageNamed:[data objectForKey:@"icon"]],@"icon",[data objectForKey:@"description"],@"description", nil]];
    }
    [self.objectsTable reloadData];
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
    NSLog(@"click------%@",NSStringFromPoint(p));
    return p;
}
#pragma table
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.objectsTableData count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    NSDictionary *dic = [self.objectsTableData objectAtIndex:rowIndex];
    
    return dic;
}

-(void)rightMouseDown:(NSEvent *)theEvent{
    NSPoint clickLocation = [self.scroll convertPoint:[theEvent locationInWindow]
                                             fromView:nil];
    NSLog(@"Context--rightMouseDown");
        lastDragPoint = clickLocation;
}

-(void)rightMouseDragged:(NSEvent *)theEvent
{
    NSPoint clickLocation = [self.scroll convertPoint:[theEvent locationInWindow]
                                             fromView:nil];
    NSLog(@"Context--rightMouseDragged--%@",NSStringFromPoint(clickLocation));
    NSPoint containerLoc = self.container.frame.origin;
    [self.container setFrameOrigin:NSMakePoint(containerLoc.x+clickLocation.x - lastDragPoint.x,containerLoc.y + clickLocation.y - lastDragPoint.y)];
    lastDragPoint = clickLocation;
}

-(void)magnifyWithEvent:(NSEvent *)event
{
    NSLog(@"Context--magnifyWithEvent");
}

- (void)keyDown:(NSEvent *)event {
    NSLog(@"Hi there");
    NSString *characters = [event characters];
    NSSize size = self.container.frame.size;
    if ([characters length]) {
        switch ([characters characterAtIndex:0]) {
            case NSLeftArrowFunctionKey:
                NSLog(@"Key +");
                [self.container scaleUnitSquareToSize:NSMakeSize(1.3, 1.3)];
                [self.container setFrameSize:NSMakeSize(size.width*1.3, size.height*1.3)];
                [self.container setNeedsDisplay:YES];
                [self.container displayIfNeeded];
                break;
            case NSRightArrowFunctionKey:
                NSLog(@"Key -");
                [self.container scaleUnitSquareToSize:NSMakeSize(0.7, 0.7)];
                [self.container setFrameSize:NSMakeSize(size.width*0.7, size.height*0.7)];
                [self.container setNeedsDisplay:YES];
                [self.container displayIfNeeded];
                break;
        }
    }
}
-(IBAction)selector:(id)sender{
    if (sender == self.addBnt) {
        NSOpenPanel *openPanel = [NSOpenPanel openPanel];
        [openPanel setCanChooseFiles:YES];
        [openPanel setCanCreateDirectories:NO];
        [openPanel setAllowsMultipleSelection:NO];
        [openPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"jpg",@"png", nil]];
        [openPanel beginWithCompletionHandler:^(NSInteger result){
            if (result == NSFileHandlingPanelOKButton) {
                [self.dragView clearAll];
                for (NSURL* url in [openPanel URLs]) {
                    NSString* background = [[url absoluteString]lastPathComponent];
                    NSData* data = [NSData dataWithContentsOfURL:url];
                    NSImage* image = [[NSImage alloc]initWithData:data];
                    image.name = background;
                    image.size = NSSizeFromCGSize(CGSizeMake(MAPWIDTH, MAPHEIGHT));
                    [self.background setImage:image];
                    break;
                }
            }
        }];
    }else if (sender == self.loadBnt){
        NSOpenPanel *openPanel = [NSOpenPanel openPanel];
        [openPanel setCanChooseFiles:YES];
        [openPanel setCanCreateDirectories:NO];
        [openPanel setAllowsMultipleSelection:NO];
        [openPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"json", nil]];
        [openPanel beginWithCompletionHandler:^(NSInteger result){
            if (result == NSFileHandlingPanelOKButton) {
                for (NSURL* url in [openPanel URLs]) {
                    NSData* data = [NSData dataWithContentsOfURL:url];
                    NSData *base64Data = [GTMBase64 decodeData:data];
                    NSDictionary *mapData = [NSJSONSerialization JSONObjectWithData:base64Data options:NSJSONReadingMutableContainers error:nil];
                    if (mapData) {
                        NSString* path = [[url absoluteString] stringByDeletingLastPathComponent];
                        NSString* background = [mapData objectForKey:@"background"];
                        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",path,background]]];
                        if (data) {
                            NSImage* image = [[NSImage alloc]initWithData:data];
                            image.size = NSSizeFromCGSize(CGSizeMake(MAPWIDTH, MAPHEIGHT));
                            [self.background setImage:image];
                            self.background.image.name = background;
                        }
                        [self.dragView clearAll];
                        [self.dragView loadMap:mapData];
                    }
                    break;
                }
            }
        }];
    }else if (sender == self.saveBnt){
        NSSavePanel* savePanel = [NSSavePanel savePanel];
        [savePanel setWorksWhenModal:NO];
        [savePanel beginWithCompletionHandler:^(NSInteger result){
            if (result == NSFileHandlingPanelOKButton) {
                NSURL* url = [savePanel URL];
                NSData *data = [self enCodeMap];
                [data writeToURL:url atomically:NO];
            }
        }];
    }else if(sender == self.routeBnt){
        if (self.dragView.isAddRoute) {
            self.routeBnt.title = @"画路";
        }else{
            self.routeBnt.title = @"正在画路";
        }
        self.dragView.isAddRoute = !self.dragView.isAddRoute;
        self.dragView.isDeleteRoute = NO;
        self.delRouteBnt.title = @"删路";
    }else if (sender == self.delRouteBnt){
        if (self.dragView.isDeleteRoute) {
            self.delRouteBnt.title = @"删路";
        }else{
            self.delRouteBnt.title = @"正在删路";
        }
        self.dragView.isDeleteRoute = !self.dragView.isDeleteRoute;
        self.dragView.isAddRoute = NO;
        self.routeBnt.title = @"画路";

    }
}

-(NSData*) enCodeMap
{
    NSMutableDictionary* allData = [self.dragView mapData];
    [allData setObject:self.background.image.name forKey:@"background"];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:allData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSData *base64Data = [GTMBase64 encodeData:jsonData];

    if (base64Data && error == nil){
        return base64Data;
    }else{
        return nil;
    }
}

#pragma mark Drag & Drop Delegates

- (BOOL)tableView:(NSTableView *)aTableView
writeRowsWithIndexes:(NSIndexSet *)rowIndexes
     toPasteboard:(NSPasteboard*)pboard
{
    if(aTableView == self.objectsTable)
    {
        NSArray* array = [self.objectsTableData objectsAtIndexes:rowIndexes];
        [pboard setString:[[array firstObject] objectForKey:@"name"] forType:NSStringPboardType];
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSDragOperation)tableView:(NSTableView*)tv
                validateDrop:(id <NSDraggingInfo>)info
                 proposedRow:(NSInteger)row
       proposedDropOperation:(NSTableViewDropOperation)op
{
    return NSDragOperationEvery;
}

#pragma EditObj
-(void)controlTextDidEndEditing:(NSNotification *)obj{
    NSTextField *textField = [obj object];
    MapObj* selectObj = [self.dragView.objects objectForKey:NSStringFromPoint(self.edit.selfObj.loc)];
    if (selectObj) {
        if([textField.identifier isEqualToString:@"target_x"]){
            selectObj.targetX = [[textField stringValue] intValue];
        }else if([textField.identifier isEqualToString:@"target_y"]){
            selectObj.targetY = [[textField stringValue] intValue];
        }
    }
}

@end
