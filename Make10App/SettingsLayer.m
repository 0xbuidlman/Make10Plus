/*******************************************************************************
 *
 * Copyright 2013 Bess Siegal
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

#import "SettingsLayer.h"
#import "IntroLayer.h"
#import "Make10AppLayer.h"
#import <UIKit/UIKit.h>
#import "SimpleAudioEngine.h"

@implementation SettingsLayer
@synthesize swipeRightRecognizer = _swipeRightRecognizer;
@synthesize swipeLeftRecognizer = _swipeLeftRecognizer;

UIPickerView*      _makeValuePicker;
NSMutableArray*    _makeValueArray;
CCMenuItemSprite*   _makeValueToggle;
CCMenuItemToggle*  _levelToggle;
//CCMenuItemToggle*  _operationToggle;
CCMenuItemToggle*  _challengeToggle;
CCMenuItemToggle*  _styleToggle;
CCSprite*          _home;

+(CCScene*) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SettingsLayer *layer = [SettingsLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init {
    
	if (self = [super init]) {
        CCSprite* background = [Make10Util genLayerBackgroundWithName:@"girlBg"];
        [self addChild:background];
        
        CCSprite* score = [Make10Util createWhiteBoxSprite];
        [self addChild:score];

        // ask director for the window size
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF* text = [CCLabelTTF labelWithString:NSLocalizedString(@"Settings", nil) fontName:@"American Typewriter" fontSize:[Make10Util getTitleFontSize]];
        text.color = ccc3(0, 0, 0);
        text.position = ccp(winSize.width / 2, winSize.height - [Make10Util getMarginTop] - [Make10Util getUpperLabelPadding] - [Make10Util getScoreLabelHeight] / 2);
        // add the label as a child to this Layer
        [self addChild:text];
        
        _home = [Make10Util createHomeSprite];
        [self addChild:_home];

        /*
         * UIView to which UIKit components can be added
         */
        UIView* view = [[CCDirector sharedDirector] view];
        view.frame = CGRectMake(0, 0, winSize.width, winSize.height);
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        /*
         * makeValue as a UIPickerView
         */
        NSNumber* makeValue = [defaults objectForKey:PREF_MAKE_VALUE]; //default set in IntroLayer

        //This will be the row to select
        int makeValueRow = 0;

        //This will be an NSString array copy of getMakeValuesArray (which contains NSNumber)
        NSArray* makeValuesNumbers = [Make10Util getMakeValuesArray];
        _makeValueArray = [[NSMutableArray alloc] initWithCapacity:[makeValuesNumbers count]];

        for (int i = 0, len = [makeValuesNumbers count]; i < len; i++) {
            
            int value = [(NSNumber*) [makeValuesNumbers objectAtIndex:i] intValue];
            [_makeValueArray addObject:[NSString stringWithFormat:@"%d", value]];
            if ([makeValue intValue] == value) {
                makeValueRow = i;
            }
        }
                
        /*
         * Make value as a button that will show the picker view
         */
        NSString* makeString = [NSString stringWithFormat:NSLocalizedString(@"Make %d", nil), [makeValue intValue]];
        _makeValueToggle = [Make10Util createButtonWithText:makeString target:self selector:@selector(makeValueAction)];
        
        /*
         * Starting level as a toggle
         */
        CCMenuItemSprite* level0 = [Make10Util createToggleWithText:NSLocalizedString(@"Level 0", nil)];
        CCMenuItemSprite* level1 = [Make10Util createToggleWithText:NSLocalizedString(@"Level 1", nil)];
        CCMenuItemSprite* level2 = [Make10Util createToggleWithText:NSLocalizedString(@"Level 2", nil)];
        CCMenuItemSprite* level3 = [Make10Util createToggleWithText:NSLocalizedString(@"Level 3", nil)];
        CCMenuItemSprite* level4 = [Make10Util createToggleWithText:NSLocalizedString(@"Level 4", nil)];
        CCMenuItemSprite* level5 = [Make10Util createToggleWithText:NSLocalizedString(@"Level 5", nil)];
        
        _levelToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggled:) items:level0, level1, level2, level3, level4, level5, nil];
        NSNumber* level = [defaults objectForKey:PREF_START_LEVEL];
        [_levelToggle setSelectedIndex:[level intValue]];
        
        /*
         * Operation as a toggle
         */
