//
//  Torch.h
//  NavigationLights
//
//  Created by wins Сергей on 09.06.12.
//  Copyright (c) 2012 LocalizeItMobile.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Color;

@interface Torch : NSManagedObject

@property (nonatomic, retain) NSNumber * coord_x;
@property (nonatomic, retain) NSNumber * coord_y;
@property (nonatomic, retain) NSNumber * coord_z;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSManagedObject *boat;
@property (nonatomic, retain) Color *color;

@end
