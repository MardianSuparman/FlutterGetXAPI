// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/app/data/detail_event_response.dart';
import 'package:myapp/app/data/event_response.dart';
import 'package:myapp/app/modules/dashboard/views/index_view.dart';
import 'package:myapp/app/modules/dashboard/views/profile_view.dart';
import 'package:myapp/app/modules/dashboard/views/your_event_view.dart';
import 'package:myapp/app/utils/api.dart';

class DashboardController extends GetxController {

  final selectedIndex = 0.obs;
  final _getConnect = GetConnect();

  final token = GetStorage().read('token');

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pages = [
    IndexView(),
    YourEventView(),
    ProfileView(),
  ];

  // GET EVENTS
  Future<EventResponse> getEvent() async {
    final response = await _getConnect.get(
      BaseUrl.events,
      headers: {'Authorization': 'Bearer $token'},
      contentType: 'application/json',
    );
    return EventResponse.fromJson(response.body);
  }

  // GET YOUR EVENTS
  var yourEvents = <Events>[].obs;
  Future<void> getYourEvent() async {
    final response = await _getConnect.get(
      BaseUrl.yourEvent,
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );
    final eventResponse = EventResponse.fromJson(response.body);
    yourEvents.value = eventResponse.events ?? [];
  }

  // controller untuk buat name, deskripsi, tanggal event, dan lokasi
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController =
      TextEditingController(); // Agar mudah mengatur tanggal
  TextEditingController eventDateController =
      TextEditingController(); // Masukan Alamat atau Tempatnya
  TextEditingController locationController = TextEditingController();


  // ADD EVENT
  void addEvent() async {
    // Kirim data ke server Pake -getConnect.poct
    final response = await _getConnect.post(
      BaseUrl.events, // Url buat API tambah Event
      {
        'name': nameController.text, // Ambil text dari input nama
        'description': descriptionController.text, // Deskripsi Event
        'event_date': eventDateController.text, // Tanggal event
        'location': locationController.text, // Lokasi event
      },
      headers: {
        'Authorization': 'Bearer $token'
      }, // Header buat autentikasi, token wajib nih
      contentType: 'application/json', // Format Json Biar rpih
    );

    // Cek respon server, kalo sukses kode 201
    if (response.statusCode == 201) {
      // notifikasi pake Get.snackbar jika berhasil
      Get.snackbar(
        'Success', // Judul notifikasi
        'Event Added', // Pesan sukses
        snackPosition: SnackPosition.BOTTOM, // Posisi notifikasi di bawah
        backgroundColor: Colors.green, // Warna hijau, vibes happy
        colorText: Colors.white, // Teks putih biar kontras
      );
      // Bersihin semua input, biar fresh lagi
      nameController.clear();
      descriptionController.clear();
      eventDateController.clear();
      locationController.clear();
      update(); // Update UI biar langsung kelihatan perubahan
      getEvent(); // Refresh daftar event
      getYourEvent(); // Refresh daftar event user
      Get.close(1); // Tutup halaman atau modal
    } else {
      // Kalau gagal, kasih notifikasi gagal
      Get.snackbar(
        'Failed', // Judul notifikasi
        'Event Failed to Add', // Pesan gagal
        snackPosition: SnackPosition.BOTTOM, // Posisi notifikasi di bawah
        backgroundColor: Colors.red, // Warna merah, vibes alert
        colorText: Colors.white, // Teks putih biar jelas
      );
    }
  }

  // DETAIL EVENT
  // Fungsi buat ngambil detail event, tinggal panggil dan kasih ID event-nya
  Future<DetailEventResponse> getDetailEvent({required int id}) async {
    // Kirim request GET ke server buat ambil detail event
    final response = await _getConnect.get(
      '${BaseUrl.detailEvents}/$id', // URL detail event, ID-nya ditempel di sini
      headers: {
        'Authorization': "Bearer $token"
      }, // Header buat autentikasi, token kudu ada
      contentType: "application/json", // Format data JSON biar proper
    );
    // Balikin data yang udah di-parse ke model DetailEventResponse
    return DetailEventResponse.fromJson(response.body);
  }

