//
//  DataSingleton.m
//  NavigationLights
//
//  Created by wins Сергей on 08.06.12.
//  Copyright (c) 2012 LocalizeItMobile.com. All rights reserved.
//

#import "DataSingleton.h"

//импортируем сюда все классы сущьностей
#import "Color.h"
#import "Torch.h"
#import "Boat.h"

#define DOCUMENTS_DIR	[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
// сюда только контент, генерируемый пользователем и необходимые данные

#define CACHE_DIR       [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
//помойка, можно класть все, что заблагорассудится

#define SQLiteName      @"NavigationLights.sqlite"
#define ModelName       @"NavigationLights"

@implementation DataSingleton
@synthesize 
persistentStoreCoordinator=_persistentStoreCoordinator,
managedObjectModel=_managedObjectModel,
managedObjectContext=_managedObjectContext;

static DataSingleton *sharedSingleton = nil;

+ (DataSingleton *)sharedSingleton{//всегда возвращаем единственный экземпляр класса
    
    static dispatch_once_t pred;
	static DataSingleton *shared = nil;
    
	dispatch_once(&pred, ^{ shared = [[self alloc] init]; });
	return shared;
    return sharedSingleton;
}

-(id)init{
    
    if ((self = [super init]) != nil) {
		//если базы нет на месте - скопируем ее туда, применяется при наличии предзаполненой базы
        // если же нет - то вызываем заполнение данными из кода
        if (![[NSFileManager defaultManager] isReadableFileAtPath:
             [DOCUMENTS_DIR stringByAppendingPathComponent: SQLiteName]]) {
            [self copyDatabase];
        }
	}
	return self;}



#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel*)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:ModelName ofType:@"momd"];//для автоматического перехода между версиями модели данных
    NSURL *momURL = [NSURL fileURLWithPath:path];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];  
    
    return _managedObjectModel;
    
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator*)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [DOCUMENTS_DIR stringByAppendingPathComponent: SQLiteName]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. 
         You should not use this function in a shipping application, although it may be useful during development. 
         If it is not possible to recover from the error, display an alert panel that instructs the user to quit 
         the application by pressing the Home button.
         
         
         Typical reasons for an error here include:
         * The persistent store is not accessible
         * The schema for the persistent store is incompatible with current managed object model
         Check the error message to determine what the actual problem was.
         */
        DBLOG(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
    
}

#pragma mark -
#pragma mark Core Data entity

-(void)saveAllChanges{
    
    NSError *error;
    if (![_managedObjectContext save:&error]) {
        DBLOG(@"Data | Error |%@",error);
        // This is a serious error saying the record could not be saved.
        // Advise the user to restart the application
    }else{
        //DBLOG(@"Data | save all");
    }
}

-(void)saveAll{
    [self performSelectorOnMainThread:@selector(saveAllChanges)
                           withObject:nil
                        waitUntilDone:YES];
}

-(NSMutableArray*)fetchAllItemsForEntity:(NSString*)nameOfEntity andApplySortDescriptor:(NSString*)sortDescriptionName withAscending:(BOOL)doAscending{
    
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:nameOfEntity inManagedObjectContext:[self managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    if (![sortDescriptionName isEqualToString:@""]) {
        
        // Define how we will sort the records
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortDescriptionName ascending:doAscending];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
        [request setSortDescriptors:sortDescriptors];
        [sortDescriptor release];
    }
    // Fetch the records and handle an error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    if (!mutableFetchResults) {
        // Handle the error.
        // This is a serious error and should advise the user to restart the application
    }
    
    return mutableFetchResults;
    
    
}

#pragma mark -
#pragma mark File manager methods

