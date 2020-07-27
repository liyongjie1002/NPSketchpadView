//
//  NPSketchpadScrollView.h
//
//  Created by 李永杰 on 2020/7/27.
//  Copyright © 2020 李永杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPSketchpadScrollView : UIScrollView

/** 撤销 */
- (void)undo;
/** 反撤销 */
- (void)forward;
/** 清屏 */
- (void)clear;

/** 路径改变的回调
 *  isUndo     YES:可以撤销  NO：不可以撤销
 *  isForward  YES:可以反撤销  NO：不可以反撤销
 */
@property (nonatomic, copy) void(^pathsChangeHandle)(BOOL isUndo, BOOL isForward);

/** 显示路径 */
- (void)showAllPaths:(NSMutableArray *)allPaths undoPaths:(NSMutableArray *)undoPaths;
/** 当前在显示的路径 */
@property (nonatomic, strong, readonly) NSMutableArray *allPathsArray;
/** 保存已经撤销的路径 */
@property (nonatomic, strong, readonly) NSMutableArray *undoPathsArray;

/** 线的颜色, 默认:#000000*/
@property (nonatomic, strong) UIColor *lineStrokeColor;
/** 线的宽度, 默认:3point */
@property (nonatomic, assign) CGFloat lineWidth;

@end
