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


#import "PlayScene.h"
#import "Make10Constants.h"
#import "Make10Util.h"
#import "Wall.h"
#import "Score.h"
#import "Progress.h"
#import "OALSimpleAudio.h"

/** UISwipeGestureRecognizers that need to be removed onExit */
UISwipeGestureRecognizer* _swipeRight;

int         _makeValue;
Wall*       _wall;
Score*      _score;
TileNode*   _nextTile;
TileNode*   _currentTile;
TileNode*   _knockedWallTile;
int         _lastRandomMakeValue;
int         _nextLastRandomMakeValue;

@implementation PlayScene


#pragma mark load and enter

-(void) didLoadFromCCB {
    _score = [[Score alloc] init];
    _wall = [[Wall alloc] init];

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSNumber* makeValue = [defaults objectForKey:PREF_MAKE_VALUE];
    _makeValue = [makeValue intValue];

    [_scoreLbl setString:[NSString stringWithFormat:@"Make %d", _makeValue]];
    [self setUserInteractionEnabled:YES];
    
    [self showLevelLayerWithPause:NO];
    
    _lastRandomMakeValue = 1;
    _nextLastRandomMakeValue = 0;
    
}

-(void) onEnter {
    [super onEnter];
    
}

-(void) onEnterTransitionDidFinish {
    [super onEnterTransitionDidFinish];
    [self addSwipeRecognizers];
    
    /*
     Show the Get Ready layer and start the timer for it to disappear
     */
    [self startLevelLayerProgress];
}



#pragma mark Swipe
-(void) addSwipeRecognizers {
    // listen for swipes to the left
    _swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeRight];
}

-(void) swipeRight {
    
    [[OALSimpleAudio sharedInstance] playEffect:@"currentToWall.m4a"];
    [self pauseAction];
}


#pragma mark spritebuilder events
-(void) pausePressed {
    
    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    [self pauseAction];
    
}

-(void) pauseAction {
    if ([_levelLayer visible]) {
        return;
    }
    [[CCDirector sharedDirector] pause];
    [self showLevelLayerWithPause:YES];
}

-(void) resumePressed {
    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    [self playAction];
}

-(void) playAction {
    [[CCDirector sharedDirector] resume];
    [_pauseBtn setVisible:YES];
    [_levelLayer setVisible:NO];
    [self setUserInteractionEnabled:YES];
    [_wall enableWall:YES];

}

-(void) startOverPressed {
    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    [self homeAction];
}

-(void) homeAction {
    
    [[CCDirector sharedDirector] resume];
    
    CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:SCENE_TRANS_TIME]];
}

#pragma mark playing the game
/**
 * Start the progress bar and enable touch
 */
-(void) startProgressBar {
    //    NSLog(@"startProgressBar");
    
    [_progressBar startWithDuration:_score.wallTime target:self callback:@selector(addWallRow)];
    [self setUserInteractionEnabled:YES];
    [_wall enableWall:YES];
    
    /*
     * If the wall has reached the max, show the game over scene after a slight delay
     */
    if ([_wall isMax]) {
        [self endGame];
        return;
    }
    
    
    
}



#pragma mark LevelLayer interactions

/**
 * Show the level layer
 * @param pause YES if it is pause mode
 */
-(void) showLevelLayerWithPause:(BOOL)pause {
    /*
     * Randomly decide which background to show
     */
    int r = arc4random() % 4 + 1;
    BOOL randomBool = r > 2;
//    NSLog(@"r = %d", r);
    [_boyReady setVisible:randomBool];
    [_girlReady setVisible:!randomBool];
    [_levelLbl setFontSize:30.0f]; //reset in case it was changed
    
    if (pause) {
        [_levelLbl setString:[NSString stringWithFormat:@"Level %d\npaused", _score.level]];
        /*
         * If 2 digits
         * we need to make the level label smaller
         */
        if (_score.level > 9) {
            [_levelLbl setFontSize:24.0f];
        } else if (_score.level > 99) {
            /*
             * If 3 digits
             * we need to make the level label even smaller
             */
            [_levelLbl setFontSize:22.0f];
        }

    } else {
        [_levelLbl setString:[NSString stringWithFormat:@"Level\n%d", _score.level]];
    }
    
    [_makeLbl setString:[NSString stringWithFormat:@"Make\n%d", _makeValue]];
    [_resumeBtn setVisible:pause];
    [_startOverBtn setVisible:pause];
    
    [_getReadyLbl setVisible:!pause];


    [_pauseBtn setVisible:NO];
    [_levelLayer setVisible:YES];
    [self setUserInteractionEnabled:NO];
    [_wall enableWall:NO];
}

