//
//  TorchesProjectionImage.h
//  NavigationLights
//
//  Created by wins Сергей on 09.06.12.
//  Copyright (c) 2012 LocalizeItMobile.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Boat.h"

@interface TorchesProjectionImage : UIView{
    NSArray *_torches;
    CGContextRef ctx;
}

@property(strong,nonatomic) Boat *boat;//лодка
@property(assign,nonatomic) float angle;//угол поворота, нулевой - когда нос вправо

- (id)initWithFrame:(CGRect)frame andBoat:(Boat*)aBoat;

@end
