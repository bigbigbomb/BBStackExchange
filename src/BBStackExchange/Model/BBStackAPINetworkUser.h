//
//  Created by Lee Fastenau on 4/3/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BBStackAPIModelBase.h"


@interface BBStackAPINetworkUser : BBStackAPIModelBase

@property (nonatomic, readonly) NSString *siteName;
@property (nonatomic, readonly) NSURL *siteURL;

@end