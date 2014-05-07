//
//  SGAppDelegate.h
//  StadtgartenApp
//
//  Created by Dennis Schaaf and team on 07/05/14.
//  Copyright (c) 2014 StadtGarten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
