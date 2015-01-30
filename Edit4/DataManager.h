//
//  DataManager.h
//  Edit4
//
//  Created by Syuuhi on 15/1/30.
//  Copyright (c) 2015年 Syuuhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
@interface DataManager : NSObject
@property (nonatomic, retain) NSMutableDictionary * gameData;

+ (DataManager *) sharedDataManager;

@end
