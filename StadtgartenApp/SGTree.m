//
//  SGBaum.m
//  StadtgartenApp
//
//  Created by Dennis Schaaf on 6/17/14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import "SGTree.h"

@implementation SGTree

-(id)init {
    if ( self = [super init] ) {
        self.userId = @"";
        self.name = @"";
        self.description = @"";
        self.tag = @"";
        self.picture = @"";
        self.latitude = 0;
        self.longitude = 0;
    }
    return self;
};

-(id)initWithUser:(NSString *)userId name:(NSString*)name description:(NSString*)description tag:(NSString*)tag picture:(NSString*)picture rating:(NSNumber *)rating latitude:(float)latitude longitude:(float)longitude {
    
    if ( self = [super init] ) {
        self.userId = userId;
        self.name = name;
        self.description = description;
        self.tag = tag;
        self.picture = picture;
        self.latitude = latitude;
        self.longitude = longitude;
        self.rating = rating;
    }
    return self;
};


@end
