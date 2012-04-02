//
//  Created by Brian Romanko on 12/4/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BBStackAPIModelBase.h"
#import "BBStackExchangeModel.h"

@class BBStackAPIUser;


@interface BBStackAPIAnswer : BBStackExchangeModel {
@private
}

@property(nonatomic, readonly, copy)NSString *answerID;

@property(nonatomic, readonly, copy)NSString *questionID;

@property(nonatomic, readonly, copy)NSString *body;

@property(nonatomic, readonly, assign)NSInteger score;

@property(nonatomic, readonly) NSArray *comments;

@property(nonatomic, readonly) NSDate *creationDate;

@property(nonatomic, readonly) BBStackAPIUser *owner;

@property(nonatomic, readonly) bool accepted;

@end