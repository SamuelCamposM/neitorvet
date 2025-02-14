import 'package:formz/formz.dart';

// Define input validation errors
enum GenericRequiredInputError { empty }

// Extend FormzInput and provide the input type and error type.
class GenericRequiredInput extends FormzInput<String, GenericRequiredInputError> {
  // Call super.pure to represent an unmodified form input.
  const GenericRequiredInput.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const GenericRequiredInput.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == GenericRequiredInputError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  GenericRequiredInputError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return GenericRequiredInputError.empty;

    return null;
  }
}

// import 'package:formz/formz.dart';

// // Define input validation errors
// enum GenericRequiredInputError { empty, invalid }

// // Extend FormzInput and provide the input type and error type.
// class GenericRequiredInput extends FormzInput<String, GenericRequiredInputError> {
//   final String customParameter;

//   // Call super.pure to represent an unmodified form input.
//   const GenericRequiredInput.pure({this.customParameter = ''}) : super.pure('');

//   // Call super.dirty to represent a modified form input.
//   const GenericRequiredInput.dirty(super.value, {this.customParameter = ''}) : super.dirty();

//   String? get errorMessage {
//     if (isValid || isPure) return null;

//     if (displayError == GenericRequiredInputError.empty) return 'El campo es requerido';
//     if (displayError == GenericRequiredInputError.invalid) return 'El valor es inválido';

//     return null;
//   }

//   // Override validator to handle validating a given input value.
//   @override
//   GenericRequiredInputError? validator(String value) {
//     if (value.isEmpty || value.trim().isEmpty) return GenericRequiredInputError.empty;

//     // Custom validation logic based on the parameter
//     if (!validateWithCustomParameter(value)) return GenericRequiredInputError.invalid;

//     return null;
//   }

//   bool validateWithCustomParameter(String value) {
//     // Implement your custom validation logic here
//     // For example, let's say the custom parameter should be part of the value
//     return value.contains(customParameter);
//   }
// }
