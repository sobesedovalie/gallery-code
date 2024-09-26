import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../config.dart';
import '../modules/lcp/lcp.dart';

abstract class Model {
  static fromMap() {}
  toMap() {}
  toMapString() {}

  generateId({
    required String collectionName,
  }) {
    Map<String, dynamic> dataArr = toMap();
    List<String> keyArr = dataArr.keys.toList();
    List<String> datasArr = [];
    for (String key in keyArr) {
      if (key == 'id') {
        continue;
      }
      datasArr.add(dataArr[key].toString());
    }
    datasArr.add(DateTime.now().toString());
    datasArr.add(lcp.rand(min: 0, max: 99999999).toString());
    // datasArr.add(AuthFirebase.ini);
    String hex = lcp.md5LCP(lcp.implode('', datasArr));
    return '#$hex';
  }

  generateMd5() {
    Map<String, dynamic> dataArr = toMap();
    List<String> keyArr = dataArr.keys.toList();
    List<String> datasArr = [];
    for (String key in keyArr) {
      if ((key == 'md5_edit') || (key == 'md5Edit') || (key == 'md5edit')) {
        continue;
      }
      datasArr.add(dataArr[key].toString());
    }
    String hex = lcp.md5LCP(lcp.implode('', datasArr));
    return hex;
  }

  static List<String> typeGetListFromJson({required dynamic json}) {
    List<String> resArr = [];
    if ((json == null) || (json.toString().toLowerCase() == 'null')) {
      resArr = [];
    } else if (json is List<dynamic>) {
      for (var element in json) {
        resArr.add(element.toString());
      }
    } else if (json is List<String>) {
      resArr = json;
    } else if (json is String) {
      var phoneArrRes = jsonDecode(json);
      if (phoneArrRes is List<dynamic>) {
        for (var element in phoneArrRes) {
          resArr.add(element.toString());
        }
      } else if (phoneArrRes is List<String>) {
        resArr = phoneArrRes;
      }
    }
    return resArr;
  }

  static Map<String, dynamic> typeGetMapFromJson({required dynamic json}) {
    Map<String, dynamic> resArr = {};
    if ((json == null) || (json.toString().toLowerCase() == 'null')) {
      resArr = {};
      // } else if (map['img_path_arr'] is List<dynamic>) {
      //   for (var element in map['phone_arr']) {
      //     phoneArr.add(element.toString());
      //   }
    } else if (json is Map<String, dynamic>) {
      resArr = json;
    } else if (json is String) {
      var blockArrRes = jsonDecode(json);
      // if (phoneArrRes is List<dynamic>) {
      //   for (var element in phoneArrRes) {
      //     phoneArr.add(element.toString());
      //   }
      // } else
      if (blockArrRes is Map<String, dynamic>) {
        resArr = blockArrRes;
      }
    }
    return resArr;
  }

  static String? typeGetStringNull({required dynamic str, String? strDefault}) {
    String? res;
    if ((str == null) || (str.toString().toLowerCase() == 'null')) {
      res = strDefault;
    } else {
      res = str.toString();
    }
    return res;
  }

  static int typeGetInt({required dynamic val, int valDefault = 0}) {
    int res = valDefault;
    if ((val == null) || (val.toString().toLowerCase() == 'null')) {
      res = valDefault;
    } else if (val is String) {
      res = int.parse(val);
    } else {
      res = val ?? valDefault;
    }
    return res;
  }

  static int? typeGetIntNull({required dynamic val, int? valDefault}) {
    int? res;
    if ((val == null) || (val.toString().toLowerCase() == 'null')) {
      res = null;
    } else if (val is String) {
      res = int.parse(val);
    } else {
      res = val ?? valDefault;
    }
    return res;
  }

  static double typeGetDouble({required dynamic val, double valDefault = 0}) {
    double res = valDefault;
    if ((val == null) || (val.toString().toLowerCase() == 'null')) {
      res = valDefault;
    } else if (val is String) {
      res = double.parse(val);
    } else if (val is double) {
      res = val;
    } else {
      try {
        res = double.parse(val.toString());
      } catch (e) {
        if (kDebugMode) {
          print('typeGetDouble: Ошибка в значении: ');
          print(val);
        }
      }
    }
    return res;
  }

  static double? typeGetDoubleNull(
      {required dynamic val, double valDefault = 0}) {
    double? res;
    if ((val == null) || (val.toString().toLowerCase() == 'null')) {
      res = null;
    } else if (val is String) {
      res = double.parse(val);
    } else {
      res = val ?? valDefault;
    }
    return res;
  }

  static bool typeGetBool({required dynamic val, bool valDefault = false}) {
    bool res = valDefault;
    if ((val == null) || (val.toString().toLowerCase() == 'null')) {
      res = valDefault;
    } else if (val is String) {
      res = val.toLowerCase().trim() == 'true' ||
          val.toLowerCase().trim() == 't' ||
          val.toLowerCase().trim() == '1';
    } else {
      res = val ?? valDefault;
    }
    return res;
  }

  static bool? typeGetBoolNull({required dynamic val}) {
    bool? res;
    if ((val == null) || (val.toString().toLowerCase() == 'null')) {
      res = null;
    } else {
      res = val.toString() == 'true';
    }
    return res;
  }

