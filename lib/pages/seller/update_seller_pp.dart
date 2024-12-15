import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bhattimandu/components/alert/quick_alert.dart';
import 'package:bhattimandu/components/form/custom_bhatti_btn.dart';
import 'package:bhattimandu/components/form/custom_file_upload.dart';
import 'package:bhattimandu/components/loader/bhatti_loader.dart';
import 'package:bhattimandu/components/pages_header.dart';
import 'package:bhattimandu/database/authentication.dart';
import 'package:bhattimandu/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../components/alert/validation.dart';
import '../../components/form/custom_textfield.dart';

class UpdateSellerPp extends StatefulWidget {
  final Map<String, dynamic>? sellerData;

  const UpdateSellerPp({super.key, this.sellerData});

  @override
  State<UpdateSellerPp> createState() => _UpdateSellerPpState();
}

class _UpdateSellerPpState extends State<UpdateSellerPp> {
  String name = '',phone='',email='',password='';

  @override
  void initState() {
    super.initState();
    if (widget.sellerData != null) {
      name = widget.sellerData!['fullName'] ?? '';
      email = _emailController.text = widget.sellerData!['email'] ?? '';
      phone=   _phoneController.text = widget.sellerData!['phone'] ?? '';
      password=   _phoneController.text = widget.sellerData!['password'] ?? '';

    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? _image;
  final _formKey = GlobalKey<FormState>();
  String _base64Image = "";
  final picker = ImagePicker();
  bool isLoading=false;
  bool isRegistered=false;
  uploadImg() async {
    final XFile? pickedImage2 =
    await picker.pickImage(source: ImageSource.gallery);
    final user = Provider.of<UserModel?>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    if (pickedImage2 != null) {
      final bytes = await pickedImage2.readAsBytes();
      final base64Image = base64Encode(bytes);

      try {

        setState(() {
          _image = File(pickedImage2.path);
          _base64Image = base64Image;
          isLoading=false;
        });

        QuickAlert.showAlert(
          context,
          "Image uploaded successfully!",
          AlertType.success,
        );
      } catch (e) {
        QuickAlert.showAlert(

          context,
          "Error uploading image: ${e.toString()}",
          AlertType.error,
        );
      }
    }
  }
  _updateProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final password = widget.sellerData!['password'];
      await AuthenticationService().updateUserProfile(
        context,
        widget.sellerData!['id'],
        {
          'email': email,
          'password': password,
          'fullName':name,
          'phone': phone,
          'image': _base64Image,
          'role':'seller'
        },
      );

      // Show success alert
      QuickAlert.showAlert(
        context,
        'Account Updated Successfully',
        AlertType.success,
      );
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacementNamed(context, '/seller_account');
    } catch (e) {
      // Handle error if update fails
      QuickAlert.showAlert(
        context,
        'Error updating profile: $e',
        AlertType.error,
      );
      setState(() {
        isLoading = false;
      });
    } finally {
      // Reset loading state
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final base64Image =
        widget.sellerData!['image'] ?? '';
    final user = Provider.of<UserModel?>(context, listen: false);

    Uint8List? imageBytes;
    if (base64Image.isNotEmpty) {
      try {
        imageBytes = base64Decode(base64Image);
      } catch (e) {
        print("Error decoding Base64: $e");
        imageBytes = null;
      }
    }
    return isLoading? const BhattiLoader(): Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            const PagesHeader(title: 'Update Profile', route: '/seller_account'),
            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child:
              Column(
                children: [
                  CircleAvatar(
                    foregroundImage: imageBytes != null
                        ? MemoryImage(imageBytes)
                        : const AssetImage('images/bhatti.png'),
                    maxRadius: 50,
                  ),
                  CustomFileUpload(
                    label: 'Upload Profile',
                    onPressed: uploadImg,
                    labelText: 'Upload proper avatar',
                    upload: 'Upload image',
                    wid: 2.5,
                    height: 120,
                  ),
                  const SizedBox(height: 10,),
                  CustomTextField(
                    label: 'FullName',
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },initialValue:name ,
                    helperText: isRegistered
                        ? Validators.validateFullName(name)
                        : null,
                    helperStyle: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'poppins',
                        fontStyle: FontStyle.italic),
                    hintText: 'enter your name',
                  ),
                  const SizedBox(height: 10,),
                  CustomTextField(
                    label: 'Email',
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    initialValue: email,
                    helperText: isRegistered
                        ? Validators.validateUserEmail(email)
                        : null,
                    helperStyle: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'poppins',
                        fontStyle: FontStyle.italic),
                    hintText: 'enter your email',
                  ),
                  const SizedBox(height: 10,),

                  CustomTextField(
                    label: 'Password',
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    initialValue: password,

                    helperText: isRegistered
                        ? Validators.validateUserPhone(name)
                        : null,
                    helperStyle: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'poppins',
                        fontStyle: FontStyle.italic),
                    hintText: 'enter your password',
                  ),
                  const SizedBox(height: 10,),

                  CustomTextField(
                    label: 'Phone',
                    onChanged: (value) {
                      setState(() {
                        phone = value;
                      });
                    },
                    initialValue: phone,
                    helperText: isRegistered
                        ? Validators.validateUserPhone(phone)
                        : null,
                    helperStyle: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'poppins',
                        fontStyle: FontStyle.italic),
                    hintText: 'enter your phone',
                  ),
                ],
              ),
            )),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: CustomBhattiBtn(text: 'Update', onPressed: _updateProfile),
            )
          ],
        ),
      ),
    );
  }
}
