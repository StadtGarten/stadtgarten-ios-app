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
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        NSMutableArray *trees = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < results.count; i++) {
            PFObject *treeObject = results[i];
            
            PFGeoPoint *gp = treeObject[@"location"];
            double longitude = [gp longitude];
            double latitude = [gp latitude];
            PFFile *imageFile = [treeObject objectForKey:@"bild"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                UIImage *bild = [UIImage imageWithData:data];
                SGTree *tree = [[SGTree alloc] initWithId:treeObject.objectId user:treeObject[@"userid"] name:treeObject[@"baumname"] description: treeObject[@"beschreibung"] tag:treeObject[@"tag"] picture:bild rating:treeObject[@"rating"] latitude:latitude longitude:longitude];
                [trees addObject:tree];
                
                if (i==(results.count-1)){
                    NSArray *result = (NSArray *)trees;
                    callback(result, NULL);
                }
                //NSLog(@"Database: %@", treeObject);
            }];
        }
        
        
        
        NSArray *result = (NSArray *)trees;
        
        callback(result, NULL);
        
    }];
};

-(void)getUser:(NSString *)userid callback:(void(^)(SGUser * user))callback {
    PFQuery *query = [PFQuery queryWithClassName:@"UserClass"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            PFObject *user = evaluatedObject;
            NSString *remoteFbId = user[@"fbId"];
            BOOL equal = [remoteFbId isEqualToString:userid];
            NSLog(@"Finding user %@ is %@: %f", remoteFbId, userid, (float)equal);
            return equal;
        }];
        NSArray *filteredUsers = [results filteredArrayUsingPredicate:filter];
        
        SGUser * user;
        if (filteredUsers.count > 0) {
            user = [[SGUser alloc] initFromDict:filteredUsers[0] ];
        } else {
            // if no user was found, create a new one
            user = [[SGUser alloc] init];
        }
        callback(user);
    }];
};
/*  Database * db=[[Database alloc]init];
    [db getTrees:(NSArray* results, NSError* error){
        //results enhält alle SGTrees aus der Datenbank
 }];
 */

-(void)getUserTrees:(NSString*)userid callback:(PFArrayResultBlock)callback {
    [self getTrees:^(NSArray *trees, NSError *error) {
        NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            SGTree *tree = evaluatedObject;
            BOOL equal = [tree.userid isEqualToString:userid];
            return equal;
        }];
        NSArray *filteredTrees = [trees filteredArrayUsingPredicate:filter];
        callback(filteredTrees, error);
    }];
};

-(void)getUserFavourites:(NSString*)userid with:(PFArrayResultBlock)callback {
    [self getTrees:^(NSArray *trees, NSError *error) {
        [self getUser:userid callback:^void(SGUser *user) {
            NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                
                SGTree *tree = evaluatedObject;
                
                for (int pos = 0; pos < user.favouriteTrees.count; pos++) {
                    NSString *favouriteTreeId = user.favouriteTrees[pos];
                    NSLog(@"Find favourite tree %@ in %@", favouriteTreeId, tree.id);
                    if ([tree.id isEqualToString:favouriteTreeId]) {
                        return true;
                    }
                }
                return false;
            }];
            NSArray *filteredTrees = [trees filteredArrayUsingPredicate:filter];
            callback(filteredTrees, error);
        }];
    }];
}

-(void)writeTree:(NSString*)userid baumname:(NSString*)baumname tag:(NSString*)tag beschreibung:(NSString*)beschreibung bild:(UIImage*)bild latitude:(double)latitude longitude:(double)longitude callback:(void(^)())callback {

    PFObject *treeObject = [PFObject objectWithClassName:@"TreeObject"];
    treeObject[@"userid"] = userid;
    treeObject[@"baumname"] = baumname;
    treeObject[@"tag"] = tag;
    //treeObject[@"location"] = @"Ort";
    treeObject[@"beschreibung"] = beschreibung;
    
    NSData *imageData = UIImagePNGRepresentation(bild);
    PFFile *imageFile = [PFFile fileWithName:@"tree.png" data:imageData];
    [imageFile saveInBackground];
    [treeObject setObject:imageFile forKey:@"bild"];
    
    //treeObject[@"bild"] = [PFFile fileWithData:imageData];
    treeObject[@"rating"] = @0.0;
    treeObject[@"location"] = [PFGeoPoint geoPointWithLatitude:latitude longitude:longitude];

    [treeObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // call callback
        callback();
        

        /*
        // Send a notification to all devices subscribed to the "Trees" channel.
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:@"Trees"];
        
        
        NSString *message = [@"Neuer Baum hochgeladen. Sorte: " stringByAppendingString:treeObject[@"tag"]];
        
        [push setMessage:message];
        [push sendPushInBackground];
         */
        
        // Create our Installation query
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"deviceType" equalTo:@"ios"];
        
        // Send push notification to query
        NSString *message = [@"Neuer Baum hochgeladen. Sorte: " stringByAppendingString:treeObject[@"tag"]];
        [PFPush sendPushMessageToQueryInBackground:pushQuery
                                       withMessage:message];
                
    }];

    /* AUFRUF: -database.h einbinden nicht vergessen!
     
     Database * db=[[Database alloc]init];
     UIImage *bild = [UIImage imageNamed:@"tree.jpg"];
     [db writeTree:@"user" baumname:@"Birnbaum33" tag:@"Birne" beschreibung:@"text" bild:bild latitude:47.2 longitude:11.0];
     //[self.view addSubview:_navigationBar];
     */

    
};

