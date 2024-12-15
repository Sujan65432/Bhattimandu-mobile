import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bhattimandu/components/pages_header.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:bhattimandu/components/alert/liquor_validation.dart';
import 'package:bhattimandu/components/alert/quick_alert.dart';
import 'package:bhattimandu/components/app_header.dart';
import 'package:bhattimandu/components/form/alcohol_list.dart';
import 'package:bhattimandu/components/form/custom_bhatti_btn.dart';
import 'package:bhattimandu/components/form/custom_file_upload.dart';
import 'package:bhattimandu/components/form/custom_textfield.dart';
import 'package:bhattimandu/components/loader/bhatti_loader.dart';
import 'package:bhattimandu/database/product_controller.dart';
import 'package:bhattimandu/model/user_model.dart';

class EditLiquor extends StatefulWidget {
  final List<Map<String, dynamic>>? liquorData;
  const EditLiquor({super.key, this.liquorData});

  @override
  State<EditLiquor> createState() => _EditLiquorState();
}

class _EditLiquorState extends State<EditLiquor> {
  File? _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
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
  Uint8List? liqImg;

  @override
  void initState() {
    super.initState();
    print("Initializing EditLiquor...");

    if (widget.liquorData != null) {
      print("Liquor data provided.");
      liquorName = widget.liquorData?[0]['liquor']['liquorName'] ?? '';
      brandName = widget.liquorData?[0]['liquor']['brandName'] ?? '';
      life = widget.liquorData![0]['liquor']['life'] ?? '';
      volume = widget.liquorData![0]['liquor']['volume'] ?? '';
      category = widget.liquorData![0]['liquor']['category'] ?? '';
      type = widget.liquorData![0]['liquor']['type'] ?? '';
      origin = widget.liquorData![0]['liquor']['origin'] ?? '';
      price = widget.liquorData![0]['liquor']['price'] ?? '';
      stock = widget.liquorData![0]['liquor']['stock'] ?? '';
      desc = widget.liquorData![0]['liquor']['desc'] ?? '';
      final base64Image = widget.liquorData![0]['liquor']['img'] ?? '';
      print("Base64 image data: $base64Image");

      if (base64Image.isNotEmpty) {
        try {
          liqImg = base64Decode(base64Image);
          print("Image decoded successfully.");
        } catch (e) {
          print("Error decoding Base64: $e");
          liqImg = null;
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> uploadImg() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      isLoading = true;
    });
    if (pickedImage != null) {
      final bytes = await pickedImage.readAsBytes();
      setState(() {
        _image = File(pickedImage.path);
        _base64Liquor = base64Encode(bytes);
        liqImg = bytes;
        isLoading = false;
        error = '';
      });
    } else {
      setState(() {
        error = "No image selected";
        isLoading = false;
      });
    }
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        final result = await LiquorService().updateLiquor(
          context,
          widget.liquorData![0]['liquor']['id'],
          {
            'liquorName': liquorName,
            'brandName': brandName,
            'life': life,
            'volume': volume,
            'category': category,
            'type': type,
            'origin': origin,
            'price': price,
            'stock': stock,
            'desc': desc,
            'image': _base64Liquor,
          },
        );
        if (result) {
          Navigator.pushReplacementNamed(context, '/liquors');
        }
      } catch (e) {
        print("Error updating liquor: $e");
        QuickAlert.showAlert(
          context,
          'Error updating liquor: $e',
          AlertType.error,
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Building UI, isLoading: $isLoading, liqImg: $liqImg");
    return isLoading
        ? const BhattiLoader()
        : Scaffold(
            body: SafeArea(
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    const PagesHeader(
                      route: '/liquors',
                      title: 'Edit',
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                label: 'Liquor Name',
                                hintText: 'Enter product name',
                                initialValue: liquorName,
                                onChanged: (value) {
                                  setState(() {
                                    liquorName = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  CustomFileUpload(
                                    label: 'Liquor Image',
                                    onPressed: uploadImg,
                                    labelText: 'Upload a proper liquor image',
                                    upload: 'Upload Image',
                                    wid: 2.5,
                                    height: 120,
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.9,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2.4),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: _image != null
                                        ? Image.memory(
                                            liqImg!,
                                            fit: BoxFit.cover,
                                          )
                                        : const Center(
                                            child: Text(
                                              'No Image',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (error.isNotEmpty)
                                Text(
                                  error,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              const SizedBox(height: 12),
                              CustomTextField(
                                label: 'Brand Name',
                                hintText: 'Enter brand name',
                                initialValue: brandName,
                                onChanged: (value) {
                                  setState(() {
                                    brandName = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'Shelf Life',
                                      hintText: 'Enter shelf life (years)',
                                      suffix: 'years',
                                      initialValue: life,
                                      onChanged: (value) {
                                        setState(() {
                                          life = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'Volume',
                                      hintText: 'Enter volume',
                                      suffix: 'L',
                                      keyboardType: TextInputType.number,
                                      initialValue: volume,
                                      onChanged: (value) {
                                        setState(() {
                                          volume = value;
                                        });
                                      },
                                    ),
                                  ),
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
                                },
                              ),
                              const SizedBox(height: 12),
                              CustomTextField(
                                label: 'Type',
                                hintText: 'Enter type (e.g., Whiskey, Vodka)',
                                initialValue: type,
                                onChanged: (value) {
                                  setState(() {
                                    type = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 12),
                              CustomTextField(
                                label: 'Origin',
                                hintText: 'Enter origin (e.g., Country)',
                                initialValue: origin,
                                onChanged: (value) {
                                  setState(() {
                                    origin = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'Price',
                                      hintText: 'Enter price',
                                      suffix: '₨',
                                      keyboardType: TextInputType.number,
                                      initialValue: price,
                                      onChanged: (value) {
                                        setState(() {
                                          price = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'Stock',
                                      hintText: 'Enter stock quantity',
                                      keyboardType: TextInputType.number,
                                      initialValue: stock,
                                      onChanged: (value) {
                                        setState(() {
                                          stock = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              CustomTextField(
                                label: 'Description',
                                hintText: 'Enter description',
                                initialValue: desc,
                                onChanged: (value) {
                                  setState(() {
                                    desc = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 12),
                              CustomBhattiBtn(
                                onPressed: _updateProduct,
                                text: 'Update',
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
