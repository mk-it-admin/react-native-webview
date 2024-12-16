package com.reactnativecommunity.webview;

import android.app.Activity;
import android.util.Log;
import android.webkit.WebView;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.minkasu.android.twofa.enums.Minkasu2faOperationType;
import com.minkasu.android.twofa.exceptions.MissingDataException;
import com.minkasu.android.twofa.model.Address;
import com.minkasu.android.twofa.model.Config;
import com.minkasu.android.twofa.model.CustomerInfo;
import com.minkasu.android.twofa.model.OrderInfo;
import com.minkasu.android.twofa.model.PartnerInfo;
import com.minkasu.android.twofa.sdk.Minkasu2faCallback;
import com.minkasu.android.twofa.sdk.Minkasu2faCallbackInfo;
import com.minkasu.android.twofa.sdk.Minkasu2faSDK;
import com.reactnativecommunity.webview.events.TopMinkasu2FAInitEvent;
import com.reactnativecommunity.webview.events.TopMinkasu2FAResultEvent;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

class Minkasu2FAUtil {
  static final String RCT_MINKASU_2FA_SDK_VERSION = "2.0.0";
  static final String INIT_BY_METHOD = "byMethod";
  static final String INIT_BY_PROPERTY = "byProperty";

  private static final String STATUS = "status";
  private static final String SUCCESS = "Success";
  private static final String FAILURE = "Failure";
  private static final String ERROR_MESSAGE = "errorMessage";
  private static final String ERROR_CODE = "errorCode";
  private static final String INIT_TYPE = "initType";
  private static final String M_ID = "m_id";
  private static final String M_TOKEN = "m_token";
  private static final String CUSTOMER_ID = "customer_id";
  private static final String CUSTOMER_INFO = "customer_info";
  private static final String C_FIRST_NAME = "c_first_name";
  private static final String C_LAST_NAME = "c_last_name";
  private static final String C_EMAIL = "c_email";
  private static final String C_PHONE = "c_phone";
  private static final String CUSTOMER_ADDRESS_INFO = "customer_address_info";
  private static final String ADDRESS_LINE_1 = "address_line_1";
  private static final String ADDRESS_LINE_2 = "address_line_2";
  private static final String ADDRESS_CITY = "address_city";
  private static final String ADDRESS_STATE = "address_state";
  private static final String ADDRESS_COUNTRY = "address_country";
  private static final String ADDRESS_ZIP_CODE = "address_zip_code";
  private static final String CUSTOMER_ORDER_INFO = "customer_order_info";
  private static final String ORDER_ID = "order_id";
  private static final String BILLING_CATEGORY = "billing_category";
  private static final String CUSTOM_DATA = "custom_data";
  private static final String PARTNER_MERCHANT_INFO = "partner_merchant_info";
  private static final String PARTNER_MERCHANT_ID = "partner_merchant_id";
  private static final String PARTNER_MERCHANT_NAME = "partner_merchant_name";
  private static final String PARTNER_TRANSACTION_ID = "partner_merchant_transaction_id";

  private static final String SDK_MODE_SANDBOX = "sdk_mode_sandbox";
  private static final String SKIP_INIT = "skip_init";

  private static final String RESULT_INFO_TYPE = "infoType";
  private static final String RESULT_DATA = "data";

  private static final String CHANGE_PIN = "changePin";
  private static final String ENABLE_BIOMETRICS = "enableBiometrics";
  private static final String DISABLE_BIOMETRICS = "disableBiometrics";

  final private ReactApplicationContext mContext;

  Minkasu2FAUtil(ReactApplicationContext context) {
    this.mContext = context;
  }

