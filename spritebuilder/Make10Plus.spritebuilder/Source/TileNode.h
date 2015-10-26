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

@interface TileNode : CCNode {
    CCButton* _tileBtn;
}

/**
 * The value of this tile
 */
@property int value;
/**
 * The column of this tile in the wall
 */
@property int col;
/**
 * The row of this tile in the wall
 */
@property int row;

/**
 * An init method with value and boolean for current tile
 * @param value int for the tile
 * @param makeValue int for the current make value
 * @param playScene to notify tilePressed
 */
-(void) initWithValue:(int)value makeValue:(int)makeValue playScene:(id)playScene;
/**
 * An init method with value and column for placement
 * @param value int for the tile
 * @param col int column placement
 * @param makeValue int for the current make value
 * @param playScene to notify tilePressed
 */
-(void) initWithValueAndCol:(int)value col:(int)col makeValue:(int)makeValue playScene:(id)playScene;
/**
 * Move the tile to the current tile position
 */
-(void) transitionToCurrentWithTarget:(id)target callback:(SEL)callback;
/**
 * Move the tile to the point
 * @param point CGPoint to move to
 * @param target where callback is located
 * @param callback selector of callback
 * @param action tag int
 */
-(void) transitionToPoint:(CGPoint)point target:(id)target callback:(SEL)callback actionTag:(int)actionTag;

@end
