#import "RNCWebViewModule.h"

#import "RNCWebViewDecisionManager.h"
#import <Minkasu2FA/Minkasu2FA.h>
#import "Minkasu2FAConstants.h"
#ifdef RCT_NEW_ARCH_ENABLED
#import <React/RCTFabricComponentsPlugins.h>
#endif /* RCT_NEW_ARCH_ENABLED */

@implementation RNCWebViewModule

RCT_EXPORT_MODULE(RNCWebViewModule)

RCT_EXPORT_METHOD(isFileUploadSupported:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    if (resolve) {
        resolve(@(YES));
    }
}

RCT_EXPORT_METHOD(shouldStartLoadWithLockIdentifier:(BOOL)shouldStart lockIdentifier:(double)lockIdentifier)
{
    [[RNCWebViewDecisionManager getInstance] setResult:shouldStart forLockIdentifier:(int)lockIdentifier];
}

#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const facebook::react::ObjCTurboModule::InitParams &)params {
  return std::make_shared<facebook::react::NativeRNCWebViewModuleSpecJSI>(params);
}
#endif /* RCT_NEW_ARCH_ENABLED */

Class RNCWebViewModuleCls(void) {
  return RNCWebViewModule.class;
}

- (NSDictionary<NSString *, id> *)constantsToExport {
    return [self getConstants];
}

- (NSDictionary<NSString *, id> *)getConstants {
    __block NSDictionary<NSString *, id> *minkasu2FAConstants;
    __weak __typeof(self) weakSelf = self;
    RCTUnsafeExecuteOnMainQueueSync(^{
      minkasu2FAConstants = @{@"DISABLE_BIOMETRICS":DISABLE_BIOMETRICS,
                             @"MERCHANT_ID":MERCHANT_ID,
                             @"MERCHANT_TOKEN":MERCHANT_TOKEN,
                             @"CUSTOMER_ID":CUSTOMER_ID,
                             @"CUSTOMER_INFO":CUSTOMER_INFO,
                             @"CUSTOMER_FIRST_NAME":CUSTOMER_FIRST_NAME,
                             @"CUSTOMER_LAST_NAME":CUSTOMER_LAST_NAME,
                             @"CUSTOMER_EMAIL":CUSTOMER_EMAIL,
                             @"CUSTOMER_PHONE":CUSTOMER_PHONE,
                             @"CUSTOMER_ADDRESS_INFO":CUSTOMER_ADDRESS_INFO,
                             @"CUSTOMER_ADDRESS_LINE_1":CUSTOMER_ADDRESS_LINE_1,
                             @"CUSTOMER_ADDRESS_LINE_2":CUSTOMER_ADDRESS_LINE_2,
                             @"CUSTOMER_ADDRESS_CITY":CUSTOMER_ADDRESS_CITY,
                             @"CUSTOMER_ADDRESS_STATE":CUSTOMER_ADDRESS_STATE,
                             @"CUSTOMER_ADDRESS_COUNTRY":CUSTOMER_ADDRESS_COUNTRY,
                             @"CUSTOMER_ADDRESS_ZIP_CODE":CUSTOMER_ADDRESS_ZIP_CODE,
                             @"CUSTOMER_ORDER_INFO":CUSTOMER_ORDER_INFO,
                             @"CUSTOMER_ORDER_ID":CUSTOMER_ORDER_ID,
                             @"SDK_MODE_SANDBOX":SDK_MODE_SANDBOX,
                             @"STATUS":STATUS,
                             @"STATUS_SUCCESS":STATUS_SUCCESS,
                             @"STATUS_FAILURE":STATUS_FAILURE,
                             @"ERROR_MESSAGE":ERROR_MESSAGE,
                             @"ERROR_CODE":ERROR_CODE,
                             @"INIT_TYPE":INIT_TYPE,
                             @"INIT_BY_METHOD":INIT_BY_METHOD,
                             @"INIT_BY_ATTRIBUTE":INIT_BY_ATTRIBUTE,
                             @"SKIP_INIT":SKIP_INIT,
                             @"NAVIGATION_BAR_COLOR":NAVIGATION_BAR_COLOR,
                             @"NAVIGATION_BAR_TEXT_COLOR":NAVIGATION_BAR_TEXT_COLOR,
                             @"DARK_MODE_NAVIGATION_BAR_COLOR":DARK_MODE_NAVIGATION_BAR_COLOR,
                             @"DARK_MODE_NAVIGATION_BAR_TEXT_COLOR":DARK_MODE_NAVIGATION_BAR_TEXT_COLOR,
                             @"SUPPORT_DARK_MODE":SUPPORT_DARK_MODE,
                             @"IOS_THEME_OBJ":IOS_THEME_OBJ,
                             @"MINKASU_2FA_USER_AGENT":[Minkasu2FA getMinkasu2FAUserAgent],
                             @"PARTNER_MERCHANT_INFO":PARTNER_MERCHANT_INFO,
                             @"PARTNER_MERCHANT_ID":PARTNER_MERCHANT_ID,
                             @"PARTNER_MERCHANT_NAME":PARTNER_MERCHANT_NAME,
                             @"PARTNER_TRANSACTION_ID":PARTNER_TRANSACTION_ID,
                             @"CUSTOMER_BILLING_CATEGORY":BILLING_CATEGORY,
                             @"CUSTOMER_ORDER_DETAILS":ORDER_DETAILS,
                             @"RESULT_INFO_TYPE":RESULT_INFO_TYPE,
                             @"RESULT_DATA":RESULT_DATA,
                             @"INFO_TYPE_RESULT":@(1),
                             @"INFO_TYPE_EVENT":@(2),
                             @"INFO_TYPE_PROGRESS":@(3)
        };
    });
    NSDictionary *exportConstants = @{@"MINKASU2FA_CONSTANTS":minkasu2FAConstants};
    return exportConstants;
}

