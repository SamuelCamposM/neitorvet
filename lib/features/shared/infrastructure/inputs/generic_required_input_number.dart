import 'package:formz/formz.dart';

// Define input validation errors
enum GenericRequiredInputNumberError { empty, lessThanOrEqualToZero, greaterThanMax }

// Extend FormzInput and provide the input type and error type.
class GenericRequiredInputNumber
    extends FormzInput<num, GenericRequiredInputNumberError> {
  final num? maxValue;

  // Constructor with required parameter
  const GenericRequiredInputNumber.pure([this.maxValue]) : super.pure(0);
  const GenericRequiredInputNumber.dirty(num value, [this.maxValue]) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == GenericRequiredInputNumberError.empty) {
      return 'El campo es requerido';
    }

    if (displayError == GenericRequiredInputNumberError.lessThanOrEqualToZero) {
      return 'El valor debe ser mayor a 0';
    }

    if (displayError == GenericRequiredInputNumberError.greaterThanMax) {
      return 'El valor debe ser menor o igual a $maxValue';
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

    if (maxValue != null && value > maxValue!) {
      return GenericRequiredInputNumberError.greaterThanMax;
    }

    return null;
  }
}