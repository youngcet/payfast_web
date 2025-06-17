import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'animation/my_animated_switcher.dart';
import 'constants.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

import 'widgets/payment_summary.dart';
import 'widgets/summary_widget.dart';
import 'widgets/waiting_overlay.dart';

/// The `PayFast` class is a stateful widget designed to integrate
/// PayFast's payment processing system into a Flutter web application.
///
/// This widget provides a fully customizable payment interface,
/// allowing developers to easily integrate both sandbox and live
/// environments of the PayFast API.
///
/// ### Features
/// - Secure payment integration using passphrases.
/// - Support for sandbox and live environments.
/// - Configurable payment buttons and overlays.
/// - Callback functions for payment success or cancellation.
/// - Validation of required data fields and URLs.
/// - Dynamic WebView for handling payment sessions.
///
/// ### Parameters
///
/// - **[passPhrase]** *(String)*: The PayFast passphrase required for securing
///   the payment process. This is mandatory.
///
/// - **[useSandBox]** *(bool)*: Indicates whether to use the PayFast sandbox
///   environment for testing. Defaults to `false` for the live environment.
///
/// - **[data]** *(Map<String, dynamic>)*: A map containing payment-related data
///   such as `merchant_id`, `amount`, and `item_name`. The map must include
///   required fields for successful processing.
///
/// - **[payButtonStyle]** *(ButtonStyle?)*: Custom style for the "Pay Now" button.
///   If not provided, a default style is applied.
///
/// - **[payButtonText]** *(String?)*: Text displayed on the "Pay Now" button.
///   Defaults to "Pay Now" if not specified.
///
/// - **[onsiteActivationScriptUrl]** *(String)*: The URL for the PayFast onsite
///   activation script. Must be an absolute HTTPS URL.
///
/// - **[paymentSumarryWidget]** *(Widget?)*: A customizable widget for displaying
///   the payment summary, such as item details and amounts.
///
/// - **[waitingOverlayWidget]** *(Widget?)*: A widget displayed during loading
///   or processing states, such as a spinner or loading indicator.
///
/// - **[paymentSummaryTitle]** *(String?)*: The title text for the payment summary
///   section. Defaults to a generic "Payment Summary" title if not provided.
///
/// - **[defaultPaymentSummaryIcon]** *(Icon?)*: The default icon displayed in the
///   payment summary section. Can be customized to match the app's theme.
///
/// - **[backgroundColor]** *(Icon?)*: The default background color in the
///   payment summary section. Can be customized to match the app's theme.
///
/// ### Example Usage
///
/// ```dart
/// PayFast(
///   passPhrase: 'your-passphrase',
///   useSandBox: true,
///   data: {
///     'merchant_id': '10000100',
///     'merchant_key': '46f0cd694581a',
///     'amount': '100.00',
///     'item_name': 'Test Item',
///     // other required data...
///   },
///   onsiteActivationScriptUrl: 'https://youngcet.github.io/sandbox_payfast_onsite_payments/',
///   paymentCancelledRoute: 'payment-cancelled',
///   paymentCompletedRoute: 'payment-completed',
/// );
/// ```
///
/// ### Notes
/// - Ensure all required fields are present in the `data` map,
///   including `merchant_id`, `merchant_key`, `amount`, and `item_name`.
/// - The onsite activation script URL must be valid and use HTTPS.

class PayFast extends StatefulWidget {
  /// The passphrase associated with your PayFast account.
  ///
  /// This is used to secure transactions and ensure the integrity of the
  /// payment process. The passphrase must match the one configured in your
  /// PayFast account settings.
  final String passPhrase;

  /// Determines whether to use the PayFast sandbox or live server.
  ///
  /// Set this to `true` for testing in the sandbox environment and `false`
  /// for live transactions. The sandbox environment is used to simulate
  /// transactions without processing real payments.
  final bool useSandBox;

