// ignore: unused_import
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'MyOrderPage.dart';
import 'outletSelect.dart';
import 'ServiceDetailPage.dart';

Future<String> fetchUserName() async {
  try{
    await dotenv.load();
    String backendUrl = dotenv.env['API_URL']!;
    String getUrl = '$backendUrl/users/';

    var response = await http.get(Uri.parse(getUrl));

    if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('Response data: $data');

    // Mengambil objek pengguna pertama dari list
    if (data is List && data.isNotEmpty) {
      final firstUser = data[0];
      return firstUser['name'];
    } else {
      throw Exception('Data pengguna tidak valid');
    }
  } else {
    print('Error code: ${response.statusCode}');
    throw Exception('Gagal mengambil nama pengguna');
  }
  } catch (e) { // Ganti dengan ini
    print('Exception: $e'); // Tambahkan baris ini
    rethrow;
  }
}

Future<bool> loginUser(String email, String password) async {
  await dotenv.load();
  String backendUrl = dotenv.env['API_URL']!;
  String loginUrl = '$backendUrl/users/login'; // Sesuaikan endpoint login jika berbeda

  Map<String, String> body = {
    'email': email,
    'password': password,
  };

  final response = await http.post(
    Uri.parse(loginUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> registerUser(String name, String email, String phone, String password) async {
  await dotenv.load();
  String backendUrl = dotenv.env['API_URL']!;
  String registerUrl = '$backendUrl/users';

  Map<String, String> body = {
    'name': name,
    'email': email,
    'phone': phone,
    'password': password,
  };

  final response = await http.post(
    Uri.parse(registerUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );

  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

Future<List<Outlet>> fetchOutlets() async {
  try {
    await dotenv.load();
    String backendUrl = dotenv.env['API_URL']!;
    String getUrl = '$backendUrl/laundries';
    final response = await http.get(Uri.parse(getUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) => Outlet.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch outlets. Error: ${response.body}');
    }
  } catch (e) {
    print('Error fetching outlets: $e');
    throw Exception('Error fetching outlets: $e');
  }
}


Future<void> updateLaundryDistance(int laundryId) async {
  try {
    await dotenv.load();
    String backendUrl = dotenv.env['API_URL']!;
    String updateUrl = '$backendUrl/laundries/:id$laundryId';

    // Mendapatkan lokasi pengguna
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Mengirim permintaan ke backend untuk mengupdate jarak
    final response = await http.put(
      Uri.parse(updateUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'location': '${position.latitude},${position.longitude}',
      }),
    );

    if (response.statusCode == 200) {
      // Jarak berhasil diupdate
      print('Distance updated successfully');
    } else {
      // Gagal mengupdate jarak
      print('Failed to update distance. Error: ${response.body}');
    }
  } catch (e) {
    print('Error updating distance: $e');
  }
}

Future<List<Service>> fetchServices() async {
  try {
    await dotenv.load();
    String backendUrl = dotenv.env['API_URL']!;
    String getUrl = '$backendUrl/services';
    final response = await http.get(Uri.parse(getUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) => Service.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch services. Error: ${response.body}');
    }
  } catch (e) {
    print('Error fetching services: $e');
    throw Exception('Error fetching services: $e');
  }
}

Future<bool> createOrder({
  required String name,
  required String address,
  required int serviceId,
  required int quantity,
  required double totalPrice,
  required DateTime pickupDate,
  required String pickupTime,
  required String payment_status,
}) async {
  await dotenv.load();
  String backendUrl = dotenv.env['API_URL']!;
  String createOrderUrl = '$backendUrl/orders';

  final url = Uri.parse(createOrderUrl);
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'name': name,
      'address': address,
      'service_id': serviceId,
      'quantity': quantity,
      'total_price': totalPrice.toStringAsFixed(2),
      'pickup_date': pickupDate.toIso8601String().split('T')[0],
      'pickup_time': pickupTime,
      'payment_status': payment_status,
    }),
  );

  if (response.statusCode == 201) {
    return true;
  } else {
    print('response: ${response.body}');
    return false;
  }
}

Future<String?> fetchOrderId() async {
  try {
    await dotenv.load();
    String backendUrl = dotenv.env['API_URL']!;
    String getUrl = '$backendUrl/orders/';

    var response = await http.get(Uri.parse(getUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Response data: $data');

      // Pastikan data yang diterima adalah list
      if (data is List && data.isNotEmpty) {
        // Ambil order_id dari objek pertama dalam list
        final firstOrder = data[0];
        if (firstOrder['order_id'] is String) {
          return firstOrder['order_id'];
        } else {
          throw Exception('order_id bukan tipe String (UUID)');
        }
      } else {
        throw Exception('Data pengguna tidak valid');
      }
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('Gagal mengambil data order');
    }
  } catch (e) {
    print('Exception: $e');
    rethrow; // lemparkan kembali exception yang ditangkap
  }
}

Future<int?> fetchIds() async {
  try {
    await dotenv.load();
    String backendUrl = dotenv.env['API_URL']!;
    String getUrl = '$backendUrl/orders/';

    var response = await http.get(Uri.parse(getUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Response data: $data');

      // Pastikan data yang diterima adalah list
      if (data is List && data.isNotEmpty) {
        // Ambil order_id dari objek pertama dalam list
        final firstOrder = data[0];
        if (firstOrder['id'] is int) {
          return firstOrder['id'];
        } else {
          throw Exception('id bukan tipe String (UUID)');
        }
      } else {
        throw Exception('Data pengguna tidak valid');
      }
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('Gagal mengambil data order');
    }
  } catch (e) {
    print('Exception: $e');
    rethrow; // lemparkan kembali exception yang ditangkap
  }
}

Future<bool> updateOrder({
  required int Id, // Menggunakan id yang diperoleh dari backend
  required String paymentMethod,
  required String paymentStatus,
}) async {
  await dotenv.load();
  String backendUrl = dotenv.env['API_URL']!;
  String apiUrl = '$backendUrl/orders/$Id'; // Menggunakan parameter id dalam URL

  Map<String, dynamic> requestData = {
    'payment_method': paymentMethod,
    'payment_status': paymentStatus,
  };
  print('id: $Id');

  try {
    var response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Gagal memperbarui pesanan: ${response.statusCode} ${response.body}');
      return false;
    }
  } catch (e) {
    print('Terjadi kesalahan saat memperbarui pesanan: $e');
    return false;
  }
}

Future<List<Order>> getOrders() async {
    await dotenv.load();
    String baseUrl = dotenv.env['API_URL']!;
    final response = await http.get(Uri.parse('$baseUrl/orders'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((order) => Order.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }
