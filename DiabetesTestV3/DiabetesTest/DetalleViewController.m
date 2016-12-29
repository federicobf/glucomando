//
//  DetalleViewController.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/29/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "DetalleViewController.h"
#import "DetalleTableViewCell.h"

@interface DetalleViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DetalleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)close:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.healthDay.healthItems count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 100;
    
}

- (NSArray*) healthItems {

    NSArray* items = [self.healthDay.healthItems sortedArrayUsingComparator:^NSComparisonResult(HealthDTO* a, HealthDTO* b) {
        
        CGFloat timeA = a.date.timeIntervalSince1970;
        CGFloat timeB = b.date.timeIntervalSince1970;
        return timeA>timeB;
    }];
    
    return items;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetalleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
    [cell configureWithHealthDTO:[self healthItems] [indexPath.row]];
    
    return cell;
}

@end