  /// A map containing the necessary payment details.
  ///
  /// This map should include mandatory fields such as:
  /// - `merchant_id`: Your PayFast merchant ID.
  /// - `merchant_key`: Your PayFast merchant key.
  /// - `name_first`: The first name of the payer.
  /// - `name_last`: The last name of the payer.
  /// - `email_address`: The email address of the payer.
  /// - `m_payment_id`: A unique identifier for the payment.
  /// - `amount`: The payment amount.
  /// - `item_name`: A description of the payment item.
  /// Additional fields may be included as per your specific requirements.
  final Map<String, dynamic> data;

  /// The style of the "Pay Now" button.
  ///
  /// Use this to customize the appearance of the button, including its
  /// color, size, padding, and other visual properties. If null, a default
  /// button style is applied.
  final ButtonStyle? payButtonStyle;

  /// The text displayed on the "Pay Now" button.
  ///
  /// If not specified, the default text "Pay Now" will be used. You can
  /// customize this to match your application’s context or language.
  final String? payButtonText;

  /// The URL for the PayFast onsite activation script.
  ///
  /// This script is used to initiate the payment process. The URL must
  /// start with `https` for secure communication. Invalid or insecure
  /// URLs will result in an exception.
  final String onsiteActivationScriptUrl;

  /// A widget to display the payment summary.
  ///
  /// This widget is typically used to show a breakdown of the payment
  /// details, such as item names, quantities, and total amount. You can
  /// provide a custom widget to enhance the user experience.
  final Widget? paymentSumarryWidget;

  /// A widget displayed as a loading overlay during the payment process.
  ///
  /// This widget provides feedback to the user while the payment is being
  /// processed, such as a spinner or loading animation. If null, no overlay
  /// is displayed.
  final Widget? waitingOverlayWidget;

  /// The title displayed in the payment summary section.
  ///
  /// This title can be used to provide context to the payment summary,
  /// such as "Order Summary" or "Payment Details". If null, no title is
  /// displayed.
  final String? paymentSummaryTitle;

  /// The default icon displayed in the payment summary section.
  ///
  /// This icon is used to visually represent the payment summary. You can
  /// customize it to match your application’s theme or branding.
  final Icon? defaultPaymentSummaryIcon;

  /// The background color for the payment summary widget widget.
  ///
  /// This color is applied to the container wrapping the child widget.
  /// If `null`, no background color will be applied.
  final Color? backgroundColor;

  /// The animatedSwitcherWidget object allows you to pass customizable animation duration
  /// and transition builder parameters to override the current animation.
  /// This uses the AnimatedSwitcher animation.
  final AnimatedSwitcherWidget? animatedSwitcherWidget;

  /// An optional leading widget to display next to the payment summary details.
  /// Defaults to a shopping bag icon.
  final Widget? itemSummarySectionLeadingWidget;

  /// The icon displayed on the "Pay Now" button.
  ///
  /// You can customize this to match your application’s context or language.
  final Widget? payButtonLeadingWidget;

  /// An optional color set to the amount displayed.
  /// Defaults blue.
  final Color? paymentSummaryAmountColor;

  /// A route to navigate to when a payment is completed
  final String paymentCompletedRoute;

  /// A route to navigate to when a payment is cancelled
  final String paymentCancelledRoute;

  PayFast({
    required this.useSandBox,
    required this.passPhrase,
    required this.data,
    required this.onsiteActivationScriptUrl,
    required this.paymentCancelledRoute,
    required this.paymentCompletedRoute,
    this.paymentSumarryWidget,
    this.payButtonStyle,
    this.payButtonText,
    this.waitingOverlayWidget,
    this.paymentSummaryTitle,
    this.defaultPaymentSummaryIcon,
    super.key,
    this.backgroundColor,
    this.animatedSwitcherWidget,
    this.itemSummarySectionLeadingWidget,
    this.payButtonLeadingWidget,
    this.paymentSummaryAmountColor,
  })  : assert(data.containsKey('merchant_id'),
            'Missing required key: merchant_id'),
        assert(data.containsKey('merchant_key'),
            'Missing required key: merchant_key'),
        assert(
            data.containsKey('name_first'), 'Missing required key: name_first'),
        assert(
            data.containsKey('name_last'), 'Missing required key: name_last'),
        assert(data.containsKey('email_address'),
            'Missing required key: email_address'),
        assert(data.containsKey('m_payment_id'),
            'Missing required key: m_payment_id'),
        assert(data.containsKey('amount'), 'Missing required key: amount'),
        assert(
            data.containsKey('item_name'), 'Missing required key: item_name');

