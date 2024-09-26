// для импорта - использовать import 'lcp.dart';

mixin class LCPFunction {
  List<String> explode(String delim, String str) {
    // функция для преобразования строки в массив, с помощью разделителя
    return str.split(delim);
  }

  String implode(String delim, List<String> arr) {
    // функция для преобразования массива в строку, добавляя свой разделитель
    String res = '';
    int arrCount = arr.length;
    for (int i = 0; i < arrCount; i++) {
      res += (i == (arrCount - 1)) ? arr[i] : arr[i] + delim;
    }
    return res;
  }

  String serialize(Map<String, String> arr) {
    String res = '';
    try {
      // получить ключи
      List<String> serializeKeysArr = arr.keys.toList();
      // получить номер сериализации
      int serializeNum = 1;
      for (int i = 0; i < serializeKeysArr.length; i++) {
        List<String> serializeArr =
            explode('[{//serialize//}]', arr[serializeKeysArr[i]].toString());
        if (serializeArr.length > 1) {
          serializeNum = int.parse(serializeArr[0]);
          serializeNum++;
        }
      }
      // преобразовать ключи
      String serializeKeys =
          implode('[{//key$serializeNum//}]', serializeKeysArr);
      serializeKeys = htmlspecialchars(serializeKeys);
      // преобразовать значения
      String serializeValues =
          implode('[{//val$serializeNum//}]', arr.values.toList());
      serializeValues = htmlspecialchars(serializeValues);
      res =
          '$serializeNum[{//serialize//}]$serializeKeys[{//delimer$serializeNum}]$serializeValues';
    } catch (e) {
      return '';
    }
    return res;
  }

  Map<String, String> unserialize(String str) {
    // функция для преобразования строки в ассоциативный массив (список)
    Map<String, String> res = {};
    try {
      // получить номер сериализации и финальную строку
      List<String> serializeArr = explode("[{//serialize//}]", str);
      String serializeNum = serializeArr[0];
      str = '';
      for (int i = 1; i < serializeArr.length; i++) {
        str += ((i > 1) ? "[{//serialize//}]" : "") + serializeArr[i];
      }
      // Получить готовый массив
      String resKeysStr = '';
      String resValsStr = '';
      List<String> resKeysStrArr = explode("[{//delimer$serializeNum}]", str);
      resKeysStr = resKeysStrArr[0];
      resValsStr = resKeysStrArr[1];
      List<String> resKeys = explode("[{//key$serializeNum//}]", resKeysStr);
      List<String> resVals = explode("[{//val$serializeNum//}]", resValsStr);
      for (int i = 0; i < resKeys.length; i++) {
        res[resKeys[i]] = htmlspecialcharsDecode(resVals[i]);
      }
    } catch (e) {
      return res;
    }
    return res;
  }

  String htmlspecialchars(String str) {
    // функция, которая преобразовывает специальные символы в HTML сущности
    str = str.replaceAll("&", "&amp;");
    str = str.replaceAll("\"", "&quot;");
    str = str.replaceAll("'", "&#039;");
    str = str.replaceAll("<", "&lt;");
    str = str.replaceAll(">", "&gt;");
    str = str.replaceAll("\\", "&#92;");
    return str;
  }

  String htmlspecialcharsDecode(String str) {
    // функция, которая преобразовывает HTML сущности обратно в специальные символы
    str = str.replaceAll("&amp;", "&");
    str = str.replaceAll("&quot;", "\"");
    str = str.replaceAll("&#039;", "'");
    str = str.replaceAll("&lt;", "<");
    str = str.replaceAll("&gt;", ">");
    str = str.replaceAll("&#92;", "\\");
    return str;
  }

  // преобразовать телефон к следующему виду: +79999999999
  String convertPhone(String phone) {
    phone = phone.trim();
    phone = phone.replaceAll(RegExp(r'[^0-9]+'), '');
    if (phone.isEmpty) {
      return '';
    }
    if (phone[0] == '8') {
      phone = '7${phone.substring(1)}';
    }
    phone = '+$phone';
    return phone;
  }

  String? isValidPhone({required String? value, bool required = true}) {
    // если есть ошибка - вернет строку. Если нет ошибок - вернет null
    // required - если true, то вернет ошибку при пустом значении (тогда поле обязательно для заполнения). Если false, то ошибок не будет
    value = value ?? '';
    String value2 = convertPhone(value);
    if ((value.isEmpty) && (required == true)) {
      return 'Введите телефон!';
    } else if ((value2.isEmpty) &&
        (required == true) &&
        (value.trim() == '+')) {
      return null;
    }
    if ((value2.isEmpty) && (required == true)) {
      return 'Введены недопустимые символы!';
    } else if ((value2.isEmpty) && (required == false)) {
      // значение пустое, ошибок нет
      return null;
    }
    if (value2.length < 12) {
      return 'Телефон введен не верно!';
    }
    return null;
  }

  String? isValidEmail({required String? value, bool required = true}) {
    // если есть ошибка - вернет строку. Если нет ошибок - вернет null
    // required - если true, то вернет ошибку при пустом значении (тогда поле обязательно для заполнения). Если false, то ошибок не будет
    value = value ?? '';
    value = value.trim();
    if ((value.isEmpty) && (required == true)) {
      return 'Введите Email!';
    } else if ((value.isEmpty) && (required == false)) {
      // значение пустое, ошибок нет
      return null;
    }
    bool emailValid = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value);
    if (emailValid == false) {
      return 'Некорректный адрес электронной почты';
    }
    if (value.contains('--')) {
      return 'Некорректный адрес электронной почты';
    }
    if (value != htmlspecialchars(value)) {
      return 'Email введен не верно';
    }
    return null;
  }

  List<String> mapToList(Map<String, dynamic> mapArr, String fieldName) {
    List<String> res = [];
    if (mapArr.isNotEmpty) {
      if (mapArr[fieldName] != null) {
        for (int i = 0; i < mapArr[fieldName].length; i++) {
          res.add(mapArr[fieldName][i]);
        }
      }
    }
    return res;
  }

  Map<String, String> mapDynamicToString(
      Map<String, dynamic> mapArr, int numLine) {
    Map<String, String> res = {};
    List<String> fieldsArr = mapArr.keys.toList();
    if (mapArr.isEmpty) {
      return {};
    }
    if ((numLine >= mapArr[fieldsArr[0]].length) || (numLine < 0)) {
      return {};
    }
    for (int i = 0; i < fieldsArr.length; i++) {
      res[fieldsArr[i]] = mapArr[fieldsArr[i]][numLine] != null
          ? mapArr[fieldsArr[i]][numLine].toString()
          : 'NULL';
    }
    return res;
  }

  Map<String, dynamic> mapDynamicToOneLine(
      Map<String, dynamic> mapArr, int numLine) {
    Map<String, dynamic> res = {};
    List<String> fieldsArr = mapArr.keys.toList();
    if (fieldsArr.isEmpty) {
      return {};
    }
    for (int i = 0; i < fieldsArr.length; i++) {
      res[fieldsArr[i]] = [];
    }
    for (int i = 0; i < fieldsArr.length; i++) {
      try {
        res[fieldsArr[i]].add(mapArr[fieldsArr[i]][numLine]);
        // ignore: empty_catches
      } catch (e) {}
    }
    if ((res[fieldsArr[0]].length) <= 0) {
      return {};
    }
    return res;
  }

  Map<String, dynamic> mapDynamicLines(
      Map<String, dynamic> mapArr, List<int> numLinesArr) {
    Map<String, dynamic> res = {};
    List<String> fieldsArr = mapArr.keys.toList();
    if (fieldsArr.isEmpty) {
      return {};
    }
    for (int i = 0; i < fieldsArr.length; i++) {
      res[fieldsArr[i]] = [];
    }
    for (int numLine in numLinesArr) {
      for (int i = 0; i < fieldsArr.length; i++) {
        try {
          res[fieldsArr[i]].add(mapArr[fieldsArr[i]][numLine]);
          // ignore: empty_catches
        } catch (e) {}
      }
    }
    if ((res[fieldsArr[0]].length) <= 0) {
      return {};
    }
    return res;
  }

  DateTime getMaxDateTime(List<DateTime> dateArr) {
    DateTime max = dateArr[0];
    for (DateTime dates in dateArr) {
      if (max.isBefore(dates)) {
        max = dates;
      }
    }
    return max;
  }

  DateTime getMinDateTime(List<DateTime> dateArr) {
    DateTime min = dateArr[0];
    for (DateTime dates in dateArr) {
      if (min.isAfter(dates)) {
        min = dates;
      }
    }
    return min;
  }

  Map<String, dynamic> orderBy({
    required Map<String, dynamic> dataArr,
    required String orderByField,
    bool desc = false,
  }) {
    // type - тип сравниваемых данных в массиве
    // - String - строковый
    // - DateTime - дата и время
    // - int - целый числовой

    if (dataArr[orderByField] == null) {
      return {};
    }
    try {
      if ((dataArr[orderByField][0] == null) ||
          (dataArr[orderByField][1] == null)) {
        return dataArr;
      }
    } catch (e) {
      return dataArr;
    }
    List<String> fieldArr = dataArr.keys.toList();
    String type = 'String';
    if (dataArr[orderByField][0] is int) {
      type = 'int';
    }
    if (dataArr[orderByField][0] is DateTime) {
      type = 'DateTime';
    }
    for (int i1 = 0; i1 < dataArr[fieldArr[0]].length - 1; i1++) {
      for (int i2 = 0; i2 < (dataArr[fieldArr[0]].length - 1) - i1; i2++) {
        if (type == 'String') {
          if (dataArr[orderByField][i2]
                  .toString()
                  .compareTo(dataArr[orderByField][i2 + 1].toString()) >
              0) {
            for (int i3 = 0; i3 < fieldArr.length; i3++) {
              dynamic dop = dataArr[fieldArr[i3]][i2 + 1];
              dataArr[fieldArr[i3]][i2 + 1] = dataArr[fieldArr[i3]][i2];
              dataArr[fieldArr[i3]][i2] = dop;
            }
          }
        } else if (type == 'int') {
          if (dataArr[orderByField][i2]
                  .compareTo(dataArr[orderByField][i2 + 1]) >
              0) {
            for (int i3 = 0; i3 < fieldArr.length; i3++) {
              dynamic dop = dataArr[fieldArr[i3]][i2 + 1];
              dataArr[fieldArr[i3]][i2 + 1] = dataArr[fieldArr[i3]][i2];
              dataArr[fieldArr[i3]][i2] = dop;
            }
          }
        } else if (type == 'DateTime') {
          if (dataArr[orderByField][i2]
              .isBefore(dataArr[orderByField][i2 + 1])) {
            for (int i3 = 0; i3 < fieldArr.length; i3++) {
              dynamic dop = dataArr[fieldArr[i3]][i2 + 1];
              dataArr[fieldArr[i3]][i2 + 1] = dataArr[fieldArr[i3]][i2];
              dataArr[fieldArr[i3]][i2] = dop;
            }
          }
        }
      }
    }
    if (desc == true) {
      Map<String, dynamic> dataArrNew = {};
      for (String field in fieldArr) {
        dataArrNew[field] = [];
        for (int i = dataArr[fieldArr[0]].length - 1; i >= 0; i--) {
          dataArrNew[field].add(dataArr[field][i]);
        }
      }
      dataArr = dataArrNew;
    }
    return dataArr;
  }
}
