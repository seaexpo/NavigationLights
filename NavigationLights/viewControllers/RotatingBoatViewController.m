//
//  RotatingBoatViewController.m
//  NavigationLights
//
//  Created by wins Сергей on 08.06.12.
//  Copyright (c) 2012 LocalizeItMobile.com. All rights reserved.
//

#import "RotatingBoatViewController.h"

@interface RotatingBoatViewController ()

@end

@implementation RotatingBoatViewController

@synthesize rotateImage=_rotateImage,
boat=_boat,
projection=_projection;

-(void)dealloc{
    [_boat release];
    [_rotateImage release];
    [super dealloc];
}

//Переопределяем метод инициализации, чтобы просто инициализировать и не помнить кучу параметров
- (id)init{
    
    self = [super initWithNibName:@"RotatingBoatViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (UIGestureRecognizer *rec in [[self view] gestureRecognizers]) //переберем все
        if ([rec class]==[UILongPressGestureRecognizer class]) //найдем нужного нам типа, он будет один
            [(UILongPressGestureRecognizer*)rec setMinimumPressDuration:0.1];//установим минимальную продолжительность нажатия
    
    _projection = [[TorchesProjectionImage alloc] initWithFrame:CGRectMake(80, 
                                                                           20, 
                                                                           160, 
                                                                           160)
                                                        andBoat:_boat];
    [[self view] addSubview:_projection];
    [_projection setNeedsDisplay];
    
    [angleLabel setText:@"0"];
    
    
    
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

- (void)rotateImage:(UIImageView *)image withAngle:(float)newAngle{ 
    image.transform = CGAffineTransformMakeRotation(newAngle);
    [_projection setAngle:newAngle];
    [angleLabel setText:[NSString stringWithFormat: @"%.2f",//выводим только угол с одним знаком после запятой
                         -newAngle/M_PI*180]];//приведем угол в удобный вид
    
    
}

//-(float)degreesToRotateObjectWithPosition:(CGPoint)objPos andTouchPoint:(CGPoint)touchPoint{
//    
//    float dX = touchPoint.x-objPos.x;        // distance along X
//    float dY = touchPoint.y-objPos.y;        // distance along Y
//    float radians = atan2(dY, dX);          // tan = opp / adj
//    
//    //Now we have to convert radians to degrees:
//    float degrees = radians*M_PI/360;
//    
//    return degrees;
//}

-(IBAction)longPress:(id)sender{
    
//    CGAffineTransform current = _rotateImage.transform;
//    
//    [_rotateImage setTransform:CGAffineTransformRotate(current,[self degreesToRotateObjectWithPosition:_rotateImage.center andTouchPoint:[sender locationInView:self.view]])];

    
    CGPoint touch = [sender locationInView:self.view];
    CGPoint center = _rotateImage.center; 
    float dx,dy,wtf;
    dx = touch.x-center.x;
    dy = touch.y-center.y;
    wtf = atan2f(dy, dx);
    
    [self rotateImage:_rotateImage withAngle:wtf];
}

@end