//        CCMenuItemImage* buttonAdd = [Make10Util createToggleWithText:@"Addition"];
//        CCMenuItemImage* buttonMult = [Make10Util createToggleWithText:@"Multiplication"];
//
//        _operationToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggled:) items:buttonAdd, buttonMult, nil];
//
//        NSNumber* operation = [defaults objectForKey:PREF_OPERATION];
//        [_operationToggle setSelectedIndex:[operation intValue]];
        
        /*
         * Challenge type as a toggle 
         */
        CCMenuItemSprite* buttonSpeed = [Make10Util createToggleWithText:NSLocalizedString(@"Speed increases", nil)];
        CCMenuItemSprite* buttonTotal = [Make10Util createToggleWithText:NSLocalizedString(@"Sum changes", nil)];

        _challengeToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggled:) items:buttonSpeed, buttonTotal, nil];
        
        NSNumber* challenge = [defaults objectForKey:PREF_CHALLENGE_TYPE];
        [_challengeToggle setSelectedIndex:[challenge intValue]];
        
        /*
         * Tile style as a toggle
         */
        CCMenuItemSprite* buttonNumber = [Make10Util createToggleWithText:@"Numbers"];
        CCMenuItemSprite* buttonDots = [Make10Util createToggleWithText:@"Mahjong dots"];
        
        _styleToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggled:) items:buttonNumber, buttonDots, nil];
        
        NSNumber* style = [defaults objectForKey:PREF_TILE_STYLE];
        [_styleToggle setSelectedIndex:[style intValue]];
        
        /*
         * Create the menu
         */
        CCMenu* menu = [CCMenu menuWithItems:
                        _makeValueToggle,
                        _levelToggle,
//                        _operationToggle,
                        _challengeToggle,
                        _styleToggle,
                        nil];
        
        float x = winSize.width / 2 + buttonDots.contentSize.width / 2 - [Make10Util getUpperLabelPadding];
        menu.position = ccp(x, winSize.height * 0.6);
        [menu alignItemsVerticallyWithPadding:[Make10Util getMenuPadding]];
        [self addChild:menu];
        
        int pickerWidth = 100;
        _makeValuePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(x - pickerWidth / 2, [Make10Util getMarginTop] + [Make10Util getUpperLabelPadding] * 2 + score.contentSize.height, pickerWidth, 300)];
        _makeValuePicker.opaque = YES;
        _makeValuePicker.delegate = self;
        _makeValuePicker.showsSelectionIndicator = YES;
        _makeValuePicker.hidden = YES;
        
        [_makeValuePicker selectRow:makeValueRow inComponent:0 animated:NO];
        
        [view addSubview:_makeValuePicker];

        
        self.isTouchEnabled = YES;
        
    }
    return self;
}

-(void) toggled: (id) sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.m4a"];
    
    CCMenuItemToggle* toggle = (CCMenuItemToggle*) sender;
    
    /*
     * Save toggle settings
     */
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if (toggle == _challengeToggle) {
        [defaults setInteger:[_challengeToggle selectedIndex] forKey:PREF_CHALLENGE_TYPE];
    } else if (toggle == _levelToggle) {
        [defaults setInteger:[_levelToggle selectedIndex] forKey:PREF_START_LEVEL];
//    } else if (toggle == _operationToggle) {
//        [defaults setInteger:[_operationToggle selectedIndex] forKey:PREF_OPERATION];
    } else if (toggle == _styleToggle) {
        [defaults setInteger:[_styleToggle selectedIndex] forKey:PREF_TILE_STYLE];
    }

}

-(void) makeValueAction {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.m4a"];
    if (_makeValuePicker.hidden) {
        _makeValuePicker.hidden = NO;
        _makeValueToggle.visible = NO;
        _levelToggle.visible = NO;
        _challengeToggle.visible = NO;
        _styleToggle.visible = NO;
    } else {
        _makeValuePicker.hidden = YES;
        _makeValueToggle.visible = YES;
        _levelToggle.visible = YES;
        _challengeToggle.visible = YES;
        _styleToggle.visible = YES;
    }
}

