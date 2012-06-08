//
//  MAinMenuViewController.m
//  NavigationLights
//
//  Created by wins Сергей on 08.06.12.
//  Copyright (c) 2012 LocalizeItMobile.com. All rights reserved.
//

#import "MAinMenuViewController.h"

@interface MAinMenuViewController ()

@end

@implementation MAinMenuViewController

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

#pragma mark - User interaction

-(IBAction)startLearning:(id)sender{
    
}

-(IBAction)doTest:(id)sender{
    
}

-(IBAction)aboutUS:(id)sender{
    
}


@end
