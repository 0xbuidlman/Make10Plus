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

NSArray*    _makeValueArray;
NSArray*    _levelArray;
NSArray*    _challengeTypeArray;
NSArray*    _challengeTypeStringsArray;
NSArray*    _styleArray;
NSArray*    _styleStringsArray;

int _makeValue;
int _level;
int _challengeType;
int _style;

int _hi;
int _hi2;
int _hi3;


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
    
    _makeValueArray = [NSArray arrayWithObjects:
    _btn5,
    _btn6,
    _btn7,
    _btn8,
    _btn9,
    _btn10,
    _btn11,
    _btn12,
    _btn13,
    _btn14,
    _btn15,
    _btn16,
    _btn17,
    _btn18,
    _btn19,
    _btn20,
    _btn60,
    _btn100,
                       nil];
    
    [self setMakeValueUI];
    
    /*
     * Starting level
     */
    _levelArray = [NSArray arrayWithObjects:
    _lvl0,
    _lvl1,
    _lvl2,
    _lvl3,
    _lvl4,
    _lvl5,
                   nil];

    
    NSNumber* level = [defaults objectForKey:PREF_START_LEVEL];
    _level = [level intValue];
    [self setStartingLevelUI];
    
    /*
     * Challenge type
     */
     
    _challengeTypeArray = [NSArray arrayWithObjects:
    _btnChallenge0,
    _btnChallenge1,
    _btnChallenge2,
    _btnChallenge3,
                           nil];

    _challengeTypeStringsArray = [NSArray arrayWithObjects:
    @"Speeds up",
    @"Sums 5-10",
    @"Sums 5-20",
    @"Sums 5-100",
                                  nil];

    NSNumber* challenge = [defaults objectForKey:PREF_CHALLENGE_TYPE];
    _challengeType = [challenge intValue];
    [self setChallengeTypeUI];
    
    /*
     * Tile style
     */
    _styleArray = [NSArray arrayWithObjects:
    _style0,
    _style1,
                   nil];

    _styleStringsArray = [NSArray arrayWithObjects:
    @"Numbers",
    @"Dots 1-10",
                          nil];
    
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
    for (NSUInteger  i = 0, len = [_makeValueArray count]; i < len; i++) {
        CCButton* btn = [_makeValueArray objectAtIndex:i];
        [btn setSelected:([btn.name intValue] == _makeValue)];
    }
    [_makeValueBtn setTitle:[NSString stringWithFormat:@"Make %d", _makeValue]];

}

-(void) setStartingLevelUI {
    for (NSUInteger i = 0, len = [_levelArray count]; i < len; i++) {
        CCButton* btn = [_levelArray objectAtIndex:i];
        [btn setSelected:([btn.name intValue] == _level)];
    }

    [_levelBtn setTitle:[NSString stringWithFormat:@"Level %d", _level]];

}

-(void) setChallengeTypeUI {
    for (NSUInteger  i = 0, len = [_challengeTypeArray count]; i < len; i++) {
        CCButton* btn = [_challengeTypeArray objectAtIndex:i];
        [btn setSelected:([btn.name intValue] == _challengeType)];
    }
    
    [_challengeTypeBtn setTitle:[_challengeTypeStringsArray objectAtIndex:_challengeType]];
    
}

-(void) setStyleUI {
    for (NSUInteger  i = 0, len = [_styleArray count]; i < len; i++) {
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
    if ([_topScoresLayer visible] || [_makeValueLayer visible] || [_challengeTypeLayer visible] ||
        [_startingLevelLayer visible] || [_styleLayer visible]) {
        //do not do swipe if a layer is visible
        return;
    }
    

    [[OALSimpleAudio sharedInstance] playEffect:@"currentToWall.m4a"];
    [self homeAction];
}

-(void) swipeLeft {
    if ([_topScoresLayer visible] || [_makeValueLayer visible] || [_challengeTypeLayer visible] ||
        [_startingLevelLayer visible] || [_styleLayer visible]) {
        //do not do swipe if a layer is visible
        return;
    }
    
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
    [_topScoresLayer setVisible:NO];
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

-(NSNumberFormatter*) getNumberFormatter {
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:[[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    return formatter;
}

-(void) topScoresPressed {
    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    
    NSNumberFormatter* formatter = [self getNumberFormatter];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSNumber* highScore = [defaults objectForKey:PREF_HIGH_SCORE];
    NSNumber* highScore2 = [defaults objectForKey:PREF_HIGH_SCORE2];
    NSNumber* highScore3 = [defaults objectForKey:PREF_HIGH_SCORE3];
    _hi = [highScore intValue];
    _hi2 = [highScore2 intValue];
    _hi3 = [highScore3 intValue];
    [_hiScoreLbl setString:[formatter stringFromNumber:highScore]];
    [_hi2ScoreLbl setString:[formatter stringFromNumber:highScore2]];
    [_hi3ScoreLbl setString:[formatter stringFromNumber:highScore3]];
    
    [_btnUndo setVisible:NO];
    [_topScoresLayer setVisible:YES];
    
}

-(void) saveClearTopScoresPressed {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:_hi] forKey:PREF_HIGH_SCORE];
    [defaults setObject:[NSNumber numberWithInt:_hi2] forKey:PREF_HIGH_SCORE2];
    [defaults setObject:[NSNumber numberWithInt:_hi3] forKey:PREF_HIGH_SCORE3];
    
    [self settingsPressed];
}

-(void) undoPressed {
    /*
     * Behave as though viewing this layer for the first time
     */
    [self topScoresPressed];
}

-(void) clearPressed {
    [[OALSimpleAudio sharedInstance] playEffect:@"click.m4a"];
    NSNumberFormatter* formatter = [self getNumberFormatter];
    [_hiScoreLbl setString:[formatter stringFromNumber:[NSNumber numberWithInt:_hi]]];
    [_hi2ScoreLbl setString:[formatter stringFromNumber:[NSNumber numberWithInt:_hi2]]];
    [_hi3ScoreLbl setString:[formatter stringFromNumber:[NSNumber numberWithInt:_hi3]]];

    [_btnUndo setVisible:YES];
}
-(void) clearAllPressed {
    _hi = 0;
    _hi2 = 0;
    _hi3 = 0;
    
    [self clearPressed];
}

-(void) clear1Pressed {
    _hi = _hi2;
    _hi2 = _hi3;
    _hi3 = 0;
    
    [self clearPressed];
}

-(void) clear2Pressed {
    _hi2 = _hi3;
    _hi3 = 0;
    
    [self clearPressed];
}

-(void) clear3Pressed {
    _hi3 = 0;
    
    [self clearPressed];
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
