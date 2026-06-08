import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';

String formatPaymentPrice(double price) {
  return '\$${price.toStringAsFixed(2)}';
}

class PaymentDetailsDialog extends StatelessWidget {
  final double totalAmount;
  final Future<void> Function() onCancel;
  final Future<void> Function() onPayNow;

  const PaymentDetailsDialog({
    super.key,
    required this.totalAmount,
    required this.onCancel,
    required this.onPayNow,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = totalAmount / 1.1;
    final tax = totalAmount - subtotal;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: _PaymentCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Column(
              spacing: 4,
              children: [
                Text(
                  'PAYMENT DETAILS',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: context.myColors.neutralDarkest,
                  ),
                ),
                Text(
                  'Select a method to pay for this item',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.myColors.neutralMidDark,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.myColors.neutralMidLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                spacing: 10,
                children: [
                  _PaymentRow(
                    label: 'Subtotal',
                    value: formatPaymentPrice(subtotal),
                  ),
                  _PaymentRow(
                    label: 'Tax (10%)',
                    value: formatPaymentPrice(tax),
                  ),
                  Divider(color: context.myColors.neutralLight, height: 1),
                  _PaymentRow(
                    label: 'Total Amount',
                    value: formatPaymentPrice(totalAmount),
                    emphasized: true,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Method:',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.myColors.neutralMidDark,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: context.myColors.neutralLight!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: context.myColors.neutralMidLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset('assets/images/qris-675x256.png'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'QRIS',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: context.myColors.neutralDarkest,
                              ),
                        ),
                        Text(
                          'Scan QR Code',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: context.myColors.neutralMidDark,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: context.myColors.neutralMidDark,
                  ),
                ],
              ),
            ),
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: CustomButton(
                    label: 'Cancel',
                    onPressed: onCancel,
                    variant: ButtonVariant.neutral,
                    outlined: true,
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    label: 'Pay Now',
                    onPressed: onPayNow,
                    oneShot: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WaitingForPaymentDialog extends StatefulWidget {
  final double totalAmount;
  final Future<String?> Function() onRefresh;

  const WaitingForPaymentDialog({
    super.key,
    required this.totalAmount,
    required this.onRefresh,
  });

  @override
  State<WaitingForPaymentDialog> createState() =>
      _WaitingForPaymentDialogState();
}

class _WaitingForPaymentDialogState extends State<WaitingForPaymentDialog> {
  String? _errorMessage;

  Future<void> _refreshPayment() async {
    setState(() => _errorMessage = null);

    final error = await widget.onRefresh();

    if (!mounted || error == null) return;

    setState(() => _errorMessage = error);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: _PaymentCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            Text(
              'WAITING FOR PAYMENT',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: context.myColors.neutralDarkest,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: context.myColors.neutralMidLight,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: context.myColors.neutralMidDark,
                  ),
                  Text(
                    '23 : 59 : 59',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.myColors.neutralDarkest,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.myColors.neutralMidLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: _PaymentRow(
                label: 'Total Amount',
                value: formatPaymentPrice(widget.totalAmount),
                emphasized: true,
              ),
            ),
            Container(
              width: 190,
              height: 190,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.myColors.neutralLightest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                'assets/images/QRdummy.png',
                fit: BoxFit.contain,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.myColors.neutralMidLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  Text(
                    'INSTRUCTIONS:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.myColors.neutralDarkest,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _InstructionText('1. Open your preferred payment app'),
                  _InstructionText('2. Scan the QR code shown above'),
                  _InstructionText('3. Confirm and complete the payment'),
                ],
              ),
            ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: context.myColors.error),
              ),
            CustomButton(
              label: 'Refresh',
              onPressed: _refreshPayment,
              oneShot: true,
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentSuccessfulDialog extends StatelessWidget {
  final double totalAmount;
  final Future<void> Function() onBackToShop;

  const PaymentSuccessfulDialog({
    super.key,
    required this.totalAmount,
    required this.onBackToShop,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: _PaymentCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Image.asset(
                  'assets/images/qris-675x256.png',
                  width: 24,
                  height: 24,
                ),
                Text(
                  'QRIS PAY',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: context.myColors.neutralDarkest,
                  ),
                ),
              ],
            ),
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFF12B981),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            Text(
              'PAYMENT SUCCESSFUL',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: context.myColors.neutralDarkest,
              ),
            ),
            Text(
              formatPaymentPrice(totalAmount),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: context.myColors.neutralDarkest,
              ),
            ),
            Text(
              'Your transaction has been processed successfully.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.myColors.neutralMidDark,
              ),
            ),
            CustomButton(
              label: 'Back to Shop',
              onPressed: onBackToShop,
              oneShot: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final Widget child;

  const _PaymentCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.82,
      ),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: context.myColors.neutralLightest,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x55000000),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasized;

  const _PaymentRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = emphasized
        ? Theme.of(context).textTheme.labelLarge
        : Theme.of(context).textTheme.bodyMedium;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: textStyle?.copyWith(color: context.myColors.neutralMidDark),
          ),
        ),
        Text(
          value,
          style: textStyle?.copyWith(color: context.myColors.neutralDarkest),
        ),
      ],
    );
  }
}

class _InstructionText extends StatelessWidget {
  final String text;

  const _InstructionText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: context.myColors.neutralMidDark),
    );
  }
}
