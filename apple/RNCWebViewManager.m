/**
 * Copyright (c) 2015-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RNCWebViewManager.h"

#import <React/RCTUIManager.h>
#import <React/RCTDefines.h>
#import "RNCWebView.h"
#import <Minkasu2FA/Minkasu2FA.h>
#import "Minkasu2FAConstants.h"

@interface RNCWebView()
@property (nonatomic, copy) WKWebView *webView;
@end

@interface RNCWebViewManager () <RNCWebViewDelegate,Minkasu2FACallbackDelegate>
@end

@implementation RCTConvert (WKWebView)
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000 /* iOS 13 */
RCT_ENUM_CONVERTER(WKContentMode, (@{
  @"recommended": @(WKContentModeRecommended),
  @"mobile": @(WKContentModeMobile),
  @"desktop": @(WKContentModeDesktop),
}), WKContentModeRecommended, integerValue)
#endif

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000 /* iOS 15 */
RCT_ENUM_CONVERTER(RNCWebViewPermissionGrantType, (@{
  @"grantIfSameHostElsePrompt": @(RNCWebViewPermissionGrantType_GrantIfSameHost_ElsePrompt),
  @"grantIfSameHostElseDeny": @(RNCWebViewPermissionGrantType_GrantIfSameHost_ElseDeny),
  @"deny": @(RNCWebViewPermissionGrantType_Deny),
  @"grant": @(RNCWebViewPermissionGrantType_Grant),
  @"prompt": @(RNCWebViewPermissionGrantType_Prompt),
}), RNCWebViewPermissionGrantType_Prompt, integerValue)
#endif
@end

@implementation RNCWebViewManager
{
  NSConditionLock *_shouldStartLoadLock;
  BOOL _shouldStartLoad;
  Minkasu2FAConfig *minkasuConfig;
  RNCWebView *mkWebView;
}

RCT_EXPORT_MODULE()

#if !TARGET_OS_OSX
- (UIView *)view
#else
- (RCTUIView *)view
#endif // !TARGET_OS_OSX
{
  RNCWebView *webView = [RNCWebView new];
  webView.delegate = self;
  return webView;
}

