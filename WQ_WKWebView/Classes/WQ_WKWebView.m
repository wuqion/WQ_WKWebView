//
//  WQ_WKWebView.m
//  B2C
//
//  Created by 联创—王增辉 on 2019/1/30.
//

#import "WQ_WKWebView.h"

@interface WQ_WKWebView ()<WKUIDelegate>

@property (strong, nonatomic) UIView            *naviView;
@property (strong, nonatomic) UIButton          *backBtn;
@property (strong, nonatomic) UILabel           *titleLB;
@property (strong, nonatomic) UIProgressView    *progressView;



@end

@implementation WQ_WKWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.webView addSubview:self.progressView];
        [self addSubview:self.webView];
        // 给webview添加监听
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }

    }
    return self;
}
- (void)setIsNavView:(BOOL)isNavView
{
    _isNavView = isNavView;
    if (isNavView) {
        [self.naviView addSubview:self.backBtn];
        [self.naviView addSubview:self.titleLB];
        [self addSubview:self.naviView];
        self.webView.frame = CGRectMake(0, self.naviView.frame.size.height, self.frame.size.width, self.frame.size.height - self.naviView.frame.size.height);
    }else{
        [self.naviView removeFromSuperview];
        self.webView.frame = self.bounds;
    }
}
- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:self.bounds];
        _webView.UIDelegate = self;
    }
    return _webView;
}
- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 3)];
        _progressView.tintColor = [UIColor blueColor];
    }
    return _progressView;
}
- (UIView *)naviView
{
    if (!_naviView) {
        CGFloat height = [UIApplication sharedApplication].statusBarFrame.size.height;
        _naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, height +44.0)];
        _naviView.backgroundColor = [UIColor whiteColor];
    }
    return _naviView;
}
- (UIButton *)backBtn
{
    if (!_backBtn) {
        CGFloat height = [UIApplication sharedApplication].statusBarFrame.size.height;
        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, height, 44, 44)];
        [_backBtn addTarget:self action:@selector(backAvtion:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:[UIImage imageNamed:@"goBackButton"] forState:UIControlStateNormal];
    }
    return _backBtn;
}
- (UILabel *)titleLB
{
    if (!_titleLB) {
        CGFloat height = [UIApplication sharedApplication].statusBarFrame.size.height;

        _titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, height, self.naviView.frame.size.width, 44)];
        _titleLB.textColor = [UIColor blackColor];
        _titleLB.font = [UIFont systemFontOfSize:15];
        _titleLB.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLB;
}
- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    self.titleLB.text = titleStr;
}
- (void)setUrl:(NSString *)url
{
    _url = url;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}
- (void)backAvtion:(UIButton *)button{
    if (self.leftBlock) {
        self.leftBlock();
    }
}
#pragma mark --observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqual:@"estimatedProgress"] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress  >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:YES];
            }];
        }
    }else if ([keyPath isEqual:@"title"] && object == self.webView) {
        if (object == self.webView)
        {
            if (!self.titleStr) {
                self.titleLB.text = self.webView.title;
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark --webview代理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
}

@end
