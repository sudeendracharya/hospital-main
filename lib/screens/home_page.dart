import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital/constants/app_constants.dart';
import 'package:hospital/providers/api_calls.dart';
import 'package:hospital/screens/add_patient.dart';
import 'package:hospital/screens/patient_details_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  static const routeName = '/HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiCalls calls = Get.find<ApiCalls>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ApiCalls>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text('Hospital Management'),
        ),
        body: FutureBuilder<int>(
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: Text('Loading'),
                  )
                : snapshot.data == 200
                    ? ListView.builder(
                        itemCount: controller.patientList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                controller
                                    .getPatientDetails(
                                        '${AppConstants.referalPatientdetails}${controller.patientList[index].id}')
                                    .then((value) {
                                  if (value == 200) {
                                    Get.toNamed(PatientDetailsPage.routeName);
                                  }
                                });
                              },
                              key: UniqueKey(),
                              title: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  controller.patientList[index].patientName,
                                ),
                              ),
                              trailing:
                                  controller.patientList[index].visited == true
                                      ? const Text(
                                          'Visited',
                                        )
                                      : const Text(
                                          'Not visited',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                        children: [
                          const Text(
                              'Unable to load data something went wrong please retry'),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {});
                              },
                              child: const Text('Retry'))
                        ],
                      ));
          },
          future: controller.getPatientList(AppConstants.referalPatientList),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 15.0, bottom: 15),
          child: IconButton(
              onPressed: () {
                Get.toNamed(AddPatient.routeName);
              },
              icon: const Icon(
                Icons.add_circle_outline,
                size: 45,
              )),
        ),
      ),
    );
  }
}