/**
 * Starts the progress bar indicating how long before you have to be ready to play next level
 */
-(void) startLevelLayerProgress {

    [_progressBar startWithDuration:GET_READY_TRANS_TIME target:self callback:@selector(prepNewLevel)];

}
#pragma mark starting the game

/**
 * Generate a random value between 1 and the makeValue
 * and it has to be different from the last 2 randomly generated
 * values to give the wall some variety
 */
-(int) genRandomValue {
    int val = (arc4random() % (_makeValue - 1)) + 1;
    if (val == _nextLastRandomMakeValue || val == _lastRandomMakeValue) {
        return [self genRandomValue];
    }
    
    _nextLastRandomMakeValue = _lastRandomMakeValue;
    _lastRandomMakeValue = val;
    return val;
}

/**
 * Create tiles for a row and stick them in row 0
 * (which are below the visible screen and will need to be transitioned up)
 */
-(void) createNewTilesForRow {
    for (int j = 0; j < MAX_COLS; j++) {
        int value = [self genRandomValue];

        TileNode* wallTile = (TileNode*)[CCBReader load:@"TileNode"];
        [wallTile initWithValueAndCol:value col:j makeValue:_makeValue playScene:self];

        [_playBg addChild:wallTile];
        [_wall addTile:wallTile row:0 col:j];
    }
    
}


/**
 * Prepare a new level by adding 2 rows (to a cleared wall)
 */
-(void) prepNewLevel {

    /*
     * Hide the level layer
     */
    [_levelLayer setVisible:NO];
    [_pauseBtn setVisible:YES];
    
    /*
     * Create 2 full row of tiles
     */
    [self createNewTilesForRow];
    
    [_wall transitionUpWithTarget:self callback:@selector(addWallRow)];
    
    [self createNextTile];
    [self createCurrentTile];
}

/**
 * Add a row to the wall.
 * Disable touch so there's no bad behavior when the wall is moving
 */
-(void) addWallRow {
    //    NSLog(@"addWallRow");
    
    [self setUserInteractionEnabled:NO];
    [_wall enableWall:NO];
    
    NSUInteger currentTileSpriteRunningActions = [_currentTile numberOfRunningActions];
    //    NSLog(@"addWallRow currentTile.sprite numberOfRunningActions = %d, currentTile.row = %d, currentTile.col = %d", currentTileSpriteRunningActions, _currentTile.row, _currentTile.col);
    
    if (currentTileSpriteRunningActions > 0 && _currentTile.row > 0) {
        _currentTile.row++;
        /*
         * If the current tile has a row (meaning valueNotMade so it's going to join the wall soon) and is in flight, increment its
         * row because it is not yet a part of the wall and the wall will be transitioning up.
         * Stop the action then "resume" after delay.
         */
        
        [_currentTile stopActionByTag:ACTION_TAG_ADD_TO_WALL];
        //        NSLog(@"addWallRow stoppedActionByTag for ACTION_TAG_ADD_TO_WALL");
        
        [self scheduleOnce:@selector(moveToAddToWall) delay:WALL_TRANS_TIME];
        
    } else if (currentTileSpriteRunningActions > 0 && _knockedWallTile) {
        /*
         * If the current tile is in flight and there is a _knockedWallTile (meaning
         * (valueMade so it might remove a tile right when the tiles need to transition up
         * This is a problem when it is the last tile moving up, the CCSequence will be gone
         * and then we'll never call the selector to restart the progressBar.
         * Solution to this is "pause" then "resume" after delay.
         */
        [_currentTile stopActionByTag:ACTION_TAG_KNOCK];
        //        NSLog(@"addWallRow stoppedActionByTag for ACTION_TAG_KNOCK");
        
        [self scheduleOnce:@selector(knockWallTile) delay:WALL_TRANS_TIME];
        
    }
    
    /*
     * Create full row of tiles
     */
    [self createNewTilesForRow];
    /*
     * Transition the wall up
     */
    [_wall transitionUpWithTarget:self callback:@selector(startProgressBar)];
    
}

/**
 * Generate a random index of possible
 */
