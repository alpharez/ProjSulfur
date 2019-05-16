//
//  Item.h
//  ProjSulfur
//
//  Created by Steve Clement on 5/10/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//
// Items can be terminals, wrenches, doors, anything the player can interact with
// key cards have codes

#import <Foundation/Foundation.h>
#import "libtcod.h"
#import "Destructible.h"
/*
 some cool items:
        item
            static item (can be multi block)  these are not usable in any way, just part of scenery
                drop ship
                plants, trees, herbs
                engines
                sulfur hib pods
                emergency lights
            pickables
                tools/stuff that can used for weapons
                head,chest,leg,feet clothing/armor
                health kits
            terminals (some of these show error conditions and read a bsod or some shit)
                errored - show bsod
                instructive - learn about generation ships, educational
                ship status - show things going on with the ship
 */

NS_ASSUME_NONNULL_BEGIN

@interface Item : NSObject <Destructible>

/*!
 * @typedef itemType
 * @brief type of item this is
 */
typedef enum {
    /// health kit
    health,
    /// access key card
    keycard,
    /// terminal to display information
    terminal,
    /// possible weapon
    wrench,
    /// possible weapon
    fireax,
    /// possible weapon
    crowbar,
    /// weapon
    stungun,
    /// decorative plant or food
    plant,
    /// decorative tree
    tree,
    /// sulur pod, multi tile... sulhib pod
    pod,
    /// multi tile drop ship
    dropShip,
    /// emergency light
    light,
    /// door
    door,
    /// stairs
    stairs,
    /// chem light
    chemLight
} itemType;

@property(nonatomic, readwrite) NSString *name;
@property(nonatomic, readwrite) NSString *text;
@property(nonatomic, readwrite) NSString *accessCode;
@property(nonatomic, readwrite) float weight;
@property(nonatomic, readwrite) char c;
@property(nonatomic, readwrite) TCOD_color_t col;
@property(nonatomic, readwrite) int x;
@property(nonatomic, readwrite) int y;

-(id)initItem:(itemType)item withX:(int)x andY:(int)y withText:(NSString *)text andCode:(NSString *)accessCode;
-(void)render;
-(void)setlocation:(int)x andY:(int)y;
@end

NS_ASSUME_NONNULL_END
