import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class ImageInput extends ConsumerStatefulWidget {
  const ImageInput({super.key, required this.saveImage});
  final Function saveImage;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImageInputState();
}

class _ImageInputState extends ConsumerState<ImageInput> {
  File? _selectedImage;

  void _pickImage() async {
    // pick an image
    final picker = ImagePicker();
    final imgFile = await picker.pickImage(source: ImageSource.gallery);
    if(imgFile == null)
    {
      return;
    }
    setState(() {
        _selectedImage = File(imgFile.path);
    });
    // get the app directory
    final appDirectory = await syspath.getApplicationDocumentsDirectory();
    // get the file name as given by the camera/internal_storage.
    final fileName = path.basename(imgFile.path);
    // Save a copy of image in the app directory with the original name of the image. 
    print("\nDIRECTORY NAME = ${appDirectory.path}");
    print("\nFILE NAME = $fileName \n");
    print("Saving file....");
    final savedImage =
        await File(imgFile.path).copy('${appDirectory.path}/$fileName');
    // send the image back to the main widget that has use this ImageInput widget
    print('File saved!!');
    widget.saveImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
          height: 150,
          width: size.width * 0.5,
          // width: 100,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: (_selectedImage == null)
              ? const Text(
                  "No Image Selected",
                  textAlign: TextAlign.center,
                )
              : Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        const SizedBox(
          width: 10,
        ),
        TextButton.icon(
          onPressed: () {
            _pickImage();
          },
          icon: const Icon(Icons.camera_alt_rounded),
          label: const Text("Select an Image"),
        ),
      ],
    );
  }
}
