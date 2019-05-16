//
//  Map.h
//  ProjSulfur
//
//  Created by Steve Clement on 5/8/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libtcod.h"
#import "Item.h"
#import "ItemManager.h"

#define SCREEN_WIDTH 110
#define SCREEN_HEIGHT 60

NS_ASSUME_NONNULL_BEGIN

@interface Map : NSObject {
    Boolean tiles[SCREEN_WIDTH][SCREEN_HEIGHT];
}

/*! @brief Zone1 TCOD map */
@property(nonatomic, readonly) TCOD_map_t zone1;
/*! @brief a room fills a random part of the node or the maximum available space ? */
@property(nonatomic, readonly) bool randomRoom;
/*! @brief if true, there is always a wall on north & west side of a room */
@property(nonatomic, readonly) bool roomWalls;
@property(nonatomic, readonly) int minRoomSize;
@property(nonatomic, readonly) int torchRadius;
@property(nonatomic, readonly) float torchx;
@property(nonatomic, readonly) TCOD_color_t darkWall;
@property(nonatomic, readonly) TCOD_color_t darkGround;
@property(nonatomic, readonly) TCOD_color_t lightWall;
@property(nonatomic, readonly) TCOD_color_t lightGround;
@property(nonatomic, readonly) TCOD_noise_t noise;

-(void)render:(int)px y:(int)py;
-(Boolean)isExploredX:(int) x andY:(int) y;
-(Boolean)isInFOVX:(int) x andY:(int) y;
-(Boolean)isWallX:(int) x andY:(int) y;
-(Boolean)canWalkX:(int) x andY:(int) y;
-(void)computeFOV:(int) x andY:(int) y;
-(void)setWallPosX:(int) x andY:(int) y;
-(void)digAtX1:(int) x1 andY1:(int) y1 andX2:(int) x2 andY2:(int) y2;
-(void)createRoomAtX1:(int) x1 andY1:(int) y1 andX2:(int) x2 andY2:(int) y2;
-(void)vline:(int) x y1:(int) y1 y2:(int) y2;
-(void)vline_up:(int) x y:(int) y;
-(void)vline_down:(int) x y:(int) y;
-(void)hline:(int) x1 y:(int) y x2:(int) x2;
-(void)hline_left:(int) x y:(int) y;
-(void)hline_right:(int) x y:(int) y;
-(void)createRooms:(int) num;

@end

NS_ASSUME_NONNULL_END
