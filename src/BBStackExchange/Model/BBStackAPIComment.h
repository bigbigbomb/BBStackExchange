//
//  Created by Brian Romanko on 1/31/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BBStackAPIModelBase.h"

@class BBStackAPIUser;

typedef enum {
    BBStackAPICommentPostTypeQuestion,
    BBStackAPICommentPostTypeAnswer
} BBStackAPICommentPostType;


@interface BBStackAPIComment  : BBStackAPIModelBase

@property(nonatomic, readonly, copy)NSString *body;

@property(nonatomic, readonly, assign)NSInteger score;

@property(nonatomic, readonly) NSDate *creationDate;

@property(nonatomic, readonly) BBStackAPIUser *owner;

@property (nonatomic, readonly) BBStackAPICommentPostType postType;

@end