RCT_EXPORT_VIEW_PROPERTY(source, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(onFileDownload, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadingStart, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadingFinish, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadingError, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadingProgress, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onHttpError, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onShouldStartLoadWithRequest, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onContentProcessDidTerminate, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(injectedJavaScript, NSString)
RCT_EXPORT_VIEW_PROPERTY(injectedJavaScriptBeforeContentLoaded, NSString)
RCT_EXPORT_VIEW_PROPERTY(injectedJavaScriptForMainFrameOnly, BOOL)
RCT_EXPORT_VIEW_PROPERTY(injectedJavaScriptBeforeContentLoadedForMainFrameOnly, BOOL)
RCT_EXPORT_VIEW_PROPERTY(javaScriptEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(javaScriptCanOpenWindowsAutomatically, BOOL)
RCT_EXPORT_VIEW_PROPERTY(allowFileAccessFromFileURLs, BOOL)
RCT_EXPORT_VIEW_PROPERTY(allowUniversalAccessFromFileURLs, BOOL)
RCT_EXPORT_VIEW_PROPERTY(allowsInlineMediaPlayback, BOOL)
RCT_EXPORT_VIEW_PROPERTY(allowsAirPlayForMediaPlayback, BOOL)
RCT_EXPORT_VIEW_PROPERTY(mediaPlaybackRequiresUserAction, BOOL)
#if WEBKIT_IOS_10_APIS_AVAILABLE
RCT_EXPORT_VIEW_PROPERTY(dataDetectorTypes, WKDataDetectorTypes)
#endif
RCT_EXPORT_VIEW_PROPERTY(contentInset, UIEdgeInsets)
RCT_EXPORT_VIEW_PROPERTY(automaticallyAdjustContentInsets, BOOL)
RCT_EXPORT_VIEW_PROPERTY(autoManageStatusBarEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(hideKeyboardAccessoryView, BOOL)
RCT_EXPORT_VIEW_PROPERTY(allowsBackForwardNavigationGestures, BOOL)
RCT_EXPORT_VIEW_PROPERTY(incognito, BOOL)
RCT_EXPORT_VIEW_PROPERTY(pagingEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(applicationNameForUserAgent, NSString)
RCT_EXPORT_VIEW_PROPERTY(cacheEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(allowsLinkPreview, BOOL)
RCT_EXPORT_VIEW_PROPERTY(allowingReadAccessToURL, NSString)
RCT_EXPORT_VIEW_PROPERTY(basicAuthCredential, NSDictionary)

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000 /* __IPHONE_11_0 */
RCT_EXPORT_VIEW_PROPERTY(contentInsetAdjustmentBehavior, UIScrollViewContentInsetAdjustmentBehavior)
#endif
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000 /* __IPHONE_13_0 */
RCT_EXPORT_VIEW_PROPERTY(automaticallyAdjustsScrollIndicatorInsets, BOOL)
#endif

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000 /* iOS 13 */
RCT_EXPORT_VIEW_PROPERTY(contentMode, WKContentMode)
#endif

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000 /* iOS 14 */
RCT_EXPORT_VIEW_PROPERTY(limitsNavigationsToAppBoundDomains, BOOL)
#endif

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 140500 /* iOS 14.5 */
RCT_EXPORT_VIEW_PROPERTY(textInteractionEnabled, BOOL)
#endif

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000 /* iOS 15 */
RCT_EXPORT_VIEW_PROPERTY(mediaCapturePermissionGrantType, RNCWebViewPermissionGrantType)
#endif

/**
 * Expose methods to enable messaging the webview.
 */
RCT_EXPORT_VIEW_PROPERTY(messagingEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onMessage, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onScroll, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(enableApplePay, BOOL)
RCT_EXPORT_VIEW_PROPERTY(menuItems, NSArray);
RCT_EXPORT_VIEW_PROPERTY(onCustomMenuSelection, RCTDirectEventBlock)

RCT_EXPORT_METHOD(postMessage:(nonnull NSNumber *)reactTag message:(NSString *)message)
{
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, RNCWebView *> *viewRegistry) {
    RNCWebView *view = viewRegistry[reactTag];
    if (![view isKindOfClass:[RNCWebView class]]) {
      RCTLogError(@"Invalid view returned from registry, expecting RNCWebView, got: %@", view);
    } else {
      [view postMessage:message];
    }
  }];
}

RCT_CUSTOM_VIEW_PROPERTY(pullToRefreshEnabled, BOOL, RNCWebView) {
  view.pullToRefreshEnabled = json == nil ? false : [RCTConvert BOOL: json];
}

RCT_CUSTOM_VIEW_PROPERTY(bounces, BOOL, RNCWebView) {
  view.bounces = json == nil ? true : [RCTConvert BOOL: json];
}

RCT_CUSTOM_VIEW_PROPERTY(useSharedProcessPool, BOOL, RNCWebView) {
  view.useSharedProcessPool = json == nil ? true : [RCTConvert BOOL: json];
}

RCT_CUSTOM_VIEW_PROPERTY(userAgent, NSString, RNCWebView) {
  view.userAgent = [RCTConvert NSString: json];
}

RCT_CUSTOM_VIEW_PROPERTY(scrollEnabled, BOOL, RNCWebView) {
  view.scrollEnabled = json == nil ? true : [RCTConvert BOOL: json];
}

RCT_CUSTOM_VIEW_PROPERTY(sharedCookiesEnabled, BOOL, RNCWebView) {
  view.sharedCookiesEnabled = json == nil ? false : [RCTConvert BOOL: json];
}

#if !TARGET_OS_OSX
RCT_CUSTOM_VIEW_PROPERTY(decelerationRate, CGFloat, RNCWebView) {
  view.decelerationRate = json == nil ? UIScrollViewDecelerationRateNormal : [RCTConvert CGFloat: json];
}
#endif // !TARGET_OS_OSX

RCT_CUSTOM_VIEW_PROPERTY(directionalLockEnabled, BOOL, RNCWebView) {
  view.directionalLockEnabled = json == nil ? true : [RCTConvert BOOL: json];
}

RCT_CUSTOM_VIEW_PROPERTY(showsHorizontalScrollIndicator, BOOL, RNCWebView) {
  view.showsHorizontalScrollIndicator = json == nil ? true : [RCTConvert BOOL: json];
}

RCT_CUSTOM_VIEW_PROPERTY(showsVerticalScrollIndicator, BOOL, RNCWebView) {
  view.showsVerticalScrollIndicator = json == nil ? true : [RCTConvert BOOL: json];
}

RCT_CUSTOM_VIEW_PROPERTY(keyboardDisplayRequiresUserAction, BOOL, RNCWebView) {
  view.keyboardDisplayRequiresUserAction = json == nil ? true : [RCTConvert BOOL: json];
}

RCT_EXPORT_METHOD(injectJavaScript:(nonnull NSNumber *)reactTag script:(NSString *)script)
{
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, RNCWebView *> *viewRegistry) {
    RNCWebView *view = viewRegistry[reactTag];
    if (![view isKindOfClass:[RNCWebView class]]) {
      RCTLogError(@"Invalid view returned from registry, expecting RNCWebView, got: %@", view);
    } else {
      [view injectJavaScript:script];
    }
  }];
}

RCT_EXPORT_METHOD(goBack:(nonnull NSNumber *)reactTag)
{
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, RNCWebView *> *viewRegistry) {
    RNCWebView *view = viewRegistry[reactTag];
    if (![view isKindOfClass:[RNCWebView class]]) {
      RCTLogError(@"Invalid view returned from registry, expecting RNCWebView, got: %@", view);
    } else {
      [view goBack];
    }
  }];
}

RCT_EXPORT_METHOD(goForward:(nonnull NSNumber *)reactTag)
{
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, RNCWebView *> *viewRegistry) {
    RNCWebView *view = viewRegistry[reactTag];
    if (![view isKindOfClass:[RNCWebView class]]) {
      RCTLogError(@"Invalid view returned from registry, expecting RNCWebView, got: %@", view);
    } else {
      [view goForward];
    }
  }];
}

