import '../constants/app_constants.dart';

class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(AppConstants.emailRegex);
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    
    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password must not exceed ${AppConstants.maxPasswordLength} characters';
    }
    
    return null;
  }

  // Name validation
  static String? name(String? value, {String fieldName = 'Name'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (value.length < AppConstants.minNameLength) {
      return '$fieldName must be at least ${AppConstants.minNameLength} characters';
    }
    
    if (value.length > AppConstants.maxNameLength) {
      return '$fieldName must not exceed ${AppConstants.maxNameLength} characters';
    }
    
    return null;
  }

  // Phone validation
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    final phoneRegex = RegExp(AppConstants.phoneRegex);
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    
    return null;
  }

  // Required field validation
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Number validation
  static String? number(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    
    return null;
  }

  // Minimum value validation
  static String? minValue(String? value, double min, {String fieldName = 'Value'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    final numValue = double.tryParse(value);
    if (numValue == null) {
      return 'Please enter a valid number';
    }
    
    if (numValue < min) {
      return '$fieldName must be at least $min';
    }
    
    return null;
  }
}