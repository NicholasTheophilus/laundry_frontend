import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'CheckoutPage.dart';
import 'api_service.dart'; // Import fungsi createOrder dan fetchOrderId

class PenjemputanPage extends StatefulWidget {
  final int quantity;
  final int totalPrice;
  final String name;
  final int serviceId;
  final String payment_status;

  PenjemputanPage({
    required this.quantity,
    required this.totalPrice,
    required this.name,
    required this.serviceId,
    required this.payment_status,
  });

  @override
  _PenjemputanPageState createState() => _PenjemputanPageState();
}

class _PenjemputanPageState extends State<PenjemputanPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String _alamat = 'Jl.Jl sendirian aja, kapan sama No.9, RT.1/RW.4';
  String _waktuPenjemputan = '08.00';
  bool _isLoading = false;

  // Fungsi untuk membuat pesanan dan mengembalikan orderId dan Id
  Future<Map<String, dynamic>> createOrderAndFetchOrderId() async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await createOrder(
        name: widget.name,
        address: _alamat,
        serviceId: widget.serviceId,
        quantity: widget.quantity,
        totalPrice: widget.totalPrice.toDouble(),
        pickupDate: _selectedDay,
        pickupTime: _waktuPenjemputan.replaceAll('.', ':'),
        payment_status: 'pending',
      );

      if (success) {
        String orderId = await fetchOrderId() ?? '';
        int Id = await fetchIds() ?? 0;
        return {'orderId': orderId, 'Id': Id};
      } else {
        throw Exception('Failed to create order.');
      }
    } catch (e) {
      throw Exception('Failed to create order: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Penjemputan'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alamat',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _alamat = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Masukkan Alamat',
                        ),
                        controller: TextEditingController(text: _alamat),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Jadwal Penjemputan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TableCalendar(
                        firstDay: DateTime(2020, 1, 1),
                        lastDay: DateTime(2030, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        calendarFormat: CalendarFormat.month,
                        availableGestures: AvailableGestures.all,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 70,
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih Waktu Penjemputan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _waktuPenjemputan = '08.00';
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: _waktuPenjemputan == '08.00' ? Colors.blue : Colors.grey,
                          ),
                          backgroundColor: _waktuPenjemputan == '08.00' ? Colors.blue[50] : Colors.white,
                        ),
                        child: Text(
                          '08.00',
                          style: TextStyle(
                            color: _waktuPenjemputan == '08.00' ? Colors.blue : Colors.black,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _waktuPenjemputan = '10.00';
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: _waktuPenjemputan == '10.00' ? Colors.blue : Colors.grey,
                          ),
                          backgroundColor: _waktuPenjemputan == '10.00' ? Colors.blue[50] : Colors.white,
                        ),
                        child: Text(
                          '10.00',
                          style: TextStyle(
                            color: _waktuPenjemputan == '10.00' ? Colors.blue : Colors.black,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _waktuPenjemputan = '13.00';
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: _waktuPenjemputan == '13.00' ? Colors.blue : Colors.grey,
                          ),
                          backgroundColor: _waktuPenjemputan == '13.00' ? Colors.blue[50] : Colors.white,
                        ),
                        child: Text(
                          '13.00',
                          style: TextStyle(
                            color: _waktuPenjemputan == '13.00' ? Colors.blue : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        color: Color(0xFFF1E9E1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total\nRp ${widget.totalPrice}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  Map<String, dynamic> result = await createOrderAndFetchOrderId();
                  String orderId = result['orderId'];
                  int Id = result['Id'];

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        totalPrice: widget.totalPrice,
                        alamat: _alamat,
                        jadwalJemput: _selectedDay,
                        waktuPenjemputan: _waktuPenjemputan,
                        quantity: widget.quantity,
                        name: widget.name,
                        serviceId: widget.serviceId,
                        payment_status: 'pending',
                        orderId: orderId,
                        Id: Id,
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal membuat pesanan: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFF986E39),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              ),
              child: Text('Check Out'),
            ),
          ],
        ),
      ),
    );
  }
}