#ifdef RCT_NEW_ARCH_ENABLED
- (void)getAvailableMinkasu2FAOperations:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {

    resolve([self getMinkasu2FAOperations]);
}

- (void)performMinkasu2FAOperation:(NSString *)merchantCustomerId minkasuOperationType:(NSString *)minkasuOperationType colourTheme:(NSDictionary *)colourTheme resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {

    if ([self performMK2FAOperations:merchantCustomerId minkasuOperationType:minkasuOperationType colourTheme:colourTheme]) {
        resolve(STATUS_SUCCESS);
    } else {
        resolve(STATUS_FAILURE);
    }
}

#else
RCT_REMAP_METHOD(getAvailableMinkasu2FAOperations,
                 resolver: (RCTPromiseResolveBlock)resolve
                 rejecter: (RCTPromiseRejectBlock)reject)
{

    resolve([self getMinkasu2FAOperations]);
}

RCT_REMAP_METHOD(performMinkasu2FAOperation,
                 merchantCustomerId:(NSString *)merchantCustomerId
                 minkasuOperationType:(NSString *)minkasuOperationType
                 colourTheme:(NSDictionary*)colourTheme
                 resolver: (RCTPromiseResolveBlock)resolve
                 rejecter: (RCTPromiseRejectBlock)reject){
    if ([self performMK2FAOperations:merchantCustomerId minkasuOperationType:minkasuOperationType colourTheme:colourTheme]) {
        resolve(STATUS_SUCCESS);
    } else {
        resolve(STATUS_FAILURE);
    }
}
#endif

-(NSDictionary*) getMinkasu2FAOperations {
    NSMutableArray *minkasu2FAOperations = [Minkasu2FA getAvailableMinkasu2FAOperations];
    NSMutableDictionary *operations = [[NSMutableDictionary alloc] init];
    if([minkasu2FAOperations count] > 0){
        for (NSNumber *operation in minkasu2FAOperations){
            if(operation.intValue == MINKASU2FA_DISABLE_BIOMETRY) {
                [operations setObject:@"DISABLE BIOMETRICS" forKey:DISABLE_BIOMETRICS];
            }
        }
    }
    return operations;
}

-(BOOL) performMK2FAOperations:(NSString *)merchantCustomerId minkasuOperationType:(NSString *)minkasuOperationType colourTheme:(NSDictionary*)colourTheme {

    NSMutableArray *minkasu2FAOperations = [Minkasu2FA getAvailableMinkasu2FAOperations];
    if([minkasu2FAOperations count] > 0){
        Minkasu2FACustomTheme *mkcolorTheme = [Minkasu2FACustomTheme new];
        if (colourTheme && colourTheme != nil) {
            if (colourTheme[NAVIGATION_BAR_COLOR]) {
                mkcolorTheme.navigationBarColor = [self colorFromHexString:colourTheme[NAVIGATION_BAR_COLOR]];
            }
            if (colourTheme[NAVIGATION_BAR_TEXT_COLOR]) {
                mkcolorTheme.navigationBarTextColor = [self colorFromHexString:colourTheme[NAVIGATION_BAR_TEXT_COLOR]];
            }
            if (colourTheme[DARK_MODE_NAVIGATION_BAR_COLOR]) {
                mkcolorTheme.darkModeNavigationBarColor = [self colorFromHexString:colourTheme[DARK_MODE_NAVIGATION_BAR_COLOR]];
            }
            if (colourTheme[DARK_MODE_NAVIGATION_BAR_TEXT_COLOR]) {
                mkcolorTheme.darkModeNavigationBarTextColor = [self colorFromHexString:colourTheme[DARK_MODE_NAVIGATION_BAR_TEXT_COLOR]];
            }
            if (colourTheme[SUPPORT_DARK_MODE]) {
                mkcolorTheme.supportDarkMode = colourTheme[SUPPORT_DARK_MODE];
            }
        }
        if ([minkasuOperationType isEqualToString:@"CHANGE PIN"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Minkasu2FA performMinkasu2FAOperation:MINKASU2FA_CHANGE_PAYPIN merchantCustomerId:merchantCustomerId customTheme:mkcolorTheme];
            });
        }else if([minkasuOperationType isEqualToString:@"ENABLE BIOMETRICS"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [Minkasu2FA performMinkasu2FAOperation:MINKASU2FA_ENABLE_BIOMETRY merchantCustomerId:merchantCustomerId customTheme:mkcolorTheme];
            });
        }else if ([minkasuOperationType isEqualToString:@"DISABLE BIOMETRICS"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [Minkasu2FA performMinkasu2FAOperation:MINKASU2FA_DISABLE_BIOMETRY merchantCustomerId:merchantCustomerId customTheme:mkcolorTheme];
            });
        }
        return true;
    }
    return false;
}

-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;  // only do this if your module initialization relies on calling UIKit!
}
@end
