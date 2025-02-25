import 'package:formz/formz.dart';

// Define input validation errors
enum NumDocError { empty, invalid }

// Extend FormzInput and provide the input type and error type.
class NumDoc extends FormzInput<String, NumDocError> {
  final String tipo;

  // Constructor with required parameter
  const NumDoc.pure(this.tipo) : super.pure('');
  const NumDoc.dirty(String value, this.tipo) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == NumDocError.empty) return 'El campo es requerido';

    if (displayError == NumDocError.invalid) {
      switch (tipo) {
        case 'RUC':
          return 'El RUC debe tener 13 caracteres';
        case 'CEDULA':
          return 'La Cédula debe tener 10 caracteres';
        case 'PASAPORTE':
          return 'El Pasaporte debe tener más de 3 caracteres';
        case 'PLACA':
          return 'El tipo PLACA es válido unicamente para buscar';
        default:
          return 'Valor inválido';
      }
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  NumDocError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return NumDocError.empty;

    switch (tipo) {
      case 'RUC':
        if (value.length != 13) return NumDocError.invalid;
        break;
      case  'CEDULA':
        if (value.length != 10) return NumDocError.invalid;
        break;
      case 'PASAPORTE':
        if (value.length <= 3) return NumDocError.invalid;
        break;
      case 'PLACA':
        return NumDocError.invalid;
    }

    return null;
  }
}

// import 'package:formz/formz.dart';

// // Define input validation errors
// enum NumDocError { empty, invalid }

// // Extend FormzInput and provide the input type and error type.
// class NumDoc extends FormzInput<String, NumDocError> {
//   final String customParameter;

//   // Call super.pure to represent an unmodified form input.
//   const NumDoc.pure({this.customParameter = ''}) : super.pure('');

//   // Call super.dirty to represent a modified form input.
//   const NumDoc.dirty(super.value, {this.customParameter = ''}) : super.dirty();

//   String? get errorMessage {
//     if (isValid || isPure) return null;

//     if (displayError == NumDocError.empty) return 'El campo es requerido';
//     if (displayError == NumDocError.invalid) return 'El valor es inválido';

//     return null;
//   }

//   // Override validator to handle validating a given input value.
//   @override
//   NumDocError? validator(String value) {
//     if (value.isEmpty || value.trim().isEmpty) return NumDocError.empty;

//     // Custom validation logic based on the parameter
//     if (!validateWithCustomParameter(value)) return NumDocError.invalid;

//     return null;
//   }

//   bool validateWithCustomParameter(String value) {
//     // Implement your custom validation logic here
//     // For example, let's say the custom parameter should be part of the value
//     return value.contains(customParameter);
//   }
// }
