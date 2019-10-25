//
//  WGBSelectImageOrVideoDemoViewController.m
//  WGBSelectPhotoView
//
//  Created by mac on 2019/10/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import "WGBSelectImageOrVideoDemoViewController.h"
#import "WGBSelectPhotoView.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <YBImageBrowser.h>
#import <YBIBVideoData.h>
#import <Masonry.h>
#import "UIView+YGCExtension.h"
#import "UILabel+YGCExtension.h"

#ifndef KWIDTH
#define KWIDTH UIScreen.mainScreen.bounds.size.width
#endif

#define  weakify(x) autoreleasepool{} __weak typeof(x) weak_##x = x;
#define  strongify(x) autoreleasepool{} __strong typeof(weak_##x)  x = weak_##x;

/// 获取RGBA颜色
#define RGBA(r,g,b,a)      [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

/// 获取RGB颜色
#define RGB(r,g,b)         RGBA(r,g,b,1.0f)

#define kBackgrounColor  RGB(51,51,51)

#define kMaxSelectImagesCount 5

@interface WGBSelectImageOrVideoDemoViewController ()<UITableViewDelegate, UITableViewDataSource,WGBSelectPhotoViewDelegate>

//列表
@property (nonatomic, strong) UITableView *tableView;

//头部
@property (nonatomic, strong) UIView *header;
//选视频
@property (nonatomic, strong) UILabel *videoTipsLabel;
@property (nonatomic, strong) WGBSelectPhotoView *selectVideoView;
@property (nonatomic, strong) NSMutableArray *selectVideoArray;
//选图片
@property (nonatomic, strong) UILabel *imagesTipsLabel;
@property (nonatomic, strong) WGBSelectPhotoView *selectPhotoView;
@property (nonatomic, strong) NSMutableArray *selectImageArray;

@end

@implementation WGBSelectImageOrVideoDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setup];
    [self.tableView reloadData];
}

- (void)setup{
    self.videoTipsLabel.frame = CGRectMake(10, 10, 200 , 21);
    CGRect videoRect = [self.selectVideoView pictureButtonFrameWithIndex:0];
    self.selectVideoView.frame = CGRectMake(0, CGRectGetMaxY(self.videoTipsLabel.frame), KWIDTH , videoRect.size.height);
    
    self.imagesTipsLabel.frame = CGRectMake(10, CGRectGetMaxY(self.selectVideoView.frame) + 30, 200 , 21);
    CGRect imageRect = [self.selectVideoView pictureButtonFrameWithIndex:0];
    self.selectPhotoView.frame = CGRectMake(0, CGRectGetMaxY(self.imagesTipsLabel.frame), KWIDTH , imageRect.size.height);
    self.header.height = CGRectGetMaxY(self.selectPhotoView.frame) + 20;
    
    self.tableView.tableHeaderView  =  self.header;
    
    @weakify(self);
    [self.selectPhotoView setUpdateHeightBlock:^(CGRect lastViewRect) {
        @strongify(self);
        self.header.height = self.selectPhotoView.y + lastViewRect.size.height;
        [self.tableView beginUpdates];
        [self.tableView setTableHeaderView:self.header];
        [self.tableView endUpdates];
    }];
    
}


///MARK:- 刷新已选的资源个数显示
- (void)refreshSelectMediaCountDisplay{
    self.videoTipsLabel.text = [NSString stringWithFormat:@"选择视频上传(%ld/1)",self.selectVideoArray.count];
    [self.videoTipsLabel moreColorWithAttributeString:@(self.selectVideoArray.count).stringValue color:RGB(217, 153, 29)];

    self.imagesTipsLabel.text = [NSString stringWithFormat:@"选择图片上传(%ld/%ld)",self.selectImageArray.count,(long)kMaxSelectImagesCount];
    [self.imagesTipsLabel moreColorWithAttributeString:@(self.selectImageArray.count).stringValue color:RGB(217, 153, 29)];
}

