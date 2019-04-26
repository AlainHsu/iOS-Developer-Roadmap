//
//  ViewController.m
//  TableVIew_Reuse
//
//  Created by Alain Hsu on 2019/4/23.
//  Copyright © 2019 alain.hsu. All rights reserved.
//

#import "ViewController.h"
#import "IndexedTableVIew.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,IndexedTableViewDataSource> {
    IndexedTableVIew *tableView;
    UIButton *button;
    NSMutableArray *dataSource;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableView = [[IndexedTableVIew alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.indexedDataSource = self;
    [self.view addSubview:tableView];

    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"reloadTable" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //dataSource
    dataSource = [NSMutableArray new];
    for (int i = 0; i < 100; i++) {
        [dataSource addObject:@(i+1)];
    }
    
    // Do any additional setup after loading the view.
}

#pragma mark IndexedTableViewDataSource

- (NSArray<NSString *> *)indexTitlesForIndexTableView:(UITableView *)tableview {
    static BOOL change = NO;
    
    if (change) {
        change = !change;
        return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K"];
    }else {
        change = !change;
        return @[@"A",@"B",@"C",@"D",@"E",@"F"];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"reuseId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [[dataSource objectAtIndex:indexPath.row] stringValue];
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)doAction:(UIButton *)sender {
    NSLog(@"reloadData");
    [tableView reloadData];
}

@end
