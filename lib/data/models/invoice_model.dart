import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class InvoiceModel extends Equatable {
  final int id;
  final String invoiceNo;
  final int clientId;
  final double total;
  final String status;
  final DateTime? createdAt;
  final DateTime? dueDate;

  const InvoiceModel({
    required this.id,
    required this.invoiceNo,
    required this.clientId,
    required this.total,
    required this.status,
    this.createdAt,
    this.dueDate,
  });

  String get formattedTotal {
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
    return formatter.format(total);
  }

  String get formattedCreatedAt {
    if (createdAt == null) return '';
    return DateFormat('dd MMM yyyy').format(createdAt!);
  }

  String get formattedDueDate {
    if (dueDate == null) return '';
    return DateFormat('dd MMM yyyy').format(dueDate!);
  }

  bool get isOverdue {
    if (status.toLowerCase() == 'paid') return false;
    if (dueDate == null) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] as int,
      invoiceNo: json['invoiceNo'] as String? ?? '',
      clientId: json['clientId'] as int,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'Pending',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      dueDate: json['dueDate'] != null
          ? DateTime.tryParse(json['dueDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceNo': invoiceNo,
      'clientId': clientId,
      'total': total,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  InvoiceModel copyWith({
    int? id,
    String? invoiceNo,
    int? clientId,
    double? total,
    String? status,
    DateTime? createdAt,
    DateTime? dueDate,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      invoiceNo: invoiceNo ?? this.invoiceNo,
      clientId: clientId ?? this.clientId,
      total: total ?? this.total,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  List<Object?> get props =>
      [id, invoiceNo, clientId, total, status, createdAt, dueDate];
}

// Paginated response for invoices
class PaginatedInvoicesResponse {
  final List<InvoiceModel> invoices;
  final int total;
  final int page;
  final int pageSize;

  PaginatedInvoicesResponse({
    required this.invoices,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  bool get hasMore => (page * pageSize) < total;

  factory PaginatedInvoicesResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedInvoicesResponse(
      invoices: (json['data'] as List?)
              ?.map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
    );
  }
}