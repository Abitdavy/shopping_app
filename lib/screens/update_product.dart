// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:real_shopping_app/provider/product.dart';
// import 'package:real_shopping_app/provider/products_provider.dart';

// class UpdateProduct extends StatefulWidget {
//   static const routeName = '/update-products';

//   @override
//   State<UpdateProduct> createState() => _UpdateProductState();
// }

// class _UpdateProductState extends State<UpdateProduct> {
//   final _form = GlobalKey<FormState>();
//   final _imgUrlController = TextEditingController();
//   bool isloading = false;
//   var initValue = {
//     'title': '',
//     'price': '',
//     'description': '',
//     'imgUrl': '',
//   };

//   @override
//   void didChangeDependencies() {
//     final productId = ModalRoute.of(context)!.settings.arguments as String;
//     var currentProduct = Provider.of<ProductsProvider>(context, listen: false)
//         .findbyId(productId);
//     initValue = {
//       'title': currentProduct.id,
//       'price': currentProduct.price.toString(),
//       'description': currentProduct.description,
//       'imgUrl': currentProduct.imageUrl,
//     };
//     _imgUrlController.text = currentProduct.imageUrl;
//     super.didChangeDependencies();
//   }

//   void initState() {
//     _imgUrlController.addListener(() {
//       setState(() {});
//     });
//     super.initState();
//   }

//   Future<void> _updateForm() async {
//     final isValid = _form.currentState!.validate();
//     if (!isValid) {
//       return;
//     }
//     _form.currentState!.save();
//     Provider.of<ProductsProvider>(context).UpdateProduct(initValue., newproduct);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final productId = ModalRoute.of(context)!.settings.arguments as String;
//     var updatedProduct =
//         Provider.of<ProductsProvider>(context).findbyId(productId);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Update Product ${updatedProduct.title}'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(
//           10,
//         ),
//         child: Form(
//           key: _form,
//           child: Column(
//             children: [
//               TextFormField(
//                 initialValue: initValue['title'],
//                 decoration: InputDecoration(
//                   label: Text('Title'),
//                 ),
//                 textInputAction: TextInputAction.next,
//                 onSaved: (newValue) {
//                   updatedProduct = Product(
//                     id: updatedProduct.id,
//                     title: newValue!,
//                     description: updatedProduct.description,
//                     price: updatedProduct.price,
//                     imageUrl: updatedProduct.imageUrl,
//                     isFavourite: updatedProduct.isFavourite,
//                   );
//                 },
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'please enter product name';
//                   } else
//                     return null;
//                 },
//               ),
//               TextFormField(
//                 initialValue: initValue['price'],
//                 decoration: InputDecoration(
//                   label: Text('Price'),
//                 ),
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.number,
//                 onSaved: (newValue) {
//                   updatedProduct = Product(
//                     id: updatedProduct.id,
//                     title: updatedProduct.title,
//                     description: updatedProduct.description,
//                     price: double.parse(newValue!),
//                     imageUrl: updatedProduct.imageUrl,
//                     isFavourite: updatedProduct.isFavourite,
//                   );
//                 },
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'please enter a price';
//                   }
//                   if (double.tryParse(value) == null) {
//                     return 'please enter a valid number';
//                   }
//                   if (double.parse(value) <= 0) {
//                     return 'please enter a number greater than zero';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 initialValue: initValue['description'],
//                 decoration: InputDecoration(
//                   label: Text('Description'),
//                 ),
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.multiline,
//                 maxLength: 300,
//                 onSaved: (newValue) {
//                   updatedProduct = Product(
//                     id: updatedProduct.id,
//                     title: updatedProduct.title,
//                     description: newValue!,
//                     price: updatedProduct.price,
//                     imageUrl: updatedProduct.imageUrl,
//                     isFavourite: updatedProduct.isFavourite,
//                   );
//                 },
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'please enter the descriptions';
//                   }
//                   if (value.length < 5) {
//                     return 'characters too short';
//                   }
//                   return null;
//                 },
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     width: 100,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         width: 1,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     child: _imgUrlController.text.isEmpty
//                         ? Text(
//                             'Enter Url',
//                           )
//                         : FittedBox(
//                             child: Image.network(
//                               _imgUrlController.text,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Expanded(
//                     child: TextFormField(
//                       //initialValue: updatedProduct.imageUrl,
//                       decoration: InputDecoration(
//                         labelText: 'Image Url',
//                       ),
//                       keyboardType: TextInputType.url,
//                       controller: _imgUrlController,
//                       textInputAction: TextInputAction.done,
//                       onSaved: (newValue) {
//                         updatedProduct = Product(
//                           id: updatedProduct.id,
//                           title: updatedProduct.title,
//                           description: updatedProduct.description,
//                           price: updatedProduct.price,
//                           imageUrl: newValue!,
//                           isFavourite: updatedProduct.isFavourite,
//                         );
//                       },
//                       // onFieldSubmitted: (_) {
//                       //   _saveForm();
//                       // },
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(vertical: 10),
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     _form.currentState!.save();
//                     Provider.of<ProductsProvider>(context, listen: false)
//                         .UpdateProduct(updatedProduct.id, updatedProduct);
//                   },
//                   child: Text('Save'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
