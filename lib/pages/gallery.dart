import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../components/load_more/load_more.dart';
import '../models/photo.dart';
import 'error_show.dart';

// страница для отображения галереи фото
class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<PhotoTBL> photoTblArr = []; // Массив фото. Если нет инициализации - null
  int offset = 1; // текущая страница загрузки
  String?
      _error; // Если при загрузке по API возникла ошибка - отобразить. Если нет ошибок - null
  final int _widthPhoto = 200; // Ширина фото
  late double _screenWidth; // Ширина экрана для расчета количества колонок
  late int _crossAxisCount; // Количество колонок
  final int _limit = 100; // Сколько фото загружать за один запрос

  Future<void> loadData({
    int offset = 1,
    int limit = 10,
  }) async {
    // функция для подгрузки фото
    _error = null;
    dynamic result;
    try {
      // проверить отображаемую страницу
      // print('page');
      // print(offset);
      // print('limit');
      // print(limit);
      result = await PhotoTBL.getData(
        page: offset,
        perPage: limit,
      );
      if (result is Map) {
        if (result['error'] == 'false') {
          if (mounted) {
            setState(() {
              _error = result['string'];
            });
          }
          return;
        }
      }
      photoTblArr.addAll(result);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Не удалось загрузить фото!';
        });
      }
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Получаем ширину экрана
    _screenWidth = MediaQuery.of(context).size.width;
    // Определяем количество колонок исходя из ширины
    _crossAxisCount = (_screenWidth / _widthPhoto).floor();
    _crossAxisCount = _crossAxisCount < 1 ? 1 : _crossAxisCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gallery',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: (_error != null)
          ? ErrorShowPage(error: _error!, onRefresh: loadData)
          : LoadMoreComponent<PhotoTBL>(
              getData: (param) async {
                offset = param['offset'];
                await loadData(offset: offset, limit: _limit);
                return photoTblArr;
              },
              getCount: (param) async {
                return await PhotoTBL.getDataCnt();
              },
              getListView: ({required datasArr, required scrollController}) {
                return GridView.builder(
                  controller: scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _crossAxisCount),
                  itemBuilder: (context, index) {
                    return datasArr[index];
                  },
                  itemCount: datasArr.length,
                );
              },
              getItemWidget: (itemTbl, index) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (event) {
                    setState(() {
                      itemTbl.isHover = true;
                    });
                  },
                  onExit: (event) {
                    setState(() {
                      itemTbl.isHover = false;
                    });
                  },
                  child: GestureDetector(
                    child: Stack(children: [
                      CachedNetworkImage(
                        width: double.infinity,
                        height: double.infinity,
                        imageUrl: itemTbl.previewURL,
                        fit: BoxFit.cover,
                      ),
                      Visibility(
                        visible: itemTbl.isHover,
                        child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: const Color.fromARGB(53, 255, 255, 255)),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          color: const Color.fromARGB(121, 0, 0, 0),
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.favorite,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    itemTbl.likes.toString(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.remove_red_eye,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    itemTbl.views.toString(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                );
              },
              limit: _limit,
            ),
    );
  }
}
