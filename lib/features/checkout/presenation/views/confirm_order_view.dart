import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/app_assets.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/features/cart/presentation/providers/cart_provider.dart';
import 'package:bookapp/core/services/notification_service.dart';
import 'package:bookapp/l10n/app_localizations.dart';

class ConfirmOrderView extends ConsumerStatefulWidget {
  const ConfirmOrderView({super.key});

  @override
  ConsumerState<ConfirmOrderView> createState() => _ConfirmOrderViewState();
}

class _ConfirmOrderViewState extends ConsumerState<ConfirmOrderView> {
  String selectedDate = 'Today';
  String selectedTime = '10:00 PM';
  String selectedPayment = 'KNET';
  bool isOrdering = false;

  DateTime selectedDeliveryDateTime = DateTime.now();

  String currentAddressTitle = 'Utama Street No.20';
  String currentAddressSubtitle = 'Dumbo Street No.20, Dumbo, New York 10001, United States';

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  void dispose() {
    cardNumberController.dispose();
    cardHolderController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  void _showPaymentDetailsBottomSheet(BuildContext context, double subtotal, List<dynamic> items) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(l10n.orderReceiptDetails, style: AppTextStyles.h5.copyWith(color: AppColors.grey900)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.grey200!),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.price, style: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.grey500)),
                        Text('\$${subtotal.toStringAsFixed(2)}', style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.grey900)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...items.map((item) {
                      final title = item['title'] ?? 'Book';
                      final quantity = item['quantity'] ?? 1;
                      final itemPrice = ((item['price'] ?? 0) * quantity).toStringAsFixed(2);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '$quantity x $title',
                                style: AppTextStyles.bodySmallRegular.copyWith(color: AppColors.grey600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text('\$$itemPrice', style: AppTextStyles.bodySmallMedium.copyWith(color: AppColors.grey900)),
                          ],
                        ),
                      );
                    }),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Divider()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.shipping, style: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.grey500)),
                        Text('\$2.00', style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.grey900)),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Divider()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.totalPayment, style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.grey900)),
                        Text('\$${(subtotal + 2.0).toStringAsFixed(2)}', style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.primary500)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickCustomDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDeliveryDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      setState(() {
        selectedDeliveryDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          selectedDeliveryDateTime.hour,
          selectedDeliveryDateTime.minute,
        );
        selectedDate = '${picked.day} ${months[picked.month - 1]}';
      });
    }
  }

  Future<void> _pickCustomTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDeliveryDateTime),
    );
    if (picked != null) {
      setState(() {
        selectedDeliveryDateTime = DateTime(
          selectedDeliveryDateTime.year,
          selectedDeliveryDateTime.month,
          selectedDeliveryDateTime.day,
          picked.hour,
          picked.minute,
        );
        selectedTime = picked.format(context);
      });
    }
  }

  void _showDateTimePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey300, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Text('Delivery date', style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.grey900)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDateChip(l10n.todayDate, selectedDate == l10n.todayDate || selectedDate == 'Today', () {
                      setState(() {
                        selectedDate = l10n.todayDate;
                        selectedDeliveryDateTime = DateTime.now();
                      });
                    }),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildDateChip(l10n.tomorrowDate, selectedDate == l10n.tomorrowDate || selectedDate == 'Tomorrow', () {
                      setState(() {
                        selectedDate = l10n.tomorrowDate;
                        selectedDeliveryDateTime = DateTime.now().add(const Duration(days: 1));
                      });
                    }),
                  ),
                  const SizedBox(width: 6),
                  Expanded(child: _buildDateChip('Pick a date', false, () => _pickCustomDate(context))),
                ],
              ),
              const SizedBox(height: 24),
              Text('Delivery time', style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.grey900)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildTimeChip(selectedTime, true)),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500.withOpacity(0.1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => _pickCustomTime(context),
                    icon: const Icon(Icons.access_time, size: 18, color: AppColors.primary500),
                    label: Text('Pick Time', style: AppTextStyles.bodySmallBold.copyWith(color: AppColors.primary500)),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary500, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                  onPressed: () => Navigator.pop(context),
                  child: Text('Confirm', style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCreditCardDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey300, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                Text('Add Credit Card', style: AppTextStyles.h5.copyWith(color: AppColors.grey900)),
                const SizedBox(height: 16),
                TextField(
                  controller: cardNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Card Number', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: cardHolderController,
                  decoration: InputDecoration(labelText: 'Cardholder Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TextField(controller: expiryDateController, decoration: InputDecoration(labelText: 'Expiry Date', hintText: 'MM/YY', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
                    const SizedBox(width: 12),
                    Expanded(child: TextField(controller: cvvController, obscureText: true, decoration: InputDecoration(labelText: 'CVV', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary500, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                    onPressed: () {
                      if (cardNumberController.text.isNotEmpty) {
                        setState(() {
                          selectedPayment = 'Credit Card (${cardNumberController.text.substring(cardNumberController.text.length > 4 ? cardNumberController.text.length - 4 : 0)})';
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Save Card', style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPaymentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey300, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Text('Your Payments', style: AppTextStyles.h5.copyWith(color: AppColors.grey900)),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.payment, color: AppColors.blue, size: 28),
                title: Text('KNET', style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.grey900)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey400),
                onTap: () { setState(() => selectedPayment = 'KNET'); Navigator.pop(context); },
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.credit_card, color: AppColors.orange, size: 28),
                title: Text('Credit Card', style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.grey900)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey400),
                onTap: () { Navigator.pop(context); _showCreditCardDialog(context); },
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.money, color: AppColors.green, size: 28),
                title: Text('Cash on Delivery', style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.grey900)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey400),
                onTap: () { setState(() => selectedPayment = 'Cash on Delivery'); Navigator.pop(context); },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateChip(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary500.withOpacity(0.1) : AppColors.grey100,
          border: Border.all(color: isSelected ? AppColors.primary500 : Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(label, style: AppTextStyles.bodySmallBold.copyWith(color: isSelected ? AppColors.primary500 : AppColors.grey900)),
        ),
      ),
    );
  }

  Widget _buildTimeChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary500.withOpacity(0.1) : AppColors.grey100,
        border: Border.all(color: isSelected ? AppColors.primary500 : Colors.transparent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: AppTextStyles.bodySmallBold.copyWith(color: isSelected ? AppColors.primary500 : AppColors.grey900)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItemsAsync = ref.watch(cartItemsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: Text(l10n.confirmOrder, style: AppTextStyles.h4.copyWith(color: AppColors.grey900)),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
          onPressed: () => context.pop(),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.notifications),
                    child: SvgPicture.asset(AppAssets.bellIcon, width: 24, height: 24),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: SvgPicture.asset(AppAssets.ellipseIcon, width: 8, height: 8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: cartItemsAsync.when(
        data: (items) {
          double subtotal = items.fold(0.0, (sum, item) => sum + ((item['price'] ?? 0).toDouble() * (item['quantity'] ?? 1)));
          const double shipping = 2.0;
          final double totalPayment = subtotal + shipping;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.grey200!)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.address, style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.grey900)),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: AppColors.primary500.withOpacity(0.1), shape: BoxShape.circle),
                            child: const Icon(Icons.location_on, color: AppColors.primary500, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(currentAddressTitle, style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.grey900)),
                                const SizedBox(height: 2),
                                Text(currentAddressSubtitle, style: AppTextStyles.bodySmallRegular.copyWith(color: AppColors.grey500, height: 1.4)),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push(AppRoutes.setAddressForm),
                            child: Text(l10n.change, style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.primary500)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey400),
                            onPressed: () async {
                              final result = await context.push<Map<String, String>>(AppRoutes.setAddress);
                              if (result != null) {
                                setState(() {
                                  currentAddressTitle = result['title'] ?? currentAddressTitle;
                                  currentAddressSubtitle = result['subtitle'] ?? currentAddressSubtitle;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.grey200!)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.summary, style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.grey900)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.price, style: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.grey500)),
                          Text('\$${subtotal.toStringAsFixed(2)}', style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.grey900)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.shipping, style: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.grey500)),
                          Text('\$2', style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.grey900)),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Divider()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.totalPayment, style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.grey900)),
                          Text('\$${totalPayment.toStringAsFixed(2)}', style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.primary500)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: InkWell(
                          onTap: () => _showPaymentDetailsBottomSheet(context, subtotal, items),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(l10n.seeDetails, style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.primary500)),
                              const Icon(Icons.keyboard_arrow_down, color: AppColors.primary500, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _showDateTimePicker(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.grey200!)),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: AppColors.primary500.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.calendar_today, color: AppColors.primary500, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l10n.dateTime, style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.grey900)), const SizedBox(height: 4), Text('$selectedDate - $selectedTime', style: AppTextStyles.bodySmallRegular.copyWith(color: AppColors.grey500))])),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey400),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _showPaymentBottomSheet(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.grey200!)),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: AppColors.primary500.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.payment, color: AppColors.primary500, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l10n.payment, style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.grey900)), const SizedBox(height: 4), Text(l10n.selectedPayment(selectedPayment), style: AppTextStyles.bodySmallRegular.copyWith(color: AppColors.grey500))])),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey400),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary500)),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: AppColors.white,
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary500, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
            onPressed: isOrdering
                ? null
                : () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) return;

                    final items = ref.read(cartItemsProvider).value ?? [];
                    if (items.isEmpty) return;

                    setState(() => isOrdering = true);

                    try {
                      double subtotal = items.fold(0.0, (sum, item) {
                        double price = (item['price'] ?? 0).toDouble();
                        int quantity = (item['quantity'] ?? 1);
                        return sum + (price * quantity);
                      });

                      final orderRef = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('orders')
                          .add({
                        'items': items,
                        'subtotal': subtotal,
                        'shipping': 2.0,
                        'total': subtotal + 2.0,
                        'paymentMethod': selectedPayment,
                        'dateTime': '$selectedDate - $selectedTime',
                        'deliveryTime': Timestamp.fromDate(selectedDeliveryDateTime),
                        'address': '$currentAddressTitle - $currentAddressSubtitle',
                        'createdAt': FieldValue.serverTimestamp(),
                        'status': 'On the way',
                      });

                      if (items.isNotEmpty) {
                        final firstBookTitle = items[0]['title'] ?? 'Book';
                        await NotificationService.showOnTheWayNotification(
                          title: l10n.pushOrderOnTheWayTitle,
                          body: l10n.pushOrderOnTheWayBody(firstBookTitle),
                        );
                      }

                      final cartDocs = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('cart')
                          .get();

                      for (var doc in cartDocs.docs) {
                        await doc.reference.delete();
                      }

                      if (context.mounted) {
                        context.go(AppRoutes.orderSuccess, extra: orderRef.id);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    } finally {
                      if (mounted) setState(() => isOrdering = false);
                    }
                  },
            child: isOrdering
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                  )
                : Text(l10n.order, style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.white)),
          ),
        ),
      ),
    );
  }
}