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
//        self.gameData = [[NSMutableDictionary alloc]init];
//        [self.gameData setObject:[NSDictionary dictionaryWithObjectsAndKeys:NSImageNameNetwork,@"icon",@"type1",@"type",@"obj1",@"name", nil] forKey:@"obj1"];
//        [self.gameData setObject:[NSDictionary dictionaryWithObjectsAndKeys:NSImageNameMobileMe,@"icon",@"type2",@"type",@"obj2",@"name", nil] forKey:@"obj2"];
//        [self.gameData setObject:[NSDictionary dictionaryWithObjectsAndKeys:NSImageNameFolderBurnable,@"icon",@"type3",@"type",@"obj3",@"name", nil] forKey:@"obj3"];
//        [self.gameData setObject:[NSDictionary dictionaryWithObjectsAndKeys:NSImageNameRefreshTemplate,@"icon",@"type4",@"type",@"obj4",@"name", nil] forKey:@"obj4"];
//        [self.gameData setObject:[NSDictionary dictionaryWithObjectsAndKeys:NSImageNameLeftFacingTriangleTemplate,@"icon",@"type5",@"type",@"obj5",@"name", nil] forKey:@"obj5"];
        
        NSString *contentPath = [[NSBundle mainBundle] pathForResource:@"objects" ofType:@"json"];
        NSString *datas = [NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[datas dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        self.gameData = [[NSMutableDictionary alloc]initWithDictionary:data];
    }
    
    return self;
}
@end