-(int) genRandomPossibleIndex:(NSMutableArray*)possibles currentTileValue:(int)currentTileValue {
    NSUInteger size = [possibles count];
    int randIndex = (arc4random() % (size - 1));
//    NSLog(@"genRandomPossibleIndex possibles count size = %d;\nrandIndex before conditions = %d;\n_lastRandomPossiblesIndex = %d", size, randIndex, _lastRandomPossiblesIndex);
    
    if (size > 2 && [[possibles objectAtIndex:randIndex] intValue] == currentTileValue) {
        return [self genRandomPossibleIndex:possibles currentTileValue:currentTileValue];
    }
    return randIndex;
}


/**
 * Create and place the next tile
 */
-(void) createNextTile {
    NSMutableArray* possibles = [_wall getUniquePossibles:_makeValue];
    NSUInteger size = [possibles count];
    int value;
    if (size > 1) {
        int randIndex = [self genRandomPossibleIndex:possibles currentTileValue:_currentTile.value];
        value = [[possibles objectAtIndex:randIndex] intValue];
        
    } else if (size == 1) {
        value = [[possibles objectAtIndex:0] intValue];
    } else {
        //should really ever happen b/c leveling up, but a safety valve.
        value = [self genRandomValue];
    }
    
    _nextTile = (TileNode*)[CCBReader load:@"TileNode"];
    [_nextTile initWithValue:value makeValue:_makeValue playScene:self];
    
    [_playBg addChild:_nextTile];
}

/**
 * Move the next tile to the current position
 * and create a new next tile
 */
-(void) createCurrentTile {
    
    [_nextTile transitionToCurrentWithTarget:self callback:@selector(nextMovedToCurrentPosition)];
    _currentTile = _nextTile;
    _nextTile = nil;
}

/**
 * Callback of createCurrentTile
 */
-(void) nextMovedToCurrentPosition {
    /*
     * Create the next tile
     */
    [self createNextTile];
}


#pragma mark Touches
/**
 * A delegate method that listens to tilePressed events
 * @param wallTile TileNode in the wall that was pressed
 */
-(void) tilePressedHandler:(TileNode*)wallTile {
//    [_nextTile setUserInteractionEnabled:NO];

    
    if (wallTile.value + _currentTile.value == _makeValue) {
        [self valueMade:wallTile];
    } else {
        [self valueNotMade:wallTile];
    }
}


#pragma mark value made
/**
 * Handle when the value is made
 * @param wallTile the tile touched to make the value
 */
-(void) valueMade:(TileNode*) wallTile {
//    NSLog(@"valueMade");
    /*
     * It's a match!
     * Move the current tile to the position of the wallTile
     */
    _knockedWallTile = wallTile;
    [self knockWallTile];
}

-(void) knockWallTile {

    CGPoint point = _knockedWallTile.position;
    [_currentTile transitionToPoint:point target:self callback:@selector(wallTileKnockedDone) actionTag:ACTION_TAG_KNOCK];
}

/**
 * Callback when the value made wall tile is done
 */
-(void) wallTileKnockedDone {
    
    [[OALSimpleAudio sharedInstance] playEffect:@"knock.m4a"];
    
    /*
     * Destroy both the current tile and the knockedWallTile
     * Create the next current tile
     */
    [_currentTile removeFromParentAndCleanup:YES];
    _currentTile = nil;
    
    _gain.position = _knockedWallTile.position;
    int tileCount = [_wall removeTile:_knockedWallTile];
    
    [_knockedWallTile removeFromParentAndCleanup:YES];
    _knockedWallTile = nil;
    
    _score.tilesRemoved += tileCount;
    int pointGain = _score.pointValue * tileCount;
    _gain.scale = 1.0f;
    
    [self updateScore:pointGain];
    [self levelUp];
    
    [self createCurrentTile];
}

/**
 * Update the score and gain labels
 * @param pointGain int increase in points
 */
