//
//  Map.m
//  ProjSulfur
//
//  Created by Steve Clement on 5/8/19.
//  Copyright © 2019 Steve Clement. All rights reserved.
//

#import "Map.h"

@implementation Map

@synthesize darkWall = _darkWall;
@synthesize darkGround = _darkGround;
@synthesize lightWall = _lightWall;
@synthesize lightGround = _lightGround;
@synthesize minRoomSize = _minRoomSize;
@synthesize randomRoom = _randomRoom;
@synthesize roomWalls = _roomWalls;
@synthesize zone1 = _zone1;
@synthesize torchRadius;
@synthesize torchx; // torch light position in the perlin noise
@synthesize noise;
@synthesize cameraX;
@synthesize cameraY;

-(id)init {
    self = [super init];
    _zone1 = TCOD_map_new(MAP_WIDTH, MAP_HEIGHT);
    TCOD_map_clear(_zone1, true, true);
    // init tiles array and map
    for(int w=0; w<MAP_WIDTH; w++) {
        for(int h=0; h<MAP_HEIGHT; h++) {
            tiles[w][h] = false;
            room[w][h] = false;
            TCOD_map_set_properties(_zone1,w,h,false,false); /* blck */
        }
    }
    _darkWall.r = 35; _darkWall.g = 106; _darkWall.b = 25;
    _darkGround.r = 0; _darkGround.g = 0; _darkGround.b = 50;
    _lightWall.r = 135; _lightWall.g = 206; _lightWall.b = 50;
    _lightGround.r = 0; _lightGround.g = 0; _lightGround.b = 150;
    _minRoomSize = 4;
    _randomRoom = false;
    _roomWalls = true;
    torchx = 0.0f;
    torchRadius = 10;
    noise = TCOD_noise_new(1,1.0f,1.0f,NULL); /* 1d noise for the torch flickering */

    return self;
}

-(void)createZoneRoom:(int)zone withRoom:(int)room playerStartAtX:(int)x andY:(int)y {
    [self moveCamera:x andY:y];
    // make room for player
    [self createRoomAtX1:x-2 andY1:y-2 andX2:x+5 andY2:y+8];
    [self createRoomAtX1:5 andY1:5 andX2:15 andY2:15];
    [self createRoomAtX1:55 andY1:10 andX2:60 andY2:14];
    
    [self setWallPosX:36 andY:22];
    //[self vline:40 y1:10 y2:50];
    [self createRoomAtX1:30 andY1:49 andX2:50 andY2:65];
    //[self hline:17 y:25 x2:50];
    [self createRoomAtX1:3 andY1:20 andX2:18 andY2:36];
    [self createRooms:166];
}

/*! @brief draw a vertical line */
-(void)vline:(int) x y1:(int) y1 y2:(int) y2 {
    int y=y1;
    int dy=(y1>y2?-1:1);
    TCOD_map_set_properties(_zone1,x,y,true,true); /* ground */
    if ( y1 == y2 ) return;
    do {
        y+=dy;
        TCOD_map_set_properties(_zone1,x,y,true,true); /* ground */
    } while (y!=y2);
}

/*! @brief draw a vertical line up until we reach an empty space */
-(void)vline_up:(int) x y:(int) y {
    while (y >= 0 && !TCOD_map_is_walkable(_zone1, x, y)) {
        TCOD_map_set_properties(_zone1,x,y,true,true); /* ground */
        y--;
    }
}

/*! @brief draw a vertical line down until we reach an empty space */
-(void)vline_down:(int) x y:(int) y {
    while (y < MAP_HEIGHT && !TCOD_map_is_walkable(_zone1, x, y)) {
        TCOD_map_set_properties(_zone1,x,y,true,true); /* ground */
        y++;
    }
}

/*! @brief draw a horizontal line */
-(void)hline:(int) x1 y:(int) y x2:(int) x2 {
    int x=x1;
    int dx=(x1>x2?-1:1);
    TCOD_map_set_properties(_zone1,x,y,true,true); /* ground */
    if ( x1 == x2 ) return;
    do {
        x+=dx;
        TCOD_map_set_properties(_zone1,x,y,true,true); /* ground */
    } while (x!=x2);
}

/*! @brief draw a horizontal line left until we reach an empty space */
-(void)hline_left:(int) x y:(int) y {
    while (x >= 0 && !TCOD_map_is_walkable(_zone1, x, y)) {
        TCOD_map_set_properties(_zone1,x,y,true,true); /* ground */
        x--;
    }
}

/*! @brief draw a horizontal line right until we reach an empty space */
-(void)hline_right:(int) x y:(int) y {
    while (x < MAP_WIDTH && !TCOD_map_is_walkable(_zone1, x, y)) {
        TCOD_map_set_properties(_zone1,x,y,true,true); /* ground */
        x++;
    }
}

/*! @brief returns true if the player has been at this tile */
-(Boolean)isExploredX:(int) x andY:(int) y {
    return tiles[x][y];
}

/*! @brief returns true if tile is in the TCOD FOV area */
-(Boolean)isInFOVX:(int) x andY:(int) y {
    if( x < 0 || x >= MAP_WIDTH || y < 0 || y >= MAP_HEIGHT) {
        return false;
    }
    if( TCOD_map_is_in_fov(_zone1, x, y) ) {
        tiles[x][y] = true;
        return true;
    }
    return false;
}

-(Boolean)isWallX:(int) x andY:(int) y {
    return !TCOD_map_is_walkable(_zone1, x, y);
}

