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


#import "SettingsScene.h"
#import "Make10Constants.h"
#import "Make10Util.h"
#import "OALSimpleAudio.h"

NSMutableArray*    _makeValueArray;
NSMutableArray*    _levelArray;
NSMutableArray*    _challengeTypeArray;
NSMutableArray*    _challengeTypeStringsArray;
NSMutableArray*    _styleArray;
NSMutableArray*    _styleStringsArray;

int _makeValue;
int _level;
int _challengeType;
int _style;

/** UISwipeGestureRecognizers that need to be removed onExit */
UISwipeGestureRecognizer* _swipeRight;
UISwipeGestureRecognizer* _swipeLeft;

@implementation SettingsScene


#pragma mark load and enter

-(void) didLoadFromCCB {
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    /*
     * makeValue 
     */
    NSNumber* makeValue = [defaults objectForKey:PREF_MAKE_VALUE]; //default set in MainScene
    _makeValue = [makeValue intValue];
    
    _makeValueArray = [[NSMutableArray alloc] initWithCapacity:18];
    [_makeValueArray addObject:_btn5];
    [_makeValueArray addObject:_btn6];
    [_makeValueArray addObject:_btn7];
    [_makeValueArray addObject:_btn8];
    [_makeValueArray addObject:_btn9];
    [_makeValueArray addObject:_btn10];
    [_makeValueArray addObject:_btn11];
    [_makeValueArray addObject:_btn12];
    [_makeValueArray addObject:_btn13];
    [_makeValueArray addObject:_btn14];
    [_makeValueArray addObject:_btn15];
    [_makeValueArray addObject:_btn16];
    [_makeValueArray addObject:_btn17];
    [_makeValueArray addObject:_btn18];
    [_makeValueArray addObject:_btn19];
    [_makeValueArray addObject:_btn20];
    [_makeValueArray addObject:_btn60];
    [_makeValueArray addObject:_btn100];
    [self setMakeValueUI];
    
    /*
     * Starting level
     */
    _levelArray = [[NSMutableArray alloc] initWithCapacity:6];
    [_levelArray addObject:_lvl0];
    [_levelArray addObject:_lvl1];
    [_levelArray addObject:_lvl2];
    [_levelArray addObject:_lvl3];
    [_levelArray addObject:_lvl4];
    [_levelArray addObject:_lvl5];

    
    NSNumber* level = [defaults objectForKey:PREF_START_LEVEL];
    _level = [level intValue];
    [self setStartingLevelUI];
    
    /*
     * Challenge type
     */
     
    _challengeTypeArray = [[NSMutableArray alloc] initWithCapacity:4];
    [_challengeTypeArray addObject:_btnChallenge0];
    [_challengeTypeArray addObject:_btnChallenge1];
    [_challengeTypeArray addObject:_btnChallenge2];
    [_challengeTypeArray addObject:_btnChallenge3];

    _challengeTypeStringsArray = [[NSMutableArray alloc] initWithCapacity:4];
    [_challengeTypeStringsArray addObject:@"Speeds up"];
    [_challengeTypeStringsArray addObject:@"Sums 5-10"];
    [_challengeTypeStringsArray addObject:@"Sums 5-20"];
    [_challengeTypeStringsArray addObject:@"Sums 5-100"];

    NSNumber* challenge = [defaults objectForKey:PREF_CHALLENGE_TYPE];
    _challengeType = [challenge intValue];
    [self setChallengeTypeUI];
    
    /*
     * Tile style
     */
    _styleArray = [[NSMutableArray alloc] initWithCapacity:2];
    [_styleArray addObject:_style0];
    [_styleArray addObject:_style1];

    _styleStringsArray = [[NSMutableArray alloc] initWithCapacity:2];
    [_styleStringsArray addObject:@"Numbers"];
    [_styleStringsArray addObject:@"Dots 1-10"];
    
    NSNumber* style = [defaults objectForKey:PREF_TILE_STYLE];
    _style = [style intValue];
    [self setStyleUI];

}

-(void) onEnter {
    [super onEnter];
    
}

-(void) onEnterTransitionDidFinish {
    [super onEnterTransitionDidFinish];
    [self addSwipeRecognizers];
    
}

