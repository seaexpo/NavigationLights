//
//  RotatingBoatViewController.h
//  NavigationLights
//
//  Created by wins Сергей on 08.06.12.
//  Copyright (c) 2012 LocalizeItMobile.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RotatingBoatViewController : UIViewController

@property(strong,nonatomic) IBOutlet UIImageView *rotateImage;

-(IBAction)longPress:(id)sender;

@end
