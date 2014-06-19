//
//  Database.h
//  StadtgartenApp
//
//  Created by admin on 11.06.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <Parse/Parse.h>

@interface Database : PFQuery

-(void)writeTree:(NSString*)userid baumname:(NSString*)baumname tag:(NSString*)tag beschreibung:(NSString*)beschreibung bild:(UIImage*)bild;
-(NSArray *)getTrees;
-(NSArray *)getUserTrees:(NSString*)userid;
-(float)getTreeRating:(NSString*)treeid;
-(void)rateTree:(NSString*)userid treeid:(NSString*)treeid rating:(float)rating;

@end
