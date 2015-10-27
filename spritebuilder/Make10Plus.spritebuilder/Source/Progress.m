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


#import "Progress.h"

@implementation Progress
#pragma mark load and enter


-(void) didLoadFromCCB {
//    NSLog(@"Progress.didLoadFromCCB");
    
    CCSprite* sprite = [CCSprite spriteWithImageNamed:@"sprites/progress.png"];

    _timeBar = [CCProgressNode progressWithSprite:sprite];
    _timeBar.type = CCProgressNodeTypeBar;
    _timeBar.midpoint = ccp(0, 0);
    _timeBar.barChangeRate = ccp(1, 0);
    _timeBar.percentage = 0;
        
    [_timeBar setAnchorPoint: ccp(0,0)];
    [_timeBar setPosition:ccp(0, 2)];
    
    [self addChild:_timeBar];
    
    
}


-(void) startWithDuration:(int)duration target:(id)target callback:(SEL)callback {
//    NSLog(@"Progress.startWithDuration");
    id actionScaleDone = [CCActionCallFunc actionWithTarget:target selector:callback];
	CCActionProgressFromTo* progressToFull = [CCActionProgressFromTo actionWithDuration:duration from:0 to:100];
	CCActionSequence *asequence = [CCActionSequence actions:progressToFull, actionScaleDone, nil];

	[_timeBar runAction:asequence];

}


@end
