import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/models.dart';
import 'package:http/http.dart' as http;

class ProductService extends ChangeNotifier {
  //https://api.cloudinary.com/v1_1/dmwe0q4mk/image/upload?upload_preset=tcficpuf
  final String _baseurl = "flutter-46200-default-rtdb.firebaseio.com";
  final List<Product> products = [];
  late Product selectedProduct = Product(available: true, name: '', price: 0);

  bool _isLoading = false;
  bool _isSave = false;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSave;
  File? newPictureFile;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set isSaving(bool value) {
    _isSave = value;
    notifyListeners();
  }

  ProductService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;

    final url = Uri.https(_baseurl, 'products.json');
    final resp = await http.get(url);
    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;

      products.add(tempProduct);
    });

    isLoading = false;
    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    if (product.id != null) {
      await updateProduct(product);
    } else {
      await createProduct(product);
    }

    isSaving = false;
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseurl, 'products/${product.id}.json');
    final resp = await http.put(url, body: product.toJson());

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseurl, 'products.json');
    final resp = await http.post(url, body: product.toJson());

    final decodedData = json.decode(resp.body);
    product.id = decodedData['name'];

    products.add(product);
    return decodedData['name'];
  }

  void updateSelectedProdcutimage(String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {

    if (  newPictureFile == null ) return null;

    isSaving = true;
    notifyListeners();

    // final url = Uri.parse('https://api.cloudinary.com/v1_1/dmwe0q4mk/image/upload?upload_preset=tcficpuf');

    // final imageUploadRequest = http.MultipartRequest('POST', url );

    // final file = await http.MultipartFile.fromPath('file', newPictureFile!.path );

    // imageUploadRequest.files.add(file);

    // final streamResponse = await imageUploadRequest.send();
    // final resp = await http.Response.fromStream(streamResponse);

    // if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
    //   print('algo salio mal');
    //   print( resp.body );
    // }
    isSaving = false;
    return 'https://res.cloudinary.com/dmwe0q4mk/image/upload/v1674268504/eeir5oc84ty18f0ogcyn.png';
    // newPictureFile = null;

    // final decodedData = json.decode( resp.body );
    // return decodedData['secure_url'];

  }
}
