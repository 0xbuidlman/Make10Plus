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


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Make10Util.h"

@interface IntroLayer : CCLayer {
    UISwipeGestureRecognizer* _swipeLeftRecognizer;
}
@property (retain) UISwipeGestureRecognizer* swipeLeftRecognizer;
/**
 * returns a CCScene that contains the IntroLayer as the only child
 */
+(CCScene *) scene;

@end
