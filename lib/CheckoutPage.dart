import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'PaymentStatusPage.dart';
import 'api_service.dart'; // Import api_service untuk fungsi updateOrder dan fetchOrderDetails

class CheckoutPage extends StatelessWidget {
  final int totalPrice;
  final String alamat;
  final DateTime jadwalJemput;
  final String waktuPenjemputan;
  final int quantity;
  final String name;
  final int serviceId;
  final String payment_status;
  final String orderId;
  final int Id;

  CheckoutPage({
    required this.totalPrice,
    required this.alamat,
    required this.jadwalJemput,
    required this.waktuPenjemputan,
    required this.quantity,
    required this.name,
    required this.serviceId,
    required this.payment_status,
    required this.orderId,
    required this.Id,
  });

  // Fungsi untuk memperbarui status pembayaran dan metode pembayaran
  Future<void> updateOrderAndProceed(BuildContext context, String paymentMethod) async {
    try {
      // Memperbarui status pembayaran dan metode pembayaran
      bool success = await updateOrder(
        Id:Id,
        paymentMethod: paymentMethod,
        paymentStatus: 'paid',
      );
      if (success) {
        // Navigasi ke halaman berikutnya dengan data yang diperbarui
        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentStatusPage(
                      totalPrice: totalPrice,
                      alamat: alamat,
                      jadwalJemput: jadwalJemput,
                      waktuPenjemputan: waktuPenjemputan,
                      quantity: quantity,
                      name: name,
                      serviceId: serviceId,
                      paymentStatus: payment_status,
                      orderId: orderId,
                      Id: Id,
                    ),
                  ),
                ); 
      } else {
        // Handle kesalahan jika gagal memperbarui
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui status pembayaran.')),
        );
      }
    } catch (e) {
      // Handle kesalahan umum
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Metode Pembayaran'),
        // Tombol back di sebelah kiri AppBar
        leading: IconButton(
          icon: Icon(Icons.cancel_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rp $totalPrice',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'ID Pesanan: $orderId',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Divider(),
                    Text(
                      'Pesanan Anda',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Cuci Setrika',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Quantity: $quantity',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Nama: $name',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'ID Layanan: $serviceId',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Status Pembayaran: $payment_status',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            // Pilihan metode pembayaran
            ListTile(
              title: Text('Bank Transfer'),
              leading: Icon(Icons.account_balance),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                updateOrderAndProceed(context, 'Bank Transfer');
              },
            ),
            ListTile(
              title: Text('E-wallet'),
              leading: Icon(Icons.account_balance_wallet),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                updateOrderAndProceed(context, 'E-wallet');
              },
            ),
            ListTile(
              title: Text('Minimarket'),
              leading: Icon(Icons.store),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                updateOrderAndProceed(context, 'Minimarket');
              },
            ),
          ],
        ),
      ),
    );
  }
}
