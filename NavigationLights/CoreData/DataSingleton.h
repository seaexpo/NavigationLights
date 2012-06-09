//
//  DataSingleton.h
//  NavigationLights
//
//  Created by wins Сергей on 08.06.12.
//  Copyright (c) 2012 LocalizeItMobile.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h> //добавили фреймворк для работы с SQLite как с объектом

@interface DataSingleton : NSObject
//используем паттерн программирования синглетон
//http://ru.wikipedia.org/wiki/%D0%9E%D0%B4%D0%B8%D0%BD%D0%BE%D1%87%D0%BA%D0%B0_(%D1%88%D0%B0%D0%B1%D0%BB%D0%BE%D0%BD_%D0%BF%D1%80%D0%BE%D0%B5%D0%BA%D1%82%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F)

@property (nonatomic, strong, readonly) NSManagedObjectModel            *managedObjectModel;  
@property (nonatomic, strong, readonly) NSManagedObjectContext          *managedObjectContext;  
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator    *persistentStoreCoordinator;

+ (DataSingleton *)sharedSingleton;
-(id)init;

-(void)saveAll;
-(NSMutableArray*)fetchAllItemsForEntity:(NSString*)nameOfEntity andApplySortDescriptor:(NSString*)sortDescriptionName withAscending:(BOOL)doAscending;

- (void)addTestData;

@end
