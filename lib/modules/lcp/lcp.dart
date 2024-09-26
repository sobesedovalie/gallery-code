//
//
// ********** Общий пакет LCP для быстрой разработки приложений **********
//
//
//
//
//
// *** Установка ***
//
// Чтобы пакет работал нормально - необходимо в терминале выполнить команды:
// - flutter pub add crypto
// - flutter pub add http
// - flutter pub add path_provider
//
//
// *** Инициализация ***
// В проекте создайте новый объект:
// final lcp = new LCP();
//
//
//
//
//
//
// *** Как работать с filegetcontents ***
// - Сначала делаем запрос на url адрес страницы. Указываем функцию, которая должна выполниться после завершения парсинга:
// lcp.filegetcontents(
//   'https://svipa.ru/montag/sv.php',
//   filegetcontentresult,
// );
//
// - Затем создайте новую функцию, и пропишите необходимые действия:
// void filegetcontentresult(texts) {
//   print(texts);
// }
//
//
// - Либо используйте более простой синтаксис в одну строку:
// lcp.filegetcontents(
//   'https://svipa.ru/montag/sv.php',
//   (texts){print(texts);}),
// );
//
//
// *** Отображение окна загрузки ***
// setState(() {
//      lcp.loading(loadingShows: true);
//    });
//
//
// *** Отображение ошибки ***
// lcp.message('Ошибка при авторизации!', context);
//
//
//
//

import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'lcp_sql.dart';
import 'lcp_function.dart';
//import 'package:svipa/main.dart';

class LCP with LCPSQL, LCPFunction {
  String connectSiteUrl = '';
  Future get pathDocuments async => await _getDocuments();
  bool loadingShow = false;
  //Future get pathDownloads async => await _getDownloads();

