// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chjokes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Joke _$JokeFromJson(Map<String, dynamic> json) => Joke()
  ..id = json['id'] as String?
  ..categories =
      (json['categories'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..createdAt = json['created_at'] as String?
  ..updatedAt = json['updated_at'] as String?
  ..iconUrl = json['icon_url'] as String?
  ..url = json['url'] as String?
  ..value = json['value'] as String?;

Map<String, dynamic> _$JokeToJson(Joke instance) => <String, dynamic>{
      'id': instance.id,
      'categories': instance.categories,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'icon_url': instance.iconUrl,
      'url': instance.url,
      'value': instance.value,
    };

JokeSearch _$JokeSearchFromJson(Map<String, dynamic> json) => JokeSearch()
  ..total = json['total'] as int
  ..result = (json['result'] as List<dynamic>)
      .map((e) => Joke.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$JokeSearchToJson(JokeSearch instance) =>
    <String, dynamic>{
      'total': instance.total,
      'result': instance.result,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _ChuckNorrisJokesClient implements ChuckNorrisJokesClient {
  _ChuckNorrisJokesClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://api.chucknorris.io/jokes/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<String>> getCategories() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<String>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/categories',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!.cast<String>();
    return value;
  }

  @override
  Future<Joke> getRandom() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Joke>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(_dio.options, '/random',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Joke.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Joke> getRandomInCategory(category) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'category': category};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Joke>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(_dio.options, '/random',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Joke.fromJson(_result.data!);
    return value;
  }

  @override
  Future<JokeSearch> search(query) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'query': query};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<JokeSearch>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/search',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = JokeSearch.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
