//
//  Boat.h
//  NavigationLights
//
//  Created by wins Сергей on 09.06.12.
//  Copyright (c) 2012 LocalizeItMobile.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Torch;

@interface Boat : NSManagedObject

@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * length;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSSet *torches;
@end

@interface Boat (CoreDataGeneratedAccessors)

- (void)addTorchesObject:(Torch *)value;
- (void)removeTorchesObject:(Torch *)value;
- (void)addTorches:(NSSet *)values;
- (void)removeTorches:(NSSet *)values;
@end
