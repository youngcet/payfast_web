<p align="center">   
    <a href="https://github.com/youngcet/payfast_web"><img src="https://img.shields.io/github/stars/youngcet/payfast_web?style=social" alt="Repo stars"></a>
    <a href="https://github.com/youngcet/payfast_web/commits/main"><img src="https://img.shields.io/github/last-commit/youngcet/payfast_web/main?logo=git" alt="Last Commit"></a>
    <a href="https://github.com/youngcet/payfast_web/pulls"><img src="https://img.shields.io/github/issues-pr/youngcet/payfast_web" alt="Repo PRs"></a>
    <a href="https://github.com/youngcet/payfast_web/issues?q=is%3Aissue+is%3Aopen"><img src="https://img.shields.io/github/issues/youngcet/payfast_web" alt="Repo issues"></a>
    <a href="https://github.com/youngcet/payfast_web/graphs/contributors"><img src="https://badgen.net/github/contributors/youngcet/payfast_web" alt="Contributors"></a>
    <a href="https://github.com/youngcet/payfast_web/blob/main/LICENSE"><img src="https://badgen.net/github/license/youngcet/payfast_web" alt="License"></a>
    <br>       
    <a href="https://app.codecov.io/gh/youngcet/payfast_web"><img src="https://img.shields.io/codecov/c/github/youngcet/payfast_web?logo=codecov&logoColor=white" alt="Coverage Status"></a>
</p>

# Payfast Web Flutter Package

A Flutter package to integrate Payfast payments into your Flutter web app. **This package is for Flutter Web only. If you're looking for the mobile package, the documentation is here: [PayFast for mobile](https://github.com/youngcet/payfast)**.

