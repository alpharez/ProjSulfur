//
//  Engine.h
//  ProjSulfur
//
//  Created by Steve Clement on 5/8/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libtcod.h"
#import "LifeForm.h"
#import "Critter.h"
#import "Map.h"
#import "HUD.h"
#import <SDL2/SDL.h>

NS_ASSUME_NONNULL_BEGIN

@interface Engine : NSObject

/*!
 * @typedef GameStatus
 * @brief Status of game
 * @constant OldCarTypeModelT A cool old car.
 * @constant OldCarTypeModelA A sophisticated old car.
 */
typedef enum {
    /// Startup activities before any turns are taken
    STARTUP,
    /// waiting for player action
    IDLE,
    /// player took turn, time for other turns to be taken
    NEW_TURN,
    /// player has won the game
    VICTORY,
    /// player died
    DEFEAT
} GameStatus;

@property(nonatomic, readonly) LifeForm *player;
@property(nonatomic, readwrite) HUD *hud;
@property(nonatomic, readonly) Map *zone1;
@property(nonatomic, readwrite) NSMutableArray *lifeForms;
@property(nonatomic, readwrite) NSMutableArray *items;
@property(nonatomic, readwrite) Boolean computeFov;
@property(nonatomic, readwrite) GameStatus gameStatus;

-(void)render;
-(void)update;
-(Boolean)checkTileAtX:(int)x andY:(int)y;
-(NSString *)ancientTextTranslator:(NSString *)text readingSkill:(int)skill max:(int)maxSkill;

@end

NS_ASSUME_NONNULL_END
