//
//  ItemManager.h
//  ProjSulfur
//
//  Created by Steve Clement on 5/14/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "Map.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemManager : NSObject

@property (nonatomic, readwrite) NSMutableArray *zone1Items;
@property (nonatomic, readwrite) NSMutableArray *zone2Items;
@property (nonatomic, readwrite) NSMutableArray *zone3Items;
@property (nonatomic, readwrite) NSMutableArray *zone4Items;
@property (nonatomic, readwrite) NSMutableArray *zone5Items;

-(NSMutableArray *)getItemsForZone:(int)zone;


@end

NS_ASSUME_NONNULL_END
