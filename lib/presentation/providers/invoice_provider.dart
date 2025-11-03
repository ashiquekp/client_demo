import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/invoice_viewmodel.dart';

// Re-export for convenience
final invoiceStateProvider = invoiceViewModelProvider;

final invoicesListProvider = Provider((ref) {
  return ref.watch(invoiceViewModelProvider).invoices;
});

final invoicesLoadingProvider = Provider<bool>((ref) {
  return ref.watch(invoiceViewModelProvider).isLoading;
});

final invoicesErrorProvider = Provider<String?>((ref) {
  return ref.watch(invoiceViewModelProvider).error;
});

final invoicesTotalProvider = Provider<int>((ref) {
  return ref.watch(invoiceViewModelProvider).total;
});