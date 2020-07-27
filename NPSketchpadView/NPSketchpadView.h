//
//  NPSketchpadView.h
//
//  Created by 李永杰 on 2020/7/27.
//  Copyright © 2020 李永杰. All rights reserved.
// 

#import <UIKit/UIKit.h>

@interface NPSketchpadView : UIView

/** 单例 */
+ (instancetype)shareInstance;

/** 横向滚动页数 默认3页 */
@property (nonatomic, assign) NSUInteger horizontalPage;
/** 纵向滚动页数 默认3页 */
@property (nonatomic, assign) NSUInteger verticalPage;

/** 显示无缓存路径的画板 */
- (void)show;
/** 加载这个id的缓存, id不能是0 */
- (void)showWithID:(NSInteger)ID;


- (void)setLineWidth:(CGFloat)lineWidth lineStrokeColor:(UIColor *)lineStrokeColor autoChangeStatusBarStyle:(BOOL)autoChangeStatusBarStyle;
/** 线的宽度, 默认:3point */
@property (nonatomic, assign) CGFloat lineWidth;
/** 线的颜色, 默认:#000000*/
@property (nonatomic, strong) UIColor *lineStrokeColor;
/** 是否自动改变StatusBarStyle, 默认:NO */
@property (nonatomic, assign) BOOL autoChangeStatusBarStyle;

@end
