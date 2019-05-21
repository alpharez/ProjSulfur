//
//  ItemManager.m
//  ProjSulfur
//
//  Created by Steve Clement on 5/14/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

#import "ItemManager.h"

@implementation ItemManager

@synthesize zone1Items;
@synthesize zone2Items;
@synthesize zone3Items;
@synthesize zone4Items;
@synthesize zone5Items;

-(id)init {
    self = [super init];
    // get items from plist for each zone
    
    NSError *error;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ItemData" ofType:@"plist"];
    //NSData *tempData = [[NSData alloc] initWithContentsOfFile:@"ItemData.plist"];
    NSData *tempData = [[NSData alloc] initWithContentsOfFile:plistPath];
    NSPropertyListFormat plistFormat;
    NSDictionary *temp = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:&plistFormat error:&error];
    zone1Items = [[NSMutableArray alloc] init];
    zone2Items = [[NSMutableArray alloc] init];
    zone3Items = [[NSMutableArray alloc] init];
    zone4Items = [[NSMutableArray alloc] init];
    zone5Items = [[NSMutableArray alloc] init];
    int randX, randY, randItem, randString;
    for(NSString *t in temp) {
        NSDictionary *item = [temp objectForKey:t];
        //NSString *name = [item objectForKey:@"name"];
        NSString *type = [item objectForKey:@"type"];
        NSString *message = [item objectForKey:@"message"];
        NSString *access_code = [item objectForKey:@"access code"];
        NSNumber *zone = [item objectForKey:@"zone"];
        //NSLog(@"%@ %@ %@ %@ %@", name, type, message, access_code, zone);
        itemType t = 0;
        if([type isEqualToString:@"health"]) {
            t = health;
        } else if ([type isEqualToString:@"keycard"]) {
            t = keycard;
        } else if ([type isEqualToString:@"terminal"]) {
            t = terminal;
        } else if ([type isEqualToString:@"wrench"]) {
            t = wrench;
        } else if ([type isEqualToString:@"fireax"]) {
            t = fireax;
        } else if ([type isEqualToString:@"crowbar"]) {
            t = crowbar;
        } else if ([type isEqualToString:@"stungun"]) {
            t = stungun;
        } else if ([type isEqualToString:@"plant"]) {
            t = plant;
        } else if ([type isEqualToString:@"tree"]) {
            t = tree;
        } else if ([type isEqualToString:@"pod"]) {
            t = pod;
        } else if ([type isEqualToString:@"dropShip"]) {
            t = dropShip;
        } else if ([type isEqualToString:@"light"]) {
            t = light;
        } else if ([type isEqualToString:@"chemLight"]) {
            t = chemLight;
        } else if ([type isEqualToString:@"door"]) {
            t = door;
        } else if ([type isEqualToString:@"stairs"]) {
            t = stairs;
        } else {
            t = plant;
        }
        randX = TCOD_random_get_int(NULL, 1, MAP_WIDTH - 10);
        randY = TCOD_random_get_int(NULL, 1, MAP_HEIGHT - 25);
        Item *gameItem = [[Item alloc] initItem:t withX:randX andY:randY withText:message andCode:access_code];
        
        switch([zone integerValue]) {
            case 1:
                //for(int n=0; n<1000; n++)
                [zone1Items addObject:gameItem];
                break;
            case 2:
                [zone2Items addObject:gameItem];
                break;
            case 3:
                [zone3Items addObject:gameItem];
                break;
            case 4:
                [zone4Items addObject:gameItem];
                break;
            case 5:
                [zone5Items addObject:gameItem];
                break;
            default:
                [zone1Items addObject:gameItem];
                break;
        }
        
    }
    // get strings from file
    NSString *fname = [[NSBundle mainBundle] pathForResource:@"TerminalMesgs" ofType:@"strings"];
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:fname];
    NSArray *allTermStrings = d.allValues;
    NSString *itemName;
    // add a bunch more items
    for(int n=0; n< 166; n++) {
        itemName = @"random item";
        randItem = TCOD_random_get_int(NULL, 0, 15);  // items 0 - 15
        if(randItem == terminal) {
            randString = TCOD_random_get_int(NULL, 0, (int)[allTermStrings count]-1);
            itemName = [allTermStrings objectAtIndex:randString];
        }
        Item *gameItem = [[Item alloc] initItem:randItem withX:0 andY:0 withText:itemName andCode:@"0000"];
        [zone1Items addObject:gameItem];
    }
    return self;
}

/*!
 @brief return all items for zone
 @param zone of items
 @return return an array of item objects for a specific zone
 */
-(NSMutableArray *)getItemsForZone:(int)zone {
    switch(zone) {
        case 1:
            return zone1Items;
        case 2:
            return zone2Items;
        case 3:
            return zone3Items;
        case 4:
            return zone4Items;
        case 5:
            return zone5Items;
        default:
            break;
    }
    return zone1Items;
}



@end