-(void)updateTree: (NSString*)treeid baumname:(NSString*)baumname beschreibung:(NSString*)beschreibung{
    
    //save treerating
    PFQuery *treeQuery = [PFQuery queryWithClassName:@"TreeObject"];
    [treeQuery whereKey:@"objectId" equalTo:treeid];
    [treeQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else{
            NSLog(@"Tree updated!");
            PFObject* tree = [results firstObject];
            tree[@"beschreibung"] = beschreibung;
            tree[@"baumname"] = baumname;
            [tree saveInBackground];
        }
    }];
}

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
            PFFile *imageFile = [treeObject objectForKey:@"bild"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    UIImage *bild = [UIImage imageWithData:data];
                SGTree *tree = [[SGTree alloc]initWithId:treeObject.objectId user:treeObject[@"userid"] name:treeObject[@"baumname"] description: treeObject[@"beschreibung"] tag:treeObject[@"tag"] picture:bild rating:treeObject[@"rating"] latitude:latitude longitude:longitude];
            //name = tree[@"baumname"];
                    callback(tree, NULL);
            }];
        }
    }];
};

-(void)bookmarkTree:(NSString *)treeid user:(NSString *)userid callback:(void(^)(BOOL succeeded, NSError *error))callback {
    PFQuery *query = [PFQuery queryWithClassName:@"UserClass"];
    [query whereKey:@"fbId" equalTo:userid];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        PFObject *userObject;
        if (results.count > 0) {
            userObject = results[0];
            
            NSMutableArray *favouriteTrees = userObject[@"favouriteTrees"];
            int index = -1;
            
            for (int x = 0; x < favouriteTrees.count; x++) {
                if ([favouriteTrees[x] isEqualToString:treeid]) {
                    index = x;
                }
            }
            if (index > -1) {
                [favouriteTrees removeObjectAtIndex:index];
            } else {
                [favouriteTrees addObject:treeid];
            }
        } else {
            userObject = [PFObject objectWithClassName:@"UserClass"];
            userObject[@"fbId"] = userid;
            userObject[@"favouriteTrees"] = [[NSMutableArray alloc] initWithObjects:treeid, nil];
        }

        [userObject saveInBackgroundWithBlock:callback];
        
    }];
}

-(void)rateTree:(NSString*)userid treeid:(NSString*)treeid rating:(NSNumber*)newRating{
    __block NSNumber* currentTreeRating;
    __block NSNumber* newTreeRating;
    __block NSNumber* userRating;
    __block NSNumber* raterCount;
    __block float sum = 0.0;
    __block Boolean alreadyRated = false;
    __block PFObject *object;
    __block int newRater = 0;
    __block int ratingsCount = 0;
    [self getTreeInfo:treeid callback:^(SGTree *tree, NSError *error){
        currentTreeRating = tree.rating;
        //alle ratingsabfragen
        PFQuery *query = [PFQuery queryWithClassName:@"Ratings"];
        [query whereKey:@"treeid"
                equalTo:[PFObject objectWithoutDataWithClassName:@"TreeObject" objectId:treeid]];
        //[query whereKey:@"treeid" equalTo:treeid];
        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            else {
                ratingsCount = (int)[results count];
                newRater = 1;
                sum = ([currentTreeRating floatValue] * ratingsCount) + [newRating floatValue];
                for (int i = 0; i < ratingsCount; i++){
                    PFObject* treeobject = results[i];
                    //falls der user bereits abgestimmt hat, count reduzieren, damit nicht immer höhere anzahl
                    if ([treeobject[@"userid"] isEqualToString: userid])
                    {
                        alreadyRated = true;
                        userRating = treeobject[@"rating"];
                        object = treeobject;
                        newRater = 0;
                        //count = count - 1;
                        //save userrating
                        object[@"rating"] = newRating;
                        [object saveInBackground];
                        sum = ([currentTreeRating floatValue] * ratingsCount) - [userRating floatValue] + [newRating floatValue];
                        break;
                    }
                }
                raterCount = [NSNumber numberWithInt:ratingsCount];
                newTreeRating = @(sum/([raterCount floatValue]+newRater));
                //save userrating, if new rating
                if (!alreadyRated){
                    PFObject *newUserRating = [PFObject objectWithClassName:@"Ratings"];
                    PFRelation *relation = [newUserRating relationforKey:@"treeid"];
                    [relation addObject:[PFObject objectWithoutDataWithClassName:@"TreeObject" objectId:treeid]];
                    newUserRating[@"userid"] = userid;
                    newUserRating[@"rating"] = newRating;
                    [newUserRating saveInBackground];
                }
                
                
                //save treerating
                PFQuery *treeQuery = [PFQuery queryWithClassName:@"TreeObject"];
                [treeQuery whereKey:@"objectId" equalTo:treeid];
                [treeQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
                    if (error) {
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                    else{
                        PFObject* tree = [results firstObject];
                        tree[@"rating"] = newTreeRating;
                        [tree saveInBackground];
                        
                    }
                }];
            }
        }];
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
         NSLog(@"distnace, %f, %f", location.coordinate.latitude, location.coordinate.longitude);
        CLLocation *treeLocation = [[CLLocation alloc] initWithLatitude:tree.latitude longitude:tree.longitude];
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:myLocation.coordinate.latitude longitude:myLocation.coordinate.longitude];
        CLLocationDistance distance = [currentLocation distanceFromLocation: treeLocation];
        NSLog(@"distnace, %f", distance);
        callback([NSNumber numberWithDouble:distance], NULL);
    }];
};




@end
