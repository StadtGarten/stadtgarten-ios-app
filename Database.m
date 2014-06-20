//
//  Database.m
//  StadtgartenApp
//
//  Created by admin on 11.06.14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import "Database.h"

@implementation Database

//-(NSArray *)getUserFavourites(String*)userid{};
//-(NSArray *)getAllUsers;

//gibt alle Bäume zurück
-(void)getTrees:(PFArrayResultBlock)callback {
    PFQuery *query = [PFQuery queryWithClassName:@"TreeObject"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        NSMutableArray *trees = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < results.count; i++) {
            PFObject *treeObject = results[i];
            
            PFGeoPoint *gp = treeObject[@"location"];
            double longitude = [gp longitude];
            double latitude = [gp latitude];
            SGTree *tree = [[SGTree alloc] initWithUser: treeObject[@"userid"] name:treeObject[@"baumname"] description: treeObject[@"beschreibung"] tag:treeObject[@"tag"] picture:treeObject[@"bild"] rating:treeObject[@"rating"] latitude:latitude longitude:longitude];
            
            [trees addObject:tree];
        }
        
        NSArray *result = (NSArray *)trees;
        
        callback(result, NULL);

    }];
};
/*  Database * db=[[Database alloc]init];
    [db getTrees:(NSArray* results, NSError* error){
        //results enhält alle SGTrees aus der Datenbank
 }];
 */

-(void)getUserTrees:(NSString*)userid callback:(PFArrayResultBlock)callback {
    //getAlltress filter for userid
    
    
    [self getTrees:^(NSArray *trees, NSError *error) {
        NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            SGTree *tree = evaluatedObject;
            BOOL equal = [tree.userid isEqualToString:userid];
            NSLog(@"Tree %@ %@ %@", userid, tree.userid, equal? @"YES" : @"NO");
            return equal;
        }];
        NSArray *filteredTrees = [trees filteredArrayUsingPredicate:filter];
        callback(filteredTrees, error);
    }];
    
};


-(void)writeTree:(NSString*)userid baumname:(NSString*)baumname tag:(NSString*)tag beschreibung:(NSString*)beschreibung bild:(UIImageView*)bild latitude:(double)latitude longitude:(double)longitude{

    PFObject *treeObject = [PFObject objectWithClassName:@"TreeObject"];
    treeObject[@"userid"] = userid;
    treeObject[@"baumname"] = baumname;
    treeObject[@"tag"] = tag;
    //treeObject[@"location"] = @"Ort";
    treeObject[@"beschreibung"] = beschreibung;
    NSData *imageData = UIImagePNGRepresentation(bild.image);
    treeObject[@"bild"] = [PFFile fileWithData:imageData];
    treeObject[@"rating"] = @0.0;
    treeObject[@"location"] = [PFGeoPoint geoPointWithLatitude:latitude longitude:longitude];

    [treeObject saveInBackground];

    /* AUFRUF: -database.h einbinden nicht vergessen! Bild einfügen
     
     UIImage *temp = [UIImage imageNamed:@"Assets/tree.jpg"];
     Database * db=[[Database alloc]init];
     [db writeTree:@"user" baumname:@"Apfelbaum1" tag:@"Apfel" beschreibung:@"Baum - toll" bild:temp];
     //[self.view addSubview:_navigationBar];
     */

    
};

-(void)getTreeInfo:(NSString*)treeid callback:(PFTreeResultBlock)callback{
    //__block NSString* name;
    PFQuery *query = [PFQuery queryWithClassName:@"TreeObject"];
    [query whereKey:@"objectId" equalTo:treeid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            PFObject* treeObject = [results firstObject];
            PFGeoPoint *gp = treeObject[@"location"];
            double longitude = [gp longitude];
            double latitude = [gp latitude];
            SGTree *tree = [[SGTree alloc] initWithUser: treeObject[@"userid"] name:treeObject[@"baumname"] description: treeObject[@"beschreibung"] tag:treeObject[@"tag"] picture:treeObject[@"bild"] rating:treeObject[@"rating"] latitude:latitude longitude:longitude];
            //name = tree[@"baumname"];
            callback(tree, NULL);
        }
    }];
};


-(void)rateTree:(NSString*)userid treeid:(NSString*)treeid rating:(NSNumber*)rating{
    __block NSNumber* currentRating;
    __block NSNumber* raterCount;
    __block Boolean alreadyRated = false;
    __block PFObject *object;
    [self getTreeInfo:treeid callback:^(SGTree *tree, NSError *error){
        currentRating = tree.rating;
    }];
    PFQuery *query = [PFQuery queryWithClassName:@"Ratings"];

    [query whereKey:@"treeid"
            equalTo:[PFObject objectWithoutDataWithClassName:@"TreeObject" objectId:treeid]];
    //[query whereKey:@"treeid" equalTo:treeid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            int count = [results count];
            for (int i = 0; i < count; i++){
                PFObject* treeobject = results[i];
                //falls der user bereits abgestimmt hat, count reduzieren, damit nicht immer höhere anzahl
                if ([treeobject[@"userid"] isEqualToString: userid])
                    {
                        object = treeobject;
                        alreadyRated = true;
                        count = count - 1;
                        //save userrating
                        object[@"rating"] = rating;
                        [object saveInBackground];
                    }
            }
            raterCount = [NSNumber numberWithInt:count];
            float temp = ([raterCount floatValue] * [currentRating floatValue])+[rating floatValue];
            currentRating = @(temp/([raterCount floatValue]+1.0));
            
            
            //save userrating, if new rating
            
            if (!alreadyRated){
                PFObject *newUserRating = [PFObject objectWithClassName:@"Ratings"];
                PFRelation *relation = [newUserRating relationforKey:@"treeid"];
                [relation addObject:[PFObject objectWithoutDataWithClassName:@"TreeObject" objectId:treeid]];
                newUserRating[@"userid"] = userid;
                newUserRating[@"rating"] = rating;
                [newUserRating saveInBackground];
            }
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

-(void)getRaterCount:(NSString*)treeid callback:(PFIntegerResultBlock)callback{
    PFQuery *query = [PFQuery queryWithClassName:@"Ratings"];
    [query whereKey:@"treeid" equalTo:[PFObject objectWithoutDataWithClassName:@"TreeObject" objectId:treeid]];
    //[query whereKey:@"treeid" equalTo:treeid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            int count = (int)[results count];
            //raterCount = [[NSNumber alloc] initWithFloat:count];
            callback(count, NULL);
        }
    }];
};

-(void)getUserRating:(NSString*)userid treeid:(NSString*)treeid callback:(PFIntegerResultBlock)callback{
    PFQuery *query = [PFQuery queryWithClassName:@"Ratings"];
    [query whereKey:@"treeid" equalTo:[PFObject objectWithoutDataWithClassName:@"TreeObject" objectId:treeid]];
    [query whereKey:@"userid" equalTo:userid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            PFObject *rating = [results firstObject];
            int i = [rating[@"rating"] intValue];
            callback(i, NULL);
        }
    }];

};

-(void)getDistance:(NSString*)treeid location:(CLLocation*)location callback:(PFNumberResultBlock)callback{
    [self getTreeInfo:treeid callback:^(SGTree *tree, NSError *error){
        CLLocation *myLocation = location;
        CLLocation *treeLocation = [[CLLocation alloc] initWithLatitude:tree.latitude longitude:tree.longitude];
        CLLocationDistance distance = [myLocation distanceFromLocation: treeLocation];
        callback([NSNumber numberWithDouble:distance], NULL);
    }];
};


@end
