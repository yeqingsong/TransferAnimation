//
//  ViewController.m
//  TransferAnimation
//
//  Created by shoule on 2018/7/23.
//  Copyright © 2018年 yqs. All rights reserved.
//

/** KeyWindow [UIApplication sharedApplication].keyWindow */
#define KEY_WINDOW    [UIApplication sharedApplication].keyWindow
#define SCREEN_Width [UIScreen mainScreen].bounds.size.width
#define SCREEN_Height [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"

@interface ViewController ()
{
    UIImageView* imageBack;
    UIImageView* IntroImgView;
    UIView *clearView;
    CALayer *layer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
        [self initControls];
//    CAShapeLayer *maskLayer =  clearView.layer.mask;
        [self initAnimatingImgView];
    layer = [CALayer layer];
    layer.frame = self.view.frame;
    [self.view.layer addSublayer:layer];
}
- (void)initControls{
    
    imageBack = [[UIImageView alloc]initWithFrame:self.view.bounds];
    //    downImageBack = [[UIImageView alloc]initWithFrame:_window.bounds];
    //    clearView = [[UIView alloc]initWithFrame:_window.bounds];
    //
    //    downImageBack.alpha=0;
    
    if (SCREEN_Width == 375) {
        imageBack.image = [UIImage imageNamed:@"启始页750X1334-bg"];
    }else{
        imageBack.image = [UIImage imageNamed:@"LaunchImage-1"];
    }
    IntroImgView=[[UIImageView alloc]init];
    //    view = [[UIView alloc]init];
    if (SCREEN_Height == 640.f) {
        IntroImgView.frame = CGRectMake(56, 79, 207, 207);
    }else if (SCREEN_Height == 568.f){
        IntroImgView.frame = CGRectMake(55.5, 119.5, 207, 207);
    }else if (SCREEN_Width == 414.f){
        IntroImgView.frame=CGRectMake(71, 156, 271, 271);
    }else if (SCREEN_Width == 375.f){
        IntroImgView.frame = CGRectMake(65, 143, 244, 244);
    }
    
    clearView =  [[UIView alloc]initWithFrame:self.view.bounds];
    clearView.backgroundColor = [UIColor clearColor];
    [imageBack addSubview:IntroImgView];
    [self.view addSubview:imageBack];
    [self.view addSubview:clearView];
    
}
- (void)initAnimatingImgView{
    //1. 将4.7英寸的屏幕与;其他屏幕区分开来，对广告画面前面的页面做动画轮播
    NSMutableArray *animImgs = [NSMutableArray array];
    //    NSString *inch4_7ImgPrefix = @"LaunchAnimInch4_7page";
    NSString *imgPrefix = @"启始页1242X2208-p";
    IntroImgView.image=[UIImage imageNamed:@"启始页1242X2208-p1"];
    for (NSUInteger index = 1; index <= 4; ++index) {
        NSString *imgName;
        imgName = [NSString stringWithFormat:@"%@%lu",imgPrefix,(unsigned long)index];
        UIImage *img = [UIImage imageNamed:imgName];
        [animImgs addObject:img];
    }
    
    IntroImgView.animationImages = [animImgs copy];
    IntroImgView.animationDuration = 1.3;
    IntroImgView.animationRepeatCount = 1;
    [IntroImgView startAnimating];
    [self performSelector:@selector(stopImgAnimating) withObject:nil afterDelay:1.5];
}
- (void)stopImgAnimating{
    [IntroImgView stopAnimating];
//    [self performSelector:@selector(waitAnimation) withObject:nil afterDelay:1.5f];
    [self waitAnimation];
}

-(void)waitAnimation{
    layer.opacity = 0;
    CGRect  _finalFrame=IntroImgView.frame;
    
    CGRect rect = CGRectInset(_finalFrame, -500, -500);//通过 第二个参数 dx和第三个参数 dy 重置第一个参数rect 作为结果返回。重置的方式为，首先将rect 的坐标（origin）按照（dx,dy) 进行平移，然后将rect的大小（size） 宽度缩小2倍的dx，高度缩小2倍的dy；
    
    CGPathRef startPath = CGPathCreateWithEllipseInRect(_finalFrame, NULL);
    CGPathRef endPath   = CGPathCreateWithEllipseInRect(rect, NULL);
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = startPath;
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.mask = maskLayer;
    
    maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pingAnimation.fromValue =(__bridge id)(startPath);
    pingAnimation.toValue   = (__bridge id)(endPath);
    pingAnimation.duration  = 0.6;
    pingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //         pingAnimation.repeatCount=FLT_MAX;
    [maskLayer addAnimation:pingAnimation forKey:@"pingInvert"];
    //        [maskLayer addAnimation:pingAnimation forKey:@"path"];
    CGPathRelease(startPath);
    CGPathRelease(endPath);
    
    [UIView animateWithDuration:0.3 animations:^{
        self->IntroImgView.alpha = 0;

        self->layer.opacity = 0.7;
        self->imageBack.alpha=0;
    } completion:^(BOOL finished) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"再来一次" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了按钮1，进入按钮1的事件");
            self->clearView.backgroundColor = [UIColor clearColor];
            self->IntroImgView.alpha = 1;
            self->layer.opacity = 0;
            
            self->imageBack.alpha = 1;
            [self->IntroImgView startAnimating];
            [self performSelector:@selector(stopImgAnimating) withObject:nil afterDelay:1.5];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了取消");
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
