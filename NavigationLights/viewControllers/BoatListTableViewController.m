//
//  BoatListTableViewController.m
//  NavigationLights
//
//  Created by wins Сергей on 01.08.12.
//  Copyright (c) 2012 LocalizeItMobile.com. All rights reserved.
//

#import "BoatListTableViewController.h"
#import "RotatingBoatViewController.h"
#import "Boat.h"

@interface BoatListTableViewController ()

@end

@implementation BoatListTableViewController

-(void)dealloc{
    
    [_dataSource release];
    [super dealloc];
}

- (id)init{
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        // Заполним корабли
        _dataSource = [[NSArray alloc] initWithArray:[[DataSingleton sharedSingleton] fetchAllItemsForEntity:@"Boat"
                                                                                      andApplySortDescriptor:@""
                                                                                               withAscending:YES]];
        // С данной переменной управление памятью идет исключительно в ручном режиме - поэтому -(void)dealloc{ [_dataSource release];...
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma mark - Table view data source

//определим метод для получения корабля по индексу
// здесь очень важно соблюсти MVC паттерн, это избавляет от кучи головной боли впоследствии
- (Boat*)getBoatAtIndexPath:(NSIndexPath *)indexPath{
    return [_dataSource objectAtIndex:[indexPath row]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Количество секций - например в секции можно поместить гражданские/военные/парусные
    // Если делать общим списком - то возвращаем (смотрим в инициализацию контроллера)
    // 1 для UITableViewStyleGrouped
    // 0 для UITableViewStylePlain
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Для каждой секции можно вернуть количество строк - например 5 военных/3 парусных
    // Для сплошного списка будем просто возвращать количество в источнике данных;
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //пробуем получить ячейку из таблицы
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //если она ==null то создадим ее
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault   //простого типа
                                      reuseIdentifier:CellIdentifier];              //задаем идентификатор для последующих обращений
        //назначим выделение - серым
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
    }
    
    // тут созданные или полученные ячейки заполняем данными. Не стоит путать создание и заполнение - это негативно отражается на управлении памятью/стабильности/скорости приложения.
    
    Boat *boat = [self getBoatAtIndexPath:indexPath];//без секций
    
    [[cell textLabel] setText:[boat name]];
    //textLabel - мы не создавали, это есть по умолчанию
    //можно так же заполнить картинку (но она очень мелкая), лучше сконфигурировать свою ячейку
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //снимем выделение
    [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];//это метод самой таблицы
    Boat *boat = [self getBoatAtIndexPath:indexPath];
    
    RotatingBoatViewController *rotBoatVC = [[RotatingBoatViewController alloc] init];
    [rotBoatVC setBoat:boat];
    [[rotBoatVC navigationItem] setTitle:[boat name]];
    
    [[self navigationController] pushViewController:rotBoatVC
                                           animated:YES];
    [rotBoatVC release];
        
}

@end
