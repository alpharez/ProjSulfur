//
//  Attacker.h
//  ProjSulfur
//
//  Created by Steve Clement on 5/12/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Attacker <NSObject>

@property(nonatomic, readwrite) int attackBonus;
@property(nonatomic, readwrite) int attackBonusUses;

-(void)attack;  // humans attack with hands or whatever improvised weapon... critters attack with claws or teeth.
-(void)attack:(id)lf;
-(void)moveOrAttack:(id)lf;
-(void)moveOrAttack:(id)lf map:(TCOD_map_t)map;

@end

NS_ASSUME_NONNULL_END
