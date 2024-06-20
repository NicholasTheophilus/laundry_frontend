import 'package:flutter/material.dart';
import 'TrackingPage.dart';
import 'api_service.dart';

class Order {
  final int id;
  final String name;
  final String status;
  final String address;
  final DateTime pickupTime;

  Order({
    required this.id,
    required this.name,
    required this.status,
    required this.address,
    required this.pickupTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Nama Tidak Diketahui',
      status: json['status'] ?? 'Status Tidak Diketahui',
      address: json['address'] ?? 'Alamat Tidak Diketahui',
      pickupTime: json['pickupTime'] != null ? DateTime.parse(json['pickupTime']) : DateTime.now(),
    );
  }
}

class MyOrderPage extends StatefulWidget {
  // Deklarasi properti yang diteruskan dari luar atau diinisialisasi di sini
  final int totalPrice; // contoh: 100000
  final String alamat; // contoh: 'Jl. Raya No. 123'
  final DateTime jadwalJemput; // contoh: DateTime.now()
  final String waktuPenjemputan; // contoh: '08:00'
  final int quantity; // contoh: 2
  final String name; // contoh: 'Nama Pelanggan'
  final int serviceId; // contoh: 1
  final String paymentStatus; // contoh: 'Belum Dibayar'
  final String orderId; // contoh: 'ORD123'
  final int Id; // contoh: 12345

  MyOrderPage({
    required this.totalPrice,
    required this.alamat,
    required this.jadwalJemput,
    required this.waktuPenjemputan,
    required this.quantity,
    required this.name,
    required this.serviceId,
    required this.paymentStatus,
    required this.orderId,
    required this.Id,
  });

  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  int _selectedIndex = 2;
  late Future<List<Order>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = getOrders(); // Misalnya, fungsi getOrders() harus didefinisikan di api_service.dart
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushNamed(context, '/home');
          break;
        case 1:
          Navigator.pushNamed(context, '/history');
          break;
        case 2:
          // Ini adalah halaman saat ini
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesanan Saya'),
        backgroundColor: Color(0xFF986E39),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Order>>(
          future: futureOrders,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Tidak ada pesanan yang ditemukan'));
            } else {
              List<Order> recentOrders = snapshot.data!.take(5).toList();
              return ListView.builder(
                itemCount: recentOrders.length,
                itemBuilder: (context, index) {
                  final order = recentOrders[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/images/on_boarding_images/sammy-line-delivery.gif',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(order.status),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text('${order.pickupTime.difference(DateTime.now()).inMinutes} menit'),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TrackingPage(
                                              totalPrice: widget.totalPrice,
                                              alamat: widget.alamat,
                                              jadwalJemput: widget.jadwalJemput,
                                              waktuPenjemputan: widget.waktuPenjemputan,
                                              quantity: widget.quantity,
                                              name: widget.name,
                                              serviceId: widget.serviceId,
                                              paymentStatus: widget.paymentStatus,
                                              orderId: widget.orderId,
                                              Id: widget.Id,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF986E39),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: Text('Lacak Pesanan'),
                                    ),
                                    SizedBox(width: 16),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 40),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: 40),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, size: 40),
            label: 'Pesanan Saya',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF986E39),
        onTap: _onItemTapped,
      ),
    );
  }
}
