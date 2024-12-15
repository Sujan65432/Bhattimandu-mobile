import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bhattimandu/components/alert/liquor_validation.dart';
import 'package:bhattimandu/components/app_header.dart';
import 'package:bhattimandu/components/form/alcohol_list.dart';
import 'package:bhattimandu/components/form/custom_bhatti_btn.dart';
import 'package:bhattimandu/components/form/custom_file_upload.dart';
import 'package:bhattimandu/components/loader/bhatti_loader.dart';
import 'package:bhattimandu/database/product_controller.dart';
import 'package:bhattimandu/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../components/form/custom_textfield.dart';

class AddLiquor extends StatefulWidget {
  const AddLiquor({super.key});

  @override
  State<AddLiquor> createState() => _AddLiquorState();
}

class _AddLiquorState extends State<AddLiquor> {
  File? _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final LiquorService _product = LiquorService();

  String liquorName = '',
      brandName = '',
      life = '',
      volume = '',
      category = '',
      type = '',
      origin = '',
      price = '',
      stock = '',
      desc = '';
  String? liquorErr,
      brandErr,
      lifeErr,
      volumeErr,
      categoryErr,
      typeErr,
      originErr,
      priceErr,
      stockErr,
      descErr;
  String error = '', _base64Liquor = '';
  bool isSubmit = false;
  Uint8List? liqImg;
  Future uploadImg() async {
    final XFile? pickedImage2 =
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      isLoading = true;
    });
    if (pickedImage2 != null) {
      final bytes = await pickedImage2.readAsBytes();
      setState(() {
        _image = File(pickedImage2.path);
        _base64Liquor = base64Encode(bytes);
        liqImg = bytes;
        isLoading = false;
        error = ''; // Clear any previous errors
      });
    } else {
      setState(() {
        error = "No image selected";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserModel?>(context);
    return isLoading
        ? const BhattiLoader()
        : Scaffold(
            body: SafeArea(
                child: Container(
                    width: double.infinity,
                    padding:null,
                    child: Column(
                      children: [
                        const AppHeader(title: 'Add Liquor'),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 26, vertical: 12),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomTextField(
                                    helperText: isSubmit
                                        ? LiquorValidation.validateLiquorName(
                                            liquorName)
                                        : null,
                                    helperStyle: const TextStyle(
                                        color: Colors.red,
                                        fontFamily: 'poppins',
                                        fontStyle: FontStyle.italic),
                                    label: 'Liquor Name',
                                    hintText: 'enter product name',
                                    onChanged: (value) {
                                      setState(() {
                                        liquorName = value;
                                      });
                                    }, initialValue: '',
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomFileUpload(
                                        label: 'Liquor Image',
                                        onPressed: uploadImg,
                                        labelText: 'Upload proper Liquor image',
                                        upload: 'Upload image',
                                        wid: 2.5,
                                        height: 120,
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                          margin: const EdgeInsets.all(0),
                                          width:
                                              MediaQuery.of(context).size.width / 2.4,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2.4,
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: _image != null
                                              ? Image.memory(
                                                  liqImg! as Uint8List,
                                                  fit: BoxFit.cover,
                                                  width: 150,
                                                  height: 120,
                                                )
                                              : null),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (_image == null)
                                        Text(
                                          error,
                                          style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontFamily: 'poppins',
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red,
                                          ),
                                        )
                                      else
                                        const Text(
                                          "Liquor Image Uploaded successfully!",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontFamily: 'poppins',
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  CustomTextField(
                                    helperText: isSubmit
                                        ? LiquorValidation.validateBrandName(
                                            brandName)
                                        : null,
                                    helperStyle: const TextStyle(
                                        color: Colors.red,
                                        fontFamily: 'poppins',
                                        fontStyle: FontStyle.italic),
                                    label: 'Brand Name',
                                    hintText: 'enter brand name',
                                    onChanged: (value) {
                                      setState(() {
                                        brandName = value;
                                      });
                                    }, initialValue: '',
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Container(
                                        padding: null,
                                        width: MediaQuery.of(context).size.width / 2,
                                        child: CustomTextField(
                                          helperText: isSubmit
                                              ? LiquorValidation.validateLife(life)
                                              : null,
                                          helperStyle: const TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'poppins',
                                              fontStyle: FontStyle.italic),
                                          label: 'Shelf Life',
                                          hintText: 'enter shelf life',
                                          suffix: 'years',
                                          onChanged: (value) {
                                            setState(() {
                                              life = value;
                                            });
                                          }, initialValue: '',
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        padding: null,
                                        width:
                                            MediaQuery.of(context).size.width / 3.3,
                                        child: CustomTextField(
                                          helperText: isSubmit
                                              ? LiquorValidation.validateVol(volume)
                                              : null,
                                          helperStyle: const TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'poppins',
                                              fontStyle: FontStyle.italic),
                                          label: 'Volume',
                                          suffix: 'litre',
                                          keyboardType: TextInputType.number,
                                          hintText: 'volume',
                                          onChanged: (value) {
                                            setState(() {
                                              volume = value;
                                            });
                                          }, initialValue: '',
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  AlcoholList(
                                      label: 'Select Alcohol Category',
                                      wid: 1,
                                      onChanged: (value) {
                                        setState(() {
                                          category = value!;
                                        });
                                      }),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: null,
                                        width:
                                            MediaQuery.of(context).size.width / 2.4,
                                        child: CustomTextField(
                                          helperText: isSubmit
                                              ? LiquorValidation.type(type)
                                              : null,
                                          helperStyle: const TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'poppins',
                                              fontStyle: FontStyle.italic),
                                          label: 'Liquor Type',
                                          hintText: 'enter liquor type',
                                          onChanged: (value) {
                                            setState(() {
                                              type = value;
                                            });
                                          }, initialValue: '',
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        padding: null,
                                        width:
                                            MediaQuery.of(context).size.width / 2.5,
                                        child: CustomTextField(
                                          helperText: isSubmit
                                              ? LiquorValidation.origin(origin)
                                              : null,
                                          helperStyle: const TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'poppins',
                                              fontStyle: FontStyle.italic),
                                          label: 'Liquor Origin',
                                          hintText: 'region name',
                                          onChanged: (value) {
                                            setState(() {
                                              origin = value;
                                            });
                                          }, initialValue: '',
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: null,
                                        width:
                                            MediaQuery.of(context).size.width / 2.4,
                                        child: CustomTextField(
                                          helperText: isSubmit
                                              ? LiquorValidation.price(price)
                                              : null,
                                          helperStyle: const TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'poppins',
                                              fontStyle: FontStyle.italic),
                                          label: 'Price',
                                          suffix: 'Rs.',
                                          keyboardType: TextInputType.number,
                                          hintText: 'liquor rate',
                                          onChanged: (value) {
                                            setState(() {
                                              price = value;
                                            });
                                          }, initialValue: '',
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        padding: null,
                                        width:
                                            MediaQuery.of(context).size.width / 2.5,
                                        child: CustomTextField(
                                          helperText: isSubmit
                                              ? LiquorValidation.stock(stock)
                                              : null,
                                          helperStyle: const TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'poppins',
                                              fontStyle: FontStyle.italic),
                                          label: 'Stock',
                                          keyboardType: TextInputType.number,
                                          hintText: 'stock',
                                          onChanged: (value) {
                                            setState(() {
                                              stock = value;
                                            });
                                          }, initialValue: '',
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  CustomTextField(
                                    maxLines: 4,
                                    helperText:
                                        isSubmit ? LiquorValidation.desc(desc) : null,
                                    helperStyle: const TextStyle(
                                        color: Colors.red,
                                        fontFamily: 'poppins',
                                        fontStyle: FontStyle.italic),
                                    label: 'Description',
                                    hintText: 'enter description',
                                    onChanged: (value) {
                                      setState(() {
                                        desc = value;
                                      });
                                    }, initialValue: '',
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  CustomBhattiBtn(
                                    text: 'Add Product',
                                    icon: const Icon(Icons.add_box_sharp),
                                    onPressed: () async {
                                      setState(() {
                                        isSubmit = true;
                                        isLoading = true;
                                      });
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await _product.addLiquor(
                                          context,
                                          _base64Liquor,
                                          liquorName,
                                          brandName,
                                          life,
                                          volume,
                                          category,
                                          type,
                                          origin,
                                          stock,
                                          desc,
                                          price,
                                          user?.uid,
                                        );
                          
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Navigator.pushReplacementNamed(context, '/liquors');
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))),
          );
  }
}
