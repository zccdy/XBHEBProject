#import <Foundation/Foundation.h>

@interface UIView (Toast)

// each makeToast method creates a view and displays it as toast
- (void)makeToast:(NSString *)message;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title image:(UIImage *)image;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position image:(UIImage *)image;

//从底部到中部 的淡入效果
//moveTime 从底部到中部的动画效果时间
//appearDelay 提示的延迟时间(多少秒后 开始提示)
//delay的 提示的存在时间
- (void)makeToast:(NSString *)message DownMoveToCenterDuration:(CGFloat)moveTime NotifyAppearDelay:(CGFloat)appearDelay HideDelay:(CGFloat)delay;
// displays toast with an activity spinner
- (void)makeToastActivity;
- (void)makeToastActivity:(id)position;
- (void)hideToastActivity;

// the showToast methods display any view as toast
- (void)showToast:(UIView *)toast;
- (void)showToast:(UIView *)toast duration:(CGFloat)interval position:(id)point;

@end
