//
//  UIListController.m
//  UseUITabBar
//
//  Created by Ibokan on 15/10/22.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import "SearchTableController.h"

#define DEFAULTKEY []
#define FILTEREDKEYS []

@implementation SearchTableController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareDate];
    [self initTableView];
    [self initReturnBtn];
    [self initSearchDC];
    [self initSearchBar];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)prepareDate
{
    _areaList = [AreaSearcher new];
    _tableSource = [_areaList allArea];
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70 + 44, 375, 667 - (30 + 44)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)initReturnBtn
{
    _returnBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 375, 50)];
    _returnBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_returnBtn setTitle:@"return" forState:UIControlStateNormal];
    [_returnBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_returnBtn addTarget:self action:@selector(dismissPage) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_returnBtn];
}

- (void)dismissPage
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initSearchBar
{
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 70, 375, 44)];
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.keyboardType = UIKeyboardTypeAlphabet;
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
}

-(void)initSearchDC
{
    _searchDC = [[UISearchController alloc]initWithSearchResultsController:self];
    _searchDC.delegate  = self;
    _searchDC.searchResultsUpdater = self;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setText:@""];
    NSLog(@"search cancel");
}

#pragma mark search

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString* searchKeyWord =  searchController.searchBar.text;
    NSLog(@"%@",searchKeyWord);
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        _tableSource = [_areaList allArea];
    }else {
        _tableSource = [_areaList areaWithSearchKey:searchText];
    }
    [self.tableView reloadData];
}



#pragma mark table

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableSource count];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString* cellId = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    Area* area = [_tableSource objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",area.district,area.city];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Area* selectedArea = [_tableSource objectAtIndex:[indexPath row]];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate addArea:selectedArea.district];
    }];
}


@end
