//
//  DataManager.m
//  Edit4
//
//  Created by Syuuhi on 15/1/30.
//  Copyright (c) 2015年 Syuuhi. All rights reserved.
//

#import "DataManager.h"
#import <Cocoa/Cocoa.h>

@implementation DataManager

SYNTHESIZE_SINGLETON_FOR_CLASS(DataManager)

-(id)init
{
    self = [super init];
    if (self)
    {
        self.gameData = [[NSMutableDictionary alloc]init];
        [self.gameData setObject:[NSDictionary dictionaryWithObjectsAndKeys:NSImageNameNetwork,@"icon",@"type1",@"tpye", nil] forKey:@"obj1"];
        [self.gameData setObject:[NSDictionary dictionaryWithObjectsAndKeys:NSImageNameMobileMe,@"icon",@"type2",@"tpye", nil] forKey:@"obj2"];
        [self.gameData setObject:[NSDictionary dictionaryWithObjectsAndKeys:NSImageNameFolderBurnable,@"icon",@"type3",@"tpye", nil] forKey:@"obj3"];
        [self.gameData setObject:[NSDictionary dictionaryWithObjectsAndKeys:NSImageNameRefreshTemplate,@"icon",@"type4",@"tpye", nil] forKey:@"obj4"];
        [self.gameData setObject:[NSDictionary dictionaryWithObjectsAndKeys:NSImageNameLeftFacingTriangleTemplate,@"icon",@"type5",@"tpye", nil] forKey:@"obj5"];
    }
    
    return self;
}
@end
