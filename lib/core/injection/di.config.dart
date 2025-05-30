// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../http/api_service.dart' as _i666;
import '../http/dio_headers.dart' as _i350;
import '../http/dio_options.dart' as _i321;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i321.DioOptions>(() => _i321.DioOptions());
    gh.lazySingleton<_i350.DioHeaders>(() => _i350.DioHeaders());
    gh.lazySingleton<_i666.ApiService>(() => _i666.ApiService());
    return this;
  }
}