RCT_EXPORT_METHOD(reload:(nonnull NSNumber *)reactTag)
{
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, RNCWebView *> *viewRegistry) {
    RNCWebView *view = viewRegistry[reactTag];
    if (![view isKindOfClass:[RNCWebView class]]) {
      RCTLogError(@"Invalid view returned from registry, expecting RNCWebView, got: %@", view);
    } else {
      [view reload];
    }
  }];
}

RCT_EXPORT_METHOD(stopLoading:(nonnull NSNumber *)reactTag)
{
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, RNCWebView *> *viewRegistry) {
    RNCWebView *view = viewRegistry[reactTag];
    if (![view isKindOfClass:[RNCWebView class]]) {
      RCTLogError(@"Invalid view returned from registry, expecting RNCWebView, got: %@", view);
    } else {
      [view stopLoading];
    }
  }];
}

RCT_EXPORT_METHOD(requestFocus:(nonnull NSNumber *)reactTag)
{
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, RNCWebView *> *viewRegistry) {
    RNCWebView *view = viewRegistry[reactTag];
    if (![view isKindOfClass:[RNCWebView class]]) {
      RCTLogError(@"Invalid view returned from registry, expecting RNCWebView, got: %@", view);
    } else {
      [view requestFocus];
    }
  }];
}

#pragma mark - Exported synchronous methods

- (BOOL)          webView:(RNCWebView *)webView
shouldStartLoadForRequest:(NSMutableDictionary<NSString *, id> *)request
             withCallback:(RCTDirectEventBlock)callback
{
  _shouldStartLoadLock = [[NSConditionLock alloc] initWithCondition:arc4random()];
  _shouldStartLoad = YES;
  request[@"lockIdentifier"] = @(_shouldStartLoadLock.condition);
  callback(request);
  
  // Block the main thread for a maximum of 250ms until the JS thread returns
  if ([_shouldStartLoadLock lockWhenCondition:0 beforeDate:[NSDate dateWithTimeIntervalSinceNow:.25]]) {
    BOOL returnValue = _shouldStartLoad;
    [_shouldStartLoadLock unlock];
    _shouldStartLoadLock = nil;
    return returnValue;
  } else {
    RCTLogWarn(@"Did not receive response to shouldStartLoad in time, defaulting to YES");
    return YES;
  }
}

