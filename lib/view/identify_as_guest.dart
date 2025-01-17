import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:graduation_project/constants.dart';

Future<String>? imageUrl;

class Identify extends StatefulWidget {
  const Identify({super.key});

  @override
  State<Identify> createState() => _IdentifyState();
}

class _IdentifyState extends State<Identify> {
  File? _imageFile;

  final _picker = ImagePicker();
  List resolutions = [];
  bool isLoading = false;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _openImagePicker({required ImageSource imageSource}) async {
    final XFile? pickedImage = await _picker.pickImage(source: imageSource);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);

        _predict();
        resolutions = [];
      });
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageurlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.go('/welcome_screen');
          },
          color: Colors.white,
        ),
        title: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              context.pushNamed('instructions');
            },
            child: const Icon(
              Icons.question_mark_rounded,
              color: Colors.white,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: kDarkColor,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 300,
              width: 280,
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: Colors.white),
                  // ignore: prefer_const_literals_to_create_immutables
                  boxShadow: [
                    const BoxShadow(
                        color: Colors.black12,
                        offset: Offset(2, 2),
                        spreadRadius: 2,
                        blurRadius: 1)
                  ]),
              child: (_imageFile != null)
                  ? Image.file(
                      File(_imageFile!.path),
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
            FloatingActionButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      actions: [
                        Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      _openImagePicker(
                                          imageSource: ImageSource.gallery);

                                      Navigator.pop(context);
                                    },
                                    child: const Text('Gallery')),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _openImagePicker(
                                          imageSource: ImageSource.camera);

                                      Navigator.pop(context);
                                    },
                                    child: const Text('Camera')),
                              ]),
                        ),
                      ],
                    ),
                  );
                  setState(() {
                    isLoading = true;
                  });
                },
                tooltip: 'Select Image',
                backgroundColor: Colors.white,
                child: const Icon(Icons.add_a_photo_outlined,
                    size: 25, color: kPrimaryColor)),
            const SizedBox(
              height: 30,
            ),
            ////
            ///   Testing Widget
            ///

            // const Text(
            //   'Name',
            //   style: TextStyle(
            //       color: kDarkColor, fontFamily: 'Inter', fontSize: 30),
            // ),
            const Center(
              child: Text(
                'Classification result:',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (isLoading)
              LoadingAnimationWidget.staggeredDotsWave(
                  color: kPrimaryColor, size: 30),
            (resolutions.isEmpty)
                ? const SizedBox(
                    height: 50,
                  )
                : Column(
                    children: [
                      Text(
                        resolutions.first['label'],
                        style: const TextStyle(
                          fontSize: 20,
                          color: kDarkColor,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Future recognizeImage(File image) async {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 5,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
        resolutions = recognitions ?? [];
      });
    });

    int endTime = DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
  }

  _predict() async {
    await Tflite.loadModel(
      model: "assets/tensorflow/model_unquant.tflite",
      labels: "assets/tensorflow/labels.txt",
      // useGpuDelegate: true,
    );
    recognizeImage(_imageFile!);
  }
}
