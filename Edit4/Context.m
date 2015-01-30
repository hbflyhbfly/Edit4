//
//  Context.m
//  Edit4
//
//  Created by Syuuhi on 15/1/29.
//  Copyright (c) 2015年 Syuuhi. All rights reserved.
//

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
    for (NSString* name in [allDatas allKeys]) {
        [self.objectsTableData addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSImage imageNamed:[[allDatas objectForKey:name] objectForKey:@"icon"]],@"icon",name,@"name", nil]];
    }
    [self.objectsTable reloadData];
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

//-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
//    NSTableCellView *result = [tableView makeViewWithIdentifier:@"NSTableCellView" owner:self];
//    if (!result) {
//        result = [[NSTableCellView alloc]init];
//    }
//    NSDictionary *data = [self.objectsTableData objectAtIndex:row];
//    result.textField.stringValue = [data objectForKey:@"name"];
//    return result;
//}

#pragma drag
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

-(IBAction)selector:(id)sender{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanCreateDirectories:NO];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"jpg",@"png", nil]];
    [openPanel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            for (NSURL* url in [openPanel URLs]) {
                NSData* data = [NSData dataWithContentsOfURL:url];
                
                NSImage* image = [[NSImage alloc]initWithData:data];
                image.size = NSSizeFromCGSize(CGSizeMake(RHOMBUSNLAYERWIDTH, RHOMBUSNLAYERWIDTH));
                [self.map setImage:image];
            }
        }
    }];

}

@end
