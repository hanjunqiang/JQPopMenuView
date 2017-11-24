//
//  ViewController.m
//  JQPopMenuView
//
//  Created by 韩军强 on 2017/11/24.
//  Copyright © 2017年 韩军强. All rights reserved.
//

#import "ViewController.h"
#import "JQPopMenuView.h"

@interface ViewController ()
{
    JQPopMenuView *jq_menuView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"点击绿色按钮";
}

- (IBAction)popMethod:(id)sender {
    
    
    //➤类方法
    //        [JQPopMenuView jq_showWithItems:@[@{@"title":@"发起讨论",@"imageName":@"popMenu_createChat"},
    //                                          @{@"title":@"扫描名片",@"imageName":@"popMenu_scanCard"},
    //                                       @{@"title":@"写日报",@"imageName":@"popMenu_writeReport"},
    //                                       @{@"title":@"外勤签到",@"imageName":@"popMenu_signIn"}]
    //                               width:130
    //                    triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width-30, 64+5)
    //                          cellHeight:44
    //                   cellTitleFontSize:15
    //                      cellTitleColor:nil
    //                              action:^(NSInteger index) {
    //                                  NSLog(@"点击了第%ld行",index);
    //        }];
    
    //➤实例化方法
    JQPopMenuView *menuView = [[JQPopMenuView alloc] initWithItems:@[@{@"title":@"发起讨论",@"imageName":@"popMenu_createChat"},
                                                                     @{@"title":@"扫描名片",@"imageName":@"popMenu_scanCard"},
                                                                     @{@"title":@"写日报",@"imageName":@"popMenu_writeReport"},
                                                                     @{@"title":@"外勤签到",@"imageName":@"popMenu_signIn"}] width:130 triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width-30, 64+5)
                                                        cellHeight:44
                                                 cellTitleFontSize:15
                                                    cellTitleColor:nil
                                                            action:^(NSInteger index) {
                                                                NSLog(@"点击了第%ld行",index);
                                                            }];
    jq_menuView = menuView;
    [menuView jq_show]; //显示
    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [jq_menuView jq_hide]; //隐藏
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
