import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';
import { Double, Int32 } from 'react-native/Libraries/Types/CodegenTypes';

type Minkasu2FAConstants = {
  DISABLE_BIOMETRICS: string,
  MERCHANT_ID: string,
  MERCHANT_TOKEN: string,
  CUSTOMER_ID: string,
  PARTNER_MERCHANT_INFO: string,
  PARTNER_MERCHANT_ID: string,
  PARTNER_MERCHANT_NAME: string,
  PARTNER_TRANSACTION_ID: string,
  CUSTOMER_INFO: string,
  CUSTOMER_FIRST_NAME: string,
  CUSTOMER_LAST_NAME: string,
  CUSTOMER_EMAIL: string,
  CUSTOMER_PHONE: string,
  CUSTOMER_ADDRESS_INFO: string,
  CUSTOMER_ADDRESS_LINE_1: string,
  CUSTOMER_ADDRESS_LINE_2: string,
  CUSTOMER_ADDRESS_CITY: string,
  CUSTOMER_ADDRESS_STATE: string,
  CUSTOMER_ADDRESS_COUNTRY: string,
  CUSTOMER_ADDRESS_ZIP_CODE: string,
  CUSTOMER_ORDER_INFO: string,
  CUSTOMER_ORDER_ID: string,
  CUSTOMER_BILLING_CATEGORY: string,
  CUSTOMER_ORDER_DETAILS: string,
  SDK_MODE_SANDBOX: string,
  STATUS: string,
  STATUS_SUCCESS: string,
  STATUS_FAILURE: string,
  ERROR_MESSAGE: string,
  ERROR_CODE: string,
  INIT_TYPE: string,
  INIT_BY_METHOD: string,
  INIT_BY_ATTRIBUTE: string,
  SKIP_INIT: string,
  MINKASU_2FA_USER_AGENT: string,
  RESULT_INFO_TYPE: string,
  RESULT_DATA: string,
  INFO_TYPE_EVENT: Int32,
  INFO_TYPE_RESULT: Int32,
  INFO_TYPE_PROGRESS: Int32,
  // iOS Only
  NAVIGATION_BAR_COLOR?: string,
  NAVIGATION_BAR_TEXT_COLOR?: string,
  DARK_MODE_NAVIGATION_BAR_COLOR?:string,
  DARK_MODE_NAVIGATION_BAR_TEXT_COLOR?:string,
  SUPPORT_DARK_MODE?: boolean
}

export interface Spec extends TurboModule {
  isFileUploadSupported(): Promise<boolean>;
  shouldStartLoadWithLockIdentifier(
    shouldStart: boolean,
    lockIdentifier: Double
  ): void;
  getAvailableMinkasu2FAOperations(): Promise<Record<string, string>>;
  performMinkasu2FAOperation(
    merchantCustomerId: string,
    minkasuOperationType: string,
    colourTheme: string,
  ): Promise<string>;
  getConstants(): { MINKASU2FA_CONSTANTS: Minkasu2FAConstants }
}

export default TurboModuleRegistry.getEnforcing<Spec>('RNCWebViewModule');
