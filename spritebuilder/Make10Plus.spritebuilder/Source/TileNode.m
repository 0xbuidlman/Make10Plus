/*******************************************************************************
 *
 * Copyright 2013-15 Bess Siegal
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 ******************************************************************************/


#import "TileNode.h"
#import "Make10Constants.h"
#import "OALSimpleAudio.h"
#import "PlayScene.h"

PlayScene* _playScene;

@implementation TileNode

#pragma mark load and enter

-(void) didLoadFromCCB {
    
    
}

#pragma mark init methods

/**
 * Used when adding tile to wall row
 */
-(void) initWithValueAndCol:(int)value col:(int)col makeValue:(int)makeValue playScene:(PlayScene*)playScene {
    
    _playScene = playScene;
    self.value = value;
    self.col = col;
    
    [self setTileNumberOrDot:value makeValue:makeValue];
    
    [_tileBtn setUserInteractionEnabled:YES];
}

/**
 * Used when becoming the next tile
 */
-(void) initWithValue:(int)value makeValue:(int)makeValue playScene:(PlayScene *)playScene{
    
    _playScene = playScene;
    self.value = value;

    /*
     * NextTile The x position is the half width of tile
     * The y position is top of screen - half the height of a tile
     * (480 is the top of the playBg in points)
     */

    self.position = ccp(self.contentSize.width / 2, 480 - self.contentSize.height * 1.5);
    self.scale = 0.5f;
    
    [self setTileNumberOrDot:value makeValue:makeValue];
    
    [_tileBtn setUserInteractionEnabled:NO];
}

-(void) setTileNumberOrDot:(int)value makeValue:(int)makeValue {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int style = [[defaults objectForKey:PREF_TILE_STYLE] intValue];
    
    if (style == PREF_TILE_STYLE_DOTS && makeValue <= 10) {
        
        NSString* fileName = [NSString stringWithFormat:@"sprites/dot%d.png", value];
        CCSpriteFrame* spriteFrame = [CCSpriteFrame frameWithImageNamed:fileName];
        [_tileBtn setBackgroundSpriteFrame:spriteFrame forState:CCControlStateNormal];
    } else {
        [_tileBtn setTitle:[NSString stringWithFormat:@"%d", value]];
    }
    

}

#pragma mark transition methods
-(void) transitionToCurrentWithTarget:(id)target callback:(SEL)callback {
    [self runAction:[CCActionScaleTo actionWithDuration:NEXT_TO_CURRENT_TRANS_TIME scale:1.0f]];
    
    id actionMove = [CCActionMoveTo actionWithDuration:NEXT_TO_CURRENT_TRANS_TIME position:ccp(320 / 2, 480 - self.contentSize.height * (1.5))];
    id actionMoveDone = [CCActionCallFunc actionWithTarget:target selector:callback];
    [self runAction:[CCActionSequence actions:actionMove, actionMoveDone, nil]];
    
    
    
}

-(void) transitionToPoint:(CGPoint)point target:(id)target callback:(SEL)callback actionTag:(int)actionTag {
    id actionMove = [CCActionMoveTo actionWithDuration:CURRENT_TO_WALL_TRANS_TIME position:point];
    id actionMoveDone = [CCActionCallFunc actionWithTarget:target selector:callback];
    id enableButton = [CCActionCallFunc actionWithTarget:self selector:@selector(enableButton)];
    CCAction* action = [self runAction:[CCActionSequence actions:actionMove, enableButton, actionMoveDone, nil]];
    action.tag = actionTag;
    
    [[OALSimpleAudio sharedInstance] playEffect:@"currentToWall.m4a"];
}

-(void) enableButton {
    [_tileBtn setUserInteractionEnabled:YES];
    
}

#pragma mark description
-(NSString*) description {
    return [NSString stringWithFormat:@"Tile row:%d col:%d value:%d",
            self.row, self.col, self.value];
}

#pragma mark spritebuilder events
-(void) tilePressed {

    NSLog(@"tilePressed! whoami: %@", self);

    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    
    [_playScene tilePressedHandler:self];
}


@end
