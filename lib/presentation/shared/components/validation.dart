mixin FormValidationMixin {
  String? nameValidation(String name) {
    if (name.trim().isEmpty) {
      return 'Please enter your name';
    }

    return null;
  }

  String? emptyValidation(String? value, String? label) {
    if (value!.trim().isEmpty || value == null) {
      return '$label is required';
    }

    return null;
  }

  String? requiredField(String? value) {
    if (value!.trim().isEmpty || value == null) {
      return 'Field is required';
    }

    return null;
  }

  String? phoneValidation(String? phone) {
    if (phone == null && phone?.isEmpty == true) {
      return 'Please enter your number';
    }
    if (phone?.length != 10) {
      return 'Phone number should be of 10 digits';
    }

    return null;
  }

  String? emailValidation(String? email) {
    if (email == null) {
      return 'Field is required';
    }
    if (email.isEmpty) {
      return 'Please Enter your email';
    }
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!regex.hasMatch(email)) {
      return 'Enter valid E-Mail';
    }

    return null;
  }
}
