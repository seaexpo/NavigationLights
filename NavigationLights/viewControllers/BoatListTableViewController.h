//
//  BoatListTableViewController.h
//  NavigationLights
//
//  Created by wins Сергей on 01.08.12.
//  Copyright (c) 2012 LocalizeItMobile.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoatListTableViewController : UITableViewController{
    
    //заведем массив для хранения объектов - кораблей. Массив не изменяется во времени
    NSArray *_dataSource;
}

@end
