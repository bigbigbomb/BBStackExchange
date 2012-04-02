//
//  Created by Brian Romanko on 12/4/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BBStackExchangeModel.h"

@class BBStackAPIUser;

@interface BBStackAPIQuestion : BBStackExchangeModel

@property(nonatomic, readonly) NSInteger questionID;

@property(nonatomic, readonly) NSDate *creationDate;

@property(nonatomic, readonly) NSString *title;

@property(nonatomic, readonly) NSArray *tags;

@property(nonatomic, readonly) BBStackAPIUser *owner;

@property(nonatomic, readonly) NSString *body;

@property(nonatomic, readonly) NSArray *answers;

@property(nonatomic, readonly) NSArray *comments;

@property(nonatomic, readonly) NSURL *URL;

@property(nonatomic, readonly) bool isAnswered;

@property(nonatomic, readonly) NSInteger answerCount;

@property(nonatomic, readonly) NSInteger score;

@property(nonatomic, readonly) bool hasAcceptedAnswer;

@end