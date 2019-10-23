//
//  ViewController.m
//  WGBSelectPhotoView
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"
#import "WGBSelectPhotoView.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <YBImageBrowser.h>
#import <YBIBVideoData.h>

#define kMaxSelectImagesCount 9

@interface ViewController ()<WGBSelectPhotoViewDelegate>

@property (nonatomic, strong) WGBSelectPhotoView *selectPhotoView;
@property (nonatomic, strong) NSMutableArray *selectImageArray;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"照片选择";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.selectPhotoView];

}

- (void)selectPhoto{
    TZImagePickerController *pickerVC = [[TZImagePickerController alloc] init];
    pickerVC.allowPickingVideo = YES;
    pickerVC.allowPickingMultipleVideo = YES;//多选
    pickerVC.maxImagesCount = kMaxSelectImagesCount;
    [self presentViewController:pickerVC animated:YES completion:^{
        
    }];

    //选图片或者视频
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
            [self.selectImageArray addObjectsFromArray:tempAssets];
            NSArray<WGBSelectPhotoDataItem *> *items = [WGBSelectPhotoDataItem createDataItemsWithPHAssets:tempAssets photoes:tempPhotoes];
            [self.selectPhotoView addPhotoesWithDataItems:items];
        }else{
            [self.selectImageArray addObjectsFromArray:assets];
            NSArray<WGBSelectPhotoDataItem *> *items = [WGBSelectPhotoDataItem createDataItemsWithPHAssets:assets photoes:photos];
            [self.selectPhotoView addPhotoesWithDataItems:items];
        }
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

#pragma mark - <WGBSelectPhotoViewDelegate>
- (void)wgb_photoViewDidClickedPhotoAtIndex:(NSInteger)index{
    if (index == [self.selectPhotoView picturesCount]) {
        [self selectPhoto];
    }else {
        NSMutableArray *localImageDataArr = [NSMutableArray array];
        for (PHAsset *imageAsset in self.selectImageArray) {
            if (imageAsset.mediaType == PHAssetMediaTypeVideo) {
                YBIBVideoData *videoData = [YBIBVideoData new];
                videoData.videoPHAsset = imageAsset;
                [localImageDataArr addObject:videoData];
            }else {
                YBIBImageData *imageData = [YBIBImageData new];
                imageData.imagePHAsset = imageAsset;
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

//删除图片事件回调
- (void)wgb_photoViewDidDeletedPhotoAtIndex:(NSInteger)index{
    if (self.selectImageArray.count) {
        [self.selectImageArray removeObjectAtIndex: index];
    }
}


- (WGBSelectPhotoView *)selectPhotoView {
    if (!_selectPhotoView) {
        _selectPhotoView = [[WGBSelectPhotoView alloc] initWithFrame:CGRectMake(0, 88, self.view.bounds.size.width, 100)];
        _selectPhotoView.maxCount = kMaxSelectImagesCount;
        _selectPhotoView.rowCount = 3;
        _selectPhotoView.backgroundColor = [UIColor cyanColor];
        _selectPhotoView.delegate = self;
        [_selectPhotoView showAddButtonDisplay];
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