-(void) updateScore:(int)pointGain {
    [_gainLbl setString:[NSString stringWithFormat:@"+%d", pointGain]];
    _gain.visible = YES;
    [_gain runAction:[CCActionScaleTo actionWithDuration:TILE_DROP_TIME scale:1.50]];
    [_gain runAction:[CCActionFadeOut actionWithDuration:TILE_DROP_TIME]];
    [_gainLbl runAction:[CCActionFadeOut actionWithDuration:TILE_DROP_TIME]];
    
    _score.score += pointGain;
    
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:[[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    
    [_scoreLbl setString:[formatter stringFromNumber:[NSNumber numberWithInt:_score.score]]];
    
}

/**
 * Check if the next level benchmark has been reached
 * and if so show the level layer with the new level
 */
-(void) levelUp {
    /*
     * If the wall was completely cleared, push score above benchmark
     */
    if ([_wall isWallClear]) {
        _score.tilesRemoved = LEVEL_MARKER;
    }
    /*
     * If enough to advance to the next level,
     * stop the timer,
     * clear the wall and prep for a new level,
     * show the level layer
     * then restart the timer
     */
    if ([_score levelUp]) {
        [self setUserInteractionEnabled:NO];
        [_wall enableWall:NO];
        
        [self stopAllActions];
        [_progressBar.timeBar stopAllActions];
        
        [_wall clearWall];
        [_nextTile removeFromParentAndCleanup:YES];
        _nextTile = nil;
        [_currentTile removeFromParentAndCleanup:YES];
        _currentTile = nil;
        
        /*
         * If the challenge type was changing sum,
         * generate a new make value
         */
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSNumber* challengeType = [defaults objectForKey:PREF_CHALLENGE_TYPE]; //default set in MainScene
        int challengeTypeInt = [challengeType intValue];
        
        if (PREF_CHALLENGE_TYPE_SPEED != challengeTypeInt) {
            _makeValue = [Make10Util genRandomMakeValue:_makeValue challengeType:challengeTypeInt];
        }
        
        [self showLevelLayerWithPause:NO];
        [self startLevelLayerProgress];
        
    }
}

#pragma mark value not made
/**
 * Handle when the value is not made
 * @param wallTile Tile that was touched
 */
-(void) valueNotMade:(TileNode*) wallTile {
//    NSLog(@"valueNotMade wallTile=%@", wallTile);
    
    /*
     * It's not a match
     * Move the current tile to the top of the column where the wallTile is     */
    if (wallTile) {
        CGPoint newPosition = [_wall getPointAtopTile: _currentTile referenceTile:wallTile];
        
        if (newPosition.x != 0 && newPosition.y != 0) {
            
            [_currentTile transitionToPoint:newPosition target:self callback:@selector(currentBecomesWallTileDone) actionTag:ACTION_TAG_ADD_TO_WALL];
            //            NSLog(@"valueNotMade wallTile !nil, currentTile.row = %d, currentTile.col = %d", _currentTile.row, _currentTile.col);
            
        } else {
            /*
             * No empty spot found (wall at max), so end game
             */
            [self endGame];
        }
        
    }
}

-(void) moveToAddToWall {
    CGPoint newPosition = [_wall getPointInGrid:_currentTile row:_currentTile.row col:_currentTile.col];
    [_currentTile transitionToPoint:newPosition target:self callback:@selector(currentBecomesWallTileDone) actionTag:ACTION_TAG_ADD_TO_WALL];
}

/**
 * Callback after the current tile becomes a part of the wall
 */
-(void) currentBecomesWallTileDone {
    //    NSLog(@"currentBecomesWallTileDone");
    
    /*
     * If the current tile transitioned to a point when the
     * when the wall was moving, we still need to position it
     * so it is in the exact grid location
     */
    int row = _currentTile.row;
    int col = _currentTile.col;
    [_wall snapTileToGrid:_currentTile row:row col:col];
    [_wall addTile:_currentTile row:row col:col];
    [_currentTile enableTileButton:YES];
    /*
     * Create the next current tile
     */
    _currentTile = nil;
    [self createCurrentTile];
    
    /*
     * If the wall has reached the max, show the game over scene after a slight delay
     */
    if ([_wall isMax]) {
        [self endGame];
        return;
    }
    
}

#pragma mark ending the game
/**
 * End the game
 */
-(void) endGame {
    //    NSLog(@"endGame");
    
    int randSuffix = arc4random() % 3 + 1;
    NSString* fileName = [NSString stringWithFormat:@"gameOver%d.m4a", randSuffix];
    [[OALSimpleAudio sharedInstance] playEffect:fileName];
    
    [self setUserInteractionEnabled:NO];
    [_wall enableWall:NO];
    [self stopAllActions];
    [_progressBar.timeBar  stopAllActions];
    
    [self scheduleOnce:@selector(showGameOver) delay:GAME_OVER_DELAY];
    
}

/**
 * Switch to the game over scene
 */
-(void) showGameOver {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:_score.score forKey:PREF_SCORE];
    
    CCScene* scene = [CCBReader loadAsScene:@"GameOverScene"];
    
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:SCENE_TRANS_TIME]];
}

#pragma mark exit
-(void) onExitTransitionDidStart {
    
    _wall = nil;
    _score = nil;

    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeRight];
    [super onExitTransitionDidStart];
}
@end

