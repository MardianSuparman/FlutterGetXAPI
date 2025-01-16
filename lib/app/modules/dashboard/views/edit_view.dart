import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/app/data/detail_event_response.dart';
import 'package:myapp/app/modules/dashboard/controllers/dashboard_controller.dart';

class EditView extends GetView {
  const EditView({super.key, required this.id, required this.title});
  final int id;
  final String title;
  
  @override
  Widget build(BuildContext context) {
    DashboardController controller = Get.put(DashboardController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit $title Event'), // Judulnya ada nama event
        centerTitle: true, // Tengahin judul biar simetris
        backgroundColor: HexColor('#feeee8'), // Warna pastel yang calming
      ),
      backgroundColor: HexColor('#feeee8'), // Latar belakang sama kayak AppBar
      body: FutureBuilder<DetailEventResponse>(
        future:
            controller.getDetailEvent(id: id), // Ambil detail event sesuai ID
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Kalau masih loading, kasih animasi lucu biar nggak boring
            return Center(
              child: Lottie.network(
                'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
                repeat: true, // Animasi muter terus
                width: MediaQuery.of(context).size.width / 1, // Lebar full
              ),
            );
          }
          if (snapshot.hasData) {
            // jika datanya sudah ada, isi format otomatis
            controller.nameController.text = snapshot.data!.name ?? '';
            controller.descriptionController.text =
                snapshot.data!.description ?? '';
            controller.eventDateController.text =
                snapshot.data!.eventDate ?? '';
            controller.locationController.text = snapshot.data!.location ?? '';
          }
          return Column(
            children: [
              // animasi buat header
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Lottie.network(
                  'https://gist.githubusercontent.com/olipiskandar/2095343e6b34255dcfb042166c4a3283/raw/d76e1121a2124640481edcf6e7712130304d6236/praujikom_kucing.json',
                  fit: BoxFit.cover, // Cocokin animasi ke layar
                ),
              ),
              // input unutk nama event, Langsung autofill dari server
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  autofocus: true, //fokus langsung ke inputan pertama
                  controller: controller.nameController, // Controller buat nama
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Event Name',
                      hintText: 'Masukan Nama Event'),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: TextField(
                  controller: controller
                      .descriptionController, // Controller unutk deskripsi
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                      hintText: 'Masukan Deskripsi'),
                ),
              ),
              // Input tanggal event, bisa dipilih lewat date picker
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: controller
                      .eventDateController, // Controller untuk Date event
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Event Date',
                      hintText: 'Masukan Tanggal Event'),
                  onTap: () async {
                    // Date picker Memilih tanggal
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), // Mulai hari ini
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2100),
                    );
                    // Date yng di pilih di set ke controller
                    if (selectedDate != null) {
                      controller.eventDateController.text =
                          DateFormat('yyyy-mm-dd').format(selectedDate);
                    }
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: TextField(
                  controller:
                      controller.locationController, // Controller Lokasi
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Location',
                      hintText: 'Masukan Lokasi Event'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // button Submit untuk membuat perubahan
              Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: () {
                    controller.editEvent(id: id);
                  },
                  child: const Text(
                    'Save', // Teks tombol "Save"
                    style: TextStyle(
                      color: Colors.white, // Teks putih biar kontras
                      fontSize: 25, // Ukuran teks gede
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
