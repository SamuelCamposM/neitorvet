import 'package:neitorvet/features/shared/helpers/parse.dart';
import 'package:neitorvet/features/shared/infrastructure/inputs/inputs.dart';

class Cliente {
  final String perNombreComercial;
  final List<String> perEmpresa;
  final String perPais;
  final String perProvincia;
  final String perCanton;
  final String perTipoProveedor;
  final String perTiempoCredito;
  final String perDocTipo;
  final String perDocNumero;
  final List<String> perPerfil;
  final String perNombre;
  final String perDireccion;
  final String perObligado;
  final String perCredito;
  final String perTelefono;
  final List<String> perCelular;
  final String perEstado;
  final String perObsevacion;
  final List<String> perEmail;
  final List<String> perOtros;
  final String? perNickname;
  final String perUser;
  final String? perFoto;
  final PerUbicacion perUbicacion;
  final String perDocumento;
  final String? perGenero;
  final String? perRecomendacion;
  final String perFecNacimiento;
  final String? perEspecialidad;
  final String perTitulo;
  final String perSenescyt;
  final String perPersonal;
  final int perId;
  final String perCodigo;
  final String perUsuario;
  final int perOnline;
  final int? perSaldo;
  final String perFecReg;
  final String perFecUpd;
  final PerPermisos? perPermisos;

  Cliente({
    required this.perNombreComercial,
    required this.perEmpresa,
    required this.perPais,
    required this.perProvincia,
    required this.perCanton,
    required this.perTipoProveedor,
    required this.perTiempoCredito,
    required this.perDocTipo,
    required this.perDocNumero,
    required this.perPerfil,
    required this.perNombre,
    required this.perDireccion,
    required this.perObligado,
    required this.perCredito,
    required this.perTelefono,
    required this.perCelular,
    required this.perEstado,
    required this.perObsevacion,
    required this.perEmail,
    required this.perOtros,
    required this.perNickname,
    required this.perUser,
    required this.perFoto,
    required this.perUbicacion,
    required this.perDocumento,
    required this.perGenero,
    required this.perRecomendacion,
    required this.perFecNacimiento,
    required this.perEspecialidad,
    required this.perTitulo,
    required this.perSenescyt,
    required this.perPersonal,
    required this.perId,
    required this.perCodigo,
    required this.perUsuario,
    required this.perOnline,
    required this.perSaldo,
    required this.perFecReg,
    required this.perFecUpd,
    this.perPermisos,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        perNombreComercial: json["perNombreComercial"] ?? '',
        perEmpresa: List<String>.from(json["perEmpresa"].map((x) => x)),
        perPais: json["perPais"],
        perProvincia: json["perProvincia"],
        perCanton: json["perCanton"],
        perTipoProveedor: json["perTipoProveedor"],
        perTiempoCredito: json["perTiempoCredito"],
        perDocTipo: json["perDocTipo"],
        perDocNumero: json["perDocNumero"],
        perPerfil: List<String>.from(json["perPerfil"].map((x) => x)),
        perNombre: json["perNombre"],
        perDireccion: json["perDireccion"],
        perObligado: json["perObligado"],
        perCredito: json["perCredito"],
        perTelefono: json["perTelefono"],
        perCelular: List<String>.from(json["perCelular"].map((x) => x)),
        perEstado: json["perEstado"],
        perObsevacion: json["perObsevacion"],
        perEmail: List<String>.from(json["perEmail"].map((x) => x)),
        perOtros: List<String>.from(json["perOtros"].map((x) => x)),
        perNickname: json["perNickname"],
        perUser: json["perUser"],
        perFoto: json["perFoto"],
        perUbicacion: PerUbicacion.fromJson(json["perUbicacion"]),
        perDocumento: json["perDocumento"],
        perGenero: json["perGenero"],
        perRecomendacion: json["perRecomendacion"],
        perFecNacimiento: json["perFecNacimiento"] ?? '',
        perEspecialidad: json["perEspecialidad"],
        perTitulo: json["perTitulo"],
        perSenescyt: json["perSenescyt"],
        perPersonal: json["perPersonal"],
        perId: json["perId"],
        perCodigo: json["perCodigo"],
        perUsuario: json["perUsuario"],
        perOnline: json["perOnline"],
        perSaldo: Parse.parseDynamicToInt(json["perSaldo"]),
        perFecReg: json["perFecReg"],
        perFecUpd: json["perFecUpd"],
        perPermisos: PerPermisos.fromJson(json["perPermisos"]),
      );

  Map<String, dynamic> toJson() => {
        "perNombreComercial": perNombreComercial,
        "perEmpresa": List<dynamic>.from(perEmpresa.map((x) => x)),
        "perPais": perPais,
        "perProvincia": perProvincia,
        "perCanton": perCanton,
        "perTipoProveedor": perTipoProveedor,
        "perTiempoCredito": perTiempoCredito,
        "perDocTipo": perDocTipo,
        "perDocNumero": perDocNumero,
        "perPerfil": List<dynamic>.from(perPerfil.map((x) => x)),
        "perNombre": perNombre,
        "perDireccion": perDireccion,
        "perObligado": perObligado,
        "perCredito": perCredito,
        "perTelefono": perTelefono,
        "perCelular": List<dynamic>.from(perCelular.map((x) => x)),
        "perEstado": perEstado,
        "perObsevacion": perObsevacion,
        "perEmail": List<dynamic>.from(perEmail.map((x) => x)),
        "perOtros": List<dynamic>.from(perOtros.map((x) => x)),
        "perNickname": perNickname,
        "perUser": perUser,
        "perFoto": perFoto,
        "perUbicacion": perUbicacion.toJson(),
        "perDocumento": perDocumento,
        "perGenero": perGenero,
        "perRecomendacion": perRecomendacion,
        "perFecNacimiento": perFecNacimiento,
        "perEspecialidad": perEspecialidad,
        "perTitulo": perTitulo,
        "perSenescyt": perSenescyt,
        "perPersonal": perPersonal,
        "perId": perId,
        "perCodigo": perCodigo,
        "perUsuario": perUsuario,
        "perOnline": perOnline,
        "perSaldo": perSaldo,
        "perFecReg": perFecReg,
        "perFecUpd": perFecUpd,
        "perPermisos": perPermisos?.toJson(),
      };
}

class PerPermisos {
  PerPermisos();

