//
//  Critter.h
//  ProjSulfur
//
//  Created by Steve Clement on 5/10/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

#import "LifeForm.h"
#import "Attacker.h"
#import "Destructible.h"

NS_ASSUME_NONNULL_BEGIN

@interface Critter : LifeForm <Attacker, Destructible>

@property(nonatomic, readwrite) char c;

-(id)initWithXPos:(int)x andY:(int)y andColor:(TCOD_color_t) col;
-(id)initWithXPos:(int)x andY:(int)y andColor:(TCOD_color_t) col andChar:(char) c;
-(void)rollAbilities;
-(int)toCameraCoordinatesX:(int) x;
-(int)toCameraCoordinatesY:(int) y;
-(void)render;
-(void)renderWithCameraX:(int)x andY:(int)y;
-(void)update;
-(void)attack;
-(void)moveOrAttack:(id)lf;

@end

NS_ASSUME_NONNULL_END
