//
//  HUD.h
//  ProjSulfur
//
//  Created by Steve Clement on 5/9/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libtcod.h"
#import "Map.h"
#import "LifeForm.h"
#import "Item.h"

NS_ASSUME_NONNULL_BEGIN

@interface HUD : NSObject {
    TCOD_console_t *console;
    int panel_height;
    int bar_width;
    NSMutableArray *msg_log;
}

-(id)init;
-(void)render;
-(void)renderBar;
-(void)render:(LifeForm *)lf;
-(void)renderBar:(LifeForm *)lf;
-(void)renderMessages;
-(void)message:(NSString *) text color:(const TCOD_color_t) color;
-(Item *)chooseFromInventory:(NSMutableArray *)items;
-(void)showTerminal:(NSString *)text;
-(void)characterSheet:(LifeForm *)player;

@end

NS_ASSUME_NONNULL_END
