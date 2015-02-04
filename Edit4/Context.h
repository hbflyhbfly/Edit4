//
//  Context.h
//  Edit4
//
//  Created by Syuuhi on 15/1/29.
//  Copyright (c) 2015年 Syuuhi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DataManager.h"
#import "DraggableItemView.h"

#define RHOMBUSNCOORDINATEWIDTH 30

#define MAPWIDTH 1200
#define MAPHEIGHT 1200


@interface Context : NSViewController<NSTableViewDataSource, NSTableViewDelegate>
{
    NSPoint lastDragPoint;
}

@property (nonatomic,strong) IBOutlet NSTableView *objectsTable;

@property (nonatomic,strong) IBOutlet NSView *container;

@property (nonatomic,strong) IBOutlet NSView *scroll;


@property (nonatomic,strong) IBOutlet NSImageView *background;

@property (nonatomic,strong) IBOutlet NSButton *addBnt;

@property (nonatomic,strong) IBOutlet NSButton *saveBnt;

@property (nonatomic,strong) IBOutlet NSButton *loadBnt;

@property (nonatomic,strong) IBOutlet NSButton *routeBnt;

@property (nonatomic,strong) IBOutlet NSButton *delRouteBnt;

@property (nonatomic,strong) IBOutlet DraggableItemView *dragView;
@property (nonatomic,strong) IBOutlet EditView *edit;

@property (nonatomic,retain) NSMutableArray *objectsTableData;

@end
