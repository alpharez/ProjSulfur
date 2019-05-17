//
//  HUD.m
//  ProjSulfur
//
//  Created by Steve Clement on 5/9/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

#import "HUD.h"

@implementation HUD

-(id)init {
    self = [super init];
    panel_height = 7;
    bar_width = 15;
    console = TCOD_console_new(CAMERA_WIDTH, panel_height);
    msg_log = [[NSMutableArray alloc] init];
    return self;
}

-(void)render {
    TCOD_console_set_default_background(console, TCOD_black);
    TCOD_console_clear(console);
    [self renderBar];
    [self renderMessages];
    TCOD_console_blit(console, 0, 0, CAMERA_WIDTH, panel_height, NULL, 0, CAMERA_HEIGHT-panel_height, 1.0f, 1.0f);
}

-(void)renderBar {
    TCOD_console_set_default_background(console, TCOD_grey);
    TCOD_console_rect(console, 0, 0, 20, 1, false, TCOD_BKGND_SET);
    char xpTxt[32];
    sprintf(xpTxt,"XP lvl %d", 1);
    TCOD_console_print_ex(console, 10, 0, TCOD_BKGND_NONE, TCOD_CENTER, xpTxt);
}

-(void)render:(LifeForm *)lf {
    TCOD_console_set_default_background(console, TCOD_black);
    TCOD_console_clear(console);
    [self renderBar:lf];
    [self renderMessages];
    TCOD_console_blit(console, 0, 0, CAMERA_WIDTH, panel_height, NULL, 0, CAMERA_HEIGHT-panel_height, 1.0f, 1.0f);
}

-(void)renderBar:(LifeForm *)lf {
    TCOD_console_set_default_background(console, TCOD_grey);
    TCOD_console_rect(console, 0, 0, 20, 1, false, TCOD_BKGND_SET);
    char xpTxt[32];
    sprintf(xpTxt,"XP lvl:%d HP:%d", lf.level, lf.health);
    char stats1[64], stats2[64], stats3[64], stats4[64];
    int level_base = 100;
    int level_factor = 100;
    int nextLevel = level_base + lf.level * level_factor;
    sprintf(stats1,"St:%d Dex:%d Con:%d",lf.strength, lf.dexterity, lf.constitution);
    sprintf(stats2,"Int:%d Wis:%d Ch:%d",lf.intelligence, lf.wisdom, lf.charisma);
    sprintf(stats3,"att:%d def:%d read:%d",[lf attackRating], [lf defenseRating], [lf readingSkill]);
    sprintf(stats4,"xp:%d next:%d", [lf xp], nextLevel);
    TCOD_console_print_ex(console, 0, 0, TCOD_BKGND_NONE, TCOD_LEFT, xpTxt);
    TCOD_console_print_ex(console, 0, 1, TCOD_BKGND_NONE, TCOD_LEFT, stats1);
    TCOD_console_print_ex(console, 0, 2, TCOD_BKGND_NONE, TCOD_LEFT, stats2);
    TCOD_console_print_ex(console, 0, 3, TCOD_BKGND_NONE, TCOD_LEFT, stats3);
    TCOD_console_print_ex(console, 0, 4, TCOD_BKGND_NONE, TCOD_LEFT, stats4);
}

-(void)renderMessages {
    // draw message log
    float colorCoef=0.4f;
    int y = 0;
    TCOD_console_set_default_foreground(console, TCOD_lime);
    for (NSString *msg in msg_log) {
        TCOD_console_print(console, bar_width+20, y, "%s", [msg UTF8String]);
        //NSLog(@" writing logs... %@", msg);
        y++;
        if ( colorCoef < 1.0f ) {
            colorCoef+=0.3f;
        }
    }
}

-(void)message:(NSString *) text color:(const TCOD_color_t) color {
    [msg_log addObject:text];
    //NSLog(@"Add object to msg_log %@", text);
    if([msg_log count] > 6) {
        [msg_log removeObjectAtIndex:0];
    }
}

/*!
 @brief show a TCOD console inventory list
 @discussion list of inventory items and keys to use them.
 @param items list of inventory items
 */
