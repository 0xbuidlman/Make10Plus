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

/* 320 x 480 is the bg size in points */

#ifndef Make10Plus_Make10Constants_h
#define Make10Plus_Make10Constants_h


#endif

/**
 * Default make value
 */
static int const MAKE_VALUE_DEFAULT = 10;

/**
 * Tiles needed to remove advance to next level
 * (MAX_COLS x MAX_ROWS)
 */
static int const LEVEL_MARKER = 56;

/**
 * The duration for scenes to change
 */
static float const SCENE_TRANS_TIME = 0.5f;

/**
 * The duration for Get Ready layer to show
 */
static float const GET_READY_TRANS_TIME = 3.5f;

/**
 * The duration for a sprite button enlarge and shrink back
 */
static float const SPRITE_SCALE_TIME = 0.1f;

/**
 * The duration between wall risings for new level of 0 (early beginner)
 */
static float const BEGINNER_WALL_SPEED = 40;
/**
 * The duration between wall risings for level 1
 */
static float const SLOWEST_WALL_SPEED = 20;

/**
 * The wall will never be faster than this speed no matter the level
 */
static float const FASTEST_WALL_SPEED = 4;

/**
 * The delay before showing the game over scene
 */
static float const GAME_OVER_DELAY = 1.5;
/**
 * Preference for the make value
 */
static NSString* const PREF_MAKE_VALUE = @"MAKE_VALUE";

/**
 * Preference for the starting level
 */
static NSString* const PREF_START_LEVEL = @"START_LEVEL";

/**
 * Preference for the operation
 */
static NSString* const PREF_OPERATION = @"OPERATION";

/**
 * Preference for the operation addition
 */
static int const PREF_OPERATION_ADDITION = 0;

/**
 * Preference for the operation multiplication
 */
static int const PREF_OPERATION_MULTIPLICATION = 1;

/**
 * Preference for the challenge type
 */
static NSString* const PREF_CHALLENGE_TYPE = @"CHALLENGE_TYPE";

/**
 * Preference for the challenge type of increasing speed
 */
static int const PREF_CHALLENGE_TYPE_SPEED = 0;

/**
 * Preference for the challenge type of changing sums any
 */
static int const PREF_CHALLENGE_TYPE_CHANGING = 3;

/**
 * Preference for the challenge type of changing sums easy
 * (5 - 10)
 */
static int const PREF_CHALLENGE_TYPE_CHANGING_EASY = 1;

/**
 * Preference for the challenge type of changing sums medium
 * (5 - 20)
 */
static int const PREF_CHALLENGE_TYPE_CHANGING_MEDIUM = 2;

/**
 * Preference for tile style
 */
static NSString* const PREF_TILE_STYLE = @"TILE_STYLE";

/**
 * Preference for tile style of numbers
 */
static int const PREF_TILE_STYLE_NUMBERS = 0;

/**
 * Preference for tile style of mahjong dots
 */
static int const PREF_TILE_STYLE_DOTS = 1;

/**
 * Preference for the local high score
 */
static NSString* const PREF_HIGH_SCORE = @"HIGH_SCORE";

/**
 * Preference for the local 2nd high score
 */
static NSString* const PREF_HIGH_SCORE2 = @"HIGH_SCORE2";

/**
 * Preference for the local 3rd high score
 */
static NSString* const PREF_HIGH_SCORE3 = @"HIGH_SCORE2";

/**
 * Preference for the local my score
 */
static NSString* const PREF_SCORE = @"SCORE";

/**
 * Tag for label on an image button
 */
static int const TAG_LABEL = 1;

/**
 * Tag for Make10AppLayer
 */
static int const TAG_MAKE10_APP_LAYER = 5;

/**
 * The duration for the next tile to become the current
 */
static float const NEXT_TO_CURRENT_TRANS_TIME = 0.25f;

/**
 * The duration for the current tile to knock a wall tile or become a part of the wall
 */
static float const CURRENT_TO_WALL_TRANS_TIME = 0.35f;

/**
 * Action tag for current to wall transition knock tile
 */
static int const ACTION_TAG_KNOCK = 1;

/**
 * Action tag for current to wall transition add tile to wall
 */
static int const ACTION_TAG_ADD_TO_WALL = 2;

/*************/
static int const TILE_FONT_SIZE = 28;
