//
//  SGBaum.h
//  StadtgartenApp
//
//  Created by Dennis Schaaf on 6/17/14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGTree : NSObject

@property(readwrite) NSString* id;
@property(readwrite) NSString* name;
@property(readwrite) NSString* userId;
@property(readwrite) NSString* description;
@property(readwrite) NSString* tag;
@property(readwrite) NSString* picture;

@property(readwrite) float latitude;
@property(readwrite) float longitude;
@property(readwrite) NSNumber *rating;

-(id)initWithUser:(NSString *)userId name:(NSString*)name description:(NSString*)description tag:(NSString*)tag picture:(NSString*)picture rating:(NSNumber *)rating latitude:(float)latitude longitude:(float)longitude ;

@end
