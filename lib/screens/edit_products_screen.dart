import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shopping_app/provider/product.dart';
import 'package:real_shopping_app/provider/products_provider.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '/edit-products';

  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imgUrlController = TextEditingController();
  final _imgUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: 'tes',
    description: 'tes',
    price: 0,
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var isLoading = false;
  var _isInit = true;

  @override
  void initState() {
    _imgUrlController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final productId = ModalRoute.of(context)!.settings.arguments as String;
        if (productId != null) {
          _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
              .findbyId(productId);
          _initValues = {
            'title': _editedProduct.title,
            'description': _editedProduct.description,
            'price': _editedProduct.price.toString(),
            // 'imageUrl': _editedProduct.imageUrl,
            'imageUrl': '',
          };
          _imgUrlController.text = _editedProduct.imageUrl;
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imgUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final validData = _form.currentState!.validate();
    if (!validData) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      isLoading = true;
    });
    if (_editedProduct.id.isNotEmpty) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .UpdateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        print('loading...');
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'An error Occured',
            ),
            content: Text(
              error.toString(),
              style: TextStyle(color: Theme.of(context).errorColor),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Products'),
      ),
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black45,
      //         //spreadRadius: 5,
      //         blurRadius: 5,
      //         offset: Offset(0, -1),
      //       ),
      //     ],
      //   ),
      //   //margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      //   width: double.infinity,
      //   child: Container(
      //       margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      //       child: ElevatedButton(onPressed: () {}, child: Text('Save'))),
      // ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: const InputDecoration(
                          label: Text('Title'),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            title: newValue.toString(),
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter product name';
                          } else
                            return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: const InputDecoration(
                          label: Text('Price'),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        //focusNode: _priceFocusNode,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descFocusNode);
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(newValue!),
                            imageUrl: _editedProduct.imageUrl,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'please enter a number greater than zero';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: const InputDecoration(
                          label: Text('Description'),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        //maxLines: 3,
                        maxLength: 300,
                        //focusNode: _priceFocusNode,
                        focusNode: _descFocusNode,
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: newValue.toString(),
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter the descriptions';
                          }
                          if (value.length < 5) {
                            return 'characters too short';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imgUrlController.text.isEmpty
                                ? const Text(
                                    'Enter Url',
                                  )
                                : FittedBox(
                                    child: Image.network(
                                      _imgUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Image Url',
                              ),
                              keyboardType: TextInputType.url,
                              controller: _imgUrlController,
                              textInputAction: TextInputAction.done,
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: newValue!,
                                );
                              },
                              // onFieldSubmitted: (_) {
                              //   _saveForm();
                              // },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _saveForm();
                          },
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
