//
//  StatisticsViewController.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/17/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "StatisticsViewController.h"
#import "HealthManager.h"
#import "StatisticsTableViewCell.h"
#import "DetalleViewController.h"

@interface StatisticsViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray* healthDays;
@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    // Do any additional setup after loading the view.
}

- (UIRectEdge)edgesForExtendedLayout
{
    return [super edgesForExtendedLayout] ^ UIRectEdgeBottom;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];


    self.healthDays =  [[HealthManager sharedInstance].retrieveAllDayItems sortedArrayUsingComparator:^NSComparisonResult(HealthDayDTO* a, HealthDayDTO* b) {
        
        CGFloat timeA = a.date.timeIntervalSince1970;
        CGFloat timeB = b.date.timeIntervalSince1970;
        return timeA<timeB;
    }];
    
    
    [self setUpScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUpScrollView {

    self.scrollView.backgroundColor = [UIColor darkGrayColor];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*3, self.scrollView.bounds.size.height-44-5);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;

    for (int x = 0; x < 3; x++){
        [self addTableToScrollViewAtIndex:x];
    }
    
}

- (void) addTableToScrollViewAtIndex: (NSInteger) index {

    CGRect frame = CGRectMake(self.scrollView.frame.size.width*index, 0, self.scrollView.frame.size.width, self.scrollView.contentSize.height);
    
    UITableView* v = [[UITableView alloc] initWithFrame:frame];
    v.tag = index;
    v.rowHeight = 140;
    v.delegate = self;
    v.dataSource = self;
    v.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:v];
    
}
- (IBAction)valueChanged:(id)sender {
    CGRect frame = CGRectMake(self.scrollView.frame.size.width*self.segmentedControl.selectedSegmentIndex, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y==0) {
        return;
    }
    
    for (UIView* v in self.scrollView.subviews) {
    
        if ([v isKindOfClass:[UITableView class]]) {
            UITableView* tableview = (UITableView*) v;
            if (tableview != scrollView) {
                tableview.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
            }
        }
        
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.segmentedControl.selectedSegmentIndex = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.healthDays count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatisticsTableViewCell *cell = [StatisticsTableViewCell new];
    cell.type = tableView.tag;
    [cell configureWithHealthDay:self.healthDays [indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"detail" sender:indexPath];
    });
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath*)indexPath {
    
    if ([segue.identifier isEqualToString:@"detail"]) {
        DetalleViewController* nextVC = (DetalleViewController*) segue.destinationViewController;
        nextVC.healthDay = self.healthDays [indexPath.row];
    }
}

@end
