import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/providers/product_form_provider.dart';
import 'package:flutter_application_1/widgets/input_decoration.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';
import '../widgets/product_image.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productService.selectedProduct),
      child: _ProductScreenBody(productService: productService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductService productService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
          children: [
            Stack(
              children: [
                ProductImage(url: productService.selectedProduct.picture),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                      onPressed: () async {
                        await productService.loadProducts();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new,
                          size: 40, color: Colors.red)),
                ),
                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                      onPressed: () async {
                        //TODO: Camara o Galeria

                        final picker = ImagePicker();
                        final XFile? pikedFile = await picker.pickImage(
                            preferredCameraDevice: CameraDevice.rear,
                            source: ImageSource.camera,
                            imageQuality: 100);
                        print(pikedFile);

                        if (pikedFile == null) {
                          print('no seleciono nada');
                          return;
                        }

                        productService
                            .updateSelectedProdcutimage(pikedFile.path);

                        print('Tenemos Imagen ${pikedFile.path}');
                      },
                      icon: const Icon(Icons.camera_alt_outlined,
                          size: 40, color: Colors.red)),
                ),
              ],
            ),
            const _ProductForm(),
            const SizedBox(height: 100),
          ],
        )),

        //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: productService.isSaving
          ? null
          : () async {
            if (!productForm.isValidform()) return;

            final String? imageurl = await productService.uploadImage();

            if( imageurl != null ) productForm.product.picture = imageurl;

            await productService.saveOrCreateProduct(productForm.product);

            Navigator.pushNamed(context, 'home');
          },
          child: productService.isSaving
          ? const CircularProgressIndicator()
          : const Icon(Icons.save_outlined),
        ));
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: _boxDecorationForm(),
        child: SingleChildScrollView(
          child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: productForm.formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text('Datos del Producto',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: product.name,
                      onChanged: (value) => product.name = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El nombre es requerido';
                        }
                        return null;
                      },
                      decoration: InputDecorations.authInputDecoration(
                          context: context,
                          hintText: 'Nombre del producto',
                          labelText: 'Nombre:'),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      initialValue: product.price.toString(),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}'))
                      ],
                      onChanged: (value) {
                        if (double.tryParse(value) == null) {
                          product.price = 0;
                        } else {
                          product.price = double.parse(value);
                        }
                      },
                      validator: (value) {
                        if (value == null || double.tryParse(value) == 0) {
                          return 'El precio es requerido';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecorations.authInputDecoration(
                          context: context,
                          hintText: '\$150',
                          labelText: 'Precio:'),
                    ),
                    const SizedBox(height: 20),
                    SwitchListTile.adaptive(
                        value: product.available,
                        onChanged: (value) =>
                            productForm.updateAvailability(value),
                        title: const Text('Disponible'),
                        activeColor: Colors.indigo),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  BoxDecoration _boxDecorationForm() => const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)));
}
