class LiquorValidation {
  static String? validateLiquorName(String value) {
    if (value.isEmpty) {
      return 'Liquor name cannot be empty';
    }
    if (value.length < 3) {
      return 'Liquor name least 3 characters long';
    }
    return null;
  }

  static String? validateBrandName(String value) {
    if (value.isEmpty) {
      return 'Brand name cannot be empty';
    }
    if (value.length < 3) {
      return 'Brand name least 3 characters long';
    }
    return null;
  }

  static String? validateLife(String value) {
    if (value.isEmpty) {
      return 'Shelf life cannot be empty';
    }
    return null;
  }

  static String? validateVol(String value) {
    if (value.isEmpty) {
      return 'Volume cannot be empty';
    }
    return null;
  }

  static String? type(String value) {
    if (value.isEmpty) {
      return 'Liquor type cannot cannot be empty';
    }
    return null;
  }

  static String? origin(String value) {
    if (value.isEmpty) {
      return 'Liquor origin cannot cannot be empty';
    }
    return null;
  }

  static String? price(String value) {
    if (value.isEmpty) {
      return 'Liquor price cannot cannot be empty';
    }
    return null;
  }
  static String? stock(String value) {
    if (value.isEmpty) {
      return 'Liquor stock cannot cannot be empty';
    }
    return null;
  }
  static String? desc(String value) {
    if (value.isEmpty) {
      return 'Liquor description cannot cannot be empty';
    }
    return null;
  }
}
