//
//  Created by Brian Romanko on 12/1/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBStackAPIModelBase.h"

@implementation BBStackAPIModelBase

@synthesize attributes = _attributes;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.attributes = attributes;

    return self;
}

+ (NSString *)attributeContainerKey {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

+ (NSMutableArray *)getObjectArrayFromAttributes:(NSDictionary *)attributes {
    return [self getObjectArrayFromAttributes:attributes containerKey:[self attributeContainerKey]];
}

+ (NSMutableArray *)getObjectArrayFromAttributes:(NSDictionary *)attributes containerKey:(NSString *)containerKey {
    NSArray *objAttributesArray = [attributes valueForKeyPath:containerKey];
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:objAttributesArray.count];
    for (NSDictionary *objAttributes in objAttributesArray) {
        id obj = [(BBStackAPIModelBase *)[self alloc] initWithAttributes:objAttributes];
        [objects addObject:obj];
        [obj release];
    }
    return objects;
}

- (void)dealloc {
    [_attributes release];
    [super dealloc];
}

- (NSDate *)dateForKey:(NSString *)key {
    return [NSDate dateWithTimeIntervalSince1970:[[self.attributes objectForKey:key] doubleValue]];
}

@end