-(Boolean)canWalkX:(int) x andY:(int) y {
    if( [self isWallX:x andY:y]) { // this is a wall
        return false;
    } else {
        // is there something else here?  check
        return true;
    }
}

-(Boolean)isRoomX:(int) x andY:(int) y {
    return room[x][y];
}

-(void)computeFOV:(int) x andY:(int) y {
    
    TCOD_map_compute_fov(_zone1, x, y, torchRadius, true, (TCOD_fov_algorithm_t)0);
}

-(void)setWallPosX:(int) x andY:(int) y {
    tiles[x][y] = false;  // can walk is false
    TCOD_map_set_properties(_zone1, x, y, true, false);
}

-(void)createRooms:(int) num {
    // create num rooms and connect them with tunnels
    int roomWidth = 8;
    int roomHeight = 10;
    int roomBuffer = 45; // ### HAVE A BUG HERE
    for( int i=0; i < num; i++ ) {
        int randX = TCOD_random_get_int(NULL, 1, MAP_WIDTH - roomWidth);
        int randY = TCOD_random_get_int(NULL, 1, MAP_HEIGHT - roomHeight - roomBuffer);
        int midpointX = randX + (roomWidth/2);
        int midpointY = randY + (roomHeight/2);
        [self createRoomAtX1:randX andY1:randY andX2:randX + roomWidth andY2:randY + roomHeight];
        [self hline_left:randX - 1 y:midpointY];
        [self hline_right:randX + roomWidth + 1 y:midpointY];
        [self vline_up:midpointX y:randY -1];
        [self vline_down:midpointX y:randY + roomHeight + 1];
    }
}

-(void)createRoomAtX1:(int) x1 andY1:(int) y1 andX2:(int) x2 andY2:(int) y2 {
    // can we also add some items ?
    [self digAtX1:x1 andY1: y1 andX2: x2 andY2: y2];
}

-(void)digAtX1:(int) x1 andY1:(int) y1 andX2:(int) x2 andY2:(int) y2 {
    if ( x2 < x1 ) {
        int tmp=x2;
        x2=x1;
        x1=tmp;
    }
    if ( y2 < y1 ) {
        int tmp=y2;
        y2=y1;
        y1=tmp;
    }
    for (int tilex=x1; tilex <= x2; tilex++) {
        for (int tiley=y1; tiley <= y2; tiley++) {
            tiles[tilex][tiley] = false;  // explored?
            room[tilex][tiley] = true; // this a room tile
            TCOD_map_set_properties(_zone1, tilex, tiley, true, true); // this makes a room
        }
    }
}
-(void)moveCamera:(int) x andY:(int) y {
    //make sure the camera doesn't see outside the map
    if (x < 0) {
        cameraX = 0;
    } else if (x > MAP_WIDTH - CAMERA_WIDTH - 1) {
        cameraX = MAP_WIDTH - CAMERA_WIDTH - 1;
    } else {
        cameraX = x - CAMERA_WIDTH / 2;
    }
    if (y < 0) {
        cameraY = 0;
    } else if (y > MAP_HEIGHT - CAMERA_HEIGHT - 1) {
        cameraY = MAP_HEIGHT - CAMERA_HEIGHT - 1;
    } else {
        cameraY = y - CAMERA_HEIGHT / 2;
    }
}

-(int)toCameraCoordinatesX:(int) x playerx:(int) px {
    return x - CAMERA_WIDTH;
}

-(int)toCameraCoordinatesY:(int) y playery:(int) py {
    return y - CAMERA_HEIGHT;
}

-(void)render:(int)px y:(int)py {
    [self moveCamera:px andY:py];
    float dx=0.0f,dy=0.0f,di=0.0f; // torch fx stuff
    float tdx;
    torchx+=0.2f;
    /* randomize the light position between -1.5 and 1.5 */
    tdx=torchx+20.0f;
    dx = TCOD_noise_get(noise,&tdx)*1.5f;
    tdx += 30.0f;
    dy = TCOD_noise_get(noise,&tdx)*1.5f;
    di = 0.2f * TCOD_noise_get(noise,&torchx);
    //NSLog(@"Player (%d, %d)", px, py);  // 294, 309
    for (int conX = 0; conX < CAMERA_WIDTH; conX++) {
        for (int conY = 0; conY < (CAMERA_HEIGHT); conY++) {
            int mapX = cameraX + conX;
            int mapY = cameraY + conY;
            bool wall = [self isWallX:mapX andY: mapY];
            bool visible = [self isInFOVX:mapX andY:mapY];
            // For Debug
            //bool visible = true;
            TCOD_color_t base = ( wall ? _darkWall : _darkGround);
            TCOD_color_t light = ( wall ? _lightWall : _lightGround);
            float r=(mapX-px+dx)*(mapX-px+dx)+(mapY-py+dy)*(mapY-py+dy); /* cell distance to torch (squared) */
            if(!visible) {
                if( tiles[mapX][mapY]) {
                    TCOD_console_set_char_background(NULL, conX, conY,
                                                         wall ? _darkWall: _darkGround, TCOD_BKGND_SET);
                }
            } else {
                int sqTorchRadius = torchRadius*torchRadius;
                if ( r < sqTorchRadius ) {
                    float l = (sqTorchRadius-r)/sqTorchRadius+di;
                    l=CLAMP(0.0f,1.0f,l);
                    base=TCOD_color_lerp(base,light,l);
                }
                TCOD_console_set_char_background(NULL, conX, conY, base, TCOD_BKGND_SET);
            }
        }
    }
}

@end
