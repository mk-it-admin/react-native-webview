//
//  RNCWebViewModule.m
//  react-native-webview
//
//  Created by Habibur Rahuman on 11/12/24.
//

#import "RNCWebViewModule.h"
#import <Minkasu2FA/Minkasu2FA.h>
#import "Minkasu2FAConstants.h"

@implementation RNCWebViewModule

RCT_EXPORT_MODULE(RNCWebView)

- (NSDictionary *)constantsToExport{
    
    NSDictionary *minkasu2FAConstants = @{@"CHANGE_PIN":CHANGE_PIN,
                             @"ENABLE_BIOMETRICS":ENABLE_BIOMETRICS,
                             @"DISABLE_BIOMETRICS":DISABLE_BIOMETRICS,
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
                             @"BUTTON_BACKGROUND_COLOR":BUTTON_BACKGROUND_COLOR,
                             @"BUTTON_TEXT_COLOR":BUTTON_TEXT_COLOR,
                             @"DARK_MODE_NAVIGATION_BAR_COLOR":DARK_MODE_NAVIGATION_BAR_COLOR,
                             @"DARK_MODE_NAVIGATION_BAR_TEXT_COLOR":DARK_MODE_NAVIGATION_BAR_TEXT_COLOR,
                             @"DARK_MODE_BUTTON_BACKGROUND_COLOR":DARK_MODE_BUTTON_BACKGROUND_COLOR,
                             @"DARK_MODE_BUTTON_TEXT_COLOR":DARK_MODE_BUTTON_TEXT_COLOR,
                             @"SUPPORT_DARK_MODE":SUPPORT_DARK_MODE,
                             @"IOS_THEME_OBJ":IOS_THEME_OBJ,
                             @"MINKASU_2FA_USER_AGENT":[Minkasu2FA getMinkasu2FAUserAgent],
                             @"PARTNER_MERCHANT_INFO":PARTNER_MERCHANT_INFO,
                             @"PARTNER_MERCHANT_ID":PARTNER_MERCHANT_ID,
                             @"PARTNER_MERCHANT_NAME":PARTNER_MERCHANT_NAME,
                             @"PARTNER_TRANSACTION_ID":PARTNER_TRANSACTION_ID,
                             @"CUSTOMER_BILLING_CATEGORY":BILLING_CATEGORY,
                             @"CUSTOMER_CUSTOM_DATA":CUSTOM_DATA,
                             @"RESULT_INFO_TYPE":RESULT_INFO_TYPE,
                             @"RESULT_DATA":RESULT_DATA
    };

    NSDictionary *export = @{@"MINKASU2FA_CONSTANTS":minkasu2FAConstants};
    return export;
}



RCT_REMAP_METHOD(getAvailableMinkasu2FAOperations,
                 resolver: (RCTPromiseResolveBlock)resolve
                 rejecter: (RCTPromiseRejectBlock)reject)
{
    NSMutableArray *minkasu2FAOperations = [Minkasu2FA getAvailableMinkasu2FAOperations];
    NSMutableDictionary *operations = [[NSMutableDictionary alloc] init];
    if([minkasu2FAOperations count] > 0){
        for (NSNumber *operation in minkasu2FAOperations){
            if(operation.intValue == MINKASU2FA_CHANGE_PAYPIN) {
                [operations setObject:@"CHANGE PIN" forKey:CHANGE_PIN];
            }else if(operation.intValue == MINKASU2FA_ENABLE_BIOMETRY) {
                [operations setObject:@"ENABLE BIOMETRICS" forKey:ENABLE_BIOMETRICS];
            } else if(operation.intValue == MINKASU2FA_DISABLE_BIOMETRY) {
                [operations setObject:@"DISABLE BIOMETRICS" forKey:DISABLE_BIOMETRICS];
            }
        }
    }
    resolve(operations);
}

RCT_REMAP_METHOD(performMinkasu2FAOperation,
                 merchantCustomerId:(NSString *)merchantCustomerId
                 operationTypeStr:(NSString *)operationTypeStr
                 colourTheme:(NSDictionary*)colourTheme
                 resolver: (RCTPromiseResolveBlock)resolve
                 rejecter: (RCTPromiseRejectBlock)reject){
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
            if (colourTheme[BUTTON_BACKGROUND_COLOR]) {
                mkcolorTheme.buttonBackgroundColor = [self colorFromHexString:colourTheme[BUTTON_BACKGROUND_COLOR]];
            }
            if (colourTheme[BUTTON_TEXT_COLOR]) {
                mkcolorTheme.buttonTextColor = [self colorFromHexString:colourTheme[BUTTON_TEXT_COLOR]];
            }
            if (colourTheme[DARK_MODE_NAVIGATION_BAR_COLOR]) {
                mkcolorTheme.darkModeNavigationBarColor = [self colorFromHexString:colourTheme[DARK_MODE_NAVIGATION_BAR_COLOR]];
            }
            if (colourTheme[DARK_MODE_NAVIGATION_BAR_TEXT_COLOR]) {
                mkcolorTheme.darkModeNavigationBarTextColor = [self colorFromHexString:colourTheme[DARK_MODE_NAVIGATION_BAR_TEXT_COLOR]];
            }
            if (colourTheme[DARK_MODE_BUTTON_BACKGROUND_COLOR]) {
                mkcolorTheme.darkModeButtonBackgroundColor = [self colorFromHexString:colourTheme[DARK_MODE_BUTTON_BACKGROUND_COLOR]];
            }
            if (colourTheme[DARK_MODE_BUTTON_TEXT_COLOR]) {
                mkcolorTheme.darkModeButtonTextColor = [self colorFromHexString:colourTheme[DARK_MODE_BUTTON_TEXT_COLOR]];
            }
            if (colourTheme[SUPPORT_DARK_MODE]) {
                mkcolorTheme.supportDarkMode = colourTheme[SUPPORT_DARK_MODE];
            }
        }
        if ([operationTypeStr isEqualToString:@"CHANGE PIN"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Minkasu2FA performMinkasu2FAOperation:MINKASU2FA_CHANGE_PAYPIN merchantCustomerId:merchantCustomerId customTheme:mkcolorTheme];
            });
        }else if([operationTypeStr isEqualToString:@"ENABLE BIOMETRICS"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [Minkasu2FA performMinkasu2FAOperation:MINKASU2FA_ENABLE_BIOMETRY merchantCustomerId:merchantCustomerId customTheme:mkcolorTheme];
            });
        }else if ([operationTypeStr isEqualToString:@"DISABLE BIOMETRICS"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [Minkasu2FA performMinkasu2FAOperation:MINKASU2FA_DISABLE_BIOMETRY merchantCustomerId:merchantCustomerId customTheme:mkcolorTheme];
            });
        }
        resolve(STATUS_SUCCESS);
    }
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
