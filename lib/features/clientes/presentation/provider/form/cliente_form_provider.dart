import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/clientes/presentation/provider/clientes_provider.dart';

import 'package:neitorvet/features/shared/shared.dart';

final clienteFormProvider = StateNotifierProvider.family
    .autoDispose<ClienteFormNotifier, ClienteFormState, Cliente>(
        (ref, cliente) {
  final createUpdateCliente =
      ref.watch(clientesProvider.notifier).createUpdateCliente;
  return ClienteFormNotifier(
      cliente: cliente, createUpdateCliente: createUpdateCliente);
});

class ClienteFormNotifier extends StateNotifier<ClienteFormState> {
  final Future<void> Function(Map<String, dynamic> clienteMap)
      createUpdateCliente;
  ClienteFormNotifier({
    required Cliente cliente,
    required this.createUpdateCliente,
  }) : super(ClienteFormState(
          perId: cliente.perId,
          perCanton: GenericRequiredInput.dirty(cliente.perCanton),
          perDireccion: GenericRequiredInput.dirty(cliente.perDireccion),
          perDocNumero: GenericRequiredInput.dirty(cliente.perDocNumero),
          perNombre: GenericRequiredInput.dirty(cliente.perNombre),
          perPais: GenericRequiredInput.dirty(cliente.perPais),
          perProvincia: GenericRequiredInput.dirty(cliente.perProvincia),
          perRecomendacion:
              GenericRequiredInput.dirty(cliente.perRecomendacion),
          perCelular: cliente.perCelular,
          perEmail: cliente.perEmail,
          perEmpresa: cliente.perEmpresa,
          perOtros: cliente.perOtros,
          perPerfil: cliente.perPerfil,
          perCodigo: cliente.perCodigo,
          perCredito: cliente.perCredito,
          perDocTipo: cliente.perDocTipo,
          perDocumento: cliente.perDocumento,
          perEspecialidad: cliente.perEspecialidad,
          perEstado: cliente.perEstado,
          perFecNacimiento: cliente.perFecNacimiento,
          perFecReg: cliente.perFecReg,
          perFecUpd: cliente.perFecUpd,
          perFoto: cliente.perFoto,
          perGenero: cliente.perGenero,
          perNombreComercial: cliente.perNombreComercial,
          perObligado: cliente.perObligado,
          perObsevacion: cliente.perObsevacion,
          perPersonal: cliente.perPersonal,
          perSenescyt: cliente.perSenescyt,
          perTelefono: cliente.perTelefono,
          perTiempoCredito: cliente.perTiempoCredito,
          perTipoProveedor: cliente.perTipoProveedor,
          perTitulo: cliente.perTitulo,
          perUser: cliente.perUser,
          perUsuario: cliente.perUsuario,
          perUbicacion: cliente.perUbicacion,
          perNickname: cliente.perNickname,
        ));

