import 'package:flutter/material.dart';
import 'package:laundry/CetakNotaPage.dart';
import 'HomePage.dart';
import 'TrackingPage.dart';

class PaymentStatusPage extends StatelessWidget {
  final int totalPrice;
  final String alamat;
  final DateTime jadwalJemput;
  final String waktuPenjemputan;
  final int quantity;
  final String name;
  final int serviceId;
  final String paymentStatus;
  final String orderId;
  final int Id;

  PaymentStatusPage({
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
            Center(
              child: Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 100),
                  SizedBox(height: 8.0),
                  Text(
                    'Pembayaran laundry Anda telah lunas!',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Order ID: $orderId',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Nama Customer: $name',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Paket Yang Dipilih: Cuci Setrika',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Quantity: $quantity',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'ID Layanan: $serviceId',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Status Pembayaran: $paymentStatus',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Tanggal Pemesanan: ${jadwalJemput.toLocal()}'.split(' ')[0],
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Jam Penjemputan: $waktuPenjemputan',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Alamat: $alamat',
              style: TextStyle(fontSize: 16.0),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrackingPage(
                          totalPrice: totalPrice,
                          alamat: alamat,
                          jadwalJemput: jadwalJemput,
                          waktuPenjemputan: waktuPenjemputan,
                          quantity: quantity,
                          name: name,
                          serviceId: serviceId,
                          paymentStatus: paymentStatus,
                          orderId: orderId,
                          Id: Id,
                        ),
                      ),
                    );
                  },
                  child: Text('Lacak'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CetakNotaPage(
                          totalPrice: totalPrice,
                          alamat: alamat,
                          jadwalJemput: jadwalJemput,
                          waktuPenjemputan: waktuPenjemputan,
                          quantity: quantity,
                          name: name,
                          serviceId: serviceId,
                          paymentStatus: paymentStatus,
                          orderId: orderId,
                          Id: Id,
                        ),
                      ),
                    );
                  },
                  child: Text('Cetak Nota'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
