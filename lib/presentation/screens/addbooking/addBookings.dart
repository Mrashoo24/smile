import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/data/apiclient/apimanager.dart';
import 'package:smile/presentation/screens/bookinghistory/bookingh_history_screen.dart';

import '../authentication/controllers/authcontroller.dart';
import '../bookinghistory/bookingController.dart';

class AddBooking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Submit Form'),
          automaticallyImplyLeading: true,
          leading: InkWell(
              onTap: (){
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
  TextEditingController _jobCardController = TextEditingController(text: "Pick Up");
  TextEditingController _priorityController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timestampController = TextEditingController();
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
        child: FutureBuilder(
          future: Future.wait([ApiClient().getCompanyAddres(),ApiClient().getLabsAddres()]),
          builder: (context,futures) {

            if(!futures.hasData){
              return Center(child: CircularProgressIndicator(),);
            }

            var companyAddress = futures.requireData[0];
            var labAddress = futures.requireData[1];


            return ListView(
              children: _buildFormFields(companyAddress,labAddress),
            );
          }
        ),
      ),
    );
  }

  List<Widget> _buildFormFields(List<String> companyAddress,List<String> labAddress) {
    return [
      _buildDropdownField("Type",_jobCardController,["Pick Up","Delivery"]),
      _buildDatePicker("Booking Date",_dateController),
      _buildDateTimePicker("Booking Due Time",_timestampController),
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

      Builder(
        builder: (context) {


          return _jobCardController.text == "Pick Up" ? _buildMultiSelectDropdown("From Address", allItems,labAddress) :  _buildDropdownField("From Address", _fromAddressController,companyAddress);
        }
      ),
      SizedBox(height: 16),
      Builder(
        builder: (context) {

          return _jobCardController.text == "Pick Up" ?  _buildDropdownField("To Address", _toAddressController,companyAddress) : _buildMultiSelectDropdown("To Address", allItems,labAddress) ;
        }
      ),
      SizedBox(height: 16),
      _buildTextFieldMulti("Notes", _notesController),
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
      loading ? Center(child: CircularProgressIndicator(),): ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
           await  Future.forEach(allItems, (element) {
              ApiClient().addBooking(requestData: {
                "parent_cmpny_id": 39,
                "company_id": 39,
                "emp_id": authController.userModel.value!.id,
                "to_add_comp_id": "",
                "jobcard": _jobCardController.text,
                "priority": "",
                "date": _dateController.text,
                "timestampp":   "${_dateController.text.split(" ")[0]} ${_timestampController.text}",
                "companyname": _jobCardController.text == "Pick Up" ? _toAddressController.text.split('-//-')[0] : _fromAddressController.text.split('-//-')[0],
                "notes":_notesController.text,
                "status":"BOOKING APPROVED",
                "from_address": _jobCardController.text == "Pick Up" ? element.split('-//-')[1] : _toAddressController.text.split('-//-')[1],
                "to_address":_jobCardController.text == "Pick Up" ?  _toAddressController.text.split('-//-')[1] :element.split('-//-')[1],
                "userid": "39",
                "duetime": "${_dateController.text.split(" ")[0]} ${_timestampController.text}",
                "pricing": 0,
                "driver": authController.userModel.value!.firstName,
                "image": "",
                "drivernote": ""
              });
            });

           Get.offAll(BookingHistoryPage());
            // All fields are valid, submit the form
            // You can access the field values using the controllers
            // Add your logic to submit the form data
          }
        },
        child: Text('Submit',style: TextStyle(color: Colors.white),),
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
  Widget _buildTextFieldMulti(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      maxLines: 4,
      validator: (value) {
        if (value!.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(String label, TextEditingController controller, List<String> items) {
    if(controller.text.isEmpty){
      controller.text = items[0].replaceAll("\r\n", "").trim();;
    }
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: label,
        contentPadding: EdgeInsets.symmetric(vertical: 16.0), // Adjust the vertical padding as needed
      ),
      value: controller.text,
      isExpanded: true,
      items: items.map((item1) {
     
        var item = item1.replaceAll("\r\n", "").trim();
        return DropdownMenuItem(
          value: item,
          child: Text(item,maxLines: 3,style: TextStyle(fontSize: 12),),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          controller.text = value.toString();
          if(label == "Type"){
            allItems.clear();
          }
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
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
        _dateController.text = picked.toString();
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
        _timestampController.text =  _dateController.text.split(" ")[0].toString() + (" ${picked.hour}:${picked.minute}:00");
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
          onPressed:  _dateController.text.isNotEmpty ? () => _selectTime(context) : null,
        ),
      ],
    );
  }

  Widget _buildMultiSelectDropdown(String label, List<String> selectedItems, List<String> allItems) {
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
          child: DropdownButtonFormField(
            isDense: true,
            isExpanded: true,
            items: allItems.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                if (selectedItems.contains(value)) {
                  selectedItems.remove(value);
                } else {
                  selectedItems.add(value!);
                }
              });
            },
            value: selectedItems.isNotEmpty ? selectedItems[0] : null,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Text("Selected Items: ${selectedItems.join(", ")}"),
      ],
    );
  }
}