  // EDIT EVENT
  // Fungsi buat edit data event, tinggal panggil terus kasih ID-nya
  void editEvent({required int id}) async {
    // Kirim request POST ke server, tapi dengan method PUT buat update data
    final response = await _getConnect.post(
      '${BaseUrl.events}/$id', // URL endpoint ditambah ID event
      {
        'name': nameController.text, // Nama event dari input
        'description': descriptionController.text, // Deskripsi event dari input
        'event_date': eventDateController.text, // Tanggal event dari input
        'location': locationController.text, // Lokasi event dari input
        '_method': 'PUT', // Hack buat ganti method jadi PUT
      },
      headers: {'Authorization': "Bearer $token"}, // Header buat autentikasi
      contentType: "application/json", // Format data JSON
    );

    // Cek respons dari server
    if (response.statusCode == 200) {
      // Kalau berhasil, kasih notifikasi sukses
      Get.snackbar(
        'Success', // Judul snack bar
        'Event Updated', // Pesan sukses
        snackPosition: SnackPosition.BOTTOM, // Posisi snack bar di bawah
        backgroundColor: Colors.green, // Warna latar hijau (success vibes)
        colorText: Colors.white, // Warna teks putih biar kontras
      );

      // Clear semua input biar bersih
      nameController.clear();
      descriptionController.clear();
      eventDateController.clear();
      locationController.clear();

      // Update UI dan reload data event
      update();
      getEvent(); // Panggil ulang data semua event
      getYourEvent(); // Panggil ulang data event user
      Get.close(1); // Tutup halaman edit
    } else {
      // Kalau gagal, kasih notifikasi gagal
      Get.snackbar(
        'Failed', // Judul snack bar
        'Event Failed to Update', // Pesan gagal
        snackPosition: SnackPosition.BOTTOM, // Posisi snack bar di bawah
        backgroundColor: Colors.red, // Warna latar merah (error vibes)
        colorText: Colors.white, // Warna teks putih biar jelas
      );
    }
  }

  // DELETE EVENT
  // Fungsi buat hapus event, tinggal kasih ID-nya
  void deleteEvent({required int id}) async {
    // Kirim request POST ke server, tapi sebenarnya buat DELETE
    final response = await _getConnect.post(
      '${BaseUrl.deleteEvents}/$id', // URL endpoint ditambah ID event
      {
        '_method': 'delete', // Hack biar request diubah jadi DELETE
      },
      headers: {
        'Authorization': "Bearer $token"
      }, // Header autentikasi (token user)
      contentType: "application/json", // Data dikirim dalam format JSON
    );

    // Cek respons server, kalau sukses ya good vibes
    if (response.statusCode == 200) {
      // Notifikasi sukses hapus event
      Get.snackbar(
        'Success', // Judul snack bar
        'Event Deleted', // Pesan sukses
        snackPosition: SnackPosition.BOTTOM, // Posisi snack bar di bawah
        backgroundColor: Colors.green, // Latar hijau biar lega
        colorText: Colors.white, // Teks putih biar baca enak
      );

      // Update UI dan reload data event biar up-to-date
      update(); // Kasih tahu UI kalau ada yang berubah
      getEvent(); // Refresh semua event
      getYourEvent(); // Refresh event user
    } else {
      // Kalau gagal, ya udah kasih tau user aja
      Get.snackbar(
        'Failed', // Judul snack bar
        'Event Failed to Delete', // Pesan error
        snackPosition: SnackPosition.BOTTOM, // Posisi snack bar di bawah
        backgroundColor: Colors.red, // Latar merah biar tegas
        colorText: Colors.white, // Teks putih biar tetap baca jelas
      );
    }
  }

  @override
  void onInit() {
    getEvent();
    getYourEvent();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