///MARK:- 选择视频（单选）
- (void)selectVideo{
    TZImagePickerController *pickerVC = [[TZImagePickerController alloc] init];
    pickerVC.allowPickingVideo = YES;
    pickerVC.allowPickingImage = NO;
    pickerVC.allowTakePicture = NO;
    pickerVC.maxImagesCount = 1;
    pickerVC.statusBarStyle = UIStatusBarStyleLightContent;
    [self presentViewController:pickerVC animated:YES completion:^{
        
    }];
    
    [pickerVC setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
        NSArray<WGBSelectPhotoDataItem *> *items = [WGBSelectPhotoDataItem createDataItemsWithPHAssets:@[asset] photoes:@[coverImage]];
        [self.selectVideoView addPhotoesWithDataItems:items];
        [self.selectVideoArray addObjectsFromArray:items];
        [self refreshSelectMediaCountDisplay];
    }];
}

///MARK:- 选择照片
- (void)selectPhoto{
    TZImagePickerController *pickerVC = [[TZImagePickerController alloc] init];
    pickerVC.allowPickingVideo = NO;
    pickerVC.allowPickingMultipleVideo = NO;//多选
    pickerVC.maxImagesCount = kMaxSelectImagesCount;
    pickerVC.statusBarStyle = UIStatusBarStyleLightContent;
    [self presentViewController:pickerVC animated:YES completion:^{
        
    }];
        
    [pickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (self.selectImageArray.count + assets.count > kMaxSelectImagesCount) {
            [self outOfLimitAlertTips];
        }
        
        ///MARK：- 优雅的方式 只获取`kMaxSelectImagesCount`张
        if (self.selectImageArray.count) {
            NSInteger detaCount = kMaxSelectImagesCount - self.selectImageArray.count;
            detaCount = MIN(detaCount, assets.count);
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                                   NSMakeRange(0,detaCount)];
            NSArray *tempAssets = [assets objectsAtIndexes:indexes];
            NSArray *tempPhotoes = [photos objectsAtIndexes:indexes];
            NSArray<WGBSelectPhotoDataItem *> *items = [WGBSelectPhotoDataItem createDataItemsWithPHAssets:tempAssets photoes:tempPhotoes];
            [self.selectPhotoView addPhotoesWithDataItems:items];
            [self.selectImageArray addObjectsFromArray:items];
        }else{
            NSArray<WGBSelectPhotoDataItem *> *items = [WGBSelectPhotoDataItem createDataItemsWithPHAssets:assets photoes:photos];
            [self.selectPhotoView addPhotoesWithDataItems:items];
            [self.selectImageArray addObjectsFromArray:items];
        }
        [self refreshSelectMediaCountDisplay];
    }];
}

///MARK:- 超出限制提示信息
- (void)outOfLimitAlertTips{
    NSString *message = [NSString stringWithFormat:@"最多只能选择%ld个媒体资源",(long)kMaxSelectImagesCount];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction: action];
    [self presentViewController:alert animated:YES completion:nil];
}

///MARK:- tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = @(indexPath.row + 666666).stringValue;
    return cell;
}

///MARK:- tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

///MARK:- <WGBSelectPhotoViewDelegate>
- (void)wgb_photoViewDidClickedPhotoAtIndex:(NSInteger)index
                                  photoView:(WGBSelectPhotoView *)photoView{

    if (photoView == self.selectVideoView) {
        if (index == [self.selectVideoView picturesCount]) {
            [self selectVideo];
        }else{
            NSMutableArray *localImageDataArr = [NSMutableArray array];
            for (WGBSelectPhotoDataItem *item in self.selectVideoArray) {
                YBIBVideoData *videoData = [YBIBVideoData new];
                videoData.videoPHAsset = item.assetObj;
                [localImageDataArr addObject:videoData];
            }
            YBImageBrowser *browser = [YBImageBrowser new];
            browser.defaultToolViewHandler.topView.operationButton.hidden = YES;
            browser.dataSourceArray = localImageDataArr;
            browser.currentPage = index;
            [browser show];
        }
    }else{
        if (index == [self.selectPhotoView picturesCount]) {
            [self selectPhoto];
        }else {
            NSMutableArray *localImageDataArr = [NSMutableArray array];
            for (WGBSelectPhotoDataItem *item in self.selectImageArray) {
                if (item.assetObj.mediaType == PHAssetMediaTypeVideo) {
                    YBIBVideoData *videoData = [YBIBVideoData new];
                    videoData.videoPHAsset = item.assetObj;
                    [localImageDataArr addObject:videoData];
                }else{
                    YBIBImageData *imageData = [YBIBImageData new];
                    imageData.imagePHAsset = item.assetObj;
                    [localImageDataArr addObject:imageData];
                }
            }
            YBImageBrowser *browser = [YBImageBrowser new];
            browser.defaultToolViewHandler.topView.operationButton.hidden = YES;
            browser.dataSourceArray = localImageDataArr;
            browser.currentPage = index;
            [browser show];
        }
    }
}

