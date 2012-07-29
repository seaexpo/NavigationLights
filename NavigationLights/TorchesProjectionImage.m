//
//  TorchesProjectionImage.m
//  NavigationLights
//
//  Created by wins Сергей on 09.06.12.
//  Copyright (c) 2012 LocalizeItMobile.com. All rights reserved.
//

static inline float radians(double degrees) { return degrees * M_PI / 180; }

#import "TorchesProjectionImage.h"
#import "Torch.h"
#import "Color.h"

@implementation TorchesProjectionImage
@synthesize boat=_boat,angle=_angle;

#define TAG_PREFIX 5555
#define scaleFactor  1.8  //2 max, 1 min

#define background_color_red    0.0 / 255.0
#define background_color_green  50.0 / 255.0
#define background_color_blue   126.0 / 255.0
#define background_color_alfa   1.00

- (id)initWithFrame:(CGRect)frame andBoat:(Boat*)aBoat{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClearsContextBeforeDrawing:YES];
        _boat = aBoat;
        _torches = [[NSArray arrayWithArray: [[aBoat torches] allObjects]] retain];
        //инициализация геометрических констант
        for (Torch *torch in _torches) {
            [torch setRadius:sqrtf(powf([[torch coord_x] floatValue], 2)+powf([[torch coord_y] floatValue], 2))];
            [torch setBetta:acosf([[torch coord_x] floatValue]/[torch radius])*//косинус-четная функция
             (([[torch coord_y] floatValue]<0)?(-1):1)];
            [torch setColor4draw:[UIColor colorWithRed:[[[torch color] red]     floatValue]
                                                 green:[[[torch color] green]   floatValue]
                                                  blue:[[[torch color] blue]    floatValue]
                                                 alpha:0.8]];
            
            
            CGFloat colors[] =
            {
                [[[torch color] red]     floatValue],
                [[[torch color] green]   floatValue],
                [[[torch color] blue]    floatValue],
                1.00,//цвет фонаря
                background_color_red,
                background_color_green,
                background_color_blue,
                background_color_alfa,//цвет фона
            };//массив перехода цветов
            
            [torch setGradient: CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(),
                                                                    colors,
                                                                    nil, 
                                                                    sizeof(colors)/(sizeof(colors[0])*3))];
            
            
                                  
        }
    }
    return self;
}

//в этом методе непосредственно идет отрисовка всех картинок
//http://www.edumobile.org/iphone/ipad-development/draw-circle-triangle-and-rectangle-in-iphone/ - хороший пример
- (void)drawRect:(CGRect)rect
{
    ctx = UIGraphicsGetCurrentContext();
    CGRect parentViewBounds = self.bounds;
    CGFloat x = CGRectGetWidth(parentViewBounds)/2;
    CGFloat y = CGRectGetHeight(parentViewBounds)/2;
    CGFloat boatLength = 1/(([[_boat length] floatValue]==0)?
                            1://при незаполненной длине - чтобы не вылетало
                            [[_boat length] floatValue]);//нормировка на длину

    //    Нормируем на длину, потому как у тестовой модели все по отношению к длине, это ошибка.
    //    CGFloat boatHeight = 1/(([[_boat height] floatValue]==0)?
    //                            1:[[_boat height] floatValue]);//нормировка на высоту
    
    
    // Получим и очистим контекст рисования
    CGContextClearRect(ctx, [self frame]);
    
    //Нарисуем ватерлинию
    CGContextSetLineWidth(ctx, 5 );
    CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 0.5);
    CGContextMoveToPoint(ctx, 0, y);
    CGContextAddLineToPoint(ctx, 2*x, y);
    CGContextStrokePath(ctx);
    
    //Нарисуем на ватерлинии кружки фонарей
    CGFloat coord_x = 0;
    CGFloat coord_y = 0;
    CGFloat visAngle = -_angle/M_PI*180;
    
    NSLog(@"%f",visAngle);
    for (Torch *torch in _torches) {
        
        if ([[torch visAngleMin] floatValue]<=visAngle && [[torch visAngleMax] floatValue]>=visAngle) 
        {
            
//градиент из пнимера
//            CGFloat colors[] =
//            {
//                204.0 / 255.0, 224.0 / 255.0, 244.0 / 255.0, 1.00,
//                0.0 / 255.0,  50.0 / 255.0, 126.0 / 255.0, 1.00,
//            };
//            CGGradientRef gradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(),
//                                                                         colors,
//                                                                         nil, 
//                                                                         sizeof(colors)/(sizeof(colors[0])*4));
//            
//            CGContextDrawRadialGradient(ctx, 
//                                        gradient, 
//                                        CGPointMake(50, 50),
//                                        20, 
//                                        CGPointMake(70, 70),
//                                        50, 
//                                        kCGGradientDrawsBeforeStartLocation);
//
//            
//            
//            
//            
//            
            coord_x = cosf([torch betta]+_angle);// пользуемся четной функцией, поэтому инверсии угла поворота не замечаем
            coord_x = coord_x*[torch radius];
            coord_x = coord_x*boatLength;
            coord_x = x*(1 + scaleFactor*coord_x);
            
            coord_y = y*(1 - scaleFactor*[[torch coord_z] floatValue]*boatLength);
            CGContextSetRGBStrokeColor(ctx, 
                                       [[[torch color] red]     floatValue],
                                       [[[torch color] green]   floatValue],
                                       [[[torch color] blue]    floatValue],
                                       0.8);
            CGContextAddArc(ctx, coord_x, coord_y, 5, radians(0), radians(360), true);
            
            CGContextStrokePath(ctx);
        }
    }
}

-(void)setAngle:(float)anAngle{
    _angle = anAngle;
    [self setNeedsDisplay];
}
@end
