//
//  Created by Brian Romanko on 12/1/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BBStackExchangeAPIClient.h"

@interface NSString (Formatting)

+ (NSString *)stringWithbool:(bool)abool;

+ (NSString *)stringWithBBStackAPISortOrder:(BBStackAPISortOrder)sortOrder;

+ (NSString *)stringWithBBStackAPIQuestionSort:(BBStackAPIQuestionSort)sort;

+ (NSString *)stringWithBBStackAPIAnswerSort:(BBStackAPIAnswerSort)sort;

+ (NSString *)stringWithBBStackAPITagSort:(BBStackAPITagSort)sort;


@end