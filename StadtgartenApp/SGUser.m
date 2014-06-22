//
//  SGUser.m
//  StadtgartenApp
//
//  Created by Dennis Schaaf on 6/20/14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import "SGUser.h"

@implementation SGUser

-(NSMutableArray *)favouriteTrees {
    if (!_favouriteTrees) {
        _favouriteTrees = [[NSMutableArray alloc] init];
    }
    return _favouriteTrees;
}

-(id)initFromDict:(NSDictionary *)dict {
    if (self = [self init]) {
        self.fbId = dict[@"fbid"];
    }
    return self;
}

-(id)initWithFbId:(NSString *)fbId {
    self = [self init];
    if (self) {
        self.fbId = fbId;
    }
    return self;
}

@end