- (void)copyDatabase {
    
	BOOL success;
	NSError *error;
	 
	NSString *writableDBPath = [DOCUMENTS_DIR stringByAppendingPathComponent:SQLiteName];
    //куда копировать
    
	
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:SQLiteName];
    //откуда копировать - файл лежит в дереве проекта и заполнен нужными нам данными
    
	success = [[NSFileManager defaultManager] copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success) {
		DBLOG(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
	
}

#pragma mark - Test data

- (void)addTestData{
    
    //заполним 3 цвета
    
    Color *redColor = (Color*)[NSEntityDescription
                               insertNewObjectForEntityForName:@"Color" //имя класса и имя сущьности одинаковы
                               inManagedObjectContext:[self managedObjectContext]];//через обращение к GETTER методу, который мы подменяем - получаем работающий контекст с базой и координатором, соответствующий нашей текущей конфигурации модели данных
    [redColor setName:@"Красный"];
    [redColor setRed:   [NSNumber numberWithFloat:1.0]];//приходится оборачивать скалярные типы в объекты
    [redColor setGreen: [NSNumber numberWithFloat:0.0]];// 0/255-нет цвета,  255/255=1.0 - полный цвет
    [redColor setBlue:  [NSNumber numberWithFloat:0.0]];
    
    Color *greenColor = (Color*)[NSEntityDescription insertNewObjectForEntityForName:@"Color" inManagedObjectContext:[self managedObjectContext]];
    [greenColor setName:@"Зеленый"];
    [greenColor setRed:   [NSNumber numberWithFloat:0.0]];
    [greenColor setGreen: [NSNumber numberWithFloat:1.0]];
    [greenColor setBlue:  [NSNumber numberWithFloat:0.0]];
    
    Color *whiteColor = (Color*)[NSEntityDescription insertNewObjectForEntityForName:@"Color" inManagedObjectContext:[self managedObjectContext]];
    [whiteColor setName:@"Белый"];
    [whiteColor setRed:   [NSNumber numberWithFloat:1.0]];
    [whiteColor setGreen: [NSNumber numberWithFloat:1.0]];
    [whiteColor setBlue:  [NSNumber numberWithFloat:1.0]];
    
    //!!! Важно так же связывать обратными ссылками объекты цветов и фонарей
    
    
    
    //добавим минный тральщик
    {//http://ptdockyardat.files.wordpress.com/2009/08/ra-1-to-8.jpg
        Boat *minesweeper = (Boat*)[NSEntityDescription insertNewObjectForEntityForName:@"Boat" inManagedObjectContext:[self managedObjectContext]];
        
        [minesweeper setImageName:@"minesweeper"];//имя файла - картинки вида сверху, без разширения
        [minesweeper setName:@"Минный тральщик"];
        //далее идут размеры, размеры будут пронормированны на длину корабля, так что можно указывать хоть реальные размеры. Я указал cоответствующие размеры в пикселях.
        [minesweeper setWidth:  [NSNumber numberWithFloat:112.0]];//ширина судна, ориентиры огней +/- от центра 
        [minesweeper setHeight: [NSNumber numberWithFloat:235.0]];//высота над ватерлинией, все огни дан ватерлинией
        [minesweeper setLength: [NSNumber numberWithFloat:725.0]];//длина судна, ориентиры огней +/- от центра
        
        
        //фонари
        //1
        Torch *torch = (Torch*)[NSEntityDescription insertNewObjectForEntityForName:@"Torch" inManagedObjectContext:[self managedObjectContext]];
        [torch setName:@"Передний левый красный"];
        
        [torch setColor:redColor];
        [redColor addTorchesObject:torch];//указываем обратную ссылку, один цвет используется во многих фонарях
        
        [torch setCoord_x:    [NSNumber numberWithFloat: 263.0]];
        [torch setCoord_y:    [NSNumber numberWithFloat: -50.0]];
        [torch setCoord_z:    [NSNumber numberWithFloat:  40.0]];
        
        [torch setVisAngleMin:[NSNumber numberWithFloat: -150]];
        [torch setVisAngleMax:[NSNumber numberWithFloat: -70]];
        
        [minesweeper addTorchesObject:torch];
        [torch setBoat:minesweeper];
        //2
        torch = (Torch*)[NSEntityDescription insertNewObjectForEntityForName:@"Torch" inManagedObjectContext:[self managedObjectContext]];
        [torch setName:@"Передний правый зеленый"];
        
        [torch setColor:greenColor];
        [greenColor addTorchesObject:torch];
        
        [torch setCoord_x:    [NSNumber numberWithFloat: 263.0]];
        [torch setCoord_y:    [NSNumber numberWithFloat:  50.0]];
        [torch setCoord_z:    [NSNumber numberWithFloat:  40.0]];
        
        [torch setVisAngleMin:[NSNumber numberWithFloat:-100]];
        [torch setVisAngleMax:[NSNumber numberWithFloat: -30]];
        
        [minesweeper addTorchesObject:torch];
        [torch setBoat:minesweeper];
        //3
        torch = (Torch*)[NSEntityDescription insertNewObjectForEntityForName:@"Torch" inManagedObjectContext:[self managedObjectContext]];
        [torch setName:@"Задний центральный белый"];
        
        [torch setColor:whiteColor];
        [whiteColor addTorchesObject:torch];
        
        [torch setCoord_x:    [NSNumber numberWithFloat:-360.0]];
        [torch setCoord_y:    [NSNumber numberWithFloat:0.0]];
        [torch setCoord_z:    [NSNumber numberWithFloat:40.0]];
        
        [torch setVisAngleMin:[NSNumber numberWithFloat:  10]];
        [torch setVisAngleMax:[NSNumber numberWithFloat: 170]];
        
        [minesweeper addTorchesObject:torch];
        [torch setBoat:minesweeper];
        
        //4
        torch = (Torch*)[NSEntityDescription insertNewObjectForEntityForName:@"Torch" inManagedObjectContext:[self managedObjectContext]];
        [torch setName:@"Передний центральный белый"];
        
        [torch setColor:whiteColor];
        [whiteColor addTorchesObject:torch];
        
        [torch setCoord_x:    [NSNumber numberWithFloat:-200.0]];
        [torch setCoord_y:    [NSNumber numberWithFloat:   0.0]];
        [torch setCoord_z:    [NSNumber numberWithFloat: 130.0]];
        
        [torch setVisAngleMin:[NSNumber numberWithFloat:-180]];
        [torch setVisAngleMax:[NSNumber numberWithFloat:  20]];
        
        [minesweeper addTorchesObject:torch];
        [torch setBoat:minesweeper];
        
        //4.5
        torch = (Torch*)[NSEntityDescription insertNewObjectForEntityForName:@"Torch" inManagedObjectContext:[self managedObjectContext]];
        [torch setName:@"Передний центральный белый 2"];
        
        [torch setColor:whiteColor];
        [whiteColor addTorchesObject:torch];
        
        [torch setCoord_x:    [NSNumber numberWithFloat:-200.0]];
        [torch setCoord_y:    [NSNumber numberWithFloat:   0.0]];
        [torch setCoord_z:    [NSNumber numberWithFloat: 130.0]];
        
        [torch setVisAngleMin:[NSNumber numberWithFloat: 160]];
        [torch setVisAngleMax:[NSNumber numberWithFloat: 180]];
        
        [minesweeper addTorchesObject:torch];
        [torch setBoat:minesweeper];
        
        //5
        torch = (Torch*)[NSEntityDescription insertNewObjectForEntityForName:@"Torch" inManagedObjectContext:[self managedObjectContext]];
        [torch setName:@"Центральный зеленый центр"];
        
        [torch setColor:greenColor];
        [greenColor addTorchesObject:torch];
        
        [torch setCoord_x:    [NSNumber numberWithFloat:   1.0]];
        [torch setCoord_y:    [NSNumber numberWithFloat:   0.0]];
        [torch setCoord_z:    [NSNumber numberWithFloat: 270.0]];
        
        [torch setVisAngleMin:[NSNumber numberWithFloat: -180]];
        [torch setVisAngleMax:[NSNumber numberWithFloat:  180]];
        
        [minesweeper addTorchesObject:torch];
        [torch setBoat:minesweeper];
        
        //6
        torch = (Torch*)[NSEntityDescription insertNewObjectForEntityForName:@"Torch" inManagedObjectContext:[self managedObjectContext]];
        [torch setName:@"Центральный зеленый левый"];
        
        [torch setColor:greenColor];
        [greenColor addTorchesObject:torch];
        
        [torch setCoord_x:    [NSNumber numberWithFloat:   0.0]];
        [torch setCoord_y:    [NSNumber numberWithFloat:  80.0]];
        [torch setCoord_z:    [NSNumber numberWithFloat: 160.0]];
        
        [torch setVisAngleMin:[NSNumber numberWithFloat:-180]];
        [torch setVisAngleMax:[NSNumber numberWithFloat: 180]];
        
        [minesweeper addTorchesObject:torch];
        [torch setBoat:minesweeper];
        
        //7
        torch = (Torch*)[NSEntityDescription insertNewObjectForEntityForName:@"Torch" inManagedObjectContext:[self managedObjectContext]];
        [torch setName:@"Центральный зеленый правый"];
        
        [torch setColor:greenColor];
        [greenColor addTorchesObject:torch];
        
        [torch setCoord_x:    [NSNumber numberWithFloat:   0.0]];
        [torch setCoord_y:    [NSNumber numberWithFloat: -80.0]];
        [torch setCoord_z:    [NSNumber numberWithFloat: 160.0]];
        
        [torch setVisAngleMin:[NSNumber numberWithFloat:-180]];
        [torch setVisAngleMax:[NSNumber numberWithFloat: 180]];
        
        [minesweeper addTorchesObject:torch];
        [torch setBoat:minesweeper];
        
    }
    
    [self saveAll];
}


@end