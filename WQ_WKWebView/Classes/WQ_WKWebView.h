//
//  WQ_WKWebView.h
//  B2C
//
//  Created by 联创—王增辉 on 2019/1/30.
//

#import <UIKit/UIKit.h>

#import <WebKit/WebKit.h>



@interface WQ_WKWebView : UIView

@property (strong, nonatomic) WKWebView *webView;

@property (assign, nonatomic) BOOL isNavView;

@property (copy, nonatomic)   NSString * url;

@property (copy, nonatomic)   NSString * titleStr;

@property (copy, nonatomic) void(^leftBlock)();


@end


