//
//  LearnMenuViewController.m
//  NavigationLights
//
//  Created by wins Сергей on 08.06.12.
//  Copyright (c) 2012 LocalizeItMobile.com. All rights reserved.
//

#import "LearnMenuViewController.h"
#import "BoatListTableViewController.h"

@interface LearnMenuViewController ()

@end

@implementation LearnMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)selectTorches:(id)sender{

    //инициализируем контроллер списка кораблей и помещаем его в стек UINavigationController
    BoatListTableViewController *boatListVC = [[BoatListTableViewController alloc] init];
    
    //Назначим ему надпись. Делать это здесь - нормальная практика, как и в методе init BoatListViewController
    [[boatListVC navigationItem] setTitle:@"List of boats"];
    
    [[self navigationController] pushViewController:boatListVC
                                           animated:YES];
    [boatListVC release];
    
}

@end