[![Pub Version](https://img.shields.io/pub/v/payfast_web)](https://pub.dev/packages/payfast_web)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/youngcet/payfast_web/blob/main/LICENSE)
<a href="https://pub.dev/packages/payfast_web"><img src="https://badgen.net/pub/points/payfast_web" alt="Pub points"></a>
<a href="https://pub.dev/packages/payfast_web"><img src="https://badgen.net/pub/likes/payfast_web" alt="Pub Likes"></a>
<a href="https://pub.dev/packages/payfast_web"><img src="https://badgen.net/pub/popularity/payfast_web" alt="Pub popularity"></a>

<p align="center">
  <img src="https://github.com/youngcet/payfast_web/blob/main/doc/sandbox.gif?raw=true" height="400">
  <img src="https://github.com/youngcet/payfast_web/blob/main/doc/live.gif?raw=true" height="400">
</p>
<br/>
<hr/>
<br/>

- [Getting Started](#getting-started)
  * [Usage](#usage)
  * [Payfast Onsite Activation Script](#payfast-onsite-activation-script)
    * [Hosting on Gihub](#hosting-on-github)
    * [Hosting on a different server](#hosting-on-a-different-server)
  * [Android & IOS Setup](#android-and-ios-setup)
- [Features](#features)
  * [Onsite Payments](#onsite-payments)
  * [Sandbox or Live Environment integration](#sandbox-or-live-environment-integration)
  * [Customizable Payment Summary Widget](#customizable-payment-summary-widget)
  * [Customizable Payment Button](#customizable-payment-button)
  * [Customizable Waiting Overlay Widget](#customizable-waiting-overlay-widget)
  * [FlutterFlow Integration](#flutterflow-integration)
- [Properties](#properties)
  * [passPhrase](#passphrase)
  * [useSandBox](#usesandbox)
  * [data](#data)
  * [onsiteActivationScriptUrl](#onsiteactivationscripturl)
  * [paymentSumarryWidget](#paymentsumarrywidget)
  * [defaultPaymentSummaryIcon](#defaultPaymentSummaryIcon)
  * [paymentSummaryAmountColor](#paymentSummaryAmountColor)
  * [itemSummarySectionLeadingWidget](#itemSummarySectionLeadingWidget)
  * [payButtonStyle](#paybuttonstyle)
  * [payButtonText](#paybuttontext)
  * [waitingOverlayWidget](#waitingoverlaywidget)
  * [backgroundColor](#backgroundcolor)
  * [animatedSwitcherWidget](#animatedswitcherwidget)


## Getting Started

This package uses Payfast's Onsite Payments integration, therefore, you need to host their onsite activiation script. 

## Payfast Onsite Activation Script

### Hosting on Github

> **Note:** You can also host the file on Github Pages

Below are GitHub links that you can use if you prefer not to host the file yourself or need them for development purposes:

- https://youngcet.github.io/sandbox_payfast_onsite_payments/ > use to point to the sandbox
- https://youngcet.github.io/payfast_onsite_payments/ > use to point to the live server

> **Note:** While these links are hosted on GitHub, accessing them through a browser will result in a 404 error from Payfast. This behavior is expected and not an issue.


### Hosting on a different server

Copy the `html` file below and host it on a secure server:


```html
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://sandbox.payfast.co.za/onsite/engine.js"></script>
</head>
<body>
    <script>
            // DO NOT MODIFY THE CODE BELOW

            // retrieve the uuid that is passed to this file and send it to PayFast onsite engine
            const queryString = window.location.search;
            const urlParams = new URLSearchParams(queryString);
            const uuid = urlParams.get('uuid');
            const return_url = urlParams.get('return_url'); 
            const cancel_url = urlParams.get('cancel_url');

            window.payfast_do_onsite_payment({"uuid":uuid}, function (result) {
                if (result === true) {
                    // Payment Completed
                    location.href = decodeURIComponent(return_url); 
                }
                else {
                    // Payment Cancelled
                    location.href = decodeURIComponent(cancel_url);
                }
            });
        </script>
</body>

</html>
```

Alternatively, you can create your own `html` file but make sure to include the tags below (**do not modify the code**):


```html
<script src="https://sandbox.payfast.co.za/onsite/engine.js"></script> 
<script>
    // retrieve the uuid that is passed to this file and send it to PayFast onsite engine
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    const uuid = urlParams.get('uuid');
    const return_url = urlParams.get('return_url'); 
    const cancel_url = urlParams.get('cancel_url'); 

    window.payfast_do_onsite_payment({"uuid":uuid}, function (result) {
        if (result === true) {
            // Payment Completed
            location.href = decodeURIComponent(return_url);
        }
        else {
            // Payment Cancelled
            location.href = decodeURIComponent(cancel_url);
        }
    });
</script>
```

You can also add your URLs like this instead of a callback:
```html
...
<script>
    // DO NOT MODIFY THE CODE BELOW
    
    // retrieve the url params that are passed to this file and send them to payfast onsite engine
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    const uuid = urlParams.get('uuid');
    const return_url = urlParams.get('return_url'); 
    const cancel_url = urlParams.get('cancel_url');

    window.payfast_do_onsite_payment({
      'uuid':uuid,
      'return_url': decodeURIComponent(return_url),
      'cancel_url': decodeURIComponent(cancel_url),
       'notify_url': 'insert-your-webhook-url'  // optional: A payment confirmation notification will be sent to the "notify_url" you specified.
    });
</script> 
```

### Payment Confirmation
A payment confirmation notification will be sent to the "notify_url" you specified.
The full implementation details can be found [here](https://developers.payfast.co.za/docs#step_4_confirm_payment).

To point to a live server, simply change `<script src="https://sandbox.payfast.co.za/onsite/engine.js"></script>` tag to `<script src="https://www.payfast.co.za/onsite/engine.js"></script>`. Take note of the url where the `html` file is hosted, you're going pass it along in the Payfast package. 

We have to host the file because for security reasons 'Onsite Payments' requires that your application be served over HTTPS. For more detailed documentation, please refer to the official [Payfast Onsite Payments documentation](https://developers.payfast.co.za/docs#onsite_payments). 

<p align="left">
<img src="https://github.com/youngcet/payfast/blob/main/doc/sandbox.png?raw=true" alt="Sandbox Screenshot" height="600" width="280" style="border:1px solid grey"/>
<img src="https://github.com/youngcet/payfast/blob/main/doc/live.png?raw=true" alt="Live Screenshot" height="600" width="280" style="border:1px solid grey"/>
</p>

## Usage

Install the library to your project by running: 

```bash
flutter pub add payfast_web
```

or add the following dependency in your `pubspec.yaml` (replace `^latest_version` with the latest version):


```yaml
dependencies:
  payfast_web: ^latest_version
```

### Android And IOS Setup


|             | Android | iOS   | macOS  |
|-------------|---------|-------|--------|
| **Support** | SDK 21+ | 12.0+ | 10.14+ |



**Android Setup**

Set `minSdkVersion` in `android/app/build.gradle` to greater than 19:

```groovy
android {
    defaultConfig {
        minSdkVersion 21
    }
}
```

Add `<uses-permission android:name="android.permission.INTERNET" />` permission in `android/app/src/main/AndroidManifest.xml`.

**IOS Setup**

Add the key below in `ios/Runner/Info.plist`

```groovy
<key>io.flutter.embedded_views_preview</key>
<string>YES</string>
```

**Import the package and create a PayFast Widget**

```dart
import 'dart:math';

import 'package:example/payment_cancelled.dart';
import 'package:example/payment_completed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payfast_web/payfast_web.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        '/payment-completed': (context) => const PaymentCompletedScreen(), // -> add a route for when a payment is completed
        '/payment-cancelled': (context) => const PaymentCancelledScreen(), // add a route for when a payment is cancelled
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  String _randomId() {
    var rng = Random();
    var randomNumber = rng.nextInt(900000) + 100000;

    return '$randomNumber';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
          body: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              transitionBetweenRoutes: false,
              middle: const Text('Payfast Widget Demo'),
              trailing: GestureDetector(
                child: const Icon(Icons.arrow_forward),
                onTap: () => Navigator.of(context).pushNamed('/thank-you'),
              ),
            ),
            child: SizedBox.expand(
              child: SingleChildScrollView(
                primary: true,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: const Text('Checkout using PayFast >>'),
                        onTap: () => showCupertinoModalBottomSheet(
                          expand: true,
                          bounce: true,
                          enableDrag: true,
                          context: context,
                          backgroundColor: Colors.white,
                          builder: (context) => PayFast(
                            data: {
                              'merchant_id': '00000',
                              'merchant_key': '000000',
                              'name_first': 'Yung',
                              'name_last': 'Cet',
                              'email_address': 'young.cet@gmail.com',
                              'm_payment_id': _randomId(),
                              'amount': '20',
                              'item_name': 'Subscription',
                            },
                            passPhrase: 'xxxxxxxxxx',
                            useSandBox: true,
                            payButtonStyle: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.red,
                              shadowColor: Colors.transparent,
                            ),
                            onsiteActivationScriptUrl:
                                'https://youngcet.github.io/sandbox_payfast_onsite_payments/',
                            paymentCancelledRoute: 'payment-cancelled', // -> name of the route as defined in routes:
                            paymentCompletedRoute: 'payment-completed', // -> name of the route as defined in routes:
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }
}
```

The code above will show you the screen below:

<img src="https://github.com/youngcet/payfast/blob/main/doc/basic_app_screenshot.png?raw=true" alt="Basic App Screenshot" height="600" width="280"/>



## Features

### Onsite Payments

Integrate PayFast's secure payment engine directly into the checkout page. Important: Please note that this is currently in Beta according to PayFast's documentation, however, it works fine.

### Sandbox or Live Environment integration

Configure whether to use PayFast's sandbox or live server. When you choose to use the sandbox or live server, ensure that the hosted `html` file also points to the server's onsite activation script (`<script src="https://sandbox.payfast.co.za/onsite/engine.js"></script>`) and the PayFast merchant id and key corresponds to the appropiate server.

```dart
PayFast(
    ...
    useSandBox: true, // true to use Payfast sandbox, false to use their live server
) 
```

### Customizable Payment Summary Widget

Provide a custom widget for displaying the payment summary with the `paymentSumarryWidget` property. This allows for full customization of the payment details display. Only the highlighted section can be replaced with a custom widget.

<img src="https://github.com/youngcet/payfast/blob/main/doc/payment_summary.png?raw=true" alt="Payment Summary" width="280"/>



Custom Payment Summary Widget

```dart
PayFast(
    ...
    ...
    paymentSumarryWidget: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.none, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: const [
                ListTile(
                  title: Text('Product 1'),
                  trailing: Text('R20.00'),
                ),
                ListTile(
                  title: Text('Product 2'),
                  trailing: Text('R15.00'),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    'R35.00',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
) 
```


<img src="https://github.com/youngcet/payfast/blob/main/doc/payment_summary_widget.png?raw=true" alt="Payment Summary Custom Widget" width="280"/>


Or modify the default widget using the properties below:

**Payment Summary Title & Icon:** Use the `paymentSummaryTitle` and `defaultPaymentSummaryIcon` properties to customize the title and icon of the payment summary section, ensuring it matches your app's theme.

```dart
PayFast(
    ...
    paymentSummaryTitle: 'Order Summary',
    defaultPaymentSummaryIcon: const Icon(
      Icons.shopping_cart,
      size: 50,
      color: Colors.grey,
    ),
) 
```


<img src="https://github.com/youngcet/payfast/blob/main/doc/payment_summary_text_icon.png?raw=true" alt="Payment Summary Custom Text & Icon" width="280"/>


### Customizable Payment Button

The `payButtonStyle` and `payButtonText` properties allow you to style the "Pay Now" button and change its text and styling, ensuring that it fits seamlessly with your app's design.

```dart
PayFast(
    ...
    payButtonText: 'Checkout >>',
    payButtonStyle: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      backgroundColor: Colors.black,
      shadowColor: Colors.transparent,
      textStyle: TextStyle(backgroundColor: Colors.black)
    ),
    payButtonLeadingWidget: const Icon(Icons.payments), // set an icon next to the 'button text'
) 
```


<img src="https://github.com/youngcet/payfast/blob/main/doc/customised_pay_button.png?raw=true" alt="Custom Pay Button" width="280"/>


### FlutterFlow Integration

**PayFast Flutter Package Integration with FlutterFlow**

FlutterFlow Demo:
https://app.flutterflow.io/share/pay-fast-demo-wgqscg

To integrate with FluterFlow, 

1. Create a new Custom Widget under **Custom Code** in FlutterFlow.
2. Rename the widget to **PayFastWidget**.
3. Under Widget Settings, add the following parameters:

<img src="https://github.com/youngcet/payfast_web/blob/main/doc/flutterflow_widget_settings.png?raw=true" alt="FlutterFlow Settings" width="280"/>


4. Add **payfast_web: ^latest_version** to the dependencies and refresh the UI (replace latest_version with the latest version).

<img src="https://github.com/youngcet/payfast_web/blob/main/doc/flutterflow_dependency.png?raw=true" alt="FlutterFlow Dependency" width="280"/>


5. Copy and paste the code below (**do not use the boilerplate code provided**):

```dart 
// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:payfast_web/payfast_web.dart';

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!

class PayFastWidget extends StatefulWidget {
  final String passPhrase;
  final bool useSandBox;
  final dynamic data;
  final String onsiteActivationScriptUrl;

  // fields below are required for a FlutterFlow widget
  final double? width;
  final double? height;

  const PayFastWidget({
    required this.useSandBox,
    required this.passPhrase,
    required this.data,
    required this.onsiteActivationScriptUrl,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  State<PayFastWidget> createState() => _PayFastWidgetState();
}

class _PayFastWidgetState extends State<PayFastWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          body: Center(
              child: PayFast(
              data: widget.data,
              passPhrase: widget.passPhrase,
              useSandBox: widget.useSandBox,
              onsiteActivationScriptUrl: widget.onsiteActivationScriptUrl,
              paymentCancelledRoute: 'paymentCancelled',
              paymentCompletedRoute: 'paymentCompleted',
              paymentSumarryWidget: _paymentSummary(), // pass widget
              // add other parameters as needed
      ))),
    );
  }

  // modify or remove this widget
  // this is only for demostration purposes
  Widget _paymentSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
              color: Colors.black),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: const [
                ListTile(
                  title: Text('Product 1'),
                  trailing: Text('R20.00'),
                ),
                ListTile(
                  title: Text('Product 2'),
                  trailing: Text('R15.00'),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    'R35.00',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
```

The widget is designed to accept only the required parameters, making it simple to configure within the 'Widget Palette'. For additional optional parameters, which are more cosmetic, it is recommended to add them directly in the code. This approach is similar to how the `paymentSummaryWidget` was integrated in the example above.

6. Save and Compile the code. There should be no errors.
7. In the **Widget Palette**, drag and drop the PayFast Widget onto your page. Select the widget and configure the required parameters. For the `onPaymentCancelled` and `onPaymentCompleted` callbacks, add appropriate actions, such as navigating to a specific page or displaying a confirmation message.
8. Create new pages for Payment Completed and Payment Cancelled, making sure their routes are set to `paymentCompleted` and `paymentCancelled` respectively. You can find the name of the route in the page properties under 'Route Settings'

<img src="https://github.com/youngcet/payfast_web/blob/main/doc/flutterflow_widget_settings.png?raw=true" alt="FlutterFlow Route Settings" width="280"/>

**Note**: You can update the route names in the widget above to match your chosen routes.


**Testing the Payment Flow**

To test the payment flow, make sure that the useSandBox flag is set to true in the PayFast widget.

Use the provided sandbox URL (https://youngcet.github.io/sandbox_payfast_onsite_payments/) or replace it with your own sandbox testing URL.


<p>
<img src="https://github.com/youngcet/payfast/blob/main/doc/flutterflow_02.png?raw=true" alt="FlutterFlow PayFast Widget" style="width:100%"/>
</p>


## How to fix the hash routing conflict:
If your app doesn't navigate correctly to payment completion or cancellation pages after a transaction—despite having the correct route names—this issue is likely caused by hash routing conflicts.

In your `PayFast` Widget, disable the hash routing in the `RouteGenerator`.
```dart
PayFast(
  ...
  routeGenerator: RouteGenerator(
     useHashRouting: false  // set to false
  ),
)
```

## Properties

### `passPhrase`:  
  The passphrase provided by Payfast for security.

### `useSandBox`:  
  A boolean flag to choose between sandbox or live environment.

### `data`:  
  A `Map<String, dynamic>` containing the required payment data. This includes keys like:
  - `merchant_id`
  - `merchant_key`
  - `name_first`
  - `name_last`
  - `amount`
  - `item_name`
  - `m_payment_id`

  optional:
  - `item_description` string, 255 char
    - The description of the item being charged for, or in the case of multiple items the order description.
  - `fica_idnumber` integer, 13 char
    - The Fica ID Number provided of the buyer must be a valid South African ID Number.
  - `cell_number` string, 100 char
    - The customer’s valid cell number. If the email_address field is empty, and cell_number provided, the system will use the cell_number as the username and auto login the user, if they do not have a registered account
  - `email_confirmation` boolean, 1 char
    - Whether to send an email confirmation to the merchant of the transaction. The email confirmation is automatically sent to the payer. 1 = on, 0 = off
  - `confirmation_address` string, 100 char
    - The email address to send the confirmation email to. This value can be set globally on your account. Using this field will override the value set in your account for this transaction.
  - `payment_method` string, 3 char | Not available in Sandbox
    - When this field is set, only the SINGLE payment method specified can be used when the customer reaches Payfast. If this field is blank, or not included, then all available payment methods will be shown.

      The values are as follows:
        - ‘ef’ – EFT
        - ‘cc’ – Credit card
        - ‘dc’ – Debit card
        - ’mp’ – Masterpass Scan to Pay
        - ‘mc’ – Mobicred
        - ‘sc’ – SCode
        - ‘ss’ – SnapScan
        - ‘zp’ – Zapper
        - ‘mt’ – MoreTyme
        - ‘rc’ – Store card
        - ‘mu’ – Mukuru
        - ‘ap’ – Apple Pay
        - ‘sp’ – Samsung Pay
        - ‘cp’ – Capitec Pay


### `onsiteActivationScriptUrl`:  
  The html file URL used for onsite payment activation.

  Below are GitHub links that you can use if you prefer not to host the file yourself or need them for development purposes:

- https://youngcet.github.io/sandbox_payfast_onsite_payments/ > use to point to the sandbox
- https://youngcet.github.io/payfast_onsite_payments/ > use to point to the live server


### `paymentSumarryWidget`:  
  A custom widget to display the payment summary before the user proceeds with the payment.

### `defaultPaymentSummaryIcon`:
  An icon to display next to the payment summary item details.

### `paymentSummaryAmountColor`:
  The amount text color on the payment summary page

### `itemSummarySectionLeadingWidget`:
  A custom widget to display next to the payment summary item details.

### `payButtonStyle`:  
  The style of the "Pay Now" button.

### `payButtonText`:  
  The text displayed on the "Pay Now" button.

### `payButtonLeadingWidget`:
  The widget displayed next to the "Pay Now" button.

### `backgroundColor`:  
  A background color of the payment summary page

## Conclusion

This package allows you to easily integrate Payfast into your Flutter web project and FlutterFlow. The integration can be fully customized to match your app's payment requirements. For production, ensure that you replace the sandbox configuration with live credentials and URLs.


## Contributing

### Github Repository
If you have ideas or improvements for this package, we welcome contributions. Please open an issue or create a pull request on our [GitHub repository](https://github.com/youngcet/payfast_web).

### Join Our Community on Discord! 🎮

Looking for support, updates, or a place to discuss the **PayFast Flutter Package**? Join our dedicated Discord channel!

👉 [Join the `#payfast-flutter-package` channel](https://discord.gg/Gh9J5sns)

### What You'll Find:
- **Help & Support**: Get assistance with integrating and using the package.
- **Feature Discussions**: Share ideas for new features or improvements.
- **Bug Reports**: Report issues and collaborate on fixes.
- **Community Interaction**: Engage with fellow developers working on Flutter projects.

We look forward to seeing you there! 🚀

## License

This package is available under the [MIT License](https://github.com/youngcet/payfast_web/blob/main/LICENSE).

Support the plugin <a href="https://www.buymeacoffee.com/yungcet" target="_blank"><img src="https://i.imgur.com/aV6DDA7.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>