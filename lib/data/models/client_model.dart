import 'package:equatable/equatable.dart';

class ClientModel extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  const ClientModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  String get fullName => '$firstName $lastName';
  
  String get initials {
    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
  }

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as int,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
    };
  }

  ClientModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) {
    return ClientModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [id, firstName, lastName, email, phone];
}

// Paginated response for clients
class PaginatedClientsResponse {
  final List<ClientModel> clients;
  final int total;
  final int page;
  final int pageSize;

  PaginatedClientsResponse({
    required this.clients,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  bool get hasMore => (page * pageSize) < total;

  factory PaginatedClientsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedClientsResponse(
      clients: (json['data'] as List?)
              ?.map((e) => ClientModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
    );
  }
}