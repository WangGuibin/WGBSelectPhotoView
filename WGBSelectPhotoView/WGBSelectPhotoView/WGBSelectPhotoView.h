//
//  WGBSelectPhotoView.h
//  TestDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@class WGBSelectPhotoDataItem;
NS_ASSUME_NONNULL_BEGIN

@protocol WGBSelectPhotoViewDelegate <NSObject>

@optional
//点击图片事件回调
- (void)wgb_photoViewDidClickedPhotoAtIndex:(NSInteger)index;
//删除图片事件回调
- (void)wgb_photoViewDidDeletedPhotoAtIndex:(NSInteger)index;

@end


@interface WGBSelectPhotoView : UIView

@property (nonatomic, assign) NSInteger maxCount;//最多显示图片数量 默认9张
@property (nonatomic, assign) NSInteger rowCount;//每行显示图片数量 默认4张
///MARK:- 显式调用 显示加号按钮  调用时机是初始化完之后 或者 重新设置`maxCount`和`rowCount`之后
- (void)showAddButtonDisplay;

@property (nonatomic, assign) CGFloat margin;//上下左右边距 默认 = 15.0
@property (nonatomic, assign) CGFloat spacing;//图片之间的间距 默认 = 10.0

@property (nonatomic, weak) id <WGBSelectPhotoViewDelegate> delegate;

- (NSUInteger)picturesCount;
- (NSUInteger)pictureButtonsCount;

///MARK:- 添加数据源数组
- (void)addPhotoesWithDataItems:(NSArray<WGBSelectPhotoDataItem *> *)items;
///MARK:- 更新视图的高度
@property (nonatomic,copy) void(^updateHeightBlock) (CGFloat viewHeight);


@end


@interface WGBSelectPhotoDataItem : NSObject

@property (nonatomic,strong) PHAsset *assetObj;
@property (nonatomic,strong) UIImage *coverImage;

///MARK:- 获取相册选择的数据源
+ (NSArray<WGBSelectPhotoDataItem *> *)createDataItemsWithPHAssets:(NSArray<PHAsset*> *)mediaAssets
                                                           photoes:(NSArray<UIImage*>*)photoes;

@end

NS_ASSUME_NONNULL_END
