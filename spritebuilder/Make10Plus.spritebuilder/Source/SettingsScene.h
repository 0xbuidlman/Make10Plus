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


@interface SettingsScene : CCNode {
    
    CCSlider* _makeValueSlider;
    CCButton* _makeValueBtn;
    CCButton* _levelBtn;
    CCButton* _challengeTypeBtn;
    CCButton* _styleBtn;
    
    CCSprite* _makeValueLayer;
    
    CCButton* _btn5;
    CCButton* _btn6;
    CCButton* _btn7;
    CCButton* _btn8;
    CCButton* _btn9;
    CCButton* _btn10;
    CCButton* _btn11;
    CCButton* _btn12;
    CCButton* _btn13;
    CCButton* _btn14;
    CCButton* _btn15;
    CCButton* _btn16;
    CCButton* _btn17;
    CCButton* _btn18;
    CCButton* _btn19;
    CCButton* _btn20;
    CCButton* _btn60;
    CCButton* _btn100;
    
    CCSprite* _challengeTypeLayer;
    CCButton* _btnChallenge0;
    CCButton* _btnChallenge1;
    CCButton* _btnChallenge2;
    CCButton* _btnChallenge3;
    
    CCSprite* _startingLevelLayer;
    CCButton* _lvl0;
    CCButton* _lvl1;
    CCButton* _lvl2;
    CCButton* _lvl3;
    CCButton* _lvl4;
    CCButton* _lvl5;
    
    CCSprite* _styleLayer;
    CCButton* _style0;
    CCButton* _style1;

    
}

@end
