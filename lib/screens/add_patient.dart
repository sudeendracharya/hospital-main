import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hospital/modular/modular_methods.dart';

class AddPatient extends StatefulWidget {
  AddPatient({super.key});
  static const routeName = '/AddPatient';

  @override
  State<AddPatient> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  TextEditingController patientNameController = TextEditingController();

  TextEditingController ageController = TextEditingController();

  TextEditingController complaintController = TextEditingController();

  TextEditingController genderController = TextEditingController();

  TextEditingController instructionsController = TextEditingController();

  var file;
  var fileName;

  var selectedFile;

  String? fileType;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        ModularMethods.removeFocus(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Patient'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25,
                ),
                textField(patientNameController, size, 'Patient Name'),
                textField(ageController, size, 'Age'),
                textField(complaintController, size, 'Complaint'),
                textField(genderController, size, 'Gender'),
                textField(instructionsController, size, 'Instructions'),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: size.width * 0.8,
                    child: Row(
                      children: [
                        const Text(
                          'Instruction File',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        fileName == null
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(fileName),
                              ),
                        fileName == null
                            ? ElevatedButton.icon(
                                onPressed: selectFile,
                                icon: const Icon(Icons.add),
                                label: const Text('Add'))
                            : ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.cancel),
                                label: const Text('Cancel'))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectFile() async {
    // Get.back();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      // EasyLoading.show();
      var fileBytes = result.files.first;
      // print(fileBytes.extension);
      File file = File(result.files.single.path!);
      // print(file.toString());
      file.readAsBytes().then((value) async {
        fileName = fileBytes.name;
        selectedFile = value;
        fileType = fileBytes.extension;
        // EasyLoading.dismiss();
        // var result = await Get.toNamed(FilePreview.routeName, arguments: {
        //   'File_Bytes': value,
        //   'File_Type': fileBytes.extension,
        //   'File_Name': fileBytes.name,
        //   'Sender_Id': senderId,
        //   'Receiver_Id': receiverId,
        //   'File_Path': file.toString(),
        //   'File': file,
        //   'Conversation_Id': conversationId,
        // });

        // if (result != null) {
        //   bool value = checkConnection();
        //   if (value == true) {
        //     // emitFile(result);
        //   }
        // }
      });
    } else {
      // User canceled the picker
    }
  }

  Widget textField(TextEditingController controller, Size size, String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: size.width * 0.8,
          height: name == 'Instructions' ? 100 : 40,
          child: TextField(
            maxLines: name == 'Instructions' ? 4 : null,
            controller: controller,
            decoration: InputDecoration(
              labelText: name,
              contentPadding: const EdgeInsets.only(left: 20, top: 10),
              // hintText: name,
              border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3),
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
      ),
    );
  }
}