-(void) setMakeValueUI {
    for (int i = 0, len = [_makeValueArray count]; i < len; i++) {
        CCButton* btn = [_makeValueArray objectAtIndex:i];
        [btn setSelected:([btn.name intValue] == _makeValue)];
    }
    [_makeValueBtn setTitle:[NSString stringWithFormat:@"Make %d", _makeValue]];

}

-(void) setStartingLevelUI {
    for (int i = 0, len = [_levelArray count]; i < len; i++) {
        CCButton* btn = [_levelArray objectAtIndex:i];
        [btn setSelected:([btn.name intValue] == _level)];
    }

    [_levelBtn setTitle:[NSString stringWithFormat:@"Level %d", _level]];

}

-(void) setChallengeTypeUI {
    for (int i = 0, len = [_challengeTypeArray count]; i < len; i++) {
        CCButton* btn = [_challengeTypeArray objectAtIndex:i];
        [btn setSelected:([btn.name intValue] == _challengeType)];
    }
    
    [_challengeTypeBtn setTitle:[_challengeTypeStringsArray objectAtIndex:_challengeType]];
    
}

-(void) setStyleUI {
    for (int i = 0, len = [_styleArray count]; i < len; i++) {
        CCButton* btn = [_styleArray objectAtIndex:i];
        [btn setSelected:([btn.name intValue] == _style)];
    }
    
    [_styleBtn setTitle:[_styleStringsArray objectAtIndex:_style]];
    
}

#pragma mark Swipe
-(void) addSwipeRecognizers {
    // listen for swipes to the left
    _swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    _swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeLeft];

    _swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeRight];
}

-(void) swipeRight {
    
    [[OALSimpleAudio sharedInstance] playEffect:@"currentToWall.m4a"];
    [self homeAction];
}

-(void) swipeLeft {
    
    [[OALSimpleAudio sharedInstance] playEffect:@"currentToWall.m4a"];
    [self playAction];
}


#pragma mark spritebuilder events
-(void) homePressed {
    
    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    [self homeAction];
    
}

-(void) homeAction {
    
    CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:SCENE_TRANS_TIME]];
    
}

-(void) playAction {
    
    CCScene* scene = [CCBReader loadAsScene:@"PlayScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:SCENE_TRANS_TIME]];
    
}

-(void) makeValuePressed {
    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    
    [_makeValueLayer setVisible:YES];
}


-(void) valuePressed:(id)sender {
    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    
    CCButton *buttonPressed = (CCButton*)sender;
    _makeValue = [buttonPressed.name intValue];
    [self setMakeValueUI];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:_makeValue forKey:PREF_MAKE_VALUE];

    [_makeValueLayer setVisible:NO];

}

-(void) settingsPressed {
    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    
    [_challengeTypeLayer setVisible:NO];
    [_makeValueLayer setVisible:NO];
    [_startingLevelLayer setVisible:NO];
    [_styleLayer setVisible:NO];

}

-(void) levelPressed {
    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    
    [_startingLevelLayer setVisible:YES];
}

-(void) startingLevelPressed:(id)sender {
    
    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    
    CCButton *buttonPressed = (CCButton*)sender;
    _level = [buttonPressed.name intValue];
    [self setStartingLevelUI];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:_level forKey:PREF_START_LEVEL];
    
    [_startingLevelLayer setVisible:NO];

}
-(void) challengeTypePressed {
    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    
    [_challengeTypeLayer setVisible:YES];
    
}

-(void) challengePressed:(id)sender {
    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    
    CCButton *buttonPressed = (CCButton*)sender;
    _challengeType = [buttonPressed.name intValue];
    [self setChallengeTypeUI];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:_challengeType forKey:PREF_CHALLENGE_TYPE];
    
    [_challengeTypeLayer setVisible:NO];
    
}
-(void) stylePressed {
    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    
    [_styleLayer setVisible:YES];
    
}

-(void) tileStylePressed:(id)sender {
    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    
    CCButton *buttonPressed = (CCButton*)sender;
    _style = [buttonPressed.name intValue];
    [self setStyleUI];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:_style forKey:PREF_TILE_STYLE];
    
    [_styleLayer setVisible:NO];
    
}

#pragma mark exit
-(void) onExitTransitionDidStart {
    
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeLeft];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeRight];
    
    /*
     * write to disk to free up memory
     */
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults synchronize];

    [super onExitTransitionDidStart];
}
@end
