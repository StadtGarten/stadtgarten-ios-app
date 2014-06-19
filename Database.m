//
//  Database.m
//  StadtgartenApp
//
//  Created by admin on 11.06.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import "Database.h"

@implementation Database

//-(NSArray *)getUserFavourites(String*)userId{};
//-(NSArray *)getAllUsers;

//gibt alle Bäume zurück
-(void)getTrees:(PFArrayResultBlock)callback {
    PFQuery *query = [PFQuery queryWithClassName:@"TreeObject"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        NSMutableArray *trees = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < results.count; i++) {
            PFObject *treeObject = results[i];
            
            SGTree *tree = [[SGTree alloc] initWithUser: treeObject[@"userid"] name:treeObject[@"baumname"] description: treeObject[@"beschreibung"] tag:treeObject[@"tag"] picture:treeObject[@"bild"] rating:treeObject[@"rating"] latitude:0 longitude:0];
            
            [trees addObject:tree];
        }
        
        NSArray *result = (NSArray *)trees;
        
        callback(result, NULL);

    }];
};


-(void)getUserTrees:(NSString*)userid with:(PFArrayResultBlock)callback {
    //getAlltress filter for userid
    
    
    [self getTrees:^(NSArray *trees, NSError *error) {
        NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            SGTree *tree = evaluatedObject;
            BOOL equal = [tree.userId isEqualToString:userid];
            NSLog(@"Tree %@ %@ %@", userid, tree.userId, equal? @"YES" : @"NO");
            return equal;
        }];
        NSArray *filteredTrees = [trees filteredArrayUsingPredicate:filter];
        callback(filteredTrees, error);
    }];
    
};


-(void)writeTree:(NSString*)userid baumname:(NSString*)baumname tag:(NSString*)tag beschreibung:(NSString*)beschreibung bild:(UIImageView*)bild{

    PFObject *treeObject = [PFObject objectWithClassName:@"TreeObject"];
    treeObject[@"userid"] = userid;
    treeObject[@"baumname"] = baumname;
    treeObject[@"tag"] = tag;
    //treeObject[@"location"] = @"Ort";
    treeObject[@"beschreibung"] = beschreibung;
    NSData *imageData = UIImagePNGRepresentation(bild.image);
    treeObject[@"bild"] = [PFFile fileWithData:imageData];
    treeObject[@"rating"] = @0.0;
    //TODO location
    //treeObject[@"location"] = longLat;

    [treeObject saveInBackground];

    /* AUFRUF: -database.h einbinden nicht vergessen! Bild einfügen
     
     UIImage *temp = [UIImage imageNamed:@"Assets/tree.jpg"];
     Database * db=[[Database alloc]init];
     [db writeTree:@"user" baumname:@"Apfelbaum1" tag:@"Apfel" beschreibung:@"Baum - toll" bild:temp];
     //[self.view addSubview:_navigationBar];
     */

    
};
-(NSNumber*)getTreeRating:(NSString*)treeid{
    __block NSNumber* rating;
    PFQuery *query = [PFQuery queryWithClassName:@"TreeObject"];
    [query whereKey:@"objectId" equalTo:treeid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            PFObject* tree = [results firstObject];
            rating = tree[@"rating"];
        }
    }];
    return rating;
};


-(void)rateTree:(NSString*)userid treeid:(NSString*)treeid rating:(NSNumber*)rating{
    __block NSNumber* currentRating = [self getTreeRating:treeid];
    __block NSNumber* raterCount;
    PFQuery *query = [PFQuery queryWithClassName:@"Rating"];
    [query whereKey:@"treeid" equalTo:treeid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            raterCount = [NSNumber numberWithFloat:[results count]];
            float temp = ([raterCount floatValue] * [currentRating floatValue])+[rating floatValue];
            currentRating = @(temp/([raterCount floatValue]+1.0));
            
            //save userrating
            PFObject *newUserRating = [PFObject objectWithClassName:@"Rating"];
            newUserRating[@"userid"] = userid;
            newUserRating[@"treeid"] = treeid;
            newUserRating[@"rating"] = rating;
            [newUserRating saveInBackground];
        }
    }];
    
    //save treerating
    PFQuery *treeQuery = [PFQuery queryWithClassName:@"TreeObject"];
    [treeQuery whereKey:@"objectId" equalTo:treeid];
    [treeQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else{
            PFObject* tree = [results firstObject];
            tree[@"rating"] = currentRating;
            [tree saveInBackground];
        }
    }];
};

-(int)getRaterCount:(NSString*)treeid{
    __block int raterCount;
    PFQuery *query = [PFQuery queryWithClassName:@"Rating"];
    [query whereKey:@"treeId" equalTo:treeid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            raterCount = [[NSNumber numberWithFloat:[results count]] intValue];
        }
    }];
    return raterCount;
};





@end
