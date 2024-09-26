import 'package:flutter/material.dart';
import '../circular_progress_indicator/circular_progress_indicator.dart';

// ---------------- getData, если надо подгружать данные постранично: ----------------

// ---------------- если уже есть загруженные данные: ---------------
//
// ------ ListView: -----
//
// getData: (param) async {
//   int limit = param['limit'];
//   int offset = param['offset'];
//   List<TypeDataTbl> datasArr = _generateDataArr.sublist(
//                   offset * limit - limit, photoTblArr!.length > offset * limit ? offset * limit : null);
//   return datasArr;
// },
// getCount: (param) async {
//   return _generateDataArr.length;
// },
//
//
// ------ GridView: ------
//
// getData: (param) async {
//   int limit = param['limit'];
//   int offset = param['offset'];
//   List<TypeDataTbl> datasArr = _generateDataArr.sublist(
//                   offset * limit - limit, offset * limit);
//   return datasArr;
// },
// getCount: (param) async {
//   return _generateDataArr.length;
// },
// getListView: ({required datasArr, required scrollController}) {
//   return GridView.builder(
//     controller: scrollController,
//     gridDelegate:
//         SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//     itemBuilder: (context, index) {
//       return datasArr[index];
//     },
//     itemCount: datasArr.length,
//   );
// },
//

class LoadMoreComponent<T> extends StatefulWidget {
  final Future<int> Function(Map<String, dynamic> param)
      getCount; // получить количество (всего) записей
  final Map<String, dynamic>
      param; // параметры для выборки записей и подсчета количества (всего)
  final Future<dynamic> Function(Map<String, dynamic> param)
      getData; // получить записи с выборкой
  final int limit;
  final bool
      isShowRefreshIndicator; // при протягивании вниз обновлять ли контент
  final Color? circularProgressIndicatorColor; // цвет колеса загрузки
  final Widget Function(T itemTbl, int index)
      getItemWidget; // если type listview - вернуть listtile
  final Widget Function({
    required List<dynamic> datasArr,
    required ScrollController scrollController,
  })? getListView; // если нужно изменить listview на что-либо другое, например, sliverlist
  final Widget?
      errorEmptyWidget; // отобразить виджет, если ничего не найдено (пустой массив)
  final String?
      errorEmptyTitle; // отобразить заголовок, если ничего не найдено (пустой массив) и если не указан errorEmptyWidget
  final String?
      errorEmptyBody; // отобразить описание, если ничего не найдено (пустой массив) и если не указан errorEmptyWidget
  final Future<void> Function()?
      onRefreshIndicator; // обновление записей при протягивании вниз

  const LoadMoreComponent({
    super.key,
    required this.getCount,
    required this.getData,
    required this.getItemWidget,
    this.param = const {},
    this.limit = 100,
    this.circularProgressIndicatorColor,
    this.getListView,
    this.isShowRefreshIndicator = true,
    this.errorEmptyWidget,
    this.errorEmptyTitle,
    this.errorEmptyBody,
    this.onRefreshIndicator,
  });

  @override
  State<LoadMoreComponent<T>> createState() => LoadMoreComponentState<T>();
}

class LoadMoreComponentState<T> extends State<LoadMoreComponent<T>> {
  late int limit;
  late Color? circularProgressIndicatorColor;
  late bool isShowRefreshIndicator;
  int page = 1;
  int maxPage = 1;
  List<T>? tblArr;
  int tblArrCnt = 0;
  String? _error;
  Map<String, dynamic> paramData = {};
  Map<String, dynamic> paramCnt = {};
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0);
  bool isLoad = false;

  @override
  void initState() {
    super.initState();

    limit = widget.limit;
    widget.param.forEach((key, value) {
      paramData[key] = value;
    });
    paramData['limit'] = limit;
    widget.param.forEach((key, value) {
      paramCnt[key] = value;
    });
    circularProgressIndicatorColor = widget.circularProgressIndicatorColor;
    isShowRefreshIndicator = widget.isShowRefreshIndicator;

    _scrollController.addListener(() async {
      if (page > maxPage) {
        return;
      }
      if (isLoad == true) {
        return;
      }
      if (_scrollController.position.maxScrollExtent < 10000) {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent) {
          setState(() {
            isLoad = true;
          });
          loadMoreData();
        }
      } else {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 10000) {
          setState(() {
            isLoad = true;
          });
          loadMoreData();
        }
      }
    });

    refreshData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> refreshData() async {
    _error = null;
    page = 1;
    tblArrCnt = await widget.getCount(paramCnt);
    maxPage = (tblArrCnt / limit).ceil();

    setState(() {
      tblArr = null;
    });

    await loadMoreData();
  }

  Future<void> loadMoreData() async {
    paramData['offset'] = page;
    // try {
    List<T> datasArr = await widget.getData(paramData);
    tblArr ??= [];
    tblArr!.addAll(datasArr);
    // } catch (e) {
    //   if (mounted) {
    //     setState(() {
    //       isLoad = false;
    //       _error = 'Ошибка при загрузке данных!';
    //     });
    //     return;
    //   }
    // }
    if (mounted) {
      setState(() {
        isLoad = false;
        page++;
      });
    }
  }

  Future<void> onRefreshIndicator() async {
    if (widget.onRefreshIndicator != null) {
      await widget.onRefreshIndicator!();
    }
    await refreshData();
  }

  Widget getWidget() {
    if (tblArr == null) {
      return Center(
        child: circularProgressIndicatorWidget(
            color: circularProgressIndicatorColor),
      );
    }

    if (tblArr!.isEmpty) {
      if (widget.errorEmptyWidget != null) {
        return widget.errorEmptyWidget!;
      }
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.errorEmptyTitle ?? 'Ничего не найдено',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.errorEmptyBody ?? 'К сожалению, ничего не удалось найти.',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    List<Widget> resArr = [];
    int index = 0;

    for (T item in tblArr!) {
      // try {
      //   if (item.status == 404) {
      //     continue;
      //   }
      //   // ignore: empty_catches
      // } catch (e) {}
      resArr.add(widget.getItemWidget(item, index));
      index++;
    }

    if (isLoad) {
      resArr.add(
        Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: circularProgressIndicatorWidget(
                color: circularProgressIndicatorColor),
          ),
        ),
      );
    }
    Widget result;
    if (widget.getListView != null) {
      result = widget.getListView!(
        datasArr: resArr,
        scrollController: _scrollController,
      );
    } else {
      result = ListView.builder(
        padding: EdgeInsets.zero,
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return resArr[index];
        },
        itemCount: resArr.length,
      );
    }
    if (isShowRefreshIndicator == true) {
      return RefreshIndicator(
        onRefresh: widget.onRefreshIndicator != null
            ? onRefreshIndicator
            : refreshData,
        child: result,
      );
    }
    return result;
  }

  void addItem({required T itemTbl}) {
    if (mounted) {
      setState(() {
        tblArrCnt++;
        maxPage = (tblArrCnt / limit).ceil();
      });
    }
  }

  void deleteItem() {
    if (mounted) {
      setState(() {
        tblArrCnt--;
        if (tblArrCnt < 0) {
          tblArrCnt = 0;
        }
        maxPage = (tblArrCnt / limit).ceil();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _error != null
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_error!),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: refreshData,
                  child: const Text('Обновить'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                ),
              ],
            ),
          )
        : getWidget();
  }
}