RCT_EXPORT_METHOD(startLoadWithResult:(BOOL)result lockIdentifier:(NSInteger)lockIdentifier)
{
  if ([_shouldStartLoadLock tryLockWhenCondition:lockIdentifier]) {
    _shouldStartLoad = result;
    [_shouldStartLoadLock unlockWithCondition:0];
  } else {
    RCTLogWarn(@"startLoadWithResult invoked with invalid lockIdentifier: "
               "got %lld, expected %lld", (long long)lockIdentifier, (long long)_shouldStartLoadLock.condition);
  }
}

RCT_EXPORT_VIEW_PROPERTY(onMinkasu2FAInit, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onMinkasu2FAResult, RCTDirectEventBlock)

-(void)onPayByAttribute{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"minkasuPayByAttribute" object:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        Minkasu2FAConfig *config = [self createConfig:mkWebView.minkasu2FAConfig];
        NSString *status = STATUS_SUCCESS;
        NSError *err = nil;
        if (self.isSkipInit) {
            self->mkWebView.onMinkasu2FAInit(@{@"status":status,@"initType":INIT_BY_ATTRIBUTE });
        }else{
            @try {
                [Minkasu2FA initReactSDKWithWKWebView:self->mkWebView.webView andConfiguration:config reactSDKVersion:REACT_NATIVE_MINKASU2FA_SDK_VERSION inViewController:nil error:&err];
                self->mkWebView.onMinkasu2FAInit(@{@"status":status,@"initType":INIT_BY_ATTRIBUTE });
            } @catch (NSException *exception) {
                status = STATUS_FAILURE;
                self->mkWebView.onMinkasu2FAInit(@{@"status":status,@"initType":INIT_BY_ATTRIBUTE,@"errorMessage":exception.reason,@"errorCode":exception.name});
            }
        }
    });
}

RCT_CUSTOM_VIEW_PROPERTY(minkasu2FAConfig, NSString, RNCWebView) {
    view.minkasu2FAConfig = json == nil? nil:[RCTConvert NSString: json];
    mkWebView = view;
    if(view.webView){
        [self onPayByAttribute];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPayByAttribute) name:@"minkasuPayByAttribute" object:nil];
    }
}


-(void) onPayByMethod{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"minkasuPayByMethod" object:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *status = STATUS_SUCCESS;
        NSError *err = nil;
        if (self.isSkipInit) {
            self->mkWebView.onMinkasu2FAInit(@{@"status":status,@"initType":INIT_BY_METHOD });
        }else{
            @try {
                [Minkasu2FA initReactSDKWithWKWebView:self->mkWebView.webView andConfiguration:self->minkasuConfig reactSDKVersion:REACT_NATIVE_MINKASU2FA_SDK_VERSION inViewController:nil error:&err];
                self->mkWebView.onMinkasu2FAInit(@{@"status":status,@"initType":INIT_BY_METHOD });
            } @catch (NSException *exception) {
                status = STATUS_FAILURE;
                self->mkWebView.onMinkasu2FAInit(@{@"status":status,@"initType":INIT_BY_METHOD,@"errorMessage":exception.reason,@"errorCode":exception.name});
            }
        }
    });
}

RCT_EXPORT_METHOD(initMinkasu2FA:(nonnull NSNumber *)reactTag minkasu2FAConfig:(NSString*)minkasu2FAConfig)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, RNCWebView *> *viewRegistry) {
        RNCWebView *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[RNCWebView class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting RNCWebView, got: %@", view);
        } else {
            Minkasu2FAConfig *config = [self createConfig:minkasu2FAConfig];
            self->minkasuConfig = config;
            self->mkWebView = view;
            if(view.webView){
                [self onPayByMethod];
            }else{
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPayByMethod) name:@"minkasuPayByMethod" object:nil];
            }
        }
    }];
}

-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

// - (NSDictionary *)constantsToExport{
    