  Future<String> _getDocuments() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/';
  }

  /*Future<String> _getDownloads() async {
    Directory directory = await getExternalStorageDirectory();
    return directory.path;
  }*/

  Future<String> filegetcontents(
    String filename, [
    String method = 'get', // post, get, put
    dynamic postArr, // Map<String,dynamic>
    Duration? timeout,
    Map<String, String>? headers,
  ]) async {
    String texts;
    final client = http.Client();
    http.Response response;
    try {
      if (timeout == null) {
        response = (method == 'post')
            ? await client.post(Uri.parse(filename),
                body: postArr, headers: headers)
            : (method == 'put')
                ? await client.put(Uri.parse(filename),
                    body: postArr, headers: headers)
                : (method == 'delete')
                    ? await client.delete(Uri.parse(filename),
                        body: postArr, headers: headers)
                    : await client.get(Uri.parse(filename), headers: headers);
      } else {
        response = (method == 'post')
            ? await client
                .post(Uri.parse(filename), body: postArr, headers: headers)
                .timeout(timeout)
            : (method == 'put')
                ? await client
                    .put(Uri.parse(filename), body: postArr, headers: headers)
                    .timeout(timeout)
                : (method == 'delete')
                    ? await client
                        .delete(Uri.parse(filename),
                            body: postArr, headers: headers)
                        .timeout(timeout)
                    : await client
                        .get(Uri.parse(filename), headers: headers)
                        .timeout(timeout);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // проверка доступа к интернету
      try {
        response = await client
            .get(Uri.parse('https://fortran-new.ru/?ver=${DateTime.now()}'));
      } catch (e) {
        return 'Нет доступа к Интернету!';
      }
      return 'Ошибка доступа к серверу!';
    }

    //print(response.statusCode);
    if (response.statusCode == 200) {
      texts = response.body;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      texts = 'Ошибка доступа к серверу!';
      //print('Request failed with status: ${response.statusCode}.');
    }
    return texts;
  }

  Future<Map<String, String>> filegetheaders(
    String filename, [
    String method = 'get',
    Map<String, String>? postArr,
  ]) async {
    Map<String, String> texts;
    final client = http.Client();
    http.Response response;
    try {
      response = (method == 'post')
          ? await client.post(Uri.parse(filename), body: postArr)
          : await client.get(Uri.parse(filename));
    } catch (e) {
      // проверка доступа к интернету
      try {
        response = await client.get(Uri.parse(
            'https://fortran-new.ru/?ver=' + DateTime.now().toString()));
      } catch (e) {
        return {
          'error': 'false',
          'string': 'Нет доступа к Интернету!',
        };
      }
      return {
        'error': 'false',
        'string': 'Ошибка доступа к серверу!',
      };
    }

    //print(response.statusCode);
    if (response.statusCode == 200) {
      texts = response.headers;
    } else {
      texts = {};
      //print('Request failed with status: ${response.statusCode}.');
    }
    return texts;
  }

  Future<Map<String, String>> sendFile({
    required String url,
    required String filename,
    required Uint8List fileData,
  }) async {
    String host = url;
    host = host.replaceAll('https://', '');
    host = host.replaceAll('http://', '');
    host = explode('/', host).first;
    host = explode('?', host).first;
    final client = http.Client();
    http.Response response;
    try {
      response = await client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          // 'Host': host,
        },
        body: jsonEncode({
          'flutterUnsigned8integers': fileData,
          'file_name': filename,
        }),
      );
    } catch (e) {
      // проверка доступа к интернету
      try {
        response = await client.get(Uri.parse(
            'https://fortran-new.ru/?ver=' + DateTime.now().toString()));
      } catch (e) {
        return {
          'error': 'false',
          'string': 'Нет доступа к Интернету!',
        };
      }
      return {
        'error': 'false',
        'string': 'Ошибка доступа к серверу!',
      };
    }
    if (response.statusCode == 200) {
      if (response.body.trim().isEmpty) {
        return {
          'error': 'true',
          'string': '',
        };
      } else {
        return {
          'error': 'false',
          'string': response.body,
        };
      }
    }
    return {
      'error': 'false',
      'string': 'Ошибка во время отправки!',
    };
  }

  Future<Uint8List?> fileReadAsByte(String filename) async {
    final client = http.Client();
    late Uint8List res;
    try {
      res = await client.readBytes(Uri.parse(filename));
    } catch (e) {
      return null;
    }
    return res;
  }

  Future<bool> fileWriteFromByte(String filename, Uint8List data) async {
    bool res = false;
    await File(filename).writeAsBytes(data);
    res = true;
    return res;
  }

  Future<void> fileWrite(String path, String data) async {
    final File file = File(path);
    if (!(await file.exists())) {
      await file.create(recursive: true);
    }
    await file.writeAsString(data);
  }

  Future<String> fileRead(String path) async {
    String text = '';
    try {
      final File file = File(path);
      text = await file.readAsString();
    } catch (e) {
      if (kDebugMode) {
        print('ERROR LCP fileRead: Couldn\'t read file path $path');
      }
    }
    return text;
  }

  String md5LCP(String str) {
    return md5.convert(utf8.encode(str)).toString();
  }

  void message(String str, BuildContext context, {Color? background}) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(str),
        backgroundColor: background,
      ));
    } catch (e) {
      if (kDebugMode) {
        print('Ошибка при отображении окна message');
        print(e);
      }
    }
  }

  void messageTop(
    String str,
    BuildContext context, {
    double? topPadding,
    Duration duration = const Duration(seconds: 3),
  }) {
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + (topPadding ?? 40),
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 6),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                const BoxShadow(
                  blurRadius: 10,
                  color: Colors.black26,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    str,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    overlayEntry.remove();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );

    // Inserting the overlay entry into the Overlay
    Overlay.of(context).insert(overlayEntry);

    // Automatically removing the overlay entry after 3 seconds
    Future.delayed(duration).then((value) {
      try {
        overlayEntry.remove();
        // ignore: empty_catches
      } catch (e) {}
    });
  }

  void messageBottom(
    String str,
    BuildContext context, {
    double? bottomPadding,
    Duration duration = const Duration(seconds: 3),
  }) {
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).padding.top + (bottomPadding ?? 40),
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 6),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                const BoxShadow(
                  blurRadius: 10,
                  color: Colors.black26,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    str,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    overlayEntry.remove();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );

    // Inserting the overlay entry into the Overlay
    Overlay.of(context).insert(overlayEntry);

    // Automatically removing the overlay entry after 3 seconds
    Future.delayed(duration).then((value) {
      try {
        overlayEntry.remove();
        // ignore: empty_catches
      } catch (e) {}
    });
  }

  int rand({int min = 0, int max = 1}) {
    Random rnd = Random();
    if (min == max) {
      return min;
    }
    int res = min + rnd.nextInt(max - min);
    return res;
  }

  List<String> searchElementFromText({
    required String text, // текст, в котором будет производиться поиск
    required String searchElement, // общий искомый элемент, например, href
    required String
        searchStart, // искомый начальный элемент, например первая кавычка (")
    required String
        searchEnd, // искомый конечный элемент, например последняя кавычка (")
    String?
        searchStart2, // искомый альтернативный начальный элемент, например первый апостроф (')
    String?
        searchEnd2, // искомый альтернативный конечный элемент, например последний апостроф (')
    int countAfterSearchElement =
        1, // сколько символов пропустить после searchElement, например в "href=" нужно пропустить один знак равно (=)
  }) {
    List<String> res = [];
    // int pos = 0;
    int posStart1 = 0;
    int posEnd1 = 0;
    int posStart2 = 0;
    int posEnd2 = 0;
    // int k = 0;

    List<String> hrefArr = lcp.explode(searchElement, text);
    if (hrefArr.length <= 1) {
      return res;
    }
    hrefArr.removeAt(0);
    for (String html in hrefArr) {
      posStart1 = html.indexOf(searchStart, 0) + countAfterSearchElement;
      posEnd1 = html.indexOf(searchEnd, posStart1);
      if ((searchStart2 != null) && (searchEnd2 != null)) {
        posStart2 = html.indexOf(searchStart2, 0) + countAfterSearchElement;
        posEnd2 = html.indexOf(searchEnd2, posStart2);
      }
      bool var1 = true;
      bool var2 = true;
      if (((posStart1 == -1) || (posEnd1 == -1)) ||
          ((posStart1 == 0) || (posEnd1 == 0))) {
        var1 = false;
      }
      if ((searchStart2 == null) || (searchEnd2 == null)) {
        var2 = false;
      } else {
        if (((posStart2 == -1) || (posEnd2 == -1)) ||
            ((posStart2 == 0) || (posEnd2 == 0))) {
          var2 = false;
        }
      }
      if ((var1 == true) && (var2 == true)) {
        if (posStart1 < posStart2) {
          res.add(html.substring(posStart1, posEnd1));
          // print(html.substring(posStart1, posEnd1));
        } else {
          res.add(html.substring(posStart2, posEnd2));
          // print(html.substring(posStart2, posEnd2));
        }
      } else if (var1 == true) {
        res.add(html.substring(posStart1, posEnd1));
        // print(html.substring(posStart1, posEnd1));
      } else if (var2 == true) {
        res.add(html.substring(posStart2, posEnd2));
        // print(html.substring(posStart2, posEnd2));
      }
    }
    return res;
  }

  int versionToNum({String version = '1.0.0'}) {
    List<String> versionArr = explode('.', version);
    int res = 0;
    for (int i = 0, k = versionArr.length - 1;
        i < versionArr.length;
        i++, k--) {
      res += int.parse(versionArr[i]) * pow(100, k).toInt();
    }
    return res;
  }
}

final lcp = LCP();
