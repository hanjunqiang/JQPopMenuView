//
//  JQPopMenuView.h
//  QQPopMenuView
//
//  Created by 韩军强 on 2017/11/23.
//  Copyright © 2017年 Code Geass. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  类似QQ消息页popMenu
 */

@interface JQPopMenuView : UIView


/**
    每行cell的高度
 */
@property (nonatomic, assign) CGFloat jq_cellHeight;

/**
    字体的大小
 */
@property (nonatomic, assign) int jq_CellTitlefontSize;

/**
    cell上字体颜色
 */
@property (nonatomic, strong) UIColor *jq_cellTitleColor;

@property (nonatomic, copy) void (^hideHandle)();

/**
 *  实例化方法
 *
 *  @param array  items，包含字典，字典里面包含标题（title）、图片名（imageName）
 *  @param width  宽度
 *  @param point  三角的顶角坐标（基于window）
 *  @param cellHeight   cell高度
 *  @param fontSize     cell中，字体大小
 *  @param titleColor   cell中，字体颜色
 *  @param action 点击回调
 */
- (instancetype)initWithItems:(NSArray <NSDictionary *>*)array
                        width:(CGFloat)width
             triangleLocation:(CGPoint)point
                   cellHeight:(CGFloat)cellHeight
            cellTitleFontSize:(CGFloat)fontSize
               cellTitleColor:(UIColor *)titleColor
                       action:(void(^)(NSInteger index))action;

/**
 *  类方法展示
 *
 *  @param array  items，包含字典，字典里面包含标题（title）、图片名（imageName）
 *  @param width  tableview宽度
 *  @param point  三角的顶角坐标（基于window）
 *  @param cellHeight   cell高度
 *  @param fontSize     cell中，字体大小
 *  @param titleColor   cell中，字体颜色
 *  @param action 点击回调
 */

+ (void)jq_showWithItems:(NSArray <NSDictionary *>*)array
                width:(CGFloat)width
     triangleLocation:(CGPoint)point
              cellHeight:(CGFloat)cellHeight
       cellTitleFontSize:(CGFloat)fontSize
          cellTitleColor:(UIColor *)titleColor
               action:(void(^)(NSInteger index))action;

- (void)jq_show; //显示
- (void)jq_hide; //隐藏


@end
