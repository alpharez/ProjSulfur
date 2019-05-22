//
//  LifeForm.m
//  ProjSulfur
//
//  Created by Steve Clement on 5/8/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

#import "LifeForm.h"

@implementation LifeForm

@synthesize c = _c;
@synthesize col = _col;
@synthesize health = _health; // average const = 6*3/2 = 9 (100)
@synthesize name = _name;
@synthesize weight = _weight;
@synthesize level = _level;
@synthesize x = _x;
@synthesize y = _y;
@synthesize strength = _strength;
@synthesize dexterity = _dexterity;
@synthesize constitution = _constitution;
@synthesize intelligence = _intelligence;
@synthesize wisdom = _wisdom;
@synthesize charisma = _charisma;
@synthesize isDestroyed = _isDestroyed;
@synthesize xp;
@synthesize items = _items;
@synthesize points = _points;

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ h:%d s:%d d:%d", _name, _health, _strength, _dexterity];
}

-(id)initWithXPos:(int)x andY:(int)y andColor:(TCOD_color_t) col andChar:(char) c {
    _c = c;
    return [self initWithXPos: x andY:y andColor:col];
}

-(id)initWithXPos:(int)x andY:(int)y andColor:(TCOD_color_t) col {
    self = [super init];
    _weight = 65.0; // kgs
    _points = 50;
    _level = 1;
    xp = 0;
    _x = x;
    _y = y;
    _col = col;
    LFNameGen *n = [[LFNameGen alloc] initWithGrammar:@"ork"];
    _name = n.name;
    [self rollAbilities];
    _health = _constitution * 100.0 / 9; // health is related to constitution
    _items = [[NSMutableArray alloc] init];
    return self;
}

-(int)rollD6 {
    return (arc4random() % (6)) + 1;
}

-(int)getHighest3Rolls {
    // roll 4 d6 and take highest 3 to get stats
    int roll[4] = {0,0,0,0};
    int a = 0;
    for(int i=0; i<4; i++) {
        roll[i] = [self rollD6];
    }
    // sort
    for (int i = 0; i < 4; ++i)
    {
        for (int j = i + 1; j < 4; ++j)
        {
            if (roll[i] > roll[j])
            {
                a = roll[i];
                roll[i] = roll[j];
                roll[j] = a;
            }
        }
    }
    // discard lowest one
    return roll[0]+roll[1]+roll[2];
}

-(void)rollAbilities {
    // abilities
    _strength = [self getHighest3Rolls];
    _dexterity = [self getHighest3Rolls];
    _constitution = [self getHighest3Rolls];
    _intelligence = [self getHighest3Rolls];
    _wisdom = [self getHighest3Rolls];
    _charisma = [self getHighest3Rolls];
}

-(void)moveOrAttack:(id)lf map:(TCOD_map_t)map {
    LifeForm *target = (LifeForm *)lf;
    // if target is in attack range, then attack it.
    
    int dx = target.x - _x;
    int dy = target.y - _y;
    int stepdx = (dx > 0 ? 1:-1);
    int stepdy = (dy > 0 ? 1:-1);
    float distance=sqrtf(dx*dx+dy*dy);
    if(distance < 2) {
        int roll = [self rollD6];
        if(roll == 1) { // miss
            //NSLog(@"Miss");
        } else if (roll == 6) { // crit
            //NSLog(@"Crit");
            target.health -= _strength + 4; // attack is lessened by dex.
        } else if (target.dexterity > _strength) {
            if(roll > 4) target.health -= _strength;  // dex is high so miss more often
        } else {
            target.health -= _strength; // attack is lessened by dex.
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
        if(TCOD_map_is_walkable(map, _x + dx, _y + dy)) {
            _x += dx;
            _y += dy;
        } else if(TCOD_map_is_walkable(map, _x + dx, _y)) {
            _x += stepdx;
        } else if(TCOD_map_is_walkable(map, _x, _y + dy)) {
            _y += stepdy;
        }
    }
}

-(void)moveUp {
    if(!_isDestroyed) _y--;
}

-(void)moveDown {
    if(!_isDestroyed) _y++;
}

-(void)moveLeft {
    if(!_isDestroyed) _x--;
}

-(void)moveRight {
    if(!_isDestroyed) _x++;
}

-(void)moveUpLeft {
    if(!_isDestroyed) { _y--; _x--; }
}

-(void)moveUpRight {
    if(!_isDestroyed) { _y--; _x++; }
}

-(void)moveDownLeft {
    if(!_isDestroyed) { _y++; _x--; }
}

-(void)moveDownRight {
    if(!_isDestroyed) { _y++; _x++; }
}

-(void)render {
    //int xpos = MAP_WIDTH - _x + (CAMERA_WIDTH/2);
    //int ypos = MAP_HEIGHT - _y + (CAMERA_HEIGHT/2);
    int xpos = CAMERA_WIDTH/2;
    int ypos = CAMERA_HEIGHT/2;
    //NSLog(@"player real: (%d, %d) console: (%d, %d)", _x, _y, xpos, ypos);
    TCOD_console_put_char(NULL, xpos, ypos, _c, TCOD_BKGND_ALPH);
    TCOD_console_set_char_foreground(NULL, _x - MAP_WIDTH, _y - MAP_HEIGHT, _col);
}

-(void)renderWithCameraX:(int)x andY:(int)y {
    TCOD_console_put_char(NULL, _x - x, _y - y, _c, TCOD_BKGND_ALPH);
    TCOD_console_set_char_foreground(NULL, _x - x, _y - y, _col);
}

-(void)update {
    if(!_isDestroyed) { // this life form isn't dead yet
        // move or attack
    }
}

-(void)levelUp {
    // roll attribute bonuses
    // recalculate skills / attack rating / defense rating
    _level++;
    _strength += [self rollD6];
    _dexterity += [self rollD6];
    _constitution += [self rollD6];
    _intelligence += [self rollD6];
    _wisdom += [self rollD6];
    _charisma += [self rollD6];
    _health = _constitution * 100.0 / 9;
    
}

-(int)defenseRating {
    return _dexterity;
}

-(int)attackRating {
    return _strength;
}

-(int)readingSkill {
    // intelligence + wisdom/2 maybe?
    return _intelligence + _wisdom/2;
}

- (void)attack {
    
}

-(void)attack:(id)lf {
    LifeForm *target = (LifeForm *)lf;
    int roll = [self rollD6];
    if(roll == 1) { // miss
        //NSLog(@"Miss");
    } else if (roll == 6) { // crit
        //NSLog(@"Crit");
        target.health -= _strength + 4; // attack is lessened by dex.
    } else {
        if(target.dexterity < _strength) {
            target.health -= _strength - target.dexterity; // attack is lessened by dex.
        }
    }
    if(target.health <= 0) {
        target.isDestroyed = true;
        target.c = '#';
        target.col = TCOD_red;
        xp += target.points;  // how much xp to give for this target.
        int nextLevel = LEVEL_BASE + _level * LEVEL_FACTOR;
        if(xp >= nextLevel) {
            [self levelUp];
        }
    }
}

@end
