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


#import "GameOverScene.h"
#import "Make10Constants.h"
#import "OALSimpleAudio.h"

/** UISwipeGestureRecognizers that need to be removed onExit */
UISwipeGestureRecognizer* _swipeLeft;

@implementation GameOverScene

#pragma mark load and enter

-(void) didLoadFromCCB {
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:[[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSNumber* scoreNumber = [defaults objectForKey:PREF_SCORE];
    NSNumber* highScore = [defaults objectForKey:PREF_HIGH_SCORE];
    NSNumber* highScore2 = [defaults objectForKey:PREF_HIGH_SCORE2];
    NSNumber* highScore3 = [defaults objectForKey:PREF_HIGH_SCORE3];
    int hi = [highScore intValue];
    int hi2 = [highScore2 intValue];
    int hi3 = [highScore3 intValue];

    if (!scoreNumber) {
        [_scoreLbl setVisible:NO];
        [_highScoreLbl setVisible:NO];
        [_topScoresLbl setVisible:NO];
        [_topScoresOnlyLbl setVisible:YES];
        [self setTopScoresLabel:_topScoresOnlyLbl highScore:hi highScore2:hi2 highScore3:hi3 formatter:formatter];
    } else {
        [_scoreLbl setVisible:YES];
        [_highScoreLbl setVisible:YES];
        [_topScoresLbl setVisible:YES];
        [_topScoresOnlyLbl setVisible:NO];
        int score = [[defaults objectForKey:PREF_SCORE] intValue];
        
        [_scoreLbl setString:[NSString stringWithFormat:@"Your score:\n%@", [formatter stringFromNumber:[NSNumber numberWithInt:score]]]];

        //clear the score in case just going back to view leaderboard
        [defaults removeObjectForKey:PREF_SCORE];
        
        /*
         * Figure out if it is on the leaderboard
         */
        if (score == hi) {
            
            [_highScoreLbl setString:@"Congratulations!\nThe top score!"];
            //if it's = don't do anything, no need to push other scores down or kids might feel bad
            
        } else if (score > hi) {
            
            [_highScoreLbl setString:@"Congratulations!\nThe top score!"];
            
            [defaults setInteger:score forKey:PREF_HIGH_SCORE];
            
            //push 2 into 3
            [defaults setInteger:hi2 forKey:PREF_HIGH_SCORE3];
            
            //then 1 into 2
            [defaults setInteger:hi forKey:PREF_HIGH_SCORE2];
            
            hi3 = hi2;
            hi2 = hi;
            hi = score;
            
        } else if (score == [highScore2 intValue]) {
            
            [_highScoreLbl setString:@"Congratulations!\nA top score!"];
            //if it's = don't do anything, no need to push other scores down or kids might feel bad

        } else if (score > [highScore2 intValue]) {
            
            [_highScoreLbl setString:@"Congratulations!\nA top score!"];

            //push 2 into 3
            [defaults setInteger:hi2 forKey:PREF_HIGH_SCORE3];
            //push new into 2
            [defaults setInteger:score forKey:PREF_HIGH_SCORE2];
            
            hi3 = hi2;
            hi2 = score;

        } else if (score >= [highScore3 intValue]) {
            
            [_highScoreLbl setString:@"Congratulations!\nA top score!"];
            [defaults setInteger:score forKey:PREF_HIGH_SCORE3];
            
            hi3 = score;
            
        } else {
            [_highScoreLbl setString:@"Great job!\nNice score!"];
        }
        
        [self setTopScoresLabel:_topScoresLbl highScore:hi highScore2:hi2 highScore3:hi3 formatter:formatter];

    }
    
    

}

-(void)setTopScoresLabel:(CCLabelTTF*)label highScore:(int)highScore highScore2:(int)highScore2 highScore3:(int)highScore3 formatter:(NSNumberFormatter*)formatter {

    /*
     * Top scores
     */
    [label setString:[NSString stringWithFormat:@"Top scores:\n%@\n%@\n%@",
        [formatter stringFromNumber:[NSNumber numberWithInt:highScore]],
            [formatter stringFromNumber:[NSNumber numberWithInt:highScore2]],
                [formatter stringFromNumber:[NSNumber numberWithInt:highScore3]]]];

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
}

-(void) swipeLeft {
    
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
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:SCENE_TRANS_TIME]];
    
}

#pragma public methods



#pragma mark exit
-(void) onExitTransitionDidStart {
    
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeLeft];
    [super onExitTransitionDidStart];
}
@end
