//
//  Created by Brian Romanko on 12/16/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BBStackAPIModelBase.h"


@interface BBStackAPIUser : BBStackAPIModelBase {

}

@property (nonatomic, readonly) NSInteger userID;

@property (nonatomic, readonly) NSString *displayName;

@end