  void setConstants(@NonNull Map<String, Object> exportConstant) {
    HashMap<String, Object> minkasu2FAConstants = new HashMap<>();
    minkasu2FAConstants.put("CHANGE_PIN", CHANGE_PIN);
    minkasu2FAConstants.put("ENABLE_BIOMETRICS", ENABLE_BIOMETRICS);
    minkasu2FAConstants.put("DISABLE_BIOMETRICS", DISABLE_BIOMETRICS);
    minkasu2FAConstants.put("MERCHANT_ID", M_ID);
    minkasu2FAConstants.put("MERCHANT_TOKEN", M_TOKEN);
    minkasu2FAConstants.put("CUSTOMER_ID", CUSTOMER_ID);
    minkasu2FAConstants.put("PARTNER_MERCHANT_INFO", PARTNER_MERCHANT_INFO);
    minkasu2FAConstants.put("PARTNER_MERCHANT_ID", PARTNER_MERCHANT_ID);
    minkasu2FAConstants.put("PARTNER_MERCHANT_NAME", PARTNER_MERCHANT_NAME);
    minkasu2FAConstants.put("PARTNER_TRANSACTION_ID", PARTNER_TRANSACTION_ID);
    minkasu2FAConstants.put("CUSTOMER_INFO", CUSTOMER_INFO);
    minkasu2FAConstants.put("CUSTOMER_FIRST_NAME", C_FIRST_NAME);
    minkasu2FAConstants.put("CUSTOMER_LAST_NAME", C_LAST_NAME);
    minkasu2FAConstants.put("CUSTOMER_EMAIL", C_EMAIL);
    minkasu2FAConstants.put("CUSTOMER_PHONE", C_PHONE);
    minkasu2FAConstants.put("CUSTOMER_ADDRESS_INFO", CUSTOMER_ADDRESS_INFO);
    minkasu2FAConstants.put("CUSTOMER_ADDRESS_LINE_1", ADDRESS_LINE_1);
    minkasu2FAConstants.put("CUSTOMER_ADDRESS_LINE_2", ADDRESS_LINE_2);
    minkasu2FAConstants.put("CUSTOMER_ADDRESS_CITY", ADDRESS_CITY);
    minkasu2FAConstants.put("CUSTOMER_ADDRESS_STATE", ADDRESS_STATE);
    minkasu2FAConstants.put("CUSTOMER_ADDRESS_COUNTRY", ADDRESS_COUNTRY);
    minkasu2FAConstants.put("CUSTOMER_ADDRESS_ZIP_CODE", ADDRESS_ZIP_CODE);
    minkasu2FAConstants.put("CUSTOMER_ORDER_INFO", CUSTOMER_ORDER_INFO);
    minkasu2FAConstants.put("CUSTOMER_ORDER_ID", ORDER_ID);
    minkasu2FAConstants.put("CUSTOMER_BILLING_CATEGORY", BILLING_CATEGORY);
    minkasu2FAConstants.put("CUSTOMER_CUSTOM_DATA", CUSTOM_DATA);
    minkasu2FAConstants.put("SDK_MODE_SANDBOX", SDK_MODE_SANDBOX);
    minkasu2FAConstants.put("STATUS", STATUS);
    minkasu2FAConstants.put("STATUS_SUCCESS", SUCCESS);
    minkasu2FAConstants.put("STATUS_FAILURE", FAILURE);
    minkasu2FAConstants.put("ERROR_MESSAGE", ERROR_MESSAGE);
    minkasu2FAConstants.put("ERROR_CODE", ERROR_CODE);
    minkasu2FAConstants.put("INIT_TYPE", INIT_TYPE);
    minkasu2FAConstants.put("INIT_BY_METHOD", INIT_BY_METHOD);
    minkasu2FAConstants.put("INIT_BY_ATTRIBUTE", INIT_BY_PROPERTY);
    minkasu2FAConstants.put("SKIP_INIT", SKIP_INIT);
    minkasu2FAConstants.put("MINKASU_2FA_USER_AGENT", Minkasu2faSDK.getMinkasu2faUserAgent());
    minkasu2FAConstants.put("RESULT_INFO_TYPE", RESULT_INFO_TYPE);
    minkasu2FAConstants.put("RESULT_DATA", RESULT_DATA);
    minkasu2FAConstants.put("INFO_TYPE_EVENT", Minkasu2faCallbackInfo.INFO_TYPE_EVENT);
    minkasu2FAConstants.put("INFO_TYPE_RESULT", Minkasu2faCallbackInfo.INFO_TYPE_RESULT);
    minkasu2FAConstants.put("INFO_TYPE_PROGRESS", Minkasu2faCallbackInfo.INFO_TYPE_PROGRESS);

    exportConstant.put("MINKASU2FA_CONSTANTS", minkasu2FAConstants);
  }

  WritableMap getAvailableMinkasu2FAOperations() {
    List<Minkasu2faOperationType> operationTypes = Minkasu2faSDK.getAvailableMinkasu2faOperations(mContext.getCurrentActivity());
    WritableMap operationTypeMap = Arguments.createMap();
    for (Minkasu2faOperationType operationType : operationTypes) {
      switch (operationType) {
        case CHANGE_PAYPIN:
          operationTypeMap.putString(CHANGE_PIN, operationType.getValue());
          break;
        case ENABLE_BIOMETRICS:
          operationTypeMap.putString(ENABLE_BIOMETRICS, operationType.getValue());
          break;
        case DISABLE_BIOMETRICS:
          operationTypeMap.putString(DISABLE_BIOMETRICS, operationType.getValue());
          break;
      }
    }
    return operationTypeMap;
  }