  static DateTime typeGetDateTime(
      {required dynamic val, DateTime? valDefault}) {
    valDefault = valDefault ?? DateTime.now();
    DateTime res = valDefault;
    if ((val == null) || (val.toString().toLowerCase() == 'null')) {
      res = valDefault;
    } else if (val is String) {
      res = DateTime.parse(val);
    } else if (val is DateTime) {
      res = val;
    } else {
      if (kDebugMode) {
        print(val.runtimeType.toString());
      }
      // настроить, например, для Timestamp
      if (kDebugMode) {
        print('невозможно преобразовать Timestamp в DateTime!!!');
      }
      res = DateTime.fromMillisecondsSinceEpoch(val.seconds * 1000);
    }
    return res;
  }

  static DateTime? typeGetDateTimeNull({required dynamic val}) {
    DateTime? res;
    if ((val == null) || (val.toString().toLowerCase() == 'null')) {
      res = null;
    } else if (val is String) {
      res = DateTime.parse(val);
    } else if (val is DateTime) {
      res = val;
    } else {
      if (kDebugMode) {
        print(val.runtimeType.toString());
      }
      // настроить, например, для Timestamp
      if (kDebugMode) {
        print('невозможно преобразовать Timestamp в DateTime!!!');
      }
      res = DateTime.fromMillisecondsSinceEpoch(val.seconds * 1000);
    }
    return res;
  }

  static String? typeGetObjectIdNull({required dynamic val}) {
    String? res;
    if ((val == null) || (val.toString().toLowerCase() == 'null')) {
      res = null;
    } else if (val is String) {
      res = val.toString();
    } else {
      if (kDebugMode) {
        print('невозможно преобразовать id в String!!!');
      }
      // res = lcp.md5LCP(val.toString()).toString().substring(0, 24);
      res = val;
    }
    return res;
  }

  static String mapToGetParams(Map<String, dynamic> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  static Future<dynamic> getDataMap({
    String? apiKey,
    Map<String, dynamic>? param,
  }) async {
    List<Map<String, dynamic>> datasArr = [];
    apiKey ??= Config.pixabayApi;
    param ??= {};
    param['key'] = apiKey;

    try {
      String resData = await lcp
          .filegetcontents('https://pixabay.com/api/?${mapToGetParams(param)}');
      // print(resData);
      if (resData.toString().trim() == '{}') {
        datasArr = [];
      } else {
        final jsonObj = json.decode(resData);
        if (jsonObj == null) {
          datasArr = [];
        } else if (jsonObj is List) {
          datasArr = List<Map<String, dynamic>>.from(jsonObj);
        } else if (jsonObj is Map) {
          if (jsonObj['errors'] != null) {
            if (jsonObj['errors'][0]['code'] == 'NOT_FOUND') {
              datasArr = [];
            }
          } else {
            datasArr = [];
            datasArr = List<Map<String, dynamic>>.from(jsonObj['hits']);
          }
        } else {
          datasArr = [];
          datasArr = List<Map<String, dynamic>>.from(jsonObj['hits']);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {
        'error': 'false',
        'string': 'Нет доступа к серверу!',
      };
    }

    List<Map<String, dynamic>> resultArr = [];
    for (Map<String, dynamic> datas in datasArr) {
      resultArr.add(datas);
    }
    return resultArr;
  }

  static Future<int> getDataCntMap({
    String? apiKey,
    Map<String, dynamic>? param,
  }) async {
    int res = 0;
    apiKey ??= Config.pixabayApi;
    param ??= {};
    param['key'] = apiKey;
    param['page'] = '1';
    param['per_page'] = '3';

    try {
      String resData = await lcp
          .filegetcontents('https://pixabay.com/api/?${mapToGetParams(param)}');
      // print(resData);
      if (resData.toString().trim() == '{}') {
        res = 0;
      } else {
        final jsonObj = json.decode(resData);
        if (jsonObj == null) {
          res = 0;
        } else if (jsonObj is Map) {
          if (jsonObj['errors'] != null) {
            if (jsonObj['errors'][0]['code'] == 'NOT_FOUND') {
              res = 0;
            }
          } else {
            try {
              res = int.parse(jsonObj['totalHits'].toString());
              // ignore: empty_catches
            } catch (e) {}
          }
        } else {
          try {
            res = int.parse(jsonObj['totalHits'].toString());
            // ignore: empty_catches
          } catch (e) {}
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return 0;
    }
    return res;
  }

  List<String> getFieldArr({required List<dynamic> allDatasFromClass}) {
    // ignore: unnecessary_null_comparison
    if (allDatasFromClass == null) {
      return [];
    }
    if (allDatasFromClass.isEmpty) {
      return [];
    }
    return allDatasFromClass[0].toMap().keys.toList();
  }

  Map<String, dynamic> classToMap({required List<dynamic> allDatasFromClass}) {
    Map<String, dynamic> resArr = {};
    // ignore: unnecessary_null_comparison
    if (allDatasFromClass == null) {
      return {};
    }
    List<String> fieldArr = getFieldArr(allDatasFromClass: allDatasFromClass);
    for (int i = 0; i < fieldArr.length; i++) {
      List<dynamic> insertArr = [];
      for (dynamic element in allDatasFromClass) {
        Map<String, dynamic> elementArr = element.toMap();
        if (elementArr[fieldArr[0]] != null) {
          insertArr.add(elementArr[fieldArr[i]]);
        }
      }
      resArr[fieldArr[i]] = [];
      resArr[fieldArr[i]] = insertArr;
    }
    return resArr;
  }
}
