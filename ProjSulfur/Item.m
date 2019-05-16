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
 @param item type of item
 @param x location x value
 @param y location y value
 @param text description text
 @param accessCode access code to access item
 @return return item object
 */
-(id)initItem:(itemType)item withX:(int)x andY:(int)y withText:(NSString *)text andCode:(NSString *)accessCode {
    self = [super init];
    _x = x;
    _y = y;
    _text = text;
    _accessCode = accessCode;
    
    // terminal.png is a 16x16
    // \03 is heart, \04 is diamond, \05 is club, \06 is spade
    // \25 looks like a snake/spiral  \27 is up and down arrow with base  \33 is left arrow  \36 triangle pointing up
    switch(item) {
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
        case chemLight:
            _c = '\35'; _col = TCOD_copper; _weight = 5152.0; _name = @"chem light"; break;
        default:
            _c = '9'; _col = TCOD_copper; _weight = 55.0; _name = @"error"; break;
    }
    return self;
}

/*!
 @brief show item object on screen
 */
-(void)render {
    TCOD_console_put_char(NULL, _x, _y, _c, TCOD_BKGND_ALPH);
    TCOD_console_set_char_foreground(NULL, _x, _y, _col);
}

/*!
 @brief set item location on map
 @param x location
 @param y location
 */
-(void)setlocation:(int)x andY:(int)y {
    _x = x;
    _y = y;
}

@end