  void updateState({
    String? perCanton,
    String? perDireccion,
    String? perDocNumero,
    String? perNombre,
    String? perPais,
    String? perProvincia,
    String? perRecomendacion,
    List<String>? perCelular,
    List<String>? perEmail,
    List<String>? perEmpresa,
    List<String>? perOtros,
    List<String>? perPerfil,
    String? perCodigo,
    String? perCredito,
    String? perDocTipo,
    String? perDocumento,
    String? perEspecialidad,
    String? perEstado,
    String? perFecNacimiento,
    String? perFecReg,
    String? perFecUpd,
    String? perFoto,
    String? perGenero,
    String? perNombreComercial,
    String? perObligado,
    String? perObsevacion,
    String? perPersonal,
    String? perSenescyt,
    String? perTelefono,
    String? perTiempoCredito,
    String? perTipoProveedor,
    String? perTitulo,
    String? perUser,
    String? perUsuario,
    String? perNickname,
  }) {
    state = state.copyWith(
      perCanton: GenericRequiredInput.dirty(perCanton ?? state.perCanton.value),
      perDireccion:
          GenericRequiredInput.dirty(perDireccion ?? state.perDireccion.value),
      perDocNumero:
          GenericRequiredInput.dirty(perDocNumero ?? state.perDocNumero.value),
      perNombre: GenericRequiredInput.dirty(perNombre ?? state.perNombre.value),
      perPais: GenericRequiredInput.dirty(perPais ?? state.perPais.value),
      perProvincia:
          GenericRequiredInput.dirty(perProvincia ?? state.perProvincia.value),
      perRecomendacion: GenericRequiredInput.dirty(
          perRecomendacion ?? state.perRecomendacion.value),
      perCelular: perCelular ?? state.perCelular,
      perEmail: perEmail ?? state.perEmail,
      perEmpresa: perEmpresa ?? state.perEmpresa,
      perOtros: perOtros ?? state.perOtros,
      perPerfil: perPerfil ?? state.perPerfil,
      perCodigo: perCodigo ?? state.perCodigo,
      perCredito: perCredito ?? state.perCredito,
      perDocTipo: perDocTipo ?? state.perDocTipo,
      perDocumento: perDocumento ?? state.perDocumento,
      perEspecialidad: perEspecialidad ?? state.perEspecialidad,
      perEstado: perEstado ?? state.perEstado,
      perFecNacimiento: perFecNacimiento ?? state.perFecNacimiento,
      perFecReg: perFecReg ?? state.perFecReg,
      perFecUpd: perFecUpd ?? state.perFecUpd,
      perFoto: perFoto ?? state.perFoto,
      perGenero: perGenero ?? state.perGenero,
      perNombreComercial: perNombreComercial ?? state.perNombreComercial,
      perObligado: perObligado ?? state.perObligado,
      perObsevacion: perObsevacion ?? state.perObsevacion,
      perPersonal: perPersonal ?? state.perPersonal,
      perSenescyt: perSenescyt ?? state.perSenescyt,
      perTelefono: perTelefono ?? state.perTelefono,
      perTiempoCredito: perTiempoCredito ?? state.perTiempoCredito,
      perTipoProveedor: perTipoProveedor ?? state.perTipoProveedor,
      perTitulo: perTitulo ?? state.perTitulo,
      perUser: perUser ?? state.perUser,
      perUsuario: perUsuario ?? state.perUsuario,
      perNickname: perNickname ?? state.perNickname,
      isFormValid: Formz.validate([
        GenericRequiredInput.dirty(perCanton ?? state.perCanton.value),
        GenericRequiredInput.dirty(perDireccion ?? state.perDireccion.value),
        GenericRequiredInput.dirty(perDocNumero ?? state.perDocNumero.value),
        GenericRequiredInput.dirty(perNombre ?? state.perNombre.value),
        GenericRequiredInput.dirty(perPais ?? state.perPais.value),
        GenericRequiredInput.dirty(perProvincia ?? state.perProvincia.value),
        GenericRequiredInput.dirty(
            perRecomendacion ?? state.perRecomendacion.value),
      ]),
    );
  }

  Future<bool> onFormSubmit() async {
    // Marcar todos los campos como tocados
    _touchedEverything();

    // Esperar un breve momento para asegurar que el estado se actualice

    // Verificar si el formulario es válido y si ya se está posteando
    if (!state.isFormValid) {
      return false;
    }
    if (state.isPosting) {
      return false;
    }
    // Actualizar el estado para indicar que se está posteando
    state = state.copyWith(isPosting: true);
    final clienteMap = {
      "perId": state.perId,
      "perCanton": state.perCanton.value,
      "perDireccion": state.perDireccion.value,
      "perDocNumero": state.perDocNumero.value,
      "perNombre": state.perNombre.value,
      "perPais": state.perPais.value,
      "perProvincia": state.perProvincia.value,
      "perRecomendacion": state.perRecomendacion.value,
      "perCelular": state.perCelular,
      "perEmail": state.perEmail,
      "perEmpresa": state.perEmpresa,
      "perOtros": state.perOtros,
      "perPerfil": state.perPerfil,
      "perCodigo": state.perCodigo,
      "perCredito": state.perCredito,
      "perDocTipo": state.perDocTipo,
      "perDocumento": state.perDocumento,
      "perEspecialidad": state.perEspecialidad,
      "perEstado": state.perEstado,
      "perFecNacimiento": state.perFecNacimiento,
      "perFecReg": state.perFecReg,
      "perFecUpd": state.perFecUpd,
      "perFoto": state.perFoto,
      "perGenero": state.perGenero,
      "perNombreComercial": state.perNombreComercial,
      "perObligado": state.perObligado,
      "perObsevacion": state.perObsevacion,
      "perPersonal": state.perPersonal,
      "perSenescyt": state.perSenescyt,
      "perTelefono": state.perTelefono,
      "perTiempoCredito": state.perTiempoCredito,
      "perTipoProveedor": state.perTipoProveedor,
      "perTitulo": state.perTitulo,
      "perUser": state.perUser,
      "perUsuario": state.perUsuario,
      "perUbicacion": {"latitud": 0, "longitud": 0},
      "tabla": "proveedor", //DEFECTO
      "rucempresa": "DEMO"
    };

    try {
      // socket.emit('editar-registro', clienteMap);
      const result = true;
      //  await onSubmitCallback(productMap);
      await createUpdateCliente(clienteMap);
      // Actualizar el estado para indicar que ya no se está posteando
      state = state.copyWith(isPosting: false);

      return result;
    } catch (e) {
      // Actualizar el estado para indicar que ya no se está posteando
      state = state.copyWith(isPosting: false);

      return false;
    }
  }

  void _touchedEverything() {
    state = state.copyWith(
        isFormValid: Formz.validate([
      GenericRequiredInput.dirty(state.perCanton.value),
      GenericRequiredInput.dirty(state.perDireccion.value),
      GenericRequiredInput.dirty(state.perDocNumero.value),
      GenericRequiredInput.dirty(state.perNombre.value),
      GenericRequiredInput.dirty(state.perPais.value),
      GenericRequiredInput.dirty(state.perProvincia.value),
      GenericRequiredInput.dirty(state.perRecomendacion.value),
    ]));
  }
}

class ClienteFormState {
  final bool isFormValid;
  final bool isPosted;
  final bool isPosting;

  final GenericRequiredInput perCanton;
  final GenericRequiredInput perDireccion;
  final GenericRequiredInput perDocNumero;
  final GenericRequiredInput perNombre;
  final GenericRequiredInput perPais;
  final GenericRequiredInput perProvincia;
  final GenericRequiredInput perRecomendacion;

  final int perId;
  final List<String> perCelular;
  final List<String> perEmail;
  final List<String> perEmpresa;
  final List<String> perOtros;
  final List<String> perPerfil;
  final PerUbicacion perUbicacion;
  final String perCodigo;
  final String perCredito;
  final String perDocTipo;
  final String perDocumento;
  final String perEspecialidad;
  final String perEstado;
  final String perFecNacimiento;
  final String perFecReg;
  final String perFecUpd;
  final String perFoto;
  final String perGenero;
  final String perNombreComercial;
  final String perObligado;
  final String perObsevacion;
  final String perPersonal;
  final String perSenescyt;
  final String perTelefono;
  final String perTiempoCredito;
  final String perTipoProveedor;
  final String perTitulo;
  final String perUser;
  final String perUsuario;
  final String? perNickname;

  ClienteFormState({
    this.isFormValid = false,
    this.isPosted = false,
    this.isPosting = false,
    this.perId = 0,
    this.perCanton = const GenericRequiredInput.dirty(''),
    this.perDireccion = const GenericRequiredInput.dirty(''),
    this.perDocNumero = const GenericRequiredInput.dirty(''),
    this.perNombre = const GenericRequiredInput.dirty(''),
    this.perPais = const GenericRequiredInput.dirty(''),
    this.perProvincia = const GenericRequiredInput.dirty(''),
    this.perRecomendacion = const GenericRequiredInput.dirty(''),
    this.perCelular = const [],
    this.perEmail = const [],
    this.perEmpresa = const [],
    this.perOtros = const [],
    this.perPerfil = const [],
    this.perCodigo = '',
    this.perCredito = '',
    this.perDocTipo = '',
    this.perDocumento = '',
    this.perEspecialidad = '',
    this.perEstado = '',
    this.perFecNacimiento = '',
    this.perFecReg = '',
    this.perFecUpd = '',
    this.perFoto = '',
    this.perGenero = '',
    this.perNombreComercial = '',
    this.perObligado = '',
    this.perObsevacion = '',
    this.perPersonal = '',
    this.perSenescyt = '',
    this.perTelefono = '',
    this.perTiempoCredito = '',
    this.perTipoProveedor = '',
    this.perTitulo = '',
    this.perUser = '',
    this.perUsuario = '',
    required this.perUbicacion,
    this.perNickname = '',
  });
  ClienteFormState copyWith({
    bool? isFormValid,
    bool? isPosted,
    bool? isPosting,
    int? perId,
    GenericRequiredInput? perCanton,
    GenericRequiredInput? perDireccion,
    GenericRequiredInput? perDocNumero,
    GenericRequiredInput? perNombre,
    GenericRequiredInput? perPais,
    GenericRequiredInput? perProvincia,
    GenericRequiredInput? perRecomendacion,
    List<String>? perCelular,
    List<String>? perEmail,
    List<String>? perEmpresa,
    List<String>? perOtros,
    List<String>? perPerfil,
    String? perCodigo,
    String? perCredito,
    String? perDocTipo,
    String? perDocumento,
    String? perEspecialidad,
    String? perEstado,
    String? perFecNacimiento,
    String? perFecReg,
    String? perFecUpd,
    String? perFoto,
    String? perGenero,
    String? perNombreComercial,
    String? perObligado,
    String? perObsevacion,
    String? perPersonal,
    String? perSenescyt,
    String? perTelefono,
    String? perTiempoCredito,
    String? perTipoProveedor,
    String? perTitulo,
    String? perUser,
    String? perUsuario,
    PerUbicacion? perUbicacion,
    String? perNickname,
  }) {
    return ClienteFormState(
      isFormValid: isFormValid ?? this.isFormValid,
      isPosted: isPosted ?? this.isPosted,
      isPosting: isPosting ?? this.isPosting,
      perId: perId ?? this.perId,
      perCanton: perCanton ?? this.perCanton,
      perDireccion: perDireccion ?? this.perDireccion,
      perDocNumero: perDocNumero ?? this.perDocNumero,
      perNombre: perNombre ?? this.perNombre,
      perPais: perPais ?? this.perPais,
      perProvincia: perProvincia ?? this.perProvincia,
      perRecomendacion: perRecomendacion ?? this.perRecomendacion,
      perCelular: perCelular ?? this.perCelular,
      perEmail: perEmail ?? this.perEmail,
      perEmpresa: perEmpresa ?? this.perEmpresa,
      perOtros: perOtros ?? this.perOtros,
      perPerfil: perPerfil ?? this.perPerfil,
      perCodigo: perCodigo ?? this.perCodigo,
      perCredito: perCredito ?? this.perCredito,
      perDocTipo: perDocTipo ?? this.perDocTipo,
      perDocumento: perDocumento ?? this.perDocumento,
      perEspecialidad: perEspecialidad ?? this.perEspecialidad,
      perEstado: perEstado ?? this.perEstado,
      perFecNacimiento: perFecNacimiento ?? this.perFecNacimiento,
      perFecReg: perFecReg ?? this.perFecReg,
      perFecUpd: perFecUpd ?? this.perFecUpd,
      perFoto: perFoto ?? this.perFoto,
      perGenero: perGenero ?? this.perGenero,
      perNombreComercial: perNombreComercial ?? this.perNombreComercial,
      perObligado: perObligado ?? this.perObligado,
      perObsevacion: perObsevacion ?? this.perObsevacion,
      perPersonal: perPersonal ?? this.perPersonal,
      perSenescyt: perSenescyt ?? this.perSenescyt,
      perTelefono: perTelefono ?? this.perTelefono,
      perTiempoCredito: perTiempoCredito ?? this.perTiempoCredito,
      perTipoProveedor: perTipoProveedor ?? this.perTipoProveedor,
      perTitulo: perTitulo ?? this.perTitulo,
      perUser: perUser ?? this.perUser,
      perUsuario: perUsuario ?? this.perUsuario,
      perUbicacion: perUbicacion ?? this.perUbicacion,
      perNickname: perNickname ?? this.perNickname,
    );
  }
}
