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
-(NSArray *)getTrees{
    NSMutableArray *trees = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"TreeObject"];
    [query whereKeyExists:@"id"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            for (int i = 0; i < results.count; i++) {
                PFObject *treeObject = results[i];
                NSDictionary *tree = [NSDictionary dictionaryWithObjectsAndKeys:
                                     treeObject[@"objectId"], @"id",
                                     treeObject[@"userid"], @"userid",
                                     treeObject[@"baumname"], @"baumname",
                                     treeObject[@"beschreibung"], @"beschreibung",
                                     treeObject[@"tag"], @"tag",
                                     treeObject[@"bild"], @"bild",
                                     nil];
                [trees addObject:tree];
            }
        }
    }];
    return (NSArray*)trees;
};


-(NSArray *)getUserTrees:(NSString*)userid{
    //getAlltress filter for userid
    NSArray *trees = [self getTrees];
    NSString *userSelector = [@"userid = " stringByAppendingString:userid];
    NSPredicate *filter = [NSPredicate predicateWithFormat:userSelector];
    return [trees filteredArrayUsingPredicate:filter];
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






@end
