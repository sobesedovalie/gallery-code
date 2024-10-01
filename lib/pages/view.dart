import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ViewPhotoPage extends StatefulWidget {
  final String url;
  const ViewPhotoPage({
    super.key,
    required this.url,
  });

  @override
  State<ViewPhotoPage> createState() => _ViewPhotoPageState();
}

class _ViewPhotoPageState extends State<ViewPhotoPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          Container(
            child: CachedNetworkImage(
              placeholder: (context, url) => Center(
                child: const CircularProgressIndicator(),
              ),
              imageUrl: widget.url,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
            alignment: Alignment.center,
          ),
          SafeArea(child: BackButton()),
        ],
      ),
    );
  }
}
