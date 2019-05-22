//
//  Item.m
//  ProjSulfur
//
//  Created by Steve Clement on 5/10/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

#import "Item.h"

@implementation Item

@synthesize name = _name;
@synthesize type = _type;
@synthesize text = _text;
@synthesize accessCode = _accessCode;
@synthesize weight = _weight;
@synthesize c = _c;
@synthesize x = _x;
@synthesize y = _y;
@synthesize isDestroyed = _isDestroyed;

-(id)init {
    self = [super init];
    return self;
}

/*!
 @brief init item values
 @param type type of item
 @param x location x value
 @param y location y value
 @param text description text
 @param accessCode access code to access item
 @return return item object
 */
-(id)initItem:(itemType)type withX:(int)x andY:(int)y withText:(NSString *)text andCode:(NSString *)accessCode {
    self = [super init];
    _x = x;
    _y = y;
    _text = text;
    _accessCode = accessCode;
    _type = type;
    
    // terminal.png is a 16x16
    // \03 is heart, \04 is diamond, \05 is club, \06 is spade
    // \25 looks like a snake/spiral  \27 is up and down arrow with base  \33 is left arrow  \36 triangle pointing up
    switch(_type) {
        case health:
            _c = '\03'; _col = TCOD_red; _weight = 2.0; _name = @"health kit"; break;
        case keycard:
            _c = '\06'; _col = TCOD_gold; _weight = 0.1; _name = @"keycard"; break;
        case terminal:
            _c = '\04'; _col = TCOD_pink; _weight = 52.0; _name = @"terminal"; break;
        case plant:
            _c = '\05'; _col = TCOD_green; _weight = 5.0; _name = @"plant"; break;
        case tree:
            _c = '\05'; _col = TCOD_green; _weight = 52.0; _name = @"tree"; break;
        case wrench:
            _c = '\35'; _col = TCOD_copper; _weight = 2.0; _name = @"wrench"; break;
        case stairs:
            _c = '\170'; _col = TCOD_copper; _weight = 152.0; _name = @"stairs"; break;
        case door:
            _c = '\170'; _col = TCOD_copper; _weight = 152.0; _name = @"door"; break;
        case pod:
            _c = '\170'; _col = TCOD_copper; _weight = 152.0; _name = @"sulhib pod"; break;
        case dropShip:
            _c = '\170'; _col = TCOD_copper; _weight = 5152.0; _name = @"drop ship"; break;
        case light:
            _c = '\35'; _col = TCOD_copper; _weight = 250.4; _name = @"light"; break;
        case chemLight:
            _c = '\35'; _col = TCOD_copper; _weight = 0.2; _name = @"chem light"; break;
        case stungun:
            _c = '\35'; _col = TCOD_copper; _weight = 2.0; _name = @"stun gun"; break;
        case crowbar:
            _c = '\35'; _col = TCOD_copper; _weight = 2.0; _name = @"crowbar"; break;
        case fireax:
            _c = '\35'; _col = TCOD_copper; _weight = 2.0; _name = @"fire ax"; break;
        case trap:
            _c = '_'; _col = TCOD_blue; _weight = 155.0; _name = @"trap"; break;  // raise alarm, spawn bots
        default:
            _c = '9'; _col = TCOD_copper; _weight = 55.0; _name = @"error"; break;
    }
    return self;
}

/*!
 @brief show item object on camera
 */
-(void)renderWithCameraX:(int)x andY:(int)y {
    if([_name isEqualToString:@"drop ship"]) {
        TCOD_console_put_char(NULL, _x - x + 1, _y - y, '/', TCOD_BKGND_ALPH);
        TCOD_console_put_char(NULL, _x - x + 2, _y - y, '/', TCOD_BKGND_ALPH);
        TCOD_console_put_char(NULL, _x - x, _y - y, _c, TCOD_BKGND_ALPH);
        TCOD_console_set_char_foreground(NULL, _x - x +1, _y - y, _col);
        TCOD_console_set_char_foreground(NULL, _x - x +2, _y - y, _col);
        TCOD_console_set_char_foreground(NULL, _x - x, _y - y, _col);
    } else {
        TCOD_console_put_char(NULL, _x - x, _y - y, _c, TCOD_BKGND_ALPH);
        TCOD_console_set_char_foreground(NULL, _x - x, _y - y, _col);
    }
}

/*!
 @brief set item location on map
 @param x location
 @param y location
 */
-(void)setlocation:(int)x andY:(int)y {
    _x = x;
    _y = y;
    NSLog(@"Item %@ Location %d,%d", _name, _x, _y);
}

@end
