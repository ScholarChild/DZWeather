//
//  UIListController.h
//  UseUITabBar
//
//  Created by Ibokan on 15/10/22.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageDelegate.h"
#import "AreaSearcher.h"

@interface SearchTableController : UIViewController<UISearchControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate>
{
    AreaSearcher* _areaList;
    UISearchBar* _searchBar;
    UISearchController* _searchDC;
    NSArray* _tableSource;
    UIButton* _returnBtn;
}

@property (nonatomic,retain)id<PageDelegate> delegate;
@property (nonatomic,retain)UITableView* tableView;


@end
