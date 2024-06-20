import 'package:flutter/material.dart';

import 'HomePage.dart';

class TrackingPage extends StatelessWidget {
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

  TrackingPage({
    required this.totalPrice,
    required this.alamat, //address
    required this.jadwalJemput,
    required this.waktuPenjemputan, //pickupTime
    required this.quantity,
    required this.name,
    required this.serviceId, 
    required this.paymentStatus, //status
    required this.orderId,
    required this.Id, //id
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laundry Status'),
        backgroundColor: Colors.brown,
        leading: IconButton(
          icon: Icon(Icons.cancel_outlined),
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          ),
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
          children: [
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TrackingStep(
                  icon: Icons.local_laundry_service,
                  label: 'Washing',
                  isActive: true,
                  isCompleted: true,
                ),
                TrackingLine(isCompleted: true),
                TrackingStep(
                  icon: Icons.local_drink,
                  label: 'Drying',
                  isActive: true,
                  isCompleted: true,
                ),
                TrackingLine(isCompleted: true),
                TrackingStep(
                  icon: Icons.iron,
                  label: 'Ironing',
                  isActive: true,
                  isCompleted: false,
                ),
                TrackingLine(isCompleted: false),
                TrackingStep(
                  icon: Icons.delivery_dining,
                  label: 'Deliver',
                  isActive: false,
                  isCompleted: false,
                ),
              ],
            ),
            SizedBox(height: 40.0),
            Card(
              color: Color(0xFFF1E9E1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: $orderId',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    OrderDetailRow(
                      label: 'Tanggal pemesanan',
                      value: '${jadwalJemput.toLocal()}'.split(' ')[0],
                    ),
                    OrderDetailRow(
                      label: 'Paket yang dipilih',
                      value: 'Cuci Setrika', // Ganti dengan variabel paket yang dipilih jika perlu
                    ),
                    OrderDetailRow(
                      label: 'Alamat',
                      value: alamat,
                    ),
                    OrderDetailRow(
                      label: 'Estimasi pengerjaan',
                      value: 'Selesai dalam 2 hari', // Ganti dengan estimasi yang sesuai jika perlu
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrackingStep extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCompleted;

  TrackingStep({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: isCompleted ? Colors.brown : Colors.grey,
          child: Icon(
            icon,
            color: isCompleted ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.brown : Colors.grey,
          ),
        ),
      ],
    );
  }
}

class TrackingLine extends StatelessWidget {
  final bool isCompleted;

  TrackingLine({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 2.0,
      color: isCompleted ? Colors.brown : Colors.grey,
    );
  }
}

class OrderDetailRow extends StatelessWidget {
  final String label;
  final String value;

  OrderDetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.brown,
              fontSize: 14.0,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
