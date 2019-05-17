//
//  Critter.m
//  ProjSulfur
//
//  Created by Steve Clement on 5/10/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

#import "Critter.h"

@implementation Critter

@synthesize c = _c;
@synthesize col = _col;
@synthesize health = _health;
@synthesize name = _name;
@synthesize weight = _weight;
@synthesize strength = _strength;
@synthesize x = _x;
@synthesize y = _y;
@synthesize isDestroyed = _isDestroyed;

-(NSString *)description {
    return [super description];
}

-(id)initWithXPos:(int)x andY:(int)y andColor:(TCOD_color_t) col andChar:(char) c {
    _c = c;
    return [self initWithXPos: x andY:y andColor:col];
}

-(id)initWithXPos:(int)x andY:(int)y andColor:(TCOD_color_t) col {
    self = [super init];
    _health = 15.0;
    _strength = 5;
    _weight = 21.0; // kgs
    _x = x;
    _y = y;
    _col = col;
    _name = @"mega hamster";
    return self;
}

-(void)rollAbilities {
    // abilities
    [super rollAbilities];
}

-(int)toCameraCoordinatesX:(int) x {
    return x - CAMERA_WIDTH; // cameraX
}

-(int)toCameraCoordinatesY:(int) y {
    return y - CAMERA_HEIGHT;  // camerY!
}

-(void)render {
    // adjust for camera
    int x = [self toCameraCoordinatesX: _x];
    int y = [self toCameraCoordinatesY: _y];
    NSLog(@"Render Critter (%d,%d) cam(%d,%d)", _x, _y, x, y);
    TCOD_console_put_char(NULL, x, y, _c, TCOD_BKGND_ALPH);
    TCOD_console_set_char_foreground(NULL, x, y, _col);
}

-(void)renderWithCameraX:(int)x andY:(int)y {
    TCOD_console_put_char(NULL, _x - x, _y - y, _c, TCOD_BKGND_ALPH);
    TCOD_console_set_char_foreground(NULL, _x - x, _y - y, _col);
}

-(void)update {
    // so this thing can do different stuff....  maybe it mate with other object like itself and
    // produce 3rd critter... maybe it attack, maybe it move around
}

-(void)attack {
    // if these things are swarming their attack strength grows based on how many around it.  a player surrounded
    // would be in bad trouble.
}

-(void)moveOrAttack:(id)lf {
    LifeForm *target = (LifeForm *)lf;
    // if target is in attack range, then attack it.
    
    int dx = target.x - _x;
    int dy = target.y - _y;
    float distance=sqrtf(dx*dx+dy*dy);
    if(distance < 2) {
        int roll = [self rollD6];
        if(roll == 1) { // miss
            //NSLog(@"Miss");
        } else if (roll == 6) { // crit
            //NSLog(@"Crit");
            target.health -= _strength + 4; // attack is lessened by dex.
        } else if (_strength > target.dexterity) {
            target.health -= _strength - target.dexterity; // attack is lessened by dex.
        }
        if(target.health <= 0) {
            target.isDestroyed = true;
            target.c = '#';
            target.col = TCOD_red;
        }
    } else if(distance < 10) {
        // if target is in sight range then move toward it.
        dx = (int)(round(dx/distance));
        dy = (int)(round(dy/distance));
        _x += dx;
        _y += dy;
    }
}

@end
