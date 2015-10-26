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


#import "AboutScene.h"
#import "Make10Constants.h"
#import "OALSimpleAudio.h"

/** UISwipeGestureRecognizers that need to be removed onExit */
UISwipeGestureRecognizer* _swipeUp;

@implementation AboutScene

#pragma mark load and enter

-(void) didLoadFromCCB {
    
    
}

-(void) onEnter {
    [super onEnter];
    
}

-(void) onEnterTransitionDidFinish {
    [super onEnterTransitionDidFinish];
    [self addSwipeRecognizers];
    
}

#pragma mark Swipe
-(void) addSwipeRecognizers {

    _swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp)];
    _swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeUp];

}

-(void) swipeUp {
    
    [[OALSimpleAudio sharedInstance] playEffect:@"currentToWall.m4a"];
    [self homeAction];
}


#pragma mark spritebuilder events
-(void) homePressed {
    
    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    [self homeAction];
    
}

-(void) homeAction {
    
    CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionUp duration:SCENE_TRANS_TIME]];
    
}


#pragma mark exit
-(void) onExitTransitionDidStart {
    
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeUp];
    [super onExitTransitionDidStart];
}
@end
