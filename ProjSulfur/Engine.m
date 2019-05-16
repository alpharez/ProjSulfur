//
//  Engine.m
//  ProjSulfur
//
//  Created by Steve Clement on 5/8/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

#import "Engine.h"

@implementation Engine

@synthesize player;
@synthesize computeFov;
@synthesize hud;
@synthesize zone1;
@synthesize lifeForms = _lifeForms;
@synthesize items = _items;
@synthesize gameStatus;

-(id)init {
    self = [super init];
    TCOD_console_set_custom_font("cp437_10x10.png", TCOD_FONT_TYPE_GREYSCALE | TCOD_FONT_LAYOUT_ASCII_INROW, 16, 16);
    player = [[LifeForm alloc] initWithXPos:40 andY:25 andColor:TCOD_yellow andChar:'@'];
    computeFov = true;
    // all life
    _lifeForms = [[NSMutableArray alloc] init];
    [_lifeForms addObject:[[LifeForm alloc] initWithXPos:11 andY:32 andColor:TCOD_red andChar:'\02']];
    [_lifeForms addObject:[[LifeForm alloc] initWithXPos:14 andY:30 andColor:TCOD_red andChar:'\02']];
    // Critters make some critters to kill, evolved mega-hamsters!
    //critter_list = [[NSMutableArray alloc] init];
    int max_critters_per_level = 25;
    for(int i=0; i<max_critters_per_level; i++ ) {
        int randX = TCOD_random_get_int(NULL, 1, SCREEN_WIDTH - 10);
        int randY = TCOD_random_get_int(NULL, 1, SCREEN_HEIGHT - 25);
        [_lifeForms addObject:[[Critter alloc] initWithXPos:randX andY:randY andColor:TCOD_azure andChar:'\176']];
    }
    // non-organic items
    _items = [[NSMutableArray alloc] init];
    //[_items addObject:[[Item alloc] initItem:keycard withX:42 andY:27 withText:@""]];
    //[_items addObject:[[Item alloc] initItem:health withX:44 andY:29 withText:@""]];
    //[_items addObject:[[Item alloc] initItem:plant withX:46 andY:31 withText:@""]];
    
    ItemManager *im = [[ItemManager alloc] init];
    //_items = [im getItemsForZone:1];
    _items = [im zone1Items];
    
    zone1 = [[Map alloc] init];
    hud = [[HUD alloc] init];
    // player starts with a chemlight
    [player.items addObject:[[Item alloc] initItem:chemLight withX:9 andY:9 withText:@"chem light" andCode:@""]];
    [hud message:@"It smells old and musty here.  You shake a chem light to get a better look." color:TCOD_lime];
    [hud message:@"There's some ambient light, but not much.  Your eyes strain to see." color:TCOD_lime];
    
    // compute initial fov
    [zone1 computeFOV:player.x andY:player.y];
    TCOD_sys_set_fps(30);
    gameStatus = STARTUP;
    return self;
}
/*!
 @brief Engine display everything to TCOD root console
 */
-(void)render {
    TCOD_console_clear(NULL);
    [zone1 render:player.x y:player.y];
    [player render];

    for(LifeForm *lf in _lifeForms) {
        if( [zone1 isInFOVX:lf.x andY:lf.y]) {
            [lf render];
        }
    }
    for(Item *i in _items) {
        if( [zone1 isInFOVX:i.x andY:i.y]) {
            [i render];
        }
    }
    [hud render:player];
}

-(Boolean)checkTileAtX:(int)x andY:(int)y {
    Boolean lifeFormHere = false;
    NSString *npc_string = @"Yo, I'm ";
    // check life forms
    for(LifeForm *lf in _lifeForms) {
        if((lf.x == x) && (lf.y == y) && (!lf.isDestroyed)) {
            [hud message:[npc_string stringByAppendingString:[lf.name stringByAppendingString:[lf isDestroyed] ? @" (is Dead)" : @" (is not Dead)"]] color:TCOD_white];
            //[hud message:[NSString stringWithFormat:@"anObject is %@", lf] color:TCOD_white];
            // player attack lf
            [player attack:lf];
            gameStatus = NEW_TURN;
            lifeFormHere = true;
            break;
        }
    }
    // check items
    for(Item *i in _items) {
        if((i.x == x) && (i.y == y)) {
            if([[i name] isEqualToString:@"terminal"]) {
                [hud showTerminal:[self ancientTextTranslator:[i text] readingSkill:player.readingSkill max:100]];
                gameStatus = NEW_TURN;
                break;
            } else if([[i name] isEqualToString:@"sulhib pod"]) {
                [hud showTerminal:[self ancientTextTranslator:[i text] readingSkill:player.readingSkill max:100]];
                gameStatus = NEW_TURN;
                break;
            } else if([[i name] isEqualToString:@"door"]) {
                [hud showTerminal:[i text]];
                gameStatus = NEW_TURN;
                break;
            } else if([[i name] isEqualToString:@"drop ship"]) {
                [hud showTerminal:[i text]];
                gameStatus = NEW_TURN;
                break;
            }
        }
    }
    return lifeFormHere;
}