  @override
  State<PayFast> createState() => _PayFastState();
}

class _PayFastState extends State<PayFast> {
  /// Payment identifier (UUID) that uniquely identifies each payment transaction.
  var paymentIdentifier = '';

  /// A dynamic widget that holds the WebView or any other widget to be displayed.
  Widget? _showWebViewWidget;

  /// A boolean flag to show or hide the loading spinner during payment processing.
  bool _showSpinner = false;

  @override
  void initState() {
    super.initState();

    _validate();
  }

  /// Validates specific fields to ensure they meet required criteria.
  ///
  /// This method checks the following:
  /// 1. The `onsiteActivationScriptUrl` field must be a valid URL with an absolute path.
  /// 2. The `onsiteActivationScriptUrl` must start with `https` to ensure secure communication.
  ///
  /// If the `onsiteActivationScriptUrl` fails validation, an exception is thrown, indicating
  /// the URL is invalid. This ensures that the PayFast integration functions correctly and
  /// securely.
  void _validate() {
    bool _validURL =
        Uri.tryParse(widget.onsiteActivationScriptUrl)?.hasAbsolutePath ??
            false;
    if (!_validURL || !widget.onsiteActivationScriptUrl.startsWith('https')) {
      throw Exception('onsiteActivationScriptUrl URL not valid');
    }
  }

  /// A set of gesture recognizers used to handle touch gestures.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };

  /// get api endpoint
  String get endpointUrl => (widget.useSandBox)
      ? Constants.onsitePaymentSandboxEndpoint
      : Constants.onsitePaymentLiveEndpoint;

