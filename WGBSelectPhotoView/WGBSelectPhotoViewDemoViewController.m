//
//  WGBSelectPhotoViewDemoViewController.m
//  WGBSelectPhotoView
//
//  Created by mac on 2019/10/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import "WGBSelectPhotoViewDemoViewController.h"
#import "WGBSelectImageAndVideoDemoViewController.h"
#import "WGBSelectImageOrVideoDemoViewController.h"
#import <Masonry.h>

@interface WGBSelectPhotoViewDemoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) NSArray<Class> *classArray;

@end

@implementation WGBSelectPhotoViewDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.classArray = @[
        [WGBSelectImageAndVideoDemoViewController class],
        [WGBSelectImageOrVideoDemoViewController class]
    ];
    self.titles = @[
           @"同时选择照片和视频",
           @"存在多个选择控件的情况",
        ];
    
    [self.tableView reloadData];

}


#pragma mark - tableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

#pragma mark - tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class cls = self.classArray[indexPath.row];
    UIViewController *demoVC = (UIViewController *)[[cls alloc] init];
    demoVC.navigationItem.title = self.titles[indexPath.row];
    [self.navigationController pushViewController:demoVC animated:YES]; 
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.left.right.equalTo(self.view);
        }];
    }
    return _tableView;
}


@end
