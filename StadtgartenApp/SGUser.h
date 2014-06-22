//
//  SGUser.h
//  StadtgartenApp
//
//  Created by Dennis Schaaf on 6/20/14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGUser : NSObject

@property(readwrite) NSString* fbId;
@property(nonatomic, readwrite) NSMutableArray* favouriteTrees;

-(id)initFromDict:(NSDictionary *)dict;
-(id)initWithFbId:(NSString *)fbId;


@end