-(void)chooseFromInventory:(NSMutableArray *)items {
    int inv_width = 50;
    int inv_height = 28;
    TCOD_console_t inv_console = TCOD_console_new(inv_width, inv_height);
    TCOD_console_set_default_foreground(inv_console, TCOD_sea);
    TCOD_console_set_default_background(inv_console, TCOD_black);
    TCOD_console_print_frame(inv_console, 0, 0, inv_width, inv_height, true, TCOD_BKGND_DEFAULT, "Inventory");
    // print inventory
    int shortcut = 'a';
    int y=1;
    for (Item *invItem in items){
        NSString *itemName = [[NSString alloc] initWithString:(NSString *)invItem.name];
        TCOD_console_print(inv_console, 2, y, "(%c) %s %s", shortcut, [itemName UTF8String], [invItem.accessCode UTF8String]);
        y++; shortcut++;
    }
    TCOD_console_blit(inv_console, 0, 0, inv_width, inv_height, NULL, CAMERA_WIDTH/2 - inv_width/2, CAMERA_HEIGHT/2 - inv_height/2, 1.0f, 1.0f);
    TCOD_console_flush();
    
    // wait for key press
    TCOD_key_t key;
    TCOD_sys_wait_for_event(TCOD_KEY_PRESSED, &key, NULL, true);
}

/*!
 @brief show a TCOD console terminal screen
 @discussion this should look like an old school terminal... bonus points to get it to teletype it out.
 @param text input text to show on the terminal
 */
-(void)showTerminal:(NSString *)text {
    int term_width = 50;
    int term_height = 28;
    if([text length] > 2) {
        TCOD_console_t terminal = TCOD_console_new(term_width, term_height);
        TCOD_console_set_default_foreground(terminal, TCOD_sea);
        TCOD_console_set_default_background(terminal, TCOD_black);
        TCOD_console_print_frame(terminal, 0, 0, term_width, term_height, true, TCOD_BKGND_DEFAULT, "Terminal");
        // show terminal width chars and then go to next line until eos
        
        int y = 1; int lineWidth = term_width - 4; int loc = 1;
        if([text length] <= lineWidth) {
            TCOD_console_print(terminal, 2, y, "%s", [text UTF8String]);
        } else {
            for (int i=0; i<[text length]/lineWidth; i++ ) {
                NSRange range = NSMakeRange(loc, lineWidth);
                NSString *substr = [text substringWithRange:range];
                TCOD_console_print(terminal, 2, y, "%s", [substr UTF8String]);
                y++; loc += lineWidth;
            }
        }
        TCOD_console_blit(terminal, 0, 0, term_width, term_height, NULL, CAMERA_WIDTH/2 - term_width/2, CAMERA_HEIGHT/2 - term_height/2, 1.0f, 1.0f);
        TCOD_console_flush();
    }
    TCOD_key_t key;
    TCOD_sys_wait_for_event(TCOD_KEY_PRESSED, &key, NULL, true);
}

/*!
 @brief show character sheet for player
 @param player the player object
 @discussion this should show character stats, skills and equipped items.
 */
-(void)characterSheet:(LifeForm *)player {
    int cs_width = 50;
    int cs_height = 28;
    
    TCOD_console_t charsheet = TCOD_console_new(cs_width, cs_height);
    TCOD_console_set_default_foreground(charsheet, TCOD_sea);
    TCOD_console_set_default_background(charsheet, TCOD_black);
    TCOD_console_print_frame(charsheet, 0, 0, cs_width, cs_height, true, TCOD_BKGND_DEFAULT, [[player name] UTF8String]);
    
    TCOD_console_print(charsheet, 2, 1, "%s %s", "Name: ", [[player name] UTF8String]);
    TCOD_console_print(charsheet, 2, 2, "%s %d", "Health: ", [player health]);
    TCOD_console_print(charsheet, 2, 3, "%s %d", "XP: ", [player xp]);
    TCOD_console_print(charsheet, 2, 4, "%s %d", "Level: ", [player level]);
    TCOD_console_print(charsheet, 2, 5, "%s %d", "Strength: ", [player strength]);
    TCOD_console_print(charsheet, 2, 6, "%s %d", "Dexterity: ", [player dexterity]);
    TCOD_console_print(charsheet, 2, 7, "%s %d", "Constitution: ", [player constitution]);
    TCOD_console_print(charsheet, 2, 8, "%s %d", "Intelligence: ", [player intelligence]);
    TCOD_console_print(charsheet, 2, 9, "%s %d", "Wisdom: ", [player wisdom]);
    TCOD_console_print(charsheet, 2, 10, "%s %d", "Charisma: ", [player charisma]);
    TCOD_console_print(charsheet, 2, 11, "%s %d", "Reading Skill: ", [player readingSkill]);
    
    TCOD_console_blit(charsheet, 0, 0, cs_width, cs_height, NULL, CAMERA_WIDTH/2 - cs_width/2, CAMERA_HEIGHT/2 - cs_height/2, 1.0f, 1.0f);
    TCOD_console_flush();
    TCOD_key_t key;
    TCOD_sys_wait_for_event(TCOD_KEY_PRESSED, &key, NULL, true);
}

@end
