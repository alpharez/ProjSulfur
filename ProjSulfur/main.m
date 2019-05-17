//
//  main.m
//  ProjSulfur
//
//  Created by Steve Clement on 5/8/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "libtcod.h"
#import "Engine.h"

int main(int argc, const char * argv[]) {
    char title[32] = "Project Sulfur";
    
    Engine *e = [[Engine alloc] init];   // init game engine
    
    //TCOD_namegen
    TCOD_console_init_root(CAMERA_WIDTH, CAMERA_HEIGHT, title, false, TCOD_RENDERER_SDL);
    [e render];
    TCOD_console_flush();
    while (! TCOD_console_is_window_closed()) {
        [e update];
        [e render];
        TCOD_console_flush();
    }
    return 0;
}
