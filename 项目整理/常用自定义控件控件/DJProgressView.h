



#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kDJProgressRoundType,//圆形进度条
    kDJProgressBarType,//长条形进度条
} DJProgressType;


@interface DJProgressView : UIView

@property (nonatomic, copy)UIColor *progressColor;//进度条的进度颜色
@property (nonatomic, copy)UIColor *baseColor;//进度条的底色

@property (nonatomic, assign)UIColor *borderColor;//进度条边框颜色
@property (nonatomic, assign)CGFloat  borderWidth;//进度条边框宽度

@property (nonatomic, assign)CGFloat lineWeight;//进度条的宽度



- (instancetype)initWithFrame:(CGRect)frame type:(DJProgressType)type;//初始化progressview 并设置类型

@property (nonatomic, assign) CGFloat progress;//传入进度 0~1之间的浮点数
/*圆形的 是否设置渐变色*/
@property (nonatomic, assign,getter=isGradual) BOOL gradual;
@end
