import 'package:formz/formz.dart';

// Define input validation errors
enum GenericRequiredInputNumberError { empty, lessThanOrEqualToZero }

// Extend FormzInput and provide the input type and error type.
class GenericRequiredInputNumber
    extends FormzInput<num, GenericRequiredInputNumberError> {
  // Call super.pure to represent an unmodified form input.
  const GenericRequiredInputNumber.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const GenericRequiredInputNumber.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == GenericRequiredInputNumberError.empty) {
      return 'El campo es requerido';
    }

    if (displayError == GenericRequiredInputNumberError.lessThanOrEqualToZero) {
      return 'El valor debe ser mayor a 0';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  GenericRequiredInputNumberError? validator(num? value) {
    if (value == null) return GenericRequiredInputNumberError.empty;

    if (value <= 0) {
      return GenericRequiredInputNumberError.lessThanOrEqualToZero;
    }

    return null;
  }
}
