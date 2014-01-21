//
//  DRWebBoxView.m
//

#import "DRWebBoxView.h"

// Hides all logging from this class. Comment out to debug this class.
//#define NSLog(...)

#pragma mark -

@interface DRWebBoxView ()
@property (nonatomic) NSInteger pendingRequestCount;
@property (nonatomic) NSURLRequest *request;
@property (nonatomic, readwrite) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic) UIButton *reloadButton;
@property (nonatomic) UIWebView *webView;
@property (nonatomic) NSError *error;
@property (nonatomic) BOOL isBusy;
@end

#pragma mark -

@implementation DRWebBoxView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // WebView
        self.webView = [[UIWebView alloc] initWithFrame:self.bounds];
        self.webView.backgroundColor = [UIColor whiteColor];
        self.webView.delegate = self;
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.webView];
        
        
        // Reload Button
        self.reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.reloadButton.frame = CGRectMake(0.0f, 60.0f, 100.0f, 44.0f);
        self.reloadButton.backgroundColor = [UIColor whiteColor];
        self.reloadButton.layer.cornerRadius = 10;
        [self.reloadButton setTitle:@"Reload?" forState:UIControlStateNormal];
        self.reloadButton.center = self.center;
        [self.reloadButton addTarget:self action:@selector(reloadRequest:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.reloadButton];
        
        
        // Activity Indicator
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicatorView.center = self.center;
        self.activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:self.activityIndicatorView];
        
        
        // Default background color
        self.backgroundColor = [UIColor blackColor];
        
        
        [self _updateUI];
    }
    return self;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.pendingRequestCount++;

    [self _updateUI];
    
    NSLog(@"Starting request");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Finished request");
    
    self.pendingRequestCount--;
    
    [self _updateUI];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Request failed. Error=%@", error);
    
    self.pendingRequestCount--;

    NSParameterAssert(error); // must exist because we test self.error to determine if error UI is used.
    self.error = error;
    
    if ( self.pendingRequestCount > 0 ) {
        NSLog(@"[WARNING] %s was called by pending request count is %d", __FUNCTION__, self.pendingRequestCount);
    }
    
    [self _updateUI];
}

#pragma mark -
#pragma mark Public

+ (NSURLRequest *)requestFromURL:(NSURL *)requestURL
{
    if ( !requestURL ) {
        return nil;
    }

    NSURLRequest *r = [[NSURLRequest alloc] initWithURL:requestURL cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:60.0];
    return r;
}

- (void)loadRequest:(NSURLRequest *)request
{
    if ( !request ) {
        return; // nothing to load
    }
    
    self.error = nil;   // unset when we try to start a new request load
    
    if ( [request isEqual:self.request] == NO )
    {
        self.request = request;
    }

    [self.webView loadRequest:self.request];
}

- (void)reloadRequest:(id)sender
{
    [self loadRequest:self.request];
}

#pragma mark - 

- (void)_updateUI
{
    NSLog(@"Request count is %d", self.pendingRequestCount);
    
    // if no request then everything is hidden
    if ( self.request == nil ) {
        self.webView.hidden = YES;
        self.reloadButton.hidden = YES;
        [self.activityIndicatorView stopAnimating];
        return;
    }
    
    BOOL webviewHidden = NO;
    
    if ( self.pendingRequestCount <= 0 )
    {
        [self.activityIndicatorView stopAnimating];
        
        BOOL hasError = (self.error != nil);
        self.reloadButton.hidden = !hasError;
        webviewHidden = hasError;
        self.webView.hidden = hasError;
        self.isBusy = NO;
    }
    else
    {
        [self.activityIndicatorView startAnimating];
        self.reloadButton.hidden = YES;
        webviewHidden = YES;
        self.isBusy = YES;
    }
    
    if ( self.fadeTransitions ) {
        
        NSTimeInterval duration = webviewHidden ? 0 : 0.8;  // don't fade the transition to loading because that will look glitchy since user will see the webview when it is in a transitoning state of HTML loading
        [UIView animateWithDuration:duration animations:^{
            self.webView.alpha = webviewHidden ? 0 : 1;
        } completion:^(BOOL finished) {
        }];
        
    } else {
        self.webView.hidden = webviewHidden;
    }
}

@end