  factory PerPermisos.fromJson(Map<String, dynamic> json) => PerPermisos();

  Map<String, dynamic> toJson() => {};
}

class PerUbicacion {
  final dynamic longitud;
  final dynamic latitud;

  const PerUbicacion({
    required this.longitud,
    required this.latitud,
  });

  const PerUbicacion.defaultValues()
      : longitud = 0,
        latitud = 0;

  factory PerUbicacion.fromJson(Map<String, dynamic> json) => PerUbicacion(
        longitud: json["longitud"],
        latitud: json["latitud"],
      );

  Map<String, dynamic> toJson() => {
        "longitud": longitud,
        "latitud": latitud,
      };
}

class ClienteForm extends Cliente {
  // final GenericRequiredInput venRucClienteInput;
  // final Productos venProductosInput;
  final GenericRequiredInput perDocTipoInput;
  final GenericRequiredInput perDocNumeroInput;
  final GenericRequiredInput perNombreInput;
  final GenericRequiredInput perDireccionInput;
  final GenericRequiredListStr perCelularInput;
  final GenericRequiredListStr perEmailInput;
  final GenericRequiredListStr perOtrosInput;
  ClienteForm({
    required this.perDocTipoInput,
    required this.perDocNumeroInput,
    required this.perNombreInput,
    required this.perDireccionInput,
    required this.perCelularInput,
    required this.perEmailInput,
    required this.perOtrosInput,

    // this.venRucClienteInput = GenericRequiredInput.dirty(''),
    // this.venProductosInput = const Productos.dirty([]),
    required super.perNombreComercial,
    required super.perEmpresa,
    required super.perPais,
    required super.perProvincia,
    required super.perCanton,
    required super.perTipoProveedor,
    required super.perTiempoCredito,
    required super.perDocTipo,
    required super.perDocNumero,
    required super.perPerfil,
    required super.perNombre,
    required super.perDireccion,
    required super.perObligado,
    required super.perCredito,
    required super.perTelefono,
    required super.perCelular,
    required super.perEstado,
    required super.perObsevacion,
    required super.perEmail,
    required super.perOtros,
    required super.perNickname,
    required super.perUser,
    required super.perFoto,
    required super.perUbicacion,
    required super.perDocumento,
    required super.perGenero,
    required super.perRecomendacion,
    required super.perFecNacimiento,
    required super.perEspecialidad,
    required super.perTitulo,
    required super.perSenescyt,
    required super.perPersonal,
    required super.perId,
    required super.perCodigo,
    required super.perUsuario,
    required super.perOnline,
    required super.perSaldo,
    required super.perFecReg,
    required super.perFecUpd,
  });

  ClienteForm copyWith({
    //* REQUERIDOS
    // GenericRequiredInput? venRucClienteInput,
    // Productos? venProductosInput,
    String? perDocTipo,
    String? perDocNumero,
    String? perNombre,
    String? perDireccion,
    List<String>? perCelular,
    List<String>? perEmail,
    List<String>? perOtros,
    //* CLIENTE
    int? perId,
    // String? perDocTipo,
    // String? perDocNumero,
    // String? perNombre,
    // String? perDireccion,
    // List<String>? perEmail,
    // List<String>? perOtros,
    String? perNombreComercial,
    List<String>? perEmpresa,
    String? perPais,
    String? perProvincia,
    String? perCanton,
    String? perTipoProveedor,
    String? perTiempoCredito,
    List<String>? perPerfil,
    String? perObligado,
    String? perCredito,
    String? perTelefono,
    String? perEstado,
    String? perObsevacion,
    String? perNickname,
    String? perUser,
    String? perFoto,
    PerUbicacion? perUbicacion,
    String? perDocumento,
    String? perGenero,
    String? perRecomendacion,
    String? perFecNacimiento,
    String? perEspecialidad,
    String? perTitulo,
    String? perSenescyt,
    String? perPersonal,
    String? perCodigo,
    String? perUsuario,
    int? perOnline,
    int? perSaldo,
    String? perFecReg,
    String? perFecUpd,
    PerPermisos? perPermisos,
  }) =>
      ClienteForm(
        //*REQUERIDOS
        perDocTipoInput: perDocTipo != null
            ? GenericRequiredInput.dirty(perDocTipo)
            : perDocTipoInput,
        perDocNumeroInput: perDocNumero != null
            ? GenericRequiredInput.dirty(perDocNumero)
            : perDocNumeroInput,
        perNombreInput: perNombre != null
            ? GenericRequiredInput.dirty(perNombre)
            : perNombreInput,
        perDireccionInput: perDireccion != null
            ? GenericRequiredInput.dirty(perDireccion)
            : perDireccionInput,
        perCelularInput: perCelular != null
            ? GenericRequiredListStr.dirty(perCelular)
            : perCelularInput,
        perEmailInput: perEmail != null
            ? GenericRequiredListStr.dirty(perEmail)
            : perEmailInput,
        perOtrosInput: perOtros != null
            ? GenericRequiredListStr.dirty(perOtros)
            : perOtrosInput,
        //*SUS EQUIVALENTES
        perDocTipo: perDocTipo ?? this.perDocTipo,
        perDocNumero: perDocNumero ?? this.perDocNumero,
        perNombre: perNombre ?? this.perNombre,
        perDireccion: perDireccion ?? this.perDireccion,
        perFecNacimiento: perFecNacimiento ?? this.perFecNacimiento,
        perCelular: perCelular ?? this.perCelular,
        perOtros: perOtros ?? this.perOtros,
        //* LO DEMAS
        perId: perId ?? this.perId,
        perNombreComercial: perNombreComercial ?? this.perNombreComercial,
        perEmpresa: perEmpresa ?? this.perEmpresa,
        perPais: perPais ?? this.perPais,
        perProvincia: perProvincia ?? this.perProvincia,
        perCanton: perCanton ?? this.perCanton,
        perTipoProveedor: perTipoProveedor ?? this.perTipoProveedor,
        perTiempoCredito: perTiempoCredito ?? this.perTiempoCredito,
        perPerfil: perPerfil ?? this.perPerfil,
        perObligado: perObligado ?? this.perObligado,
        perCredito: perCredito ?? this.perCredito,
        perTelefono: perTelefono ?? this.perTelefono,
        perEstado: perEstado ?? this.perEstado,
        perObsevacion: perObsevacion ?? this.perObsevacion,
        perEmail: perEmail ?? this.perEmail,
        perNickname: perNickname ?? this.perNickname,
        perUser: perUser ?? this.perUser,
        perFoto: perFoto ?? this.perFoto,
        perUbicacion: perUbicacion ?? this.perUbicacion,
        perDocumento: perDocumento ?? this.perDocumento,
        perGenero: perGenero ?? this.perGenero,
        perRecomendacion: perRecomendacion ?? this.perRecomendacion,
        perEspecialidad: perEspecialidad ?? this.perEspecialidad,
        perTitulo: perTitulo ?? this.perTitulo,
        perSenescyt: perSenescyt ?? this.perSenescyt,
        perPersonal: perPersonal ?? this.perPersonal,
        perCodigo: perCodigo ?? this.perCodigo,
        perUsuario: perUsuario ?? this.perUsuario,
        perOnline: perOnline ?? this.perOnline,
        perSaldo: perSaldo ?? this.perSaldo,
        perFecReg: perFecReg ?? this.perFecReg,
        perFecUpd: perFecUpd ?? this.perFecUpd,
        // perPermisos: perPermisos ?? this.perPermisos,
      );
  //CONVIERTE A VENTA
  Cliente toCliente() => Cliente(
        perCelular: perCelular,
        perDireccion: perDireccion,
        perDocNumero: perDocNumero,
        perDocTipo: perDocTipo,
        perFecNacimiento: perFecNacimiento,
        perNombre: perNombreInput.value,
        // perCelular: perCelular,
        // perDireccion: perDireccion,
        // perDocNumero: perDocNumero,
        // perDocTipo: perDocTipo,
        // perFecNacimiento: perFecNacimiento,
        // perNombre: perNombre,
        // perOtros: perOtros,
        perCanton: perCanton,
        perCodigo: perCodigo,
        perCredito: perCredito,
        perDocumento: perDocumento,
        perEmail: perEmail,
        perEmpresa: perEmpresa,
        perEspecialidad: perEspecialidad,
        perEstado: perEstado,
        perFecReg: perFecReg,
        perFecUpd: perFecUpd,
        perFoto: perFoto,
        perGenero: perGenero,
        perId: perId,
        perNickname: perNickname,
        perNombreComercial: perNombreComercial,
        perObligado: perObligado,
        perObsevacion: perObsevacion,
        perOnline: perOnline,
        perOtros: perOtrosInput.value,
        perPais: perPais,
        perPerfil: perPerfil,
        perPersonal: perPersonal,
        perProvincia: perProvincia,
        perRecomendacion: perRecomendacion,
        perSaldo: perSaldo,
        perSenescyt: perSenescyt,
        perTelefono: perTelefono,
        perTiempoCredito: perTiempoCredito,
        perTipoProveedor: perTipoProveedor,
        perTitulo: perTitulo,
        perUbicacion: perUbicacion,
        perUser: perUser,
        perUsuario: perUsuario,
      );

