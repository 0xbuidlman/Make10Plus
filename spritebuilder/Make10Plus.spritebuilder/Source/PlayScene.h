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

#import "LevelLayer.h"
#import "Progress.h"
#import "TileNode.h"

@interface PlayScene : CCNode {
    
    CCSprite* _playBg;
    CCLabelTTF* _scoreLbl;
    CCButton* _pauseBtn;
    LevelLayer* _levelLayer;
    Progress* _progressBar;
    CCSprite*   _gain;
    CCLabelTTF* _gainLbl;
    
    //Things inside _levelLayer
    CCSprite* _girlReady;
    CCSprite* _boyReady;
    CCButton* _resumeBtn;
    CCButton* _startOverBtn;
    CCLabelTTF* _levelLbl;
    CCLabelTTF* _getReadyLbl;
    CCLabelTTF* _makeLbl;
}

/**
 * A delegate method that listens to tilePressed events
 * @param wallTile TileNode in the wall that was pressed
 */
-(void) tilePressedHandler:(id)wallTile;

@end
