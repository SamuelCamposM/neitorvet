import 'package:dio/dio.dart';
import 'package:neitorvet/config/config.dart';

final Dio dioZaracay = Dio(BaseOptions(baseUrl: Environment.apiUrlZaracay));
