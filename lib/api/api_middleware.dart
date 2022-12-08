import 'package:http/http.dart' as http;
import 'package:kd_api_call/kd_api_call.dart';

import '../api/api_end_points.dart';

class ApiMiddleware {
  ApiMiddleware._();

  static ApiMiddleware instance = ApiMiddleware._();

  //Get Final Url...
  String getFinalURL({String endpoint = ""}) {
    //Live Base URL...
    const String liveBaseURL = APISetup.productionURL;

    //Check if App is in Debug or Live Mode...
    final String finalURL = liveBaseURL + endpoint;
    return finalURL;
  }

  // Get Header...
  Map<String, String> get getHeader {
    final Map<String, String> header = {'Content-Type': 'application/json'};

    return header;
  }

  // Call API Service...
  Future<String> callService({
    required APIRequestInfo requestInfo,
  }) async {
    try {
      // Get Final URL...
      requestInfo.url = getFinalURL(endpoint: requestInfo.url);

      // Get header...
      requestInfo.headers = getHeader;

      // Call Serivce...
      final http.Response apiResponse =
          await ApiCall.instance.callService(requestInfo: requestInfo);

      return processResponse(apiResponse);
    } on FormatException catch (e) {
      throw e.message;
    } catch (error) {
      rethrow;
    }
  }

  //Get Error Title...
  String _getErrorTitle(http.Response response) =>
      APIErrorMsg.defaultErrorTitle;

  //Get Error Message...
  String _getErrorMsg(http.Response response) => APIErrorMsg.somethingWentWrong;

  //Process Response...
  String processResponse(http.Response response) {
    String title = "";
    String msg = "";
    if (response.statusCode != 200) {
      title = _getErrorTitle(response);
      msg = _getErrorMsg(response);
    }

    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 204:
        return response.body;

      case 401:
      case 403:
      case 410:
        throw AppException(
          statusCode: response.statusCode,
          title: title,
          message: msg,
          type: ExceptionType.UnAuthorised,
        );

      case 400:
      case 404:
      case 422:
      case 500:
        throw AppException(
          statusCode: response.statusCode,
          title: title,
          message: msg,
        );

      // Service Unavailable...
      case 502:
      case 503:
        throw AppException(
          statusCode: response.statusCode,
          title: APIErrorMsg.underMaintainanceTitle,
          message: APIErrorMsg.underMaintainanceMsg,
          type: ExceptionType.UnderMaintainance,
        );

      default:
        throw AppException(
          statusCode: response.statusCode,
          title: title,
          message: msg,
        );
    }
  }
}
