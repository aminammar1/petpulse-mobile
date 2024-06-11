import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/pet_selection_state.dart';
import 'dart:io';
import 'package:petpulse/api/api.dart';
import 'package:logger/logger.dart';
import 'package:petpulse/views/screens/device config/device_config.dart';

class PetDescribe extends StatelessWidget {
  final TextEditingController _petDescriptionController =
      TextEditingController();

  PetDescribe({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PetSelectionState>(
      create: (_) => PetSelectionState(),
      child: Consumer<PetSelectionState>(
        builder: (context, petSelectionState, child) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Add Pet',
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new),
              color: const Color.fromARGB(255, 22, 188, 58),
            ),
          ),
          body: _buildBody(context, petSelectionState),
          floatingActionButton: FloatingActionButton(
              onPressed: () => _submitPetDetails(context, petSelectionState),
              backgroundColor: const Color(0xFF00AF19),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              )),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PetSelectionState petSelectionState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ElevatedButton.icon(
              onPressed: () => _getImageFromDevice(context),
              icon: const Icon(Icons.image, color: Colors.white),
              label: const Text('Upload Image',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00AF19),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (petSelectionState.selectedImage != null)
            Container(
              padding: const EdgeInsets.all(10),
              child: ClipOval(
                child: Image.file(
                  petSelectionState.selectedImage!,
                  fit: BoxFit.cover,
                  width: 260,
                  height: 260,
                ),
              ),
            ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  labelStyle: TextStyle(color: Colors.black),
                  focusColor: Colors.grey,
                  floatingLabelStyle: TextStyle(color: Colors.grey),
                ),
              ),
              child: TextFormField(
                onChanged: (value) => petSelectionState.updatePetName(value),
                decoration: InputDecoration(
                  labelText: 'Pet Name',
                  border: InputBorder.none,
                  filled: true,
                  fillColor: const Color(0xFF00AF19).withOpacity(0.15),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  labelStyle: TextStyle(color: Colors.black),
                  focusColor: Colors.grey,
                  floatingLabelStyle: TextStyle(color: Colors.grey),
                ),
              ),
              child: TextFormField(
                readOnly: true,
                onTap: () => _selectDate(
                    context: context, petSelectionState: petSelectionState),
                decoration: InputDecoration(
                  labelText: 'Birthday',
                  border: InputBorder.none,
                  filled: true,
                  fillColor: const Color(0xFF00AF19).withOpacity(0.15),
                  contentPadding: const EdgeInsets.all(12),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(
                        context: context, petSelectionState: petSelectionState),
                  ),
                ),
                controller: TextEditingController(
                  text: petSelectionState.selectedDate != null
                      ? DateFormat('y MMMM d')
                          .format(petSelectionState.selectedDate!)
                      : '',
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  labelStyle: TextStyle(color: Colors.black),
                  focusColor: Colors.grey,
                  floatingLabelStyle: TextStyle(color: Colors.grey),
                ),
              ),
              child: TextFormField(
                controller: _petDescriptionController,
                maxLines: null,
                minLines: 3,
                keyboardType: TextInputType.multiline,
                maxLength: 150,
                decoration: InputDecoration(
                  labelText: 'Tell me about your pet (max 150 characters)',
                  border: InputBorder.none,
                  filled: true,
                  fillColor: const Color(0xFF00AF19).withOpacity(0.15),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _selectDate({
    required BuildContext context,
    required PetSelectionState petSelectionState,
  }) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              surface: Colors.green,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      petSelectionState.updateSelectedDate(pickedDate);
    }
  }

  Future<void> _getImageFromDevice(BuildContext context) async {
    final picker = ImagePicker();
    final petSelectionState =
        Provider.of<PetSelectionState>(context, listen: false);
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (context.mounted) {
      if (pickedFile != null) {
        petSelectionState.updateSelectedImage(File(pickedFile.path));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No image selected'),
        ));
      }
    }
  }

  Future<void> _submitPetDetails(
      BuildContext context, PetSelectionState petSelectionState) async {
    if (petSelectionState.selectedImage == null ||
        petSelectionState.selectedDate == null ||
        _petDescriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please complete all fields'),
      ));
      return;
    }

    final ScaffoldMessengerState scaffoldMessenger =
        ScaffoldMessenger.of(context);
    final NavigatorState navigator = Navigator.of(context);

    final response = await Api().addPetDetails(
      petName: petSelectionState.petName ?? "",
      birthday:
          DateFormat('yyyy-MM-dd').format(petSelectionState.selectedDate!),
      description: _petDescriptionController.text,
      petImage: petSelectionState.selectedImage!,
    );

    if (response.statusCode == 200) {
      Logger().i('Pet details added successfully');
      navigator
          .push(MaterialPageRoute(builder: (context) => const DeviceConfig()));
    } else {
      Logger().e('Failed to add pet details: ${response.body}');
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text('Failed to add pet details: ${response.body}'),
      ));
    }
  }
}
