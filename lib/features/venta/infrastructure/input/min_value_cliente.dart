import 'package:formz/formz.dart';

// Define input validation errors
enum MinValueClienteError { empty, lessThanRequired }

class MinValueCliente extends FormzInput<num, MinValueClienteError> {
  final String venRucCliente;

  // Constructor que recibe el tipo de cliente
  const MinValueCliente.pure({this.venRucCliente = ''}) : super.pure(0);

  const MinValueCliente.dirty(super.value, {required this.venRucCliente})
      : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == MinValueClienteError.lessThanRequired) {
      return 'Por favor ingrese los datos del cliente';
    }

    return null;
  }

  @override
  MinValueClienteError? validator(num? value) {
    if (value == null) return MinValueClienteError.empty;

    // Validar si el tipo de cliente es "CONSUMIDOR FINAL" y el valor es menor o igual a 19
    if (venRucCliente == '9999999999999') {
      return MinValueClienteError.lessThanRequired;
    }

    return null;
  }
}
