import 'model_from_pixabay.dart';

class PhotoTBL extends Model {
  int id;
  String pageURL;
  String type;
  String tags;
  String previewURL;
  int previewWidth;
  int previewHeight;
  String webformatURL;
  int webformatWidth;
  int webformatHeight;
  String largeImageURL;
  int imageWidth;
  int imageHeight;
  int imageSize;
  int views;
  int downloads;
  int collections;
  int likes;
  int comments;
  int userId;
  String user;
  String userImageURL;
  bool isHover;

  PhotoTBL({
    required this.id,
    required this.pageURL,
    required this.type,
    required this.tags,
    required this.previewURL,
    required this.previewWidth,
    required this.previewHeight,
    required this.webformatURL,
    required this.webformatWidth,
    required this.webformatHeight,
    required this.largeImageURL,
    required this.imageWidth,
    required this.imageHeight,
    required this.imageSize,
    required this.views,
    required this.downloads,
    required this.collections,
    required this.likes,
    required this.comments,
    required this.userId,
    required this.user,
    required this.userImageURL,
    this.isHover = false,
  });

  static Future<dynamic> getData({
    int page = 1,
    int perPage = 20,
  }) async {
    List<PhotoTBL> resArr = [];
    dynamic dataArr = await Model.getDataMap(
      param: {
        'image_type': 'photo',
        'page': page.toString(),
        'per_page': perPage.toString(),
        'q': 'cat',
      },
    );
    if (dataArr == null) {
      return null;
    }
    if (dataArr is Map<String, dynamic>) {
      if (dataArr['error'] == 'false') {
        return dataArr;
      }
    }
    for (Map<String, dynamic> item in dataArr) {
      resArr.add(fromMap(item));
    }
    return resArr;
  }

  static Future<int> getDataCnt() async {
    int res = 0;
    try {
      res = await Model.getDataCntMap(
        param: {
          'image_type': 'photo',
          'page': '1',
          'per_page': '3',
          'q': 'cat',
        },
      );
    } catch (e) {}
    return res;
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'pageURL': pageURL,
      'type': type,
      'tags': tags,
      'previewURL': previewURL,
      'previewWidth': previewWidth,
      'previewHeight': previewHeight,
      'webformatURL': webformatURL,
      'webformatWidth': webformatWidth,
      'webformatHeight': webformatHeight,
      'largeImageURL': largeImageURL,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
      'imageSize': imageSize,
      'views': views,
      'downloads': downloads,
      'collections': collections,
      'likes': likes,
      'comments': comments,
      'user_id': userId,
      'user': user,
      'userImageURL': userImageURL,
    };
    return map;
  }

  Map<String, String> toMapString() {
    Map<String, String> map = {
      'id': id.toString(),
      'pageURL': pageURL.toString(),
      'type': type.toString(),
      'tags': tags.toString(),
      'previewURL': previewURL.toString(),
      'previewWidth': previewWidth.toString(),
      'previewHeight': previewHeight.toString(),
      'webformatURL': webformatURL.toString(),
      'webformatWidth': webformatWidth.toString(),
      'webformatHeight': webformatHeight.toString(),
      'largeImageURL': largeImageURL.toString(),
      'imageWidth': imageWidth.toString(),
      'imageHeight': imageHeight.toString(),
      'imageSize': imageSize.toString(),
      'views': views.toString(),
      'downloads': downloads.toString(),
      'collections': collections.toString(),
      'likes': likes.toString(),
      'comments': comments.toString(),
      'user_id': userId.toString(),
      'user': user.toString(),
      'userImageURL': userImageURL.toString(),
    };
    return map;
  }

  static PhotoTBL fromMap(Map<String, dynamic> map) {
    return PhotoTBL(
      id: Model.typeGetInt(val: map['id']),
      pageURL: map['pageURL'],
      type: map['type'],
      tags: map['tags'],
      previewURL: map['previewURL'],
      previewWidth: Model.typeGetInt(val: map['previewWidth']),
      previewHeight: Model.typeGetInt(val: map['previewHeight']),
      webformatURL: map['webformatURL'],
      webformatWidth: Model.typeGetInt(val: map['webformatWidth']),
      webformatHeight: Model.typeGetInt(val: map['webformatHeight']),
      largeImageURL: map['largeImageURL'],
      imageWidth: Model.typeGetInt(val: map['imageWidth']),
      imageHeight: Model.typeGetInt(val: map['imageHeight']),
      imageSize: Model.typeGetInt(val: map['imageSize']),
      views: Model.typeGetInt(val: map['views']),
      downloads: Model.typeGetInt(val: map['downloads']),
      collections: Model.typeGetInt(val: map['collections']),
      likes: Model.typeGetInt(val: map['likes']),
      comments: Model.typeGetInt(val: map['comments']),
      userId: Model.typeGetInt(val: map['user_id']),
      user: map['user'],
      userImageURL: map['userImageURL'],
    );
  }
}
