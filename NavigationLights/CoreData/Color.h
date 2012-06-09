//
//  Color.h
//  NavigationLights
//
//  Created by wins Сергей on 09.06.12.
//  Copyright (c) 2012 LocalizeItMobile.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Torch;

@interface Color : NSManagedObject

@property (nonatomic, retain) NSNumber * blue;
@property (nonatomic, retain) NSNumber * green;
@property (nonatomic, retain) NSNumber * red;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *torches;
@end

@interface Color (CoreDataGeneratedAccessors)

- (void)addTorchesObject:(Torch *)value;
- (void)removeTorchesObject:(Torch *)value;
- (void)addTorches:(NSSet *)values;
- (void)removeTorches:(NSSet *)values;
@end
