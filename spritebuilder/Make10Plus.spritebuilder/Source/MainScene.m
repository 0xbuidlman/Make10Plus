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


#import "MainScene.h"
#import "Make10Constants.h"
#import "OALSimpleAudio.h"

/** UISwipeGestureRecognizers that need to be removed onExit */
UISwipeGestureRecognizer* _swipeLeft;
UISwipeGestureRecognizer* _swipeRight;
UISwipeGestureRecognizer* _swipeDown;

@implementation MainScene

#pragma mark load and enter

-(void) didLoadFromCCB {
    
    /*
     * Set all defaults if there were none so elsewhere can just grab values
     * instead of having to test existence
     */
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSNumber* makeValue = [defaults objectForKey:PREF_MAKE_VALUE];
    
    if (!makeValue) {
        [defaults setInteger:MAKE_VALUE_DEFAULT forKey:PREF_MAKE_VALUE];
    }
    
    NSNumber* startingLevel = [defaults objectForKey:PREF_START_LEVEL];
    if (!startingLevel) {
        [defaults setInteger:1 forKey:PREF_START_LEVEL];
    }
    
    NSNumber* challenge = [defaults objectForKey:PREF_CHALLENGE_TYPE];
    if (!challenge) {
        [defaults setInteger:PREF_CHALLENGE_TYPE_SPEED forKey:PREF_CHALLENGE_TYPE];
    }
    
    NSNumber* style = [defaults objectForKey:PREF_TILE_STYLE];
    if (!style) {
        [defaults setInteger:PREF_TILE_STYLE_NUMBERS forKey:PREF_TILE_STYLE];
    }
    
    NSNumber* hi = [defaults objectForKey:PREF_HIGH_SCORE];
    if (!hi) {
        [defaults setInteger:0 forKey:PREF_HIGH_SCORE];
    }

    NSNumber* hi2 = [defaults objectForKey:PREF_HIGH_SCORE2];
    if (!hi2) {
        [defaults setInteger:0 forKey:PREF_HIGH_SCORE2];
    }

    NSNumber* hi3 = [defaults objectForKey:PREF_HIGH_SCORE3];
    if (!hi3) {
        [defaults setInteger:0 forKey:PREF_HIGH_SCORE3];
    }

    
    
    defaults = [NSUserDefaults standardUserDefaults];
    makeValue = [defaults objectForKey:PREF_MAKE_VALUE];
    [_scoreLbl setString:[NSString stringWithFormat:@"Make %d+", [makeValue intValue]]];

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
    // listen for swipes to the left
    _swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    _swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeLeft];
    
    // listen for swipes to the right
    _swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeRight];

    // listen for swipes down
    _swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown)];
    _swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeDown];

}

-(void) swipeLeft {

    [[OALSimpleAudio sharedInstance] playEffect:@"currentToWall.m4a"];
    [self settingsAction];
}

-(void) swipeRight {
    
    [[OALSimpleAudio sharedInstance] playEffect:@"currentToWall.m4a"];
    [self showGameOver];
}

-(void) swipeDown {
    
    [[OALSimpleAudio sharedInstance] playEffect:@"currentToWall.m4a"];
    [self aboutAction];
}

-(void) showGameOver {
    
    CCScene* scene = [CCBReader loadAsScene:@"GameOverScene"];
    
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:SCENE_TRANS_TIME]];
}

#pragma mark spritebuilder events
-(void) aboutPressed {
    
    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    [self aboutAction];
    
}

-(void) aboutAction {
    
    CCScene* scene = [CCBReader loadAsScene:@"AboutScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:SCENE_TRANS_TIME]];
    
}

-(void) playPressed {
    
    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    [self playAction];

}

-(void) playAction {
    
    CCScene* scene = [CCBReader loadAsScene:@"PlayScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:SCENE_TRANS_TIME]];
    
}

-(void) settingsPressed {

    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    [self settingsAction];
}

-(void) settingsAction {
    CCScene* scene = [CCBReader loadAsScene:@"SettingsScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:SCENE_TRANS_TIME]];
    
}

#pragma mark exit
-(void) onExitTransitionDidStart {
    
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeLeft];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeRight];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeDown];
    
    [super onExitTransitionDidStart];
}
@end
