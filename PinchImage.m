//
//  JBImageView.m
//  GifGroupImage
//
//  Created by 孙牧and殷俊伟 on 15/10/29.
//  Copyright (c) 2015年 yjw. All rights reserved.
//

#import "JBImageView.h"

@implementation JBImageView

-(id)initWithFrame:(CGRect )frame{
    self = [super initWithFrame:frame];
    
    if (self) {
    
    
    }
    return self;
}

-(void)showInView:(UIView *)view withBgImage:(UIImage *)bgImage withPanImageArray:(NSArray *)gifArray tableview:(UITableView *)tableV  {
    
    _Iscale = 0.0;// 旋转的时候及时缩放比例
    _rotationAngle = 0.0;//旋转的角度
    self.initialW = self.frame.size.width;
    self.initialH = self.frame.size.height;
    _bevel = sqrtf(powf(self.frame.size.width, 2)+powf(self.frame.size.height, 2));//对角线长度
    //自身的一些属性
    self.backgroundColor = [UIColor clearColor];
    
    self.layer.borderWidth = 0.3;
    
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _gifArray = [[NSArray alloc] initWithArray:gifArray];
    
    self.animationImages = gifArray; //动画图片数组
    self.animationDuration = 0.5; //执行一次完整动画所需的时长
    self.animationRepeatCount = 0;  //动画重复次数
    
//   self.contentMode = UIViewContentModeScaleAspectFit;
    
    [self startAnimating];
    
    //传递父view
//    [view addSubview:self];
    if (tableV) {
        [view insertSubview:self belowSubview:tableV];
    }else{
        [view addSubview:self];
    }
    
    
    
    _view = view;
    _view.userInteractionEnabled = YES;
//    _view = view;
    
    //右下角拖拽按钮
    _tranImgV = [[UIButton alloc] init];
    _tranImgV.userInteractionEnabled = YES;
    _tranImgV.frame = CGRectMake(0, 0, 60*Wscale, 60*Wscale);
    
    _tranImgV.center = CGPointMake(self.frame.origin.x+self.frame.size.width, self.frame.origin.y+self.frame.size.height);
    
    _drawImg = [UIImage imageNamed:@"拉伸"];
    
    [_tranImgV setImage:_drawImg forState:UIControlStateNormal];
    
    if (tableV) {
        [view insertSubview:_tranImgV belowSubview:tableV];
    }else{
        [view addSubview:_tranImgV];
    }
    


    //添加左上角删除按钮
    
    _deleBtn = [[UIButton alloc] init];
    
    _deleBtn.frame = CGRectMake(0, 0, 60*Wscale, 60*Wscale);
    
    _deleBtn.center = CGPointMake(self.frame.origin.x, self.frame.origin.y);
    if (tableV) {
        [view insertSubview:_deleBtn belowSubview:tableV];
    }else{
        [view addSubview:_deleBtn];
    }
    
    [_deleBtn setImage:[UIImage imageNamed:@"删除-2"] forState:UIControlStateNormal];
    [_deleBtn addTarget:self action:@selector(deletA:) forControlEvents:UIControlEventTouchUpInside];

//    self.dollImagePro = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
//    self.dollImagePro.frame = CGRectMake(0, 0, UIScreenWith, (10/667)*UIScreenHeight);
//    self.dollImagePro.transform = CGAffineTransformMakeScale(1.0f,3.0f);
//    self.dollImagePro.progressTintColor = HWColor(255, 192, 42);
//    self.dollImagePro.trackTintColor = HWColora(0, 0, 0, 0.4);
//    [view addSubview:self.dollImagePro];
//    self.dollImagePro.hidden = YES;

    //添加拖动手势1
    self.panGesture1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan1:)];
    
    [_tranImgV addGestureRecognizer:_panGesture1];
    
    _tranImgV.userInteractionEnabled = YES;
    
    //添加拖动手势2
    self.panGesture2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan2:)];
    [self addGestureRecognizer:_panGesture2];
    self.userInteractionEnabled = YES;
    
    //添加点击手势
    self.ret = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rett:)];
    [self addGestureRecognizer:_ret];
    _ret.numberOfTapsRequired = 1;
    
}

//点击手势
- (void)rett:(UITapGestureRecognizer *)sender
{
    int tag = (int)sender.view.tag;
    [self.dragDelegate dragImage:tag];
}

//拖动手势1
-(void)handlePan1:(UIPanGestureRecognizer *)rec{
    if (rec.state==UIGestureRecognizerStateBegan) {
        [_tranImgV setImage:[UIImage imageNamed:@"拉伸-点击"] forState:UIControlStateNormal];
    }else if (rec.state==UIGestureRecognizerStateEnded){
        [_tranImgV setImage:[UIImage imageNamed:@"拉伸"] forState:UIControlStateNormal];
    }
    CGPoint point = [rec translationInView:self.view];
    
    NSLog(@"%f,%f",point.x,point.y);
    
    //固定中心点
    float x1 = self.center.x;
    
    float y1 = self.center.y;
    //拖动之前
    float x2 = rec.view.center.x;
    
    float y2 = rec.view.center.y;
    //拖动之后
    float x3 = rec.view.center.x+point.x;
    
    float y3 = rec.view.center.y+point.y;
    //算出旋转角度
    float angle1 = atan2(x2-x1, y2-y1)* 360 / M_PI;
    
    float angle2 = atan2(x3-x1, y3-y1)*360 /M_PI;
    
    float angle = angle2-angle1;
    
    //算出伸缩比例
    CGFloat W = sqrtf(powf(y2-y1, 2)+powf(x2-x1, 2));
    
    CGFloat newW =sqrtf(powf(y3-y1, 2)+powf(x3-x1, 2));
    
    _rotationAngle = angle*M_PI/360+_rotationAngle;
    
    CGAffineTransform t1 = CGAffineTransformRotate(self.transform, -angle*M_PI/360);
    
    _Iscale = newW/W;
    
    CGAffineTransform t2 = CGAffineTransformScale(t1, _Iscale,_Iscale);
    
    self.transform = t2;
    
    _deleBtn.center = CGPointMake(_deleBtn.center.x - point.x, _deleBtn.center.y - point.y);
    
    rec.view.center = CGPointMake(rec.view.center.x + point.x, rec.view.center.y + point.y);
    NSString *str = NSStringFromCGRect(self.frame); //结构体转化为字符串
    
    NSLog(@"%@",str);
    [rec setTranslation:CGPointMake(0, 0) inView:self.view];
}

//拖动手势2
-(void)handlePan2:(UIPanGestureRecognizer *)rec{
    CGPoint point = [rec translationInView:self.view];
    
    rec.view.center = CGPointMake(rec.view.center.x + point.x, rec.view.center.y + point.y);
    
    _tranImgV.center = CGPointMake(_tranImgV.center.x + point.x, _tranImgV.center.y + point.y);
    
    _deleBtn.center =  CGPointMake(_deleBtn.center.x + point.x, _deleBtn.center.y + point.y);
    
    [rec setTranslation:CGPointMake(0, 0) inView:self.view];
    
}

- (void)deletA:(UIButton *)sender
{
    self.deletDollBlock(self);
    [_dragDelegate deleteSticker:(int)self.tag];
    [_deleBtn removeFromSuperview];
    [_tranImgV removeFromSuperview];
    [self removeFromSuperview];
}

@end