//删除图片事件回调
- (void)wgb_photoViewDidDeletedPhotoAtIndex:(NSInteger)index
                                  photoView:(WGBSelectPhotoView *)photoView{
    if (photoView == self.selectVideoView) {
        if (self.selectVideoArray.count) {
            [self.selectVideoArray removeObjectAtIndex: index];
        }
    }else{
        if (self.selectImageArray.count) {
            [self.selectImageArray removeObjectAtIndex: index];
        }
    }
    [self refreshSelectMediaCountDisplay];
}

//移动图片事件
- (void)wgb_photoViewDidMovedPhotoWithStartIndex:(NSInteger)startIndex
                                        endIndex:(NSInteger)endIndex
                                       photoView:(WGBSelectPhotoView *)photoView{
//    NSLog(@"startIndex: %ld --- endIndex: %ld",startIndex,endIndex);
    if (self.selectVideoView == photoView) {
        return ;
    }
    if (startIndex != endIndex) {
        //不要直接操作数据源本身， 不然数据会错乱
        NSMutableArray *tempArr = self.selectImageArray.mutableCopy;
        id obj = tempArr[startIndex];
        [tempArr removeObject:obj];
        [tempArr insertObject:obj atIndex:endIndex];
        self.selectImageArray = tempArr ;
    }
}

///MARK:- lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kBackgrounColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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


- (UIView *)header {
    if (!_header) {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH , 100)];
        _header.backgroundColor = kBackgrounColor;
    }
    return _header;
}

- (UILabel *)videoTipsLabel {
    if (!_videoTipsLabel) {
        _videoTipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _videoTipsLabel.textAlignment = NSTextAlignmentLeft;
        _videoTipsLabel.textColor = RGB(148,151,159);
        _videoTipsLabel.font = [UIFont systemFontOfSize:16];
        _videoTipsLabel.text = @"选择视频上传（0/1）";
        [self.header addSubview: _videoTipsLabel];
    }
    return  _videoTipsLabel;
}


- (WGBSelectPhotoView *)selectVideoView {
    if (!_selectVideoView) {
        _selectVideoView = [[WGBSelectPhotoView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH , 100)];
        _selectVideoView.maxCount = 1;
        _selectVideoView.delegate = self;
        [_selectVideoView showAddButtonDisplay];
        [self.header addSubview: _selectVideoView];
    }
    return _selectVideoView;
}


- (NSMutableArray *)selectVideoArray {
    if (!_selectVideoArray) {
        _selectVideoArray = [[NSMutableArray alloc] init];
    }
    return _selectVideoArray;
}


- (UILabel *)imagesTipsLabel {
    if (!_imagesTipsLabel) {
        _imagesTipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _imagesTipsLabel.textAlignment = NSTextAlignmentLeft;
        _imagesTipsLabel.textColor = RGB(148,151,159);
        _imagesTipsLabel.font = [UIFont systemFontOfSize:16];
        _imagesTipsLabel.text = @"选择图片上传（0/5）";
        [self.header addSubview: _imagesTipsLabel];
    }
    return  _imagesTipsLabel;
}



- (WGBSelectPhotoView *)selectPhotoView {
    if (!_selectPhotoView) {
        _selectPhotoView = [[WGBSelectPhotoView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
        _selectPhotoView.backgroundColor = kBackgrounColor;
        _selectPhotoView.delegate = self;
        _selectPhotoView.maxCount = kMaxSelectImagesCount;
        _selectPhotoView.rowCount = 4;
        [_selectPhotoView showAddButtonDisplay];
        [self.header addSubview: _selectPhotoView];
    }
    return _selectPhotoView;
}


- (NSMutableArray *)selectImageArray {
    if (!_selectImageArray) {
        _selectImageArray = [[NSMutableArray alloc] init];
    }
    return _selectImageArray;
}

@end
