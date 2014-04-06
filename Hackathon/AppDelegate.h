//
//  AppDelegate.h
//  Hackathon
//
//  Created by sushil kundu on 4/5/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (assign,nonatomic) BOOL isLoggedIn;
@property (strong,nonatomic) IIViewDeckController *viewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
