//
//  Created by Brian Romanko on 12/1/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface BBStackAPICallData : NSObject

@property (nonatomic, assign) NSUInteger quotaRemaining;
@property (nonatomic, assign) NSUInteger quotaMax;
@property (nonatomic, assign) bool hasMore;

@property (nonatomic, assign) NSUInteger total;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSUInteger pageSize;
@property(nonatomic, copy) NSString *type;

- (id)initWithQuotaRemaining:(NSUInteger)quotaRemaining quotaMax:(NSUInteger)quotaMax hasMore:(bool)hasMore;

@end