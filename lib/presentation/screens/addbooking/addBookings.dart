import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smile/data/apiclient/apimanager.dart';
import 'package:smile/data/models/companyModel.dart';
import 'package:smile/presentation/screens/bookinghistory/bookingh_history_screen.dart';

import '../../../data/models/addressModel.dart';
import '../authentication/controllers/authcontroller.dart';
import '../bookinghistory/bookingController.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddBooking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Submit Form'),
          automaticallyImplyLeading: true,
          leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.keyboard_backspace_rounded)),
        ),
        body: MyForm(),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var controller = Get.put(BookingController());
  var authController = Get.put(AuthController());

  bool loading = false;
  // Define controllers for each field
  TextEditingController _parentCompanyController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _employeeIdController = TextEditingController();
  TextEditingController _toAddressCompanyController = TextEditingController();
  TextEditingController _jobCardController =
      TextEditingController(text: "Pick Up");
  TextEditingController _priorityController = TextEditingController();
  TextEditingController _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController _timestampController = TextEditingController(
      text: DateFormat('hh:mm:ss').format(DateTime.now()));
  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  TextEditingController _fromAddressController = TextEditingController();
  TextEditingController _toAddressController = TextEditingController();
  TextEditingController _userIdController = TextEditingController();
  TextEditingController _dueTimeController = TextEditingController();
  TextEditingController _pricingController = TextEditingController();
  TextEditingController _driverController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  TextEditingController _driverNoteController = TextEditingController();

  List<String> allItems = [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<List<dynamic>>>(
            future: Future.wait(
                [ApiClient().getCompanyAddres(), ApiClient().getLabsAddres()]),
            builder: (context, futures) {
              if (!futures.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var companyAddress = futures.requireData[0];
              var labAddress = futures.requireData[1];

              return ListView(
                children: _buildFormFields(companyAddress as List<Company>,
                    labAddress as List<DentalLab>),
              );
            }),
      ),
    );
  }

  List<Widget> _buildFormFields(
      List<Company> companyAddress, List<DentalLab> labAddress) {
    return [
      _buildDropdownField("Type", _jobCardController, ["Pick Up", "Delivery"]),
      _buildDatePicker("Booking Date", _dateController),
      _buildDateTimePicker("Booking Due Time", _timestampController),
      // Builder(
      //   builder: (context) {
      //     _employeeIdController = TextEditingController(text: "Arsalan");
      //     return _buildDropdownField("Select Employee", _employeeIdController,["Arsalan","Me"]);
      //   }
      // ),
      // Divider(thickness: 1),
      // Text("Company Info",style:  TextStyle(color: Colors.black),),
      // Divider(thickness: 1),
      SizedBox(height: 16),

      Builder(builder: (context) {
        return _jobCardController.text == "Pick Up"
            ? _buildMultiSelectDropdown("From Address", allItems, labAddress)
            : _buildDropdownField(
                "From Address", _fromAddressController, companyAddress);
      }),
      SizedBox(height: 16),
      Builder(builder: (context) {
        return _jobCardController.text == "Pick Up"
            ? _buildDropdownField(
                "To Address", _toAddressController, companyAddress)
            : _buildMultiSelectDropdown("To Address", allItems, labAddress);
      }),
      SizedBox(height: 16),
      _buildTextFieldMulti("Notes", _notesController, mandatory: false),
      //
      // _buildTextField("Parent Company ID", _parentCompanyController),
      // _buildTextField("Company ID", _companyController),
      // _buildTextField("Job Card", _jobCardController),
      // _buildTextField("Priority", _priorityController),
      // _buildTextField("Date", _dateController),
      // _buildTextField("Timestamp", _timestampController),
      // _buildTextField("Company Name", _companyNameController),
      //
      // _buildTextField("Status", _statusController),
      //
      // _buildTextField("User ID", _userIdController),
      // _buildTextField("Due Time", _dueTimeController),
      // _buildTextField("Pricing", _pricingController),
      // _buildTextField("Driver", _driverController),
      // _buildTextField("Image", _imageController),
      // _buildTextField("Driver Note", _driverNoteController),
      SizedBox(height: 16),
      loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await Future.forEach(allItems, (element) {
                    ApiClient().addBooking(requestData: {
                      "parent_cmpny_id": _jobCardController.text == "Pick Up"
                          ? companyAddress
                              .firstWhere((e) =>
                                  e.companyName ==
                                  _toAddressController.text.split(' - ')[0])
                              .companyId
                          : companyAddress
                              .firstWhere((e) =>
                                  e.companyName ==
                                  _toAddressController.text.split(' - ')[0])
                              .companyId,
                      "company_id": 39,
                      "emp_id": authController.userModel.value!.id,
                      "to_add_comp_id": "",
                      // _jobCardController.text == "Pick Up" ?  companyAddress.firstWhere((e) => e.companyName == _toAddressController.text.split(' - ')[0]).companyId : companyAddress.firstWhere((e) => e.companyName == _toAddressController.text.split(' - ')[0]).companyId,
                      "jobcard": _jobCardController.text,
                      "priority": "",
                      "date": _dateController.text,
                      "timestampp":
                          "${_dateController.text} ${_timestampController.text}",
                      "companyname":_jobCardController.text == "Pick Up"
                          ? element.split(' - ')[0]
                          : _fromAddressController.text.split(' - ')[0],
                      // _jobCardController.text == "Pick Up"
                      //     ? _toAddressController.text.split(' - ')[0]
                      //     : _fromAddressController.text.split(' - ')[0],
                      "notes": _notesController.text,
                      "status": "OPEN",
                      "from_address": _jobCardController.text == "Pick Up"
                          ? element.split(' - ')[0]
                          :_fromAddressController.text.split(' - ')[0] ,
                      "to_address": _jobCardController.text == "Pick Up"
                          ? _toAddressController.text.split(' - ')[0]
                          : element.split(' - ')[0] ,
                      "userid": "39",
                      "duetime":
                          "${_dateController.text}  ${_timestampController.text}",
                      "pricing": 0,
                      "driver": authController.userModel.value!.firstName,
                      "image": "",
                      "drivernote": "",
                      "platform_type": "mobile"
                    });
                  });

                  await Future.delayed(Duration(seconds: 1));

                  Get.offAll(BookingHistoryPage());
                  // All fields are valid, submit the form
                  // You can access the field values using the controllers
                  // Add your logic to submit the form data
                }
              },
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
    ];
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value!.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  Widget _buildTextFieldMulti(String label, TextEditingController controller,
      {bool mandatory = true}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      maxLines: 4,
      validator: (value) {
        if (value!.isEmpty && mandatory) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(
      String label, TextEditingController controller, List<dynamic> items) {
    if (controller.text.isEmpty) {
      controller.text = items is List<Company>
          ? "${items[0].companyName} - ${items[0].address}"
          : items is List<DentalLab>
              ? "${items[0].labName} - ${items[0].labAddress}"
              : "";
    }
    return items is List<Company>
        ? DropdownSearch<String>(
            selectedItem: controller.text,
            items:
                (items).map((e) => "${e.companyName} - ${e.address}").toList(),
            popupProps: const PopupPropsMultiSelection.menu(
              showSelectedItems: true,
              showSearchBox: true,
            ),
            onChanged: (selectedItems1) {
              setState(() {
                controller.text = selectedItems1.toString();
                if (label == "Type") {
                  allItems.clear();
                }
              });
              // Handle selected items here
            },
            validator: (value) {
              if (value == null) {
                return '$label is required';
              }
              return null;
            },
            // dropdownSearchDecoration: InputDecoration(
            //   border: InputBorder.none,
            // ),
            // showSelectedItem: true,
            compareFn: (item, selectedItem) => item == selectedItem,
            // label: "Select",
            // itemAsString: ,
            // popupItemBuilder: (context, item, isSelected) {
            //   return ListTile(
            //     title: Text(item),
            //     trailing: isSelected ? Icon(Icons.check) : null,
            //   );
            // },
          )
        : items is List<DentalLab>
            ? DropdownSearch<String>(
                selectedItem: controller.text,
                items: (items)
                    .map((e) => "${e.labName} - ${e.labAddress}")
                    .toList(),
                popupProps: const PopupPropsMultiSelection.menu(
                  showSelectedItems: true,
                  showSearchBox: true,
                ),
                onChanged: (selectedItems1) {
                  setState(() {
                    controller.text = selectedItems1.toString();
                    if (label == "Type") {
                      allItems.clear();
                    }
                  });
                  // Handle selected items here
                },
                validator: (value) {
                  if (value == null) {
                    return '$label is required';
                  }
                  return null;
                },
                // dropdownSearchDecoration: InputDecoration(
                //   border: InputBorder.none,
                // ),
                // showSelectedItem: true,
                compareFn: (item, selectedItem) => item == selectedItem,
                // label: "Select",
                // itemAsString: ,
                // popupItemBuilder: (context, item, isSelected) {
                //   return ListTile(
                //     title: Text(item),
                //     trailing: isSelected ? Icon(Icons.check) : null,
                //   );
                // },
              )
            : DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: label,
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 16.0), // Adjust the vertical padding as needed
                ),
                value: controller.text,
                isExpanded: true,
                items: items.map((item1) {
                  var item = item1.replaceAll("\r\n", "").trim();
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      maxLines: 3,
                      style: TextStyle(fontSize: 12),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    controller.text = value.toString();
                    if (label == "Type") {
                      allItems.clear();
                    }
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return '$label is required';
                  }
                  return null;
                },
              );

    //
    //   DropdownButtonFormField(
    //   decoration: InputDecoration(
    //     labelText: label,
    //     contentPadding: EdgeInsets.symmetric(vertical: 16.0), // Adjust the vertical padding as needed
    //   ),
    //   value: controller.text,
    //   isExpanded: true,
    //   items: items.map((item1) {
    //
    //     var item = item1.replaceAll("\r\n", "").trim();
    //     return DropdownMenuItem(
    //       value: item,
    //       child: Text(item,maxLines: 3,style: TextStyle(fontSize: 12),),
    //     );
    //   }).toList(),
    //   onChanged: (value) {
    //     setState(() {
    //       controller.text = value.toString();
    //       if(label == "Type"){
    //         allItems.clear();
    //       }
    //     });
    //   },
    //   validator: (value) {
    //     if (value == null || value.isEmpty) {
    //       return '$label is required';
    //     }
    //     return null;
    //   },
    // );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dateController.text) {
      setState(() {
        _dateController.text =
            DateFormat('yyyy-MMM-dd hh:mm:ss').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final DateTime selectedTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        picked.hour,
        picked.minute,
      );
      setState(() {
        _timestampController.text = DateFormat('hh:mm:ss').format(selectedTime);
      });
    }
  }

  Widget _buildDatePicker(String label, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(labelText: label),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label is required';
              }
              return null;
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker(String label, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(labelText: label),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label is required';
              }
              return null;
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.access_time),
          onPressed: _dateController.text.isNotEmpty
              ? () => _selectTime(context)
              : null,
        ),
      ],
    );
  }

  Widget _buildMultiSelectDropdown(
      String label, List<String> selectedItems, List<dynamic> allItems1) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: allItems1 is List<Company>
              ? DropdownSearch<String>.multiSelection(
                  items: (allItems1)
                      .map((e) => "${e.companyName} - ${e.address}")
                      .toList(),
                  popupProps: PopupPropsMultiSelection.menu(
                    showSelectedItems: true,
                    showSearchBox: true,
                  ),
                  onChanged: (selectedItems1) {
                    print("selected Items = ${selectedItems1}");
                    setState(() {
                      allItems = selectedItems1;
                    });
                    // Handle selected items here
                  },
                  selectedItems: selectedItems,
                  // dropdownSearchDecoration: InputDecoration(
                  //   border: InputBorder.none,
                  // ),
                  // showSelectedItem: true,
                  compareFn: (item, selectedItem) => item == selectedItem,
                  // label: "Select",
                  // itemAsString: ,
                  // popupItemBuilder: (context, item, isSelected) {
                  //   return ListTile(
                  //     title: Text(item),
                  //     trailing: isSelected ? Icon(Icons.check) : null,
                  //   );
                  // },
                )
              : allItems1 is List<DentalLab>
                  ? DropdownSearch<String>.multiSelection(
                      items: (allItems1)
                          .map((e) => e.labName + " - " + e.labAddress)
                          .toList(),
                      popupProps: PopupPropsMultiSelection.menu(
                        showSelectedItems: true,
                        showSearchBox: true,
                      ),
                      onChanged: (selectedItems1) {
                        print("selected Items = ${selectedItems1}");
                        setState(() {
                          allItems = selectedItems1;
                        });
                        // Handle selected items here
                      },
                      selectedItems: selectedItems,
                      // dropdownSearchDecoration: InputDecoration(
                      //   border: InputBorder.none,
                      // ),
                      // showSelectedItem: true,
                      compareFn: (item, selectedItem) => item == selectedItem,
                      // label: "Select",
                      // itemAsString: ,
                      // popupItemBuilder: (context, item, isSelected) {
                      //   return ListTile(
                      //     title: Text(item),
                      //     trailing: isSelected ? Icon(Icons.check) : null,
                      //   );
                      // },
                    )
                  : SizedBox(),
        ),
      ],
    );
  }
}
