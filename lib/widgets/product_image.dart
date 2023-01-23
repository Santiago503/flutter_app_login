import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? url;
  const ProductImage({super.key, this.url});
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.8,
      child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Container(
            decoration: _boxDecorationProductImage(),
            width: double.infinity,
            height: 450,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45)),
              child: getImage(url),
            ),
          )),
    );
  }

  BoxDecoration _boxDecorationProductImage() => BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ]);
}

Widget getImage(String? picture) {
  if (picture == null) {
    return const Image(
      image: AssetImage('assets/no-image.png'),
      fit: BoxFit.fill,
    );
  }

  if (picture.startsWith('http')) {
    return FadeInImage(
      image: NetworkImage(picture),
      placeholder: const AssetImage('assets/jar-loading.gif'),
      fit: BoxFit.cover,
    );
  }

  return FadeInImage(
      image: NetworkImage(picture),
      placeholder: const AssetImage('assets/jar-loading.gif'),
      fit: BoxFit.cover,
    );
}
