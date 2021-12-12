
import 'package:dio/dio.dart';

class DioHelper{
  //start Create object dio from Dio class
  static late Dio dio;
//end Create object dio from Dio class
////start Create method for object dio from Dio class
static init()
{
  dio = Dio(
    BaseOptions(
      //enable for news app
      //baseUrl: 'https://newsapi.org/',
      //enable for login shop app
      baseUrl: 'https://student.valuxapps.com/api/',
      receiveDataWhenStatusError: true,
      headers: {
        'Content-Type':'application/json',

      }
    )
  );
}
// start Get Data
static Future<Response> getData({
  required String url,
  required Map<String, dynamic> query,
  String lang = 'ar',
  String? token,
})async
{
  dio.options.headers = {
          'lang': lang,
          'Authorization' : token,
};


  return await dio.get(url, queryParameters: query,);
}
// End Get Data
  // start Post Data
static Future<Response> postData({
  required String url,
   Map<String, dynamic>? query,
  required Map<String, dynamic> data,
  String lang = 'ar',
  String? token,
}) async
{
  dio.options.headers =
  {
    'lang': lang,
    'Authorization' : token,
  };
  return dio.post(
    url,
    queryParameters: query,
    data: data,
  );
}
// End Post Data
}