//
//  DRWebBoxView.h
//

/**
 @class DRWebBoxView
 @brief A custom UIView with a UIWebView, activity indicator, and reload button. The activity indicator is shown while loading the webview and the reload button is displayed when loading on the webview fails.
 */

@interface DRWebBoxView : UIView <UIWebViewDelegate>

@property (nonatomic, readonly) UIWebView *webView;
@property (nonatomic, readonly) UIButton *reloadButton;
@property (nonatomic, readonly) NSURLRequest *request;

- (void)reloadRequest:(id)sender;
- (void)loadRequest:(NSURLRequest *)request;

+ (NSURLRequest *)requestFromURL:(NSURL *)requestURL;


@end
