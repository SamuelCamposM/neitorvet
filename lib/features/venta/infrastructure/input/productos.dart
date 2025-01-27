import 'package:formz/formz.dart';
import 'package:neitorvet/features/venta/domain/entities/producto.dart';

// Define input validation errors
enum ProductosError { empty }

// Extend FormzInput and provide the input type and error type.
class Productos extends FormzInput<List<Producto>, ProductosError> {
  // Call super.pure to represent an unmodified form input.
  const Productos.pure() : super.pure(const []);

  // Call super.dirty to represent a modified form input.
  const Productos.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == ProductosError.empty) {
      return 'Ingrese al menos un producto';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  ProductosError? validator(List<Producto> value) {
    if (value.isEmpty) return ProductosError.empty;

    return null;
  }
}