/*!
 @brief Engine update method
 */
-(void)update {
    TCOD_key_t key;
    TCOD_sys_check_for_event(TCOD_EVENT_KEY_PRESS, &key, NULL);
    // 8 way movement surrounding 'j'
    // h left, j down, k up, l right
    // y up/left, u up/right, b down/left, n down/right
    
    switch(key.vk) {
        case TCODK_UP :
            if( ![zone1 isWallX:player.x andY:player.y-1] ) {
                if( ![self checkTileAtX:player.x andY:player.y-1] ) {
                    [player moveUp];
                    computeFov = true;
                    gameStatus = NEW_TURN;
                }
            } else {
                [hud message:@"You hit a wall" color:TCOD_white];
            }
            break;
        case TCODK_DOWN :
            if( ![zone1 isWallX:player.x andY:player.y+1] ) {
                if( ![self checkTileAtX:player.x andY:player.y+1] ) {
                    [player moveDown];
                    computeFov = true;
                    gameStatus = NEW_TURN;
                }
            } else {
                [hud message:@"You hit a wall" color:TCOD_white];
            }
            break;
        case TCODK_LEFT :
            if( ![zone1 isWallX:player.x-1 andY:player.y] ) {
                if( ![self checkTileAtX:player.x-1 andY:player.y] ) {
                    [player moveLeft];
                    computeFov = true;
                    gameStatus = NEW_TURN;
                }
            } else {
                [hud message:@"You hit a wall" color:TCOD_white];
            }
            break;
        case TCODK_RIGHT :
            if( ![zone1 isWallX:player.x+1 andY:player.y] ) {
                if( ![self checkTileAtX:player.x+1 andY:player.y] ) {
                    [player moveRight];
                    computeFov = true;
                    gameStatus = NEW_TURN;
                }
            } else {
                [hud message:@"You hit a wall" color:TCOD_white];
            }
            break;
        case TCODK_ESCAPE :
            // show main menu
            NSLog(@"Main Menu: Save/Load/Quit");
            break;
        case TCODK_CHAR :
            if(key.c == 'k') { // up
                if( ![zone1 isWallX:player.x andY:player.y-1] ) {
                    if( ![self checkTileAtX:player.x andY:player.y-1] ) {
                        [player moveUp];
                        computeFov = true;
                        gameStatus = NEW_TURN;
                    }
                } else {
                    [hud message:@"You hit a wall" color:TCOD_white];
                }
                break;
            }
            if(key.c == 'j') { // down
                if( ![zone1 isWallX:player.x andY:player.y+1] ) {
                    if( ![self checkTileAtX:player.x andY:player.y+1] ) {
                        [player moveDown];
                        computeFov = true;
                        gameStatus = NEW_TURN;
                    }
                } else {
                    [hud message:@"You hit a wall" color:TCOD_white];
                }
                break;
            }
            if(key.c == 'h') { // left
                if( ![zone1 isWallX:player.x-1 andY:player.y] ) {
                    if( ![self checkTileAtX:player.x-1 andY:player.y] ) {
                        [player moveLeft];
                        computeFov = true;
                        gameStatus = NEW_TURN;
                    }
                } else {
                    [hud message:@"You hit a wall" color:TCOD_white];
                }
                break;
            }
            if(key.c == 'l') { // right
                if( ![zone1 isWallX:player.x+1 andY:player.y] ) {
                    if( ![self checkTileAtX:player.x+1 andY:player.y] ) {
                        [player moveRight];
                        computeFov = true;
                        gameStatus = NEW_TURN;
                    }
                } else {
                    [hud message:@"You hit a wall" color:TCOD_white];
                }
                break;
            }
            if(key.c == 'y') { // up/left
                if( ![zone1 isWallX:player.x-1 andY:player.y-1] ) {
                    if( ![self checkTileAtX:player.x-1 andY:player.y-1] ) {
                        [player moveUpLeft];
                        computeFov = true;
                        gameStatus = NEW_TURN;
                    }
                } else {
                    [hud message:@"You hit a wall" color:TCOD_white];
                }
                break;
            }
            if(key.c == 'u') { // up/right
                if( ![zone1 isWallX:player.x+1 andY:player.y-1] ) {
                    if( ![self checkTileAtX:player.x+1 andY:player.y-1] ) {
                        [player moveUpRight];
                        computeFov = true;
                        gameStatus = NEW_TURN;
                    }
                } else {
                    [hud message:@"You hit a wall" color:TCOD_white];
                }
                break;
            }
            if(key.c == 'b') { // down/left
                if( ![zone1 isWallX:player.x-1 andY:player.y+1] ) {
                    if( ![self checkTileAtX:player.x-1 andY:player.y+1] ) {
                        [player moveDownLeft];
                        computeFov = true;
                        gameStatus = NEW_TURN;
                    }
                } else {
                    [hud message:@"You hit a wall" color:TCOD_white];
                }
                break;
            }
            if(key.c == 'n') { // down/right
                if( ![zone1 isWallX:player.x+1 andY:player.y+1] ) {
                    if( ![self checkTileAtX:player.x+1 andY:player.y+1] ) {
                        [player moveDownRight];
                        computeFov = true;
                        gameStatus = NEW_TURN;
                    }
                } else {
                    [hud message:@"You hit a wall" color:TCOD_white];
                }
                break;
            }
            if(key.c == 'g') { // grab item
                bool found = false;
                for(Item *item in _items) {
                    if((player.x == item.x) && (player.y == item.y)) {
                        found = true;
                        if(item.weight < 24.0) {
                            [player.items addObject:item]; // add to player inventory.
                            [_items removeObject:item];
                        } else {
                            [hud message:@"Too heavy to pick up" color:TCOD_white];
                        }
                        break;
                    }
                }
                if(!found) [hud message:@"Nothing here to pick up" color:TCOD_white];
                break;
            }
            if(key.c == 'i') { // inventory
                [hud chooseFromInventory:player.items];
                break;
            }
            if(key.c == 't') { // terminal
                //NSString *scrambled = [self ancientTextTranslator:ancient readingSkill:player.readingSkill max:100];
                //[hud showTerminal:scrambled];
            }
            if(key.c == 'c') { // character sheet
                [hud characterSheet:player];
            }
            break;
        default:
            //NSLog(@"%s", key.text);
            break;
    }
    
    if(gameStatus == NEW_TURN) {
        for (LifeForm *lf in _lifeForms) {
            if(!lf.isDestroyed) {
                [lf update];
                [lf moveOrAttack:player];
            }
        }
    }
    if( computeFov ) {
        [zone1 computeFOV:player.x andY:player.y];
        computeFov = false;
    }
    gameStatus = IDLE;
}

/*!
 @brief translates text based on skill
 @discussion This function gets a UTF8String from NSString input so that it can do a rot13 on the alphabetic characters.  After that it converts that output back to NSString for return.
 @param text The cleartext input
 @param skill the reading skill that will determine how much this will stay clear text
 @param maxSkill max possible reading skill
 @return ciphertext or ancienttext
 */
-(NSString *)ancientTextTranslator:(NSString *)text readingSkill:(int)skill max:(int)maxSkill {
    if(skill >= maxSkill) {
        return text;
    } else {
        char *UTF8Str = strdup([text UTF8String]);
        unsigned long length = [text length];
        float fskill = skill;
        float fmaxSkill = maxSkill;
        float pctRight = 1 / ((fmaxSkill - fskill) / fmaxSkill);
        int ipctRight = round(pctRight);
        int pctRightIdx = 0;
        for (int i = 0; i < length; i++)
        {
            if(pctRightIdx == ipctRight) {
                if(UTF8Str[i] > 'A' && UTF8Str[i] < 'm') UTF8Str[i] += 13;
                pctRightIdx = 0;
            }
            pctRightIdx++;
        }
        return [NSString stringWithUTF8String:UTF8Str];
    }
}

@end