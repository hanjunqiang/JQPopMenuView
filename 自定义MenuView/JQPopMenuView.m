//
//  JQPopMenuView.m
//  QQPopMenuView
//
//  Created by 韩军强 on 2017/11/23.
//  Copyright © 2017年 Code Geass. All rights reserved.
//

#import "JQPopMenuView.h"
//#import "UIView+views.h"

//--------------以下为自定义的cell，因为JQPopMenuView中要用cell,所以要提前声明----------------

//static CGFloat const kCellHeight = 44;

@interface PopMenuTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *titleLabel;

/**
 每行cell的高度
 */
@property (nonatomic, assign) CGFloat jq_cellHeight;

@end

//-------------------------以下为自定义的JQPopMenuView----------------------------------


@interface JQPopMenuView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, assign) CGPoint trianglePoint;
@property (nonatomic, copy) void(^action)(NSInteger index);

@end

@implementation JQPopMenuView

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#pragma Mrhan- 初始化
- (instancetype)initWithItems:(NSArray <NSDictionary *>*)array
                        width:(CGFloat)width
             triangleLocation:(CGPoint)point
                   cellHeight:(CGFloat)cellHeight
            cellTitleFontSize:(CGFloat)fontSize
               cellTitleColor:(UIColor *)titleColor
                       action:(void(^)(NSInteger index))action
{
    if (array.count == 0) return nil;
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds; //全屏哦
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        self.alpha = 0;
        _tableData = [array copy];
        _trianglePoint = point;
        self.action = action;
        self.jq_cellHeight = cellHeight;
        self.jq_CellTitlefontSize = fontSize;
        self.jq_cellTitleColor = titleColor;
        
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        
        // 创建tableView
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - width - 5, point.y + 10, width, (self.jq_cellHeight?self.jq_cellHeight:44) * array.count) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 5;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = (self.jq_cellHeight?self.jq_cellHeight:44);
        [_tableView registerClass:[PopMenuTableViewCell class] forCellReuseIdentifier:@"PopMenuTableViewCell"];
        [self addSubview:_tableView];
        
    }
    return self;
}
+ (void)jq_showWithItems:(NSArray <NSDictionary *>*)array
                   width:(CGFloat)width
        triangleLocation:(CGPoint)point
              cellHeight:(CGFloat)cellHeight
       cellTitleFontSize:(CGFloat)fontSize
          cellTitleColor:(UIColor *)titleColor
                  action:(void(^)(NSInteger index))action
{
    JQPopMenuView *view = [[JQPopMenuView alloc] initWithItems:array width:width triangleLocation:point cellHeight:cellHeight cellTitleFontSize:fontSize cellTitleColor:titleColor action:action];
    [view jq_show];
}

- (void)tap {
    [self jq_hide];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //点击cell的时候，不触发点击手势（不然就点不住cell了）
    if ([touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        return NO;
    }
    return YES;
}

#pragma mark - show or hide
- (void)jq_show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    // 设置右上角为transform的起点（默认是中心点）
    _tableView.layer.position = CGPointMake(SCREEN_WIDTH - 5, _trianglePoint.y + 10);
//    _tableView.layer.position = CGPointMake(SCREEN_WIDTH - 25, _trianglePoint.y + 10);    //偏移一点

    /**
     设置锚点，锚点的位置决定了动画的参照点
     左上(0,0),
     右上(1,0),
     左下(0,1),
     右下(1,1),
     
     默认锚点anchorPoint和中心点position是重合在中心位置的。
     
     由公式：
     position.x = frame.origin.x + anchorPoint.x * bounds.size.width;
     position.y = frame.origin.y + anchorPoint.y * bounds.size.height;
     
     现在修改了position的位置为右上角，
     为了保证frame不变，所以上面锚点anchorPoint的位置也设置到了右上角。
     
     动画的是以锚点anchorPoint为依赖点来执行的。
     
     */
    _tableView.layer.anchorPoint = CGPointMake(1, 0);
//    _tableView.layer.anchorPoint = CGPointMake(0.85, 0);  //偏移一点

    _tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
        _tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    
}

- (void)jq_hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        _tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } completion:^(BOOL finished) {
        [_tableView removeFromSuperview];
        [self removeFromSuperview];
        if (self.hideHandle) {
            self.hideHandle();
        }
    }];
}

#pragma mark - Draw triangle
- (void)drawRect:(CGRect)rect {
    // 设置背景色
    [[UIColor whiteColor] set];
    //拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    //利用path进行绘制三角形
    CGContextBeginPath(context);
    CGPoint point = _trianglePoint;
    // 设置起点
    CGContextMoveToPoint(context, point.x, point.y);
    // 画线
    CGContextAddLineToPoint(context, point.x - 10, point.y + 10);
    CGContextAddLineToPoint(context, point.x + 10, point.y + 10);
    CGContextClosePath(context);
    // 设置填充色
    [[UIColor whiteColor] setFill];
    // 设置边框颜色
    [[UIColor whiteColor] setStroke];
    // 绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PopMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopMenuTableViewCell" forIndexPath:indexPath];
    cell.jq_cellHeight = (self.jq_cellHeight?self.jq_cellHeight:44);
    
    NSDictionary *dic = _tableData[indexPath.row];
    cell.leftImageView.image = [UIImage imageNamed:dic[@"imageName"]];
    cell.titleLabel.text = dic[@"title"];
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    
    cell.titleLabel.textColor = self.jq_cellTitleColor?self.jq_cellTitleColor:[UIColor blackColor];
    cell.titleLabel.font = [UIFont systemFontOfSize:self.jq_CellTitlefontSize?self.jq_CellTitlefontSize:15];
    
    [cell.titleLabel sizeToFit];    //由于label没有设置size，所以这里必须加。
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self jq_hide];
    if (_action) {
        _action(indexPath.row);
    }
}

@end




//-------------------------<#参数#>----------------------------------

@implementation PopMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 20, 20)];
        [self.contentView addSubview:_leftImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImageView.frame)+10, 0, 0, 0)];
        [self.contentView addSubview:_titleLabel];
        
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
//    NSLog(@"test---%@",NSStringFromCGPoint(self.center));
    
    /**
        注意：自定义cell中的layoutSubviews方法中，想要使用当前行cell的中心点center
     
        cell的centerX是一致的。
        cell的y是从上往下递增的。比如行高默认44，第一行y是0，第二行是44，第三行是44*2...
        那么，cell的centerY也是从上往下递增的。
     
        如果想要获取当前cell的centerY，那就使用：行高/2
    */
//    _leftImageView.centerY = self.height/2;
//    _titleLabel.centerY = self.height/2;

        _leftImageView.center = CGPointMake(_leftImageView.center.x, self.frame.size.height/2);
        _titleLabel.center = CGPointMake(_titleLabel.center.x, self.frame.size.height/2);
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

//当前view添加到window时，会调用该方法。
//-(void)setNeedsLayout{
//
//}

//当前view添加到window时，会调用该方法。
//-(void)setNeedsDisplay{
//
//}

//当前view添加到window时，没有调用该方法！！！
//-(void)setNeedsDisplayInRect:(CGRect)rect{
//
//}

@end
