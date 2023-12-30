
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/data/models/bookingModel.dart';
import 'package:smile/data/models/notesModel.dart';
import 'package:smile/presentation/screens/authentication/controllers/authcontroller.dart';
import 'package:smile/presentation/screens/bookinghistory/bookingController.dart';

class NotesHistoryPage extends StatefulWidget {
  const NotesHistoryPage({super.key});

  @override
  State<NotesHistoryPage> createState() => _NotesHistoryPageState();
}

class _NotesHistoryPageState extends State<NotesHistoryPage> {
  var controller = Get.put(BookingController());
  var authController = Get.put(AuthController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    controller.getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.getNotes();
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Notes History'),
          backgroundColor: Colors.red,
          automaticallyImplyLeading: true,
          // leading: InkWell(
          //     onTap: () {
          //       _scaffoldKey.currentState!.openDrawer();
          //     },
          //     child: Icon(Icons.menu)),
          actions: [
            Container(
              width: 120,
              margin: const EdgeInsets.only(right: 10),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: GetX<BookingController>(
                            builder: (controller) {
                              return SingleChildScrollView(
                                child: Container(
                                  height: 400,
                                  width: Get.width * 0.7,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 40, horizontal: 10),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const Text(
                                          "SELECT STATUS",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text("CAPTURE IMAGE"),
                                        Obx(() {
                                          return Center(
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: <Widget>[
                                                controller.selectedFileList
                                                    .value ==
                                                    null ||
                                                    controller.selectedFileList
                                                        .value!.isEmpty
                                                    ? const Text('No image selected.')
                                                    : Wrap(
                                                  children: controller
                                                      .selectedFileList.value!
                                                      .map((data) =>
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .all(20.0),
                                                        child: Image.file(
                                                          data,
                                                          height: 150.0,
                                                        ),
                                                      ),).toList(),
                                                ),
                                                const SizedBox(height: 20.0),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    controller.getImageBulk();
                                                  },
                                                  child: const Text('Select Image'),
                                                ),
                                                const SizedBox(height: 20.0),
                                                TextFormField(
                                                  controller:
                                                  controller.notesController,
                                                  decoration: const InputDecoration(
                                                      enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
                                                              color: Colors
                                                                  .red)),
                                                      focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
                                                              color: Colors
                                                                  .red)),
                                                      label: Text("Notes")),
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                        controller.notesloading.value
                                            ? const Center(
                                          child:
                                          CircularProgressIndicator(),
                                        )
                                            : InkWell(
                                          onTap: () {
                                            controller.updateNotes();
                                          },
                                          child: Card(
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.red),
                                                width: double.infinity,
                                                child: const Center(
                                                    child: Padding(
                                                      padding:
                                                      EdgeInsets.all(
                                                          8.0),
                                                      child: Text(
                                                        "Add Notes",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white),
                                                      ),
                                                    )),
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      });
                  // Get.defaultDialog(title: "Select Status",
                  //   content:
                  // );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red, backgroundColor: Colors.white,
                ),
                child: const Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        // drawer: SafeArea(
        //   child: Drawer(
        //     width: Get.width * 0.4,
        //     child: Padding(
        //       padding: EdgeInsets.only(top: 20.0),
        //       child: Column(
        //         children: [
        //           Text(authController.userModel.value!.firstName!,
        //             style: TextStyle(color: Colors.red,
        //                 fontWeight: FontWeight.bold,
        //                 letterSpacing: 3),),
        //           SizedBox(height: 20,),
        //           ListTile(title: Text("Booking"), onTap: () {
        //             Get.to(NotesHistoryPage());
        //           }, leading: Icon(Icons.newspaper_outlined)),
        //           SizedBox(height: 20,),
        //           ListTile(title: Text("Logout"), onTap: () {
        //             authController.logoutUser();
        //           }, leading: Icon(Icons.logout))
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        body: GetX<BookingController>(
          init: controller,
          builder: (controller) {
            return controller.notesloading.value
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
              itemCount: controller.noteList.value.length,
              itemBuilder: (context, index) {
                NotesModel booking = controller.noteList.value[index];

                return Card(
                    margin: const EdgeInsets.all(16.0),
                    child: Container(
                      child: Card(
                        child: Column(
                          children: [
                            Wrap(
                              children: booking.image!.map((e) =>
                                  Container(
                                      height: 100,
                                      width: 100,
                                      margin: const EdgeInsets.all(20),
                                      child: ClipRRect(
                                          child: Image.network(
                                            e,
                                            fit: BoxFit.fill,
                                          ))),).toList(),
                            ), const SizedBox(
                              height: 10,
                            ),
                            buildDataText(
                                context, 'Notes', '${booking.note}'),
                            const SizedBox(
                              height: 10,
                            ),
                            buildDataText(
                                context, 'Date', '${booking.date}'),
                          ],
                        ),
                      ),
                    ));
              },
            );
          },
        ),
      ),
    );
  }

  buildInkWell(title, BookingModel booking) {
    return InkWell(
      onTap: () {
        controller.updateBooking(int.parse(booking.id!), title);
      },
      child: Card(
          child: Container(
            decoration: const BoxDecoration(color: Colors.red),
            width: double.infinity,
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
          )),
    );
  }

  RichText buildDataText(BuildContext context, key, value) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle
            .of(context)
            .style,
        children: <TextSpan>[
          TextSpan(
            text: '$key: ',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
