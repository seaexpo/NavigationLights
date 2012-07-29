//
//  Torch.m
//  NavigationLights
//
//  Created by wins Сергей on 09.06.12.
//  Copyright (c) 2012 LocalizeItMobile.com. All rights reserved.
//

#import "Torch.h"
#import "Color.h"


@implementation Torch

@dynamic coord_x;
@dynamic coord_y;
@dynamic coord_z;
@dynamic name;
@dynamic boat;
@dynamic color;
//устанавливаем геттер и сеттер методы
@synthesize radius=_radius;
@synthesize betta=_betta;
@synthesize color4draw;
@synthesize gradient;

//углы видимости
@dynamic visAngleMin;
@dynamic visAngleMax;

@end