  void performMinkasu2faOperation(String merchantCustomerId, String operationTypeStr) throws Exception {
    String TAG = "PerformMKOp";
    String errorMsg = "";
    if (merchantCustomerId == null || merchantCustomerId.isEmpty()) {
      errorMsg = "Invalid Merchant Customer Id";
      Log.e(TAG, errorMsg);
      throw new Exception(errorMsg);
    }
    if (mContext.getCurrentActivity() != null) {
      List<Minkasu2faOperationType> operationTypes = Minkasu2faSDK.getAvailableMinkasu2faOperations(mContext.getCurrentActivity());
      Minkasu2faOperationType operationType = getMinkasu2faOperationType(operationTypeStr, operationTypes, TAG);
      try {
        Minkasu2faSDK minkasu2faSDKInstance = Minkasu2faSDK.initReactSDKOperation(mContext.getCurrentActivity(), operationType, merchantCustomerId, RCT_MINKASU_2FA_SDK_VERSION, new Minkasu2faCallback() {
          @Override
          public void handleInfo(Minkasu2faCallbackInfo minkasu2faCallbackInfo) {
            Log.e("Minkasu2FAOperation", minkasu2faCallbackInfo.getData() != null ? minkasu2faCallbackInfo.getData().toString() : "No operation result");
          }
        });
        minkasu2faSDKInstance.start();
      } catch (Exception e) {
        Log.e(TAG, e.toString());
        throw e;
      }
    } else {
      errorMsg = "Activity unavailable";
      Log.e(TAG, errorMsg);
      throw new Exception(errorMsg);
    }
  }

  @NonNull
  private static Minkasu2faOperationType getMinkasu2faOperationType(String operationTypeStr, List<Minkasu2faOperationType> operationTypes, String TAG) throws Exception {
    Minkasu2faOperationType operationType = null;
    if (operationTypeStr != null && !operationTypeStr.isEmpty()) {
      for (Minkasu2faOperationType opType : operationTypes) {
        if (opType.getValue().equalsIgnoreCase(operationTypeStr)) {
          operationType = opType;
          break;
        }
      }
    }
    if (operationType == null) {
      String msg = "Invalid Operation Type";
      Log.e(TAG, msg);
      throw new Exception(msg);
    }
    return operationType;
  }

  /**
   * @noinspection deprecation
   */
  static void setUserAgent(WebView view) {
    Minkasu2faSDK.setMinkasu2faUserAgent(view);
  }

  static String appendMinkasu2faUserAgent(String existingAgent) {
    String userAgent = "";
    if (existingAgent != null && !existingAgent.isEmpty()) {
      userAgent = Minkasu2faSDK.removeDuplicatesFromUserAgent(existingAgent);
    }
    return userAgent + " " + Minkasu2faSDK.getMinkasu2faUserAgent();
  }

  private static String getReadableMapStringValue(ReadableMap map, String keyName, String defaultValue) {
    return map.hasKey(keyName) ? map.getString(keyName) : defaultValue;
  }

  private static String getJsonStringValue(JSONObject input, String keyName, String defaultValue) throws JSONException {
    return input.has(keyName) ? input.get(keyName).toString() : defaultValue;
  }

