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

#define RHOMBUSNLAYERWIDTH 900

@interface Context : NSViewController<NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic,strong) IBOutlet NSTableView *objectsTable;

@property (nonatomic,strong) IBOutlet NSView *container;

@property (nonatomic,strong) IBOutlet NSImageView *map;

@property (nonatomic,strong) IBOutlet DraggableItemView *dragView;


@property (nonatomic,retain) NSMutableArray *objectsTableData;


@end
