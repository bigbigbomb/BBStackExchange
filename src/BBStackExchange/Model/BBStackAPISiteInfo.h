//
//  Created by Brian Romanko on 12/3/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BBStackAPIModelBase.h"
#import "BBStackExchangeModel.h"


@interface BBStackAPISiteInfo : BBStackExchangeModel {

}

@property (nonatomic, readonly, assign) NSInteger totalQuestions;
@property (nonatomic, readonly, assign) NSInteger totalUnanswered;
@property (nonatomic, readonly, assign) NSInteger totalAccepted;
@property (nonatomic, readonly, assign) NSInteger totalAnswers;
@property (nonatomic, readonly, assign) NSInteger totalComments;
@property (nonatomic, readonly, assign) NSInteger totalVotes;
@property (nonatomic, readonly, assign) NSInteger totalBadges;
@property (nonatomic, readonly, assign) NSInteger totalUsers;
@property (nonatomic, readonly, assign) CGFloat questionsPerMinute;
@property (nonatomic, readonly, assign) CGFloat answersPerMinute;
@property (nonatomic, readonly, assign) CGFloat badgesPerMinute;

@end