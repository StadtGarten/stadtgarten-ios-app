//
//  Database.h
//  StadtgartenApp
//
//  Created by admin on 11.06.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <Parse/Parse.h>
#import "SGTree.h"

typedef void (^PFNumberResultBlock)(NSNumber* number, NSError *error);

@interface Database : PFQuery

-(void)writeTree:(NSString*)userid baumname:(NSString*)baumname tag:(NSString*)tag beschreibung:(NSString*)beschreibung bild:(UIImage*)bild;
-(void)getTrees:(PFArrayResultBlock)callback;
-(void)getUserTrees:(NSString*)userid callback:(PFArrayResultBlock)callback;

-(void)getTreeRating:(NSString*)treeid callback:(PFNumberResultBlock)callback;
-(void)getRaterCount:(NSString*)treeid callback:(PFNumberResultBlock)callback;
-(void)rateTree:(NSString*)userid treeid:(NSString*)treeid rating:(NSNumber*)rating;

@end
