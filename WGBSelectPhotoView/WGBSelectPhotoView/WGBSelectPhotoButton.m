//
//  WGBSelectPhotoButton.m
//  TestDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 mac. All rights reserved.
//

#import "WGBSelectPhotoButton.h"

@interface WGBSelectPhotoButton()

@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIImageView *videoImageView;

@end


@implementation WGBSelectPhotoButton


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.deleteBtn];
        CGRect deleteRect = self.deleteBtn.frame;
        deleteRect.origin.x = frame.size.width - 25;
        self.deleteBtn.frame = deleteRect;
        
        self.isAddButton = YES;
        
        self.contentVerticalAlignment   = UIControlContentVerticalAlignmentFill;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        
        NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"WGBSelectPhotoView.bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:path];

        UIImage *addImg = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"wgb_add" ofType:@"png"]];
        [self setBackgroundImage: addImg forState:UIControlStateNormal];
        
        [self addTarget:self
                 action:@selector(didClickedPictureBtn)
       forControlEvents:UIControlEventTouchUpInside];
    
        [self addSubview: self.videoImageView];
        [self bringSubviewToFront:self.videoImageView];
        self.videoImageView.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
    
    }
    return self;
}

#pragma mark - click event
- (void)didClickedPictureBtn {
    !self.didClickButtonBlock? : self.didClickButtonBlock();
}

- (void)didCLickedDeleteBtn {
    !self.deletePhotoBlock? : self.deletePhotoBlock();
}

#pragma mark - getters & setters
- (void)setIsAddButton:(BOOL)isAddButton{
    _isAddButton = isAddButton;
    self.deleteBtn.hidden = isAddButton;
    self.videoImageView.hidden = isAddButton;
}

- (void)setIsVideoButton:(BOOL)isVideoButton{
    _isVideoButton = isVideoButton;
    self.videoImageView.hidden = !isVideoButton;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(0, 0, 25, 25);
        NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"WGBSelectPhotoView.bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:path];
        UIImage *deleteImg = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"wgb_delete" ofType:@"png"]];
        [_deleteBtn setBackgroundImage: deleteImg forState:UIControlStateNormal];
        [_deleteBtn addTarget:self
                       action:@selector(didCLickedDeleteBtn)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIImageView *)videoImageView {
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24 , 24)];
        NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"WGBSelectPhotoView.bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:path];
        UIImage *videoMarkImg = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"wgb_video_icon" ofType:@"png"]];
        _videoImageView.image = videoMarkImg;
        _videoImageView.clipsToBounds = YES;
    }
    return _videoImageView;
}

@end