  static void initSDK(Activity mActivity, @NonNull WebView view, String config, String initType) {

    WritableMap eventData = Arguments.createMap();
    String status = FAILURE;
    String errorMessage = null;
    try {
      JSONObject configJson = new JSONObject(config);
      if (!JSONObject.NULL.equals(configJson) && configJson.length() > 0) {
        boolean isSkipInit = configJson.has(SKIP_INIT) && configJson.getBoolean(SKIP_INIT);
        if (!isSkipInit) {
          CustomerInfo customer = new CustomerInfo();
          if (configJson.has(CUSTOMER_INFO)) {
            JSONObject customerInfo = configJson.getJSONObject(CUSTOMER_INFO);
            if (!JSONObject.NULL.equals(customerInfo) && customerInfo.length() > 0) {
              customer.setFirstName(getJsonStringValue(customerInfo, C_FIRST_NAME, null));
              customer.setLastName(getJsonStringValue(customerInfo, C_LAST_NAME, null));
              customer.setEmail(getJsonStringValue(customerInfo, C_EMAIL, null));
              customer.setPhone(getJsonStringValue(customerInfo, C_PHONE, null));
            }
            Address address = new Address();
            if (configJson.has(CUSTOMER_ADDRESS_INFO)) {
              JSONObject addressInfo = configJson.getJSONObject(CUSTOMER_ADDRESS_INFO);
              if (!JSONObject.NULL.equals(addressInfo) && addressInfo.length() > 0) {
                address.setAddressLine1(getJsonStringValue(addressInfo, ADDRESS_LINE_1, null));
                address.setAddressLine2(getJsonStringValue(addressInfo, ADDRESS_LINE_2, null));
                address.setCity(getJsonStringValue(addressInfo, ADDRESS_CITY, null));
                address.setState(getJsonStringValue(addressInfo, ADDRESS_STATE, null));
                address.setCountry(getJsonStringValue(addressInfo, ADDRESS_COUNTRY, null));
                address.setZipCode(getJsonStringValue(addressInfo, ADDRESS_ZIP_CODE, null));
              }
            }
            customer.setAddress(address);
          }
          OrderInfo order = null;
          if (configJson.has(CUSTOMER_ORDER_INFO)) {
            JSONObject orderInfo = configJson.getJSONObject(CUSTOMER_ORDER_INFO);
            if (!JSONObject.NULL.equals(orderInfo) && orderInfo.length() > 0) {
              order = new OrderInfo();
              order.setOrderId(getJsonStringValue(orderInfo, ORDER_ID, null));
              order.setBillingCategory(getJsonStringValue(orderInfo, BILLING_CATEGORY, null));
              order.setCustomData(getJsonStringValue(orderInfo, CUSTOM_DATA, null));
            }
          }

          String mId = getJsonStringValue(configJson, M_ID, null);
          String mToken = getJsonStringValue(configJson, M_TOKEN, null);
          String customerId = getJsonStringValue(configJson, CUSTOMER_ID, null);

          Config configObj;
          if (configJson.has(PARTNER_MERCHANT_INFO)) {
            JSONObject partnerMerchantInfo = configJson.getJSONObject(PARTNER_MERCHANT_INFO);
            PartnerInfo partnerInfo = null;
            if (!JSONObject.NULL.equals(partnerMerchantInfo) && partnerMerchantInfo.length() > 0) {
              partnerInfo = new PartnerInfo(
                getJsonStringValue(partnerMerchantInfo, PARTNER_MERCHANT_ID, null),
                getJsonStringValue(partnerMerchantInfo, PARTNER_MERCHANT_NAME, null),
                getJsonStringValue(partnerMerchantInfo, PARTNER_TRANSACTION_ID, null)
              );
            }
            configObj = Config.getInstance(mId, mToken, customerId, partnerInfo, customer);
          } else {
            configObj = Config.getInstance(mId, mToken, customerId, customer);
          }

          String sdkMode = Config.PRODUCTION_MODE;
          if (configJson.has(SDK_MODE_SANDBOX) && configJson.getBoolean(SDK_MODE_SANDBOX)) {
            sdkMode = Config.SANDBOX_MODE;
          }
          configObj.setSDKMode(sdkMode);
          configObj.setOrderInfo(order);
          configObj.setDisableMinkasu2faUserAgent(true);
          Minkasu2faSDK.initReactSDK(mActivity, configObj, view, RCT_MINKASU_2FA_SDK_VERSION, new Minkasu2faCallback() {
            @Override
            public void handleInfo(Minkasu2faCallbackInfo info) {
              WritableMap resultData = Arguments.createMap();
              int infoType = -1;
              String data = null;
              if (info != null) {
                infoType = info.getInfoType();
                data = info.getData() != null ? info.getData().toString() : null;
              }
              resultData.putInt(RESULT_INFO_TYPE, infoType);
              resultData.putString(RESULT_DATA, data);
              view.post(new Runnable() {
                @Override
                public void run() {
                  ((RNCWebViewManager.RNCWebView) view).dispatchEvent(view, new TopMinkasu2FAResultEvent(view.getId(), resultData));
                }
              });
            }
          });
          status = SUCCESS;
        } else {
          errorMessage = "Initialization Skipped";
        }
      }
    } catch (JSONException e) {
      Log.e("Minkasu2FAUtil", "Error in initializing the sdk" + e.getMessage());
      errorMessage = e.getMessage();
    } catch (Exception e1) {
      if (e1 instanceof MissingDataException) {
        eventData.putString(ERROR_CODE, ((MissingDataException) e1).getErrorCode());
      }
      errorMessage = e1.getMessage();
    }
    if (errorMessage != null) {
      Log.e("Minkasu2FAUtil", "Error in initializing the sdk" + errorMessage);
      eventData.putString(ERROR_MESSAGE, errorMessage);
    }
    eventData.putString(INIT_TYPE, initType);
    eventData.putString(STATUS, status);
    view.post(new Runnable() {
      @Override
      public void run() {
        ((RNCWebViewManager.RNCWebView) view).dispatchEvent(view, new TopMinkasu2FAInitEvent(view.getId(), eventData));
      }
    });
  }
}