#pragma mark UIPickerViewDelegate


-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}

-(NSInteger) pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	
	return [_makeValueArray count];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setOpaque:YES];
    label.backgroundColor = [UIColor colorWithRed:177.0f/255.0f green:209.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
//    label.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:183.0f/255.0f blue:5.0f/255.0f alpha:1.0f];
//    label.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:214.0f/255.0f blue:130.0f/255.0f alpha:1.0f];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"American Typewriter" size:36];
    label.text = [_makeValueArray objectAtIndex:row];
    return label;
}

//-(NSString*) pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//	
//	return [_makeValueArray objectAtIndex:row];
//}

-(void) pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    /*
     * Save make value setting
     */
    int makeValue = [[_makeValueArray objectAtIndex:row] intValue];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:makeValue forKey:PREF_MAKE_VALUE];

    NSString* makeString = [NSString stringWithFormat:@"Make %d", makeValue];
    CCLabelTTF* label = (CCLabelTTF*) [_makeValueToggle getChildByTag:TAG_LABEL];
    [label setString:makeString];
    
}

#pragma mark Swipe

-(void) handleRightSwipe:(UISwipeGestureRecognizer *)swipeRecognizer {
    [[SimpleAudioEngine sharedEngine] playEffect:@"currentToWall.m4a"];
    [self homeAction];
}

-(void) handleLeftSwipe:(UISwipeGestureRecognizer *)swipeRecognizer {
    [[SimpleAudioEngine sharedEngine] playEffect:@"currentToWall.m4a"];
    [self playAction];
}

#pragma mark Touches

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([Make10Util isSpriteTouched:_home touches:touches]) {
        [Make10Util touchSpriteBegan:_home];
    }
}

-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    
    _makeValuePicker.hidden = YES;
    _makeValueToggle.visible = YES;
    _makeValueToggle.visible = YES;
    _levelToggle.visible = YES;
    _challengeToggle.visible = YES;
    _styleToggle.visible = YES;
    
    if ([Make10Util isSpriteTouched:_home touches:touches]) {
    
        [Make10Util touchedSprite:_home target:self selector:@selector(homeAction)];
        return;
    }
    
    /*
     * In case moved off
     */
    [Make10Util touchSpriteEnded:_home];

}

-(void) homeAction {
    
    /*
     * write to disk to free up memory
     */
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults synchronize];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:LAYER_TRANS_TIME scene:[IntroLayer scene]]];
    
}

-(void) playAction {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:LAYER_TRANS_TIME scene:[Make10AppLayer scene]]];
    
}

-(void) onEnter {
    [super onEnter];
    self.swipeRightRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)] autorelease];
    _swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeRightRecognizer];

    self.swipeLeftRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)] autorelease];
    _swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeLeftRecognizer];

}

-(void) onExit {
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeRightRecognizer];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeLeftRecognizer];
    [super onExit];
}

-(void) dealloc {
//    NSLog(@"Settings dealloc");

    self.isTouchEnabled = NO;
    
    _makeValuePicker.delegate = nil;
    [_makeValuePicker removeFromSuperview];
    [_makeValuePicker release];
    _makeValuePicker = nil;
    
    [_makeValueArray release];
    _makeValueArray = nil;

    [_home removeFromParentAndCleanup:YES];
    _home = nil;
    
    [_makeValueToggle removeFromParentAndCleanup:YES];
    _makeValueToggle = nil;
    
    [_levelToggle removeFromParentAndCleanup:YES];
    _levelToggle = nil;

//    [_operationToggle removeFromParentAndCleanup:YES];
//    _operationToggle = nil;

    [_challengeToggle removeFromParentAndCleanup:YES];
    _challengeToggle = nil;

    [_styleToggle removeFromParentAndCleanup:YES];
    _styleToggle = nil;
    
    [_swipeRightRecognizer release];
    _swipeRightRecognizer = nil;
    
    [_swipeLeftRecognizer release];
    _swipeLeftRecognizer = nil;
    
    [self removeFromParentAndCleanup:YES];
    
    [super dealloc];
}
@end
