import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:job_posting_bidding_app/database/app_settings.dart';
import 'package:job_posting_bidding_app/model/common.dart';
import 'package:job_posting_bidding_app/model/service.dart';
import 'package:job_posting_bidding_app/model/user.dart';
import 'package:path_provider/path_provider.dart';

class ServerApis {
  static const String serverAddress =
      "https://trayd.blogstation.co.in";
  Dio _dio;

  Future<Dio> getDio() async {
    if (_dio != null) return _dio;
    _dio = Dio();
    _dio.options.connectTimeout = 20000; //5s
    _dio.options.receiveTimeout = 20000;
    _dio.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    _dio.interceptors.add(CookieManager(PersistCookieJar(dir: tempPath)));
    return _dio;
  }

  Future<ServiceListResponse> getServiceList() async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(serverAddress + "/services/get-all",
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = ServiceListResponse.fromJson(map);
      return responseData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<LoginResponse> login(String user_id) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(serverAddress + "/auth/login",
          data: {"user_id": user_id},
          options: Options(contentType: Headers.formUrlEncodedContentType));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = LoginResponse.fromJson(map);
      return responseData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<RegistrationResponse> registration(
    String name,
    String email,
    String password,
    String user_id,
    String phone_no,
  ) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(serverAddress + "/auth/register",
          data: {
            "name": name,
            "email": email,
            "password": password,
            "user_id": user_id,
            "phone_no": phone_no
          },
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
          ));
      print(name);
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = RegistrationResponse.fromJson(map);
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<BasicActionsResponse> updateProfileInfo(
    String name,
    String email,
    String user_id,
  ) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(
          serverAddress + "/profile/update-userinfo",
          data: {
            "name": name,
            "email": email,
            "user_id": user_id,
          },
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));
      print(name);
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = BasicActionsResponse.fromJson(map);
      return responseData;
    } catch (e) {
      return null;
    }
  }

  Future<BasicActionsResponse> editAddress(
      String user_id, Address address) async {
    Dio dio = await getDio();
    try {
      Response response =
          await dio.post(serverAddress + "/profile/edit-address",
              data: {
                "user_id": user_id,
                "address_line1": address.address_line1,
                "address_line2": address.address_line2,
                "landmark": address.landmark,
                "pincode": address.pincode,
                "lat": address.lat,
                "lng": address.lng,
                "address_id": address.address_id,
              },
              options: Options(contentType: Headers.jsonContentType, headers: {
                HttpHeaders.authorizationHeader:
                    'Bearer ' + await SharedPreferencesTest().getUserToken()
              }));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = BasicActionsResponse.fromJson(map);
      return responseData;
    } catch (e) {
      return null;
    }
  }

  Future<BasicActionsResponse> addAddress(
      String user_id, Address address) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(serverAddress + "/profile/add-address",
          data: {
            "user_id": user_id,
            "address_line1": address.address_line1,
            "address_line2": address.address_line2,
            "landmark": address.landmark,
            "pincode": address.pincode,
            "lat": address.lat,
            "lng": address.lng
          },
          options: Options(contentType: Headers.jsonContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = BasicActionsResponse.fromJson(map);
      return responseData;
    } catch (e) {
      return null;
    }
  }

  Future<BasicActionsResponse> deleteAddress(
      String user_id, String address_id) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(
          serverAddress + "/profile/delete-address",
          data: {
            "user_id": user_id,
            "address_id": address_id,
          },
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = BasicActionsResponse.fromJson(map);
      return responseData;
    } catch (e) {
      return null;
    }
  }

  Future<BasicActionsResponse> addReview(
    String user_id,
    String expert_id,
    int rating,
    String review,
  ) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(serverAddress + "/profile/add-review",
          data: {
            "user_id": user_id,
            "expert_id": expert_id,
            "rating": rating,
            "review": review,
          },
          options: Options(contentType: Headers.jsonContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = BasicActionsResponse.fromJson(map);
      return responseData;
    } catch (e) {
      return null;
    }
  }

  Future<BasicActionsResponse> update_image(
      String user_id, String img_url) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(serverAddress + "/profile/update-img",
          data: {"user_id": user_id, "img_url": img_url},
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));

      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = BasicActionsResponse.fromJson(map);
      return responseData;
    } catch (e) {
      return null;
    }
  }

  Future<UserInfoResponse> fetchProfile(String user_id) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(
          serverAddress + "/profile/fetch-profile",
          data: {
            "user_id": user_id,
          },
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));

      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = UserInfoResponse.fromJson(map);
      return responseData;
    } catch (e) {
      return null;
    }
  }

  Future<BasicActionsResponse> addJob(Job job) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(serverAddress + "/jobs/add-job",
          data: {
            "user_id": job.user_id,
            "service_name": job.service_name,
            "title": job.title,
            "sub_service": job.sub_service,
            "description": job.description,
            "service_date": job.service_date,
            "service_time": job.service_time,
            "address": job.address,
            "amount": job.amount
          },
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = BasicActionsResponse.fromJson(map);
      return responseData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<JobsListResponse> getMyPostedJobs(String user_id) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(
          serverAddress + "/jobs/get-by-customer",
          data: {
            "user_id": user_id,
          },
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = JobsListResponse.fromJson(map);
      return responseData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<JobsListResponse> getJobs(String user_id) async {
    Dio dio = await getDio();

    Response response = await dio.post(serverAddress + "/jobs/fetch-jobs",
        data: {
          "user_id": user_id,
        },
        options:
            Options(contentType: Headers.formUrlEncodedContentType, headers: {
          HttpHeaders.authorizationHeader:
              'Bearer ' + await SharedPreferencesTest().getUserToken()
        }));
    var map = Map<String, dynamic>.from(response.data);
    print(map);
    var responseData = JobsListResponse.fromJson(map);
    return responseData;
  }

  Future<JobsListResponse> getJobById(String job_id) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(serverAddress + "/jobs/get-by-id",
          data: {
            "id": job_id,
          },
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = JobsListResponse.fromJson(map);
      return responseData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<JobsListResponse> expertGetAll(String user_id) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(
          serverAddress + "/expert/get-by-expert",
          data: {
            "user_id": user_id,
          },
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = JobsListResponse.fromJson(map);
      return responseData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<PlaceBidResponse> placeBid(
      String user_id, String job_id, int amount) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(serverAddress + "/jobs/place-bid",
          data: {
            "user_id": user_id,
            "job_id": job_id,
            "amount": amount,
          },
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = PlaceBidResponse.fromJson(map);
      return responseData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<BasicActionsResponse> deleteJob(String user_id, String job_id) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(serverAddress + "/jobs/delete-job",
          data: {"user_id": user_id, "job_id": job_id},
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = BasicActionsResponse.fromJson(map);
      return responseData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<BasicActionsResponse> cancelBid(String bid_id, String job_id) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(serverAddress + "/expert/cancel-bid",
          data: {"bid_id": bid_id, "job_id": job_id},
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = BasicActionsResponse.fromJson(map);
      return responseData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<BasicActionsResponse> updateBid(
      String bid_id, String job_id, int amount) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(serverAddress + "/expert/update-bid",
          data: {"bid_id": bid_id, "job_id": job_id, "amount": amount},
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = BasicActionsResponse.fromJson(map);
      return responseData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<BasicActionsResponse> hire(String user_id, String job_id) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(serverAddress + "/jobs/hire",
          data: {"user_id": user_id, "job_id": job_id},
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = BasicActionsResponse.fromJson(map);
      return responseData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<BasicActionsResponse> cancelHire(String user_id, String job_id) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(serverAddress + "/jobs/cancel-hire",
          data: {"user_id": user_id, "job_id": job_id},
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = BasicActionsResponse.fromJson(map);
      return responseData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<BasicActionsResponse> goingOutForService(String job_id) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(
          serverAddress + "/expert/out-for-service",
          data: {"job_id": job_id},
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = BasicActionsResponse.fromJson(map);
      return responseData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<BasicActionsResponse> completedTheJob(String job_id) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(
          serverAddress + "/expert/service-completed",
          data: {"job_id": job_id},
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = BasicActionsResponse.fromJson(map);
      return responseData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<BasicActionsResponse> addLatLng(
      String user_id, double lat, double lng) async {
    Dio dio = await getDio();
    try {
      Response response = await dio.post(serverAddress + "/profile/add-latlng",
          data: {
            "user_id": user_id,
            "lat": lat,
            "lng": lng,
          },
          options: Options(contentType: Headers.jsonContentType, headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + await SharedPreferencesTest().getUserToken()
          }));
      var map = Map<String, dynamic>.from(response.data);
      print(map);
      var responseData = BasicActionsResponse.fromJson(map);
      return responseData;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
