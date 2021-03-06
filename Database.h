//
//  Database.h
//  StadtgartenApp
//
//  Created by admin on 11.06.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <Parse/Parse.h>
#import "SGTree.h"
#import "SGUser.h"


typedef void (^PFNumberResultBlock)(NSNumber* number, NSError *error);
typedef void (^PFTreeResultBlock)(SGTree* tree, NSError *error);

@interface Database : PFQuery


-(void)updateTree: (NSString*)treeid baumname:(NSString*)baumname beschreibung:(NSString*)beschreibung;

-(void)writeTree:(NSString*)userid baumname:(NSString*)baumname tag:(NSString*)tag beschreibung:(NSString*)beschreibung bild:(UIImage*)bild latitude:(double)latitude longitude:(double)longitude callback:(void(^)())callback;
-(void)bookmarkTree:(NSString *)treeid user:(NSString *)userid callback:(void(^)(BOOL succeeded, NSError *error))callback;

-(void)getTrees:(PFArrayResultBlock)callback;
-(void)getUserTrees:(NSString*)userid callback:(PFArrayResultBlock)callback;
-(void)getUserFavourites:(NSString*)userid with:(PFArrayResultBlock)callback;
-(void)getTreeInfo:(NSString*)treeid callback:(PFTreeResultBlock)callback;

-(void)getRaterCount:(NSString*)treeid callback:(PFIntegerResultBlock)callback;
-(void)rateTree:(NSString*)userid treeid:(NSString*)treeid rating:(NSNumber*)rating;
-(void)getUserRating:(NSString*)userid treeid:(NSString*)treeid callback:(PFIntegerResultBlock)callback;

-(void)getDistance:(NSString*)treeid location:(CLLocation*)location callback:(PFNumberResultBlock)callback;


@end