  factory ClienteForm.fromCliente(Cliente cliente) {
    return cliente.perId == 0
        ? ClienteForm(
            perDocTipoInput: const GenericRequiredInput.pure(),
            perDocNumeroInput: const GenericRequiredInput.pure(),
            perNombreInput: const GenericRequiredInput.pure(),
            perDireccionInput: const GenericRequiredInput.pure(),
            perCelularInput: const GenericRequiredListStr.pure(),
            perEmailInput: const GenericRequiredListStr.pure(),
            perOtrosInput: const GenericRequiredListStr.pure(),
            perNombreComercial: cliente.perNombreComercial,
            perEmpresa: cliente.perEmpresa,
            perPais: cliente.perPais,
            perProvincia: cliente.perProvincia,
            perCanton: cliente.perCanton,
            perTipoProveedor: cliente.perTipoProveedor,
            perTiempoCredito: cliente.perTiempoCredito,
            perDocTipo: cliente.perDocTipo,
            perDocNumero: cliente.perDocNumero,
            perPerfil: cliente.perPerfil,
            perNombre: cliente.perNombre,
            perDireccion: cliente.perDireccion,
            perObligado: cliente.perObligado,
            perCredito: cliente.perCredito,
            perTelefono: cliente.perTelefono,
            perCelular: cliente.perCelular,
            perEstado: cliente.perEstado,
            perObsevacion: cliente.perObsevacion,
            perEmail: cliente.perEmail,
            perOtros: cliente.perOtros,
            perNickname: cliente.perNickname,
            perUser: cliente.perUser,
            perFoto: cliente.perFoto,
            perUbicacion: cliente.perUbicacion,
            perDocumento: cliente.perDocumento,
            perGenero: cliente.perGenero,
            perRecomendacion: cliente.perRecomendacion,
            perFecNacimiento: cliente.perFecNacimiento,
            perEspecialidad: cliente.perEspecialidad,
            perTitulo: cliente.perTitulo,
            perSenescyt: cliente.perSenescyt,
            perPersonal: cliente.perPersonal,
            perId: cliente.perId,
            perCodigo: cliente.perCodigo,
            perUsuario: cliente.perUsuario,
            perOnline: cliente.perOnline,
            perSaldo: cliente.perSaldo,
            perFecReg: cliente.perFecReg,
            perFecUpd: cliente.perFecUpd,
          )
        : ClienteForm(
            perDocTipoInput: GenericRequiredInput.dirty(cliente.perDocTipo),
            perDocNumeroInput: GenericRequiredInput.dirty(cliente.perDocNumero),
            perNombreInput: GenericRequiredInput.dirty(cliente.perNombre),
            perDireccionInput: GenericRequiredInput.dirty(cliente.perDireccion),
            perCelularInput: GenericRequiredListStr.dirty(cliente.perCelular),
            perEmailInput: GenericRequiredListStr.dirty(cliente.perEmail),
            perOtrosInput: GenericRequiredListStr.dirty(cliente.perOtros),
            perNombreComercial: cliente.perNombreComercial,
            perEmpresa: cliente.perEmpresa,
            perPais: cliente.perPais,
            perProvincia: cliente.perProvincia,
            perCanton: cliente.perCanton,
            perTipoProveedor: cliente.perTipoProveedor,
            perTiempoCredito: cliente.perTiempoCredito,
            perDocTipo: cliente.perDocTipo,
            perDocNumero: cliente.perDocNumero,
            perPerfil: cliente.perPerfil,
            perNombre: cliente.perNombre,
            perDireccion: cliente.perDireccion,
            perObligado: cliente.perObligado,
            perCredito: cliente.perCredito,
            perTelefono: cliente.perTelefono,
            perCelular: cliente.perCelular,
            perEstado: cliente.perEstado,
            perObsevacion: cliente.perObsevacion,
            perEmail: cliente.perEmail,
            perOtros: cliente.perOtros,
            perNickname: cliente.perNickname,
            perUser: cliente.perUser,
            perFoto: cliente.perFoto,
            perUbicacion: cliente.perUbicacion,
            perDocumento: cliente.perDocumento,
            perGenero: cliente.perGenero,
            perRecomendacion: cliente.perRecomendacion,
            perFecNacimiento: cliente.perFecNacimiento,
            perEspecialidad: cliente.perEspecialidad,
            perTitulo: cliente.perTitulo,
            perSenescyt: cliente.perSenescyt,
            perPersonal: cliente.perPersonal,
            perId: cliente.perId,
            perCodigo: cliente.perCodigo,
            perUsuario: cliente.perUsuario,
            perOnline: cliente.perOnline,
            perSaldo: cliente.perSaldo,
            perFecReg: cliente.perFecReg,
            perFecUpd: cliente.perFecUpd,
          );
  }
}
