//
//  AppDelegate.h
//  TestThuatToan
//
//  Created by NguyenKimTai on 5/9/16.
//  Copyright © 2016 NguyenKimTai. All rights reserved.
//

#define ShareDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *quotations;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