//     NSDictionary *export = @{@"MERCHANT_ID":MERCHANT_ID,
//                              @"MERCHANT_TOKEN":MERCHANT_TOKEN,
//                              @"CUSTOMER_ID":CUSTOMER_ID,
//                              @"CUSTOMER_INFO":CUSTOMER_INFO,
//                              @"CUSTOMER_FIRST_NAME":CUSTOMER_FIRST_NAME,
//                              @"CUSTOMER_LAST_NAME":CUSTOMER_LAST_NAME,
//                              @"CUSTOMER_EMAIL":CUSTOMER_EMAIL,
//                              @"CUSTOMER_PHONE":CUSTOMER_PHONE,
//                              @"CUSTOMER_ADDRESS_INFO":CUSTOMER_ADDRESS_INFO,
//                              @"CUSTOMER_ADDRESS_LINE_1":CUSTOMER_ADDRESS_LINE_1,
//                              @"CUSTOMER_ADDRESS_LINE_2":CUSTOMER_ADDRESS_LINE_2,
//                              @"CUSTOMER_ADDRESS_CITY":CUSTOMER_ADDRESS_CITY,
//                              @"CUSTOMER_ADDRESS_STATE":CUSTOMER_ADDRESS_STATE,
//                              @"CUSTOMER_ADDRESS_COUNTRY":CUSTOMER_ADDRESS_COUNTRY,
//                              @"CUSTOMER_ADDRESS_ZIP_CODE":CUSTOMER_ADDRESS_ZIP_CODE,
//                              @"CUSTOMER_ORDER_INFO":CUSTOMER_ORDER_INFO,
//                              @"CUSTOMER_ORDER_ID":CUSTOMER_ORDER_ID,
//                              @"SDK_MODE_SANDBOX":SDK_MODE_SANDBOX,
//                              @"STATUS":STATUS,
//                              @"STATUS_SUCCESS":STATUS_SUCCESS,
//                              @"STATUS_FAILURE":STATUS_FAILURE,
//                              @"ERROR_MESSAGE":ERROR_MESSAGE,
//                              @"ERROR_CODE":ERROR_CODE,
//                              @"INIT_TYPE":INIT_TYPE,
//                              @"INIT_BY_METHOD":INIT_BY_METHOD,
//                              @"INIT_BY_ATTRIBUTE":INIT_BY_ATTRIBUTE,
//                              @"SKIP_INIT":SKIP_INIT,
//                              @"NAVIGATION_BAR_COLOR":NAVIGATION_BAR_COLOR,
//                              @"NAVIGATION_BAR_TEXT_COLOR":NAVIGATION_BAR_TEXT_COLOR,
//                              @"BUTTON_BACKGROUND_COLOR":BUTTON_BACKGROUND_COLOR,
//                              @"BUTTON_TEXT_COLOR":BUTTON_TEXT_COLOR,
//                              @"DARK_MODE_NAVIGATION_BAR_COLOR":DARK_MODE_NAVIGATION_BAR_COLOR,
//                              @"DARK_MODE_NAVIGATION_BAR_TEXT_COLOR":DARK_MODE_NAVIGATION_BAR_TEXT_COLOR,
//                              @"DARK_MODE_BUTTON_BACKGROUND_COLOR":DARK_MODE_BUTTON_BACKGROUND_COLOR,
//                              @"DARK_MODE_BUTTON_TEXT_COLOR":DARK_MODE_BUTTON_TEXT_COLOR,
//                              @"SUPPORT_DARK_MODE":SUPPORT_DARK_MODE,
//                              @"IOS_THEME_OBJ":IOS_THEME_OBJ,
//                              @"MINKASU_2FA_USER_AGENT":[Minkasu2FA getMinkasu2FAUserAgent],
//                              @"PARTNER_MERCHANT_INFO":PARTNER_MERCHANT_INFO,
//                              @"PARTNER_MERCHANT_ID":PARTNER_MERCHANT_ID,
//                              @"PARTNER_MERCHANT_NAME":PARTNER_MERCHANT_NAME,
//                              @"PARTNER_TRANSACTION_ID":PARTNER_TRANSACTION_ID,
//                              @"CUSTOMER_BILLING_CATEGORY":BILLING_CATEGORY,
//                              @"CUSTOMER_CUSTOM_DATA":CUSTOM_DATA,
//                              @"RESULT_INFO_TYPE":RESULT_INFO_TYPE,
//                              @"RESULT_DATA":RESULT_DATA};
//     return export;
// }



