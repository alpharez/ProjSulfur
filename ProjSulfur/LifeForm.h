//
//  LifeForm.h
//  ProjSulfur
//
//  Created by Steve Clement on 5/8/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libtcod.h"
#import "Map.h"
#import "LFNameGen.h"
#import "Attacker.h"
#import "Destructible.h"

NS_ASSUME_NONNULL_BEGIN

@interface LifeForm : NSObject <Attacker, Destructible>

@property(nonatomic, readwrite) NSString *name;
@property(nonatomic, readwrite) char c;
@property(nonatomic, readonly) int x;
@property(nonatomic, readonly) int y;
@property(nonatomic, readwrite) int health;
@property(nonatomic, readonly) int xp;
@property(nonatomic, readonly) int level;
@property(nonatomic, readonly) float weight;
@property(nonatomic, readwrite) TCOD_color_t col;
@property(nonatomic, readonly) int strength;
@property(nonatomic, readonly) int dexterity;
@property(nonatomic, readonly) int constitution;
@property(nonatomic, readonly) int intelligence;
@property(nonatomic, readonly) int wisdom;
@property(nonatomic, readonly) int charisma;
@property(nonatomic, readwrite) NSMutableArray *items;

-(id)initWithXPos:(int)x andY:(int)y andColor:(TCOD_color_t) col;
-(id)initWithXPos:(int)x andY:(int)y andColor:(TCOD_color_t) col andChar:(char) c;
-(void)moveUp;
-(void)moveDown;
-(void)moveLeft;
-(void)moveRight;
-(void)moveUpLeft;
-(void)moveUpRight;
-(void)moveDownLeft;
-(void)moveDownRight;
-(void)render;
-(void)update;
-(int)getHighest3Rolls;
-(int)rollD6;
-(void)rollAbilities;
-(void)levelUp;
-(int)defenseRating;
-(int)attackRating;
-(int)readingSkill;
-(void)moveOrAttack:(id)lf;

@end

NS_ASSUME_NONNULL_END
