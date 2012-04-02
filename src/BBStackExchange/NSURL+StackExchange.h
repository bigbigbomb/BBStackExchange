//
//  Created by Brian Romanko on 2/14/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

@class BBStackAPISite;

@interface NSURL (StackExchange)

- (BOOL)isStackExchangeQuestionURL;

- (BOOL)isStackExchangeAnswerURL;


- (NSString *)getStackExchangeQuestionID;

- (NSString *)getStackExchangeAnswerID;


- (BBStackAPISite *)getStackExchangeSite;


@end