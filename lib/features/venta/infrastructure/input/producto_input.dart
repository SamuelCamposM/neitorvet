import 'package:formz/formz.dart';
import 'package:neitorvet/features/venta/domain/entities/producto.dart';

// Define input validation errors
enum ProductoInputError { empty }

// Extend FormzInput and provide the input type and error type.
class ProductoInput extends FormzInput<Producto, ProductoInputError> {
  // Call super.pure to represent an unmodified form input.
  const ProductoInput.pure()
      : super.pure(const Producto(
            cantidad: 0,
            codigo: "",
            descripcion: "",
            valUnitarioInterno: 0,
            valorUnitario: 0,
            recargoPorcentaje: 0,
            recargo: 0,
            descPorcentaje: 0,
            descuento: 0,
            precioSubTotalProducto: 0,
            valorIva: 0,
            costoProduccion: 0,
            llevaIva: "SI",
            incluyeIva: ''));

  // Call super.dirty to represent a modified form input.
  const ProductoInput.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == ProductoInputError.empty) {
      return 'Seleccione un producto';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  ProductoInputError? validator(Producto value) {
    if (value.descripcion.isEmpty) return ProductoInputError.empty;

    return null;
  }
}
