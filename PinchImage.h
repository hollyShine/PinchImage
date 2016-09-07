//
//  JBImageView.h
//  GifGroupImage
//
//  Created by 孙牧and殷俊伟 on 15/10/29.
//  Copyright (c) 2015年 yjw. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GifDragDelegate <NSObject>

-(void)dragImage:(int)tag;

@optional

-(void)deleteSticker:(int)tag;

@end

@interface JBImageView : UIImageView

@property(nonatomic, assign)id<GifDragDelegate>dragDelegate;// 点击的代理

/**声明block回调属性**/
@property (nonatomic, strong) void (^deletDollBlock) (JBImageView *codition);

@property(nonatomic, strong)UIButton *tranImgV;//拉伸旋转imageView

@property(nonatomic, strong)UIImage *drawImg;//拉伸旋转图片

@property(nonatomic, strong)UIImage *bgImg;//聊天背景图

@property(nonatomic, strong)UIImage *tagsImg;//贴纸图片

@property(nonatomic, strong)UIButton *deleBtn;//删除按钮

@property(nonatomic, strong)NSArray *gifArray;//可旋转所放的图片数组

@property(nonatomic, strong)UIView *view;//父view

@property(nonatomic, assign)CGFloat Iscale;

@property(nonatomic, assign)CGFloat rotationAngle;

@property(nonatomic, assign)CGFloat bevel;

@property(nonatomic, assign)CGFloat initialW;

@property(nonatomic, assign)CGFloat initialH;

-(void)showInView:(UIView *)view withBgImage:(UIImage *)bgImage withPanImageArray:(NSArray *)gifArray tableview:(UITableView *)tableV ;

//拖拽的手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture1;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture2;
@property (nonatomic, strong) UITapGestureRecognizer *ret;
//@property (nonatomic, strong) UIProgressView *dollImagePro;
@end