-(Minkasu2FAConfig*)createConfig:(NSString*)mkConfig{
    NSError *jsonError;
    NSData *objectData = [mkConfig dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *minkasu2FAConfig = [NSJSONSerialization JSONObjectWithData:objectData
                                          options:NSJSONReadingMutableContainers
                                            error:&jsonError];
    
    Minkasu2FAConfig *config = [Minkasu2FAConfig new];
    config.delegate = self;
    if (minkasu2FAConfig && !minkasu2FAConfig[SKIP_INIT]) {
        Minkasu2FACustomerInfo *customer = [Minkasu2FACustomerInfo new];
        Minkasu2FAAddress *address = [Minkasu2FAAddress new];
        Minkasu2FAOrderInfo *orderInfo = [Minkasu2FAOrderInfo new];
        if (minkasu2FAConfig[CUSTOMER_ADDRESS_INFO] && minkasu2FAConfig[CUSTOMER_ADDRESS_INFO] != nil) {
            if (minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_LINE_1]) {
                address.line1 = minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_LINE_1];
            }
            if (minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_LINE_2]) {
                address.line2 = minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_LINE_2];
            }
            if (minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_CITY]) {
                address.city = minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_CITY];
            }
            if (minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_STATE]) {
                address.state = minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_STATE];
            }
            if (minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_COUNTRY]) {
                address.country = minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_COUNTRY];
            }
            if (minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_ZIP_CODE]) {
                address.zipCode = minkasu2FAConfig[CUSTOMER_ADDRESS_INFO][CUSTOMER_ADDRESS_ZIP_CODE];
            }
        }
        if (minkasu2FAConfig[CUSTOMER_INFO] && minkasu2FAConfig[CUSTOMER_INFO] != nil ) {
            if (minkasu2FAConfig[CUSTOMER_INFO][CUSTOMER_FIRST_NAME]) {
                customer.firstName = minkasu2FAConfig[CUSTOMER_INFO][CUSTOMER_FIRST_NAME];
            }
            if (minkasu2FAConfig[CUSTOMER_INFO][CUSTOMER_LAST_NAME]) {
                customer.lastName = minkasu2FAConfig[CUSTOMER_INFO][CUSTOMER_LAST_NAME];
            }
            if (minkasu2FAConfig[CUSTOMER_INFO][CUSTOMER_PHONE]) {
                customer.phone = minkasu2FAConfig[CUSTOMER_INFO][CUSTOMER_PHONE];
            }
            if (minkasu2FAConfig[CUSTOMER_INFO][CUSTOMER_EMAIL]) {
                customer.email = minkasu2FAConfig[CUSTOMER_INFO][CUSTOMER_EMAIL];
            }
        }
        customer.address = address;
        if (minkasu2FAConfig[MERCHANT_ID]) {
            config._id = minkasu2FAConfig[MERCHANT_ID];
        }
        if (minkasu2FAConfig[MERCHANT_TOKEN]) {
            config.token = minkasu2FAConfig[MERCHANT_TOKEN];
        }
        if (minkasu2FAConfig[CUSTOMER_ID]) {
            config.merchantCustomerId = minkasu2FAConfig[CUSTOMER_ID];
        }
        config.customerInfo = customer;
        if (minkasu2FAConfig[SDK_MODE_SANDBOX]) {
            config.sdkMode = [minkasu2FAConfig[SDK_MODE_SANDBOX]  isEqual: @1] ? MINKASU2FA_SANDBOX_MODE : MINKASU2FA_PRODUCTION_MODE;
        }
        if (minkasu2FAConfig[CUSTOMER_ORDER_INFO] && minkasu2FAConfig[CUSTOMER_ORDER_INFO] != nil) {
            if (minkasu2FAConfig[CUSTOMER_ORDER_INFO][CUSTOMER_ORDER_ID]) {
                orderInfo.orderId = minkasu2FAConfig[CUSTOMER_ORDER_INFO][CUSTOMER_ORDER_ID];
            }
            if (minkasu2FAConfig[CUSTOMER_ORDER_INFO][BILLING_CATEGORY]) {
                orderInfo.billingCategory = minkasu2FAConfig[CUSTOMER_ORDER_INFO][BILLING_CATEGORY];
            }
            if (minkasu2FAConfig[CUSTOMER_ORDER_INFO][CUSTOM_DATA]) {
                orderInfo.billingCategory = minkasu2FAConfig[CUSTOMER_ORDER_INFO][CUSTOM_DATA];
            }
        }
        
        config.orderInfo = orderInfo;
        Minkasu2FACustomTheme *mkcolorTheme = [Minkasu2FACustomTheme new];
        if (minkasu2FAConfig[IOS_THEME_OBJ] && minkasu2FAConfig[IOS_THEME_OBJ] != nil) {
            if (minkasu2FAConfig[IOS_THEME_OBJ][NAVIGATION_BAR_COLOR]) {
                mkcolorTheme.navigationBarColor = [self colorFromHexString:minkasu2FAConfig[IOS_THEME_OBJ][NAVIGATION_BAR_COLOR]];
            }
            if (minkasu2FAConfig[IOS_THEME_OBJ][NAVIGATION_BAR_TEXT_COLOR]) {
                mkcolorTheme.navigationBarTextColor = [self colorFromHexString:minkasu2FAConfig[IOS_THEME_OBJ][NAVIGATION_BAR_TEXT_COLOR]];
            }
            if (minkasu2FAConfig[IOS_THEME_OBJ][BUTTON_BACKGROUND_COLOR]) {
                mkcolorTheme.buttonBackgroundColor = [self colorFromHexString:minkasu2FAConfig[IOS_THEME_OBJ][BUTTON_BACKGROUND_COLOR]];
            }
            if (minkasu2FAConfig[IOS_THEME_OBJ][BUTTON_TEXT_COLOR]) {
                mkcolorTheme.buttonTextColor = [self colorFromHexString:minkasu2FAConfig[IOS_THEME_OBJ][BUTTON_TEXT_COLOR]];
            }
            if (minkasu2FAConfig[IOS_THEME_OBJ][DARK_MODE_NAVIGATION_BAR_COLOR]) {
                mkcolorTheme.darkModeNavigationBarColor = [self colorFromHexString:minkasu2FAConfig[IOS_THEME_OBJ][DARK_MODE_NAVIGATION_BAR_COLOR]];
            }
            if (minkasu2FAConfig[IOS_THEME_OBJ][DARK_MODE_NAVIGATION_BAR_TEXT_COLOR]) {
                mkcolorTheme.darkModeNavigationBarTextColor = [self colorFromHexString:minkasu2FAConfig[IOS_THEME_OBJ][DARK_MODE_NAVIGATION_BAR_TEXT_COLOR]];
            }
            if (minkasu2FAConfig[IOS_THEME_OBJ][DARK_MODE_BUTTON_BACKGROUND_COLOR]) {
                mkcolorTheme.darkModeButtonBackgroundColor = [self colorFromHexString:minkasu2FAConfig[IOS_THEME_OBJ][DARK_MODE_BUTTON_BACKGROUND_COLOR]];
            }
            if (minkasu2FAConfig[IOS_THEME_OBJ][DARK_MODE_BUTTON_TEXT_COLOR]) {
                mkcolorTheme.darkModeButtonTextColor = [self colorFromHexString:minkasu2FAConfig[IOS_THEME_OBJ][DARK_MODE_BUTTON_TEXT_COLOR]];
            }
            if (minkasu2FAConfig[IOS_THEME_OBJ][SUPPORT_DARK_MODE]) {
                mkcolorTheme.supportDarkMode = minkasu2FAConfig[IOS_THEME_OBJ][SUPPORT_DARK_MODE];
            }
        }
        config.customTheme = mkcolorTheme;
    }else{
        _isSkipInit = true;
    }
    return config;
}

+(BOOL)requiresMainQueueSetup
{  return YES;  // only do this if your module initialization relies on calling UIKit!
}

- (void)minkasu2FACallback:(Minkasu2FACallbackInfo *)minkasu2FACallbackInfo{
    self->mkWebView.onMinkasu2FAResult(@{@"infoType":@(minkasu2FACallbackInfo.infoType),@"data":minkasu2FACallbackInfo.data});
}

@end
