// для импорта - использовать import 'lcp.dart';
import 'lcp_function.dart';

mixin class LCPSQL {
  final _lcpFunction = LCPFunction();
  String getcelldbSQL(
      [String dbcell = '',
      String dbSELECT = '*',
      String dbFROM = '',
      String dbWHERE = '',
      String dbORDER = '',
      String dbLIMIT = '']) {
    String s = '';
    if (dbSELECT.isNotEmpty) {
      s += ' SELECT $dbSELECT ';
    } else {
      s += ' SELECT * ';
    }
    if (dbFROM.isNotEmpty) {
      s += ' FROM $dbFROM ';
    } else {
      return 'ERROR: TABLE FROM EMPTY';
    }
    if (dbWHERE.isNotEmpty) {
      s += ' WHERE $dbWHERE ';
    }
    if (dbORDER.isNotEmpty) {
      s += ' ORDER $dbORDER ';
    }
    if (dbLIMIT.isNotEmpty) {
      s += ' LIMIT $dbLIMIT ';
    }
    s = s.replaceAll('\'NULL\'', 'NULL');
    s = s.replaceAll('\'Null\'', 'NULL');
    s = s.replaceAll('\'null\'', 'NULL');
    return s;
  }

  String getarrayvaluedbSQL(
      [List<String> dbcellarr = const [],
      String dbSELECT = '*',
      String dbFROM = '',
      String dbWHERE = '',
      String dbORDER = '',
      String dbLIMIT = '']) {
    String s = '';
    if (dbSELECT.isNotEmpty) {
      s += ' SELECT $dbSELECT ';
    } else {
      s += ' SELECT * ';
    }
    if (dbFROM.isNotEmpty) {
      s += ' FROM $dbFROM ';
    } else {
      return 'false';
    }
    if (dbWHERE.isNotEmpty) {
      s += ' WHERE $dbWHERE ';
    }
    if (dbORDER.isNotEmpty) {
      s += ' ORDER $dbORDER ';
    }
    if (dbLIMIT.isNotEmpty) {
      s += ' LIMIT $dbLIMIT ';
    }
    s = s.replaceAll('\'NULL\'', 'NULL');
    s = s.replaceAll('\'Null\'', 'NULL');
    s = s.replaceAll('\'null\'', 'NULL');
    return s;
  }

  String deletedbSQL([
    String dbFROM = '',
    String dbWHERE = '',
  ]) {
    String s = '';
    if (dbFROM.isNotEmpty) {
      s += 'DELETE FROM $dbFROM ';
    } else {
      return 'false';
    }
    if (dbWHERE.isNotEmpty) {
      s += ' WHERE $dbWHERE ';
    }
    s = s.replaceAll('\'NULL\'', 'NULL');
    s = s.replaceAll('\'Null\'', 'NULL');
    s = s.replaceAll('\'null\'', 'NULL');
    return s;
  }

  String deletedbSyncSQL([
    String dbFROM = '',
    String dbWHERE = '',
  ]) {
    Map<String, String> param = {};
    param['active'] = '404';
    return updatevaluedbSQL(dbFROM, param, dbWHERE);
  }

  String insertvaluedbSQL(String dbFROM, String dbCOLUMNS, String dbVALUES) {
    String s = 'INSERT INTO';
    if (dbFROM.isNotEmpty) {
      s += ' $dbFROM ';
    } else {
      return 'false';
    }
    if (dbCOLUMNS.isNotEmpty) {
      s += ' ($dbCOLUMNS) ';
    } else {
      return 'false';
    }
    if (dbVALUES.isNotEmpty) {
      s += ' VALUES ($dbVALUES) ';
    } else {
      dbVALUES = '\'\'';
      List<String> exparray = _lcpFunction.explode(',', dbCOLUMNS);
      int exparraycount = exparray.length;
      for (int iii = 1; iii < exparraycount; iii++) {
        dbVALUES += ',\'\'';
      }
      s += ' VALUES ($dbVALUES) ';
    }
    s += ' RETURNING id;';
    s = s.replaceAll('\'NULL\'', 'NULL');
    s = s.replaceAll('\'Null\'', 'NULL');
    s = s.replaceAll('\'null\'', 'NULL');
    return s;
  }

  String insertarrayvaluedbSQL(
      String dbFROM, List<Map<String, dynamic>> dbPARAM) {
    String s = 'INSERT INTO';
    if (dbFROM.isNotEmpty) {
      s += ' $dbFROM ';
    } else {
      return 'false';
    }
    if (dbPARAM.isNotEmpty) {
      List<String> dbPARAMField = dbPARAM[0].keys.toList();
      s += ' (${_lcpFunction.implode(',', dbPARAMField)}) VALUES ';
      for (int iRow = 0; iRow < dbPARAM.length; iRow++) {
        List<String> line = [];
        for (int iCol = 0; iCol < dbPARAMField.length; iCol++) {
          line.add(dbPARAM[iRow][dbPARAMField[iCol]].toString());
        }
        s += (iRow == 0) ? '' : ',';
        s += ' (\'${_lcpFunction.implode('\',\'', line)}\')';
      }
      s += ';';
    } else {
      return 'false';
    }
    s = s.replaceAll('\'NULL\'', 'NULL');
    s = s.replaceAll('\'Null\'', 'NULL');
    s = s.replaceAll('\'null\'', 'NULL');
    return s;
  }

  String addvaluedbSQL(String dbFROM, Map<String, String> dbPARAM,
      {returnId = false}) {
    String s = 'INSERT INTO';
    if (dbFROM.isNotEmpty) {
      s += ' $dbFROM ';
    } else {
      return 'false';
    }
    if (dbPARAM.isNotEmpty) {
      List<String> dbPARAMField = dbPARAM.keys.toList();
      List<String> dbPARAMValues = dbPARAM.values.toList();
      s += ' (${_lcpFunction.implode(',', dbPARAMField)}) ';
      s += ' VALUES (\'${_lcpFunction.implode('\',\'', dbPARAMValues)}\') ';
    } else {
      return 'false';
    }
    if (returnId == true) {
      s += ' RETURNING id;';
    } else {
      s += ';';
    }
    s = s.replaceAll('\'NULL\'', 'NULL');
    s = s.replaceAll('\'Null\'', 'NULL');
    s = s.replaceAll('\'null\'', 'NULL');
    return s;
  }

  String updatevaluedbSQL(
      String dbFROM, Map<String, String> dbPARAM, String dbWHERE) {
    String s = 'UPDATE ';
    if (dbFROM.isNotEmpty) {
      s += ' $dbFROM ';
    } else {
      return 'false';
    }
    if (dbPARAM.isNotEmpty) {
      s += ' SET ';

      List<String> dbPARAMField = dbPARAM.keys.toList();
      // List<String> dbPARAM_values = dbPARAM.values.toList();
      // s += ' (' + implode(',', dbPARAM_field) + ') ';
      // s += ' VALUES (\'' + implode('\',\'', dbPARAM_values) + '\') ';

      String ss = '';
      for (int i = 0; i < dbPARAMField.length; i++) {
        if (ss.isEmpty) {
          ss += '${dbPARAMField[i]}=\'${dbPARAM[dbPARAMField[i].toString()]}\'';
        } else {
          ss +=
              ', ${dbPARAMField[i]}=\'${dbPARAM[dbPARAMField[i].toString()].toString()}\'';
        }
      }
      s += ss;
    } else {
      return 'false';
    }
    if (dbWHERE.isNotEmpty) {
      s += ' WHERE $dbWHERE ';
    }
    s = s.replaceAll('\'NULL\'', 'NULL');
    s = s.replaceAll('\'Null\'', 'NULL');
    s = s.replaceAll('\'null\'', 'NULL');
    return s;
  }
}
