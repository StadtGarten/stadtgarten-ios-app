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
        self.id = @"";
        self.userid = @"";
        self.name = @"";
        self.description = @"";
        self.tag = @"";
        self.picture = nil;
        self.latitude = 0;
        self.longitude = 0;
    }
    return self;
};

-(id)initWithId:(NSString *)id user:(NSString *)userid name:(NSString*)name description:(NSString*)description tag:(NSString*)tag picture:(UIImage*)picture rating:(NSNumber *)rating latitude:(float)latitude longitude:(float)longitude {
    
    if ( self = [super init] ) {
        self.id = id;
        self.userid = userid;
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
