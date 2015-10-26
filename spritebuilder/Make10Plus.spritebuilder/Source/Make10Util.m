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

#import "Make10Util.h"

@implementation Make10Util


+(NSArray*) getMakeValuesArray {
    NSArray* makeValues = nil;
    if (makeValues == nil) {
        /*
         * 5 - 20
         */
        NSMutableArray* makeValuesArray = [[NSMutableArray alloc] init];

        for (int i = 5; i <= 20; i++) {
            [makeValuesArray addObject:[NSNumber numberWithInt:i]];
        }
        /*
         * 60
         */
        [makeValuesArray addObject:[NSNumber numberWithInt:60]];
        /*
         * 100
         */
        [makeValuesArray addObject:[NSNumber numberWithInt:100]];
        makeValues = [NSArray arrayWithArray:makeValuesArray];
        
        
    }
    return makeValues;
}


+(int) genRandomMakeValue:(int)currentMakeValue challengeType:(int)challengeType {
    NSArray* makeValuesArray = [self getMakeValuesArray];
    int randomIndex = arc4random() % [makeValuesArray count];
    int newMakeValue = [[makeValuesArray objectAtIndex:randomIndex] intValue];
    if (newMakeValue == currentMakeValue) {
        return [self genRandomMakeValue:currentMakeValue challengeType:challengeType];
    } else if (PREF_CHALLENGE_TYPE_CHANGING_MEDIUM == challengeType && newMakeValue > 20) {
        return [self genRandomMakeValue:currentMakeValue challengeType:challengeType];
    } else if (PREF_CHALLENGE_TYPE_CHANGING_EASY == challengeType && newMakeValue > 10) {
        return [self genRandomMakeValue:currentMakeValue challengeType:challengeType];
    }

    return newMakeValue;
}
@end