  /// Sends a request to the payment endpoint to obtain a payment identifier.
  ///
  /// This asynchronous method prepares the necessary data, generates a signature,
  /// and sends an HTTP POST request to the payment endpoint. The response
  /// is then parsed and returned as a map of key-value pairs.
  Future<Map<String, dynamic>> _requestPaymentIdentifier() async {
    Map<String, dynamic> jsonResponse = {};

    Map<String, dynamic> data = Map.from(widget.data);
    data['passphrase'] = widget.passPhrase;

    var signature = _generateSignature(data);
    data['signature'] = signature;

    String paramString = _dataToString(data);

    var response = await http.post(Uri.parse('$endpointUrl?$paramString'));

    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);
    } else {
      setState(() {
        _showWebViewWidget = Html(data: response.body);
      });
    }

    return jsonResponse;
  }

  /// Converts a map of key-value pairs into a URL-encoded query string.
  ///
  /// This utility method takes a `Map<String, dynamic>` and generates a string
  /// suitable for use in a URL query or as part of an HTTP request body. Each
  /// key-value pair is concatenated in the format `key=value` and joined by
  /// `&`. Values are URL-encoded to ensure compatibility with web standards.
  String _dataToString(Map<String, dynamic> data) {
    var paramString = '';

    for (var entry in data.entries) {
      paramString += '${entry.key}=${Uri.encodeComponent(entry.value)}&';
    }

    paramString = paramString.substring(0, paramString.length - 1);

    return paramString;
  }

  /// Generates an MD5 signature for the given data map.
  ///
  /// The signature is created by:
  /// 1. Sorting the map entries alphabetically by key.
  /// 2. Concatenating the key-value pairs into a query string format.
  /// 3. Encoding the string with MD5.
  ///
  /// [data] is the input map containing the data to be signed.
  /// Returns the MD5 hash of the generated parameter string.
  String _generateSignature(Map<String, dynamic> data) {
    var paramString = '';

    data = Map.fromEntries(
      data.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    for (var entry in data.entries) {
      if (entry.key != 'signature') {
        paramString += '${entry.key}=${Uri.encodeComponent(entry.value)}&';
      }
    }

    paramString = paramString.substring(0, paramString.length - 1);

    return md5.convert(utf8.encode(paramString)).toString();
  }

  /// Returns the base URL of the current web page.
  /// For localhost or 127.0.0.1, it includes the port.
  /// For production hosts, it returns just the protocol and hostname.
  String getBaseUrl() {
    final location = html.window.location;
    final hostname = location.hostname;
    final port = location.port;

    if (hostname == 'localhost' || hostname == '127.0.0.1') {
      return '${location.protocol}//$hostname:$port';
    }

    return '${location.protocol}//$hostname';
  }

  /// Displays a WebView for processing payment.
  ///
  /// The WebView loads a payment page using the unique identifier (`uuid`)
  /// retrieved from the payment system. It also handles navigation events,
  /// including tracking loading progress, completed or cancelled payments,
  /// and resource errors.
  void _showWebView() async {
    var response = await _requestPaymentIdentifier();
    if (response['uuid'] == null) {
      setState(() {
        _showWebViewWidget = _error(
            'An error has occured. Please re-check the Payfast details supplied and try again.',
            btnText: 'Retry');
      });
    }

    paymentIdentifier = response['uuid'];
    setState(() {
      _showSpinner = true;
    });

    String paymentCompletedRoute =
        widget.paymentCompletedRoute.replaceAll('/', '');
    String paymentCancelledRoute =
        widget.paymentCancelledRoute.replaceAll('/', '');

    final encodedReturnUrl =
        Uri.encodeComponent('${getBaseUrl()}/#/$paymentCompletedRoute');
    final encodedCancelUrl =
        Uri.encodeComponent('${getBaseUrl()}/#/$paymentCancelledRoute');

    html.window.location.href =
        '${widget.onsiteActivationScriptUrl}?uuid=$paymentIdentifier'
        '&return_url=$encodedReturnUrl&cancel_url=$encodedCancelUrl';
    return;
  }

  /// Builds an error card widget with an error icon, message, and a button.
  ///
  /// [message] - The error message to display.
  /// [btnText] - Optional custom text for the button. Defaults to 'Continue'.
  Widget _error(String message, {String? btnText}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Colors.red,
          width: 1, // Border width
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.error,
                color: Colors.red,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Error!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showWebViewWidget = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  btnText ?? 'Continue',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: widget.backgroundColor ?? Colors.transparent,
        child: Column(
          children: [
            // Show spinner with AnimatedSwitcher
            AnimatedSwitcher(
              duration: widget.animatedSwitcherWidget?.getDuration() ??
                  const Duration(milliseconds: 500),
              transitionBuilder:
                  widget.animatedSwitcherWidget?.getTransitionBuilder() ??
                      (child, animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 1), // Start off-screen
                            end: Offset.zero, // End on-screen
                          ).animate(animation),
                          child: child,
                        );
                      },
              child: _showSpinner
                  ? WaitingOverlay(
                      key: const ValueKey('WaitingOverlay'),
                      child: widget.waitingOverlayWidget,
                    )
                  : const SizedBox.shrink(),
            ),

            // Content Switcher for WebView or SummaryWidget
            Expanded(
              child: AnimatedSwitcher(
                duration: widget.animatedSwitcherWidget?.getDuration() ??
                    const Duration(milliseconds: 500),
                transitionBuilder:
                    widget.animatedSwitcherWidget?.getTransitionBuilder() ??
                        (child, animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 1), // Start off-screen
                              end: Offset.zero, // End on-screen
                            ).animate(animation),
                            child: child,
                          );
                        },
                child: _showWebViewWidget != null
                    ? _showWebViewWidget!
                    : SummaryWidget(
                        key: const ValueKey('SummaryWidget'),
                        paymentSummaryWidget: PaymentSummary(
                          data: widget.data,
                          title: widget.paymentSummaryTitle,
                          icon: widget.defaultPaymentSummaryIcon,
                          itemSectionLeadingWidget:
                              widget.itemSummarySectionLeadingWidget,
                          paymentSummaryAmountColor:
                              widget.paymentSummaryAmountColor,
                          child: widget.paymentSumarryWidget,
                        ),
                        onPayButtonPressed: _showWebView,
                        payButtonStyle: widget.payButtonStyle,
                        payButtonText: widget.payButtonText,
                        payButtonLeadingWidget: widget.payButtonLeadingWidget,
                      ),
              ),
            ),
          ],
        ));
  }
}
