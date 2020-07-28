//
//  ViewController.m
//  Demo
//
//  Created by 李永杰 on 2020/7/27.
//  Copyright © 2020 李永杰. All rights reserved.
//

#import "ViewController.h"
#import "NPSketchpadView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *clickButton;
@property (weak, nonatomic) IBOutlet UIButton *click1Button;
@property (nonatomic, strong) NPSketchpadView *sketchpadView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sketchpadView = [NPSketchpadView shareInstance];
    self.sketchpadView.autoChangeStatusBarStyle = YES;
    self.sketchpadView.horizontalPage = 1;
    self.sketchpadView.verticalPage = 1;
}


- (IBAction)didClickAction {
    self.sketchpadView.lineStrokeColor = [UIColor magentaColor];
    [self.sketchpadView showWithID:@"123"];
}
- (IBAction)didClickAction1 {
    self.sketchpadView.lineStrokeColor = [UIColor yellowColor];
    [self.sketchpadView showWithID:@"456"];
}
@end
