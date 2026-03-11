
class ValidationService {

  /// Email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return "Please enter a valid email";
    }
    return null; // valid
  }

  /// Full name
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Full name is required";
    }
    return null;
  }


  /// Last name
  static String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Last name is required";
    }
    return null;
  }

  /// Vehicle name
  static String? validateVehicleName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Vehicle name is required";
    }
    return null;
  }

  /// Registration number
  static String? validateRegistration(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Registration number is required";
    }
    return null;
  }
  /// Date
  static String? validateDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Date is required";
    }
    return null;
  }
  /// Desc
  static String? validateDesc(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Description is required";
    }
    return null;
  }  /// Income
  static String? validateIncome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Income is  required";
    }
    return null;
  }
 /// Amount
  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Amount is  required";
    }
    return null;
  }

  /// Phone
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone Number is required";
    }
    // Remove non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length < 10) {
      return "Enter a valid phone number";
    }

    return null;
  }

  /// Company name
  static String? validateCompanyName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Company name is required";
    }
    return null;
  }

  /// Password
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Password is required";
    }

    if (value.trim().length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  /// Confirm Password
  static String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Confirm Password is required";
    }

    if (value.trim().length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }



  /// Optional field (returns null always → means valid)
  static String? validateOptional(String? value) {
    return null; // always valid
  }
}