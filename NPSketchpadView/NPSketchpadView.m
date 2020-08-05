//
//  NPSketchpadView.m
//
//  Created by 李永杰 on 2020/7/27.
//  Copyright © 2020 李永杰. All rights reserved.
//

#import "NPSketchpadView.h"
#import "NPSketchpadScrollView.h"

#define NPSketchpadPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"NPSketchpadView.data"]

static NSString *const allPathsArray = @"allPathsArray";
static NSString *const undoPathsArray = @"undoPathsArray";

static const CGFloat animationDuration = 0.25;

@interface NPSketchpadView()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) NPSketchpadScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
/** 缓存id */
@property (nonatomic, copy) NSString    *sketchID;
/** 导航视图的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
/** 存储原来的StatusBarStyle */
@property (nonatomic, assign) UIStatusBarStyle originalStatusBarStyle;

@end

@implementation NPSketchpadView

+ (instancetype)shareInstance {
    static NPSketchpadView *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [NPSketchpadView sketchpadView];
    });
    return obj;
}

+ (instancetype)sketchpadView {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    return [[bundle loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)setLineWidth:(CGFloat)lineWidth lineStrokeColor:(UIColor *)lineStrokeColor autoChangeStatusBarStyle:(BOOL)autoChangeStatusBarStyle {
    self.lineWidth = lineWidth;
    self.lineStrokeColor = lineStrokeColor;
    self.autoChangeStatusBarStyle = autoChangeStatusBarStyle;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.scrollView.lineWidth = lineWidth;
}

- (void)setLineStrokeColor:(UIColor *)lineStrokeColor {
    _lineStrokeColor = lineStrokeColor;
    self.scrollView.lineStrokeColor = lineStrokeColor;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSURL *url = [bundle URLForResource:@"NPSketchpadView" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    UIImage *colseImage = [UIImage imageNamed:@"sketchpad_close" inBundle:imageBundle compatibleWithTraitCollection:nil];
    UIImage *backImage = [UIImage imageNamed:@"sketchpad_back" inBundle:imageBundle compatibleWithTraitCollection:nil];
    UIImage *clearImage = [UIImage imageNamed:@"sketchpad_clear" inBundle:imageBundle compatibleWithTraitCollection:nil];
    UIImage *undoImage = [UIImage imageNamed:@"sketchpad_forward" inBundle:imageBundle compatibleWithTraitCollection:nil];
    [self.closeButton setImage:colseImage forState:UIControlStateNormal];
    [self.undoButton setImage:backImage forState:UIControlStateNormal];
    [self.clearButton setImage:clearImage forState:UIControlStateNormal];
    [self.forwardButton setImage:undoImage forState:UIControlStateNormal];

    self.topViewHeight.constant = [UIApplication sharedApplication].statusBarFrame.size.height + 44;
    [self addSubview:self.scrollView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.bounds.size.width, self.bounds.size.height-CGRectGetHeight(self.topView.frame));
    _horizontalPage = _horizontalPage > 0 ? : 3;
    _verticalPage = _verticalPage > 0 ? : 3;

    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width*_horizontalPage, self.bounds.size.height*_verticalPage);
}

- (IBAction)toolButtonClick:(UIButton *)sender {
    if (sender == self.undoButton) {
        //撤销
        [self.scrollView undo];
    } else if (sender == self.forwardButton) {
        //反撤销
        [self.scrollView forward];
    } else if (sender == self.clearButton) {
        //清空
        [self.scrollView clear];
    } else {
        //关闭
        [self disappear];
    }
}

- (void)show {
    [self showWithID:0];
}

- (void)showWithID:(NSString *)sketchID {
    if (sketchID != nil) {
        _sketchID = sketchID;
        NSMutableDictionary *dataDic = [NSKeyedUnarchiver unarchiveObjectWithFile:NPSketchpadPath];
        if (dataDic) {
            NSMutableDictionary *contentDic = dataDic[[NSString stringWithFormat:@"%@", _sketchID]];
            if (contentDic) {
                NSMutableArray *allPaths = contentDic[allPathsArray];
                NSMutableArray *undoPaths = contentDic[undoPathsArray];
                [self.scrollView showAllPaths:allPaths undoPaths:undoPaths];
            } else {
                [self.scrollView clear];
            }
        } else {
            [self.scrollView clear];
        }
    } else {
        [self.scrollView clear];
    }
    
    self.alpha = 0;
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [rootView addSubview:self];
    self.frame = rootView.bounds;
    
    // 动画
    self.topViewHeight.constant = 0;
    self.scrollView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height-CGRectGetHeight(self.topView.frame));

    [UIView transitionWithView:self duration:animationDuration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.alpha = 1;
        self.topViewHeight.constant = [UIApplication sharedApplication].statusBarFrame.size.height + 44;
        self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.bounds.size.width, self.bounds.size.height-CGRectGetHeight(self.topView.frame));
    } completion:^(BOOL finished) {
    }];
    
    if (self.autoChangeStatusBarStyle) {
        self.originalStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        if (self.originalStatusBarStyle == UIStatusBarStyleLightContent) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }
    }
}

- (void)disappear {
    if (_sketchID != nil) {
        NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
        contentDic[allPathsArray] = self.scrollView.allPathsArray;
        contentDic[undoPathsArray] = self.scrollView.undoPathsArray;
        NSMutableDictionary *dataDic = [NSKeyedUnarchiver unarchiveObjectWithFile:NPSketchpadPath];
        if (!dataDic) {
            dataDic = [NSMutableDictionary dictionary];
        }
        dataDic[[NSString stringWithFormat:@"%@", _sketchID]] = contentDic;
        [NSKeyedArchiver archiveRootObject:dataDic toFile:NPSketchpadPath];
    }
    
    [UIView transitionWithView:self duration:animationDuration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.alpha = 0;
        self.topViewHeight.constant = 0;
        self.scrollView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height-CGRectGetHeight(self.topView.frame));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    if (self.autoChangeStatusBarStyle) {
        if ([UIApplication sharedApplication].statusBarStyle == UIStatusBarStyleDefault && self.originalStatusBarStyle == UIStatusBarStyleLightContent) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    }
}

#pragma mark - lazy loading
- (NPSketchpadScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[NPSketchpadScrollView alloc] init];
        __weak typeof(self) wself = self;
        _scrollView.pathsChangeHandle = ^(BOOL isUndo, BOOL isForward) {
            wself.undoButton.enabled = isUndo;
            wself.forwardButton.enabled = isForward;
            wself.clearButton.enabled = isUndo;
        };
    }
    return _scrollView;
}

@end
