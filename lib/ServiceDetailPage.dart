import 'package:flutter/material.dart';
import 'PenjemputanPage.dart';
// import 'api_service.dart';

class Service {
  final int id;
  final String name;
  final double price;

  Service({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}

class ServiceDetailPage extends StatefulWidget {
  final Service service;
  final String name;

  ServiceDetailPage({required this.name, required this.service});

  @override
  _ServiceDetailPageState createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  int totalPrice = 1;
  int _quantity = 1;
  String _payment_status = 'pending';

  @override
  void initState() {
    super.initState();
    totalPrice = widget.service.price.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1, // Sesuaikan dengan jumlah tab yang ingin ditampilkan
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detail Layanan'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              ItemList(
                services: [widget.service], // Menampilkan hanya layanan yang dipilih
                updateTotalPrice: _updateTotalPrice,
                updateQuantity: _updateQuantity,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          color: Color(0xFFF1E9E1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total\nRp $totalPrice',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PenjemputanPage(
                        quantity: _quantity,
                        serviceId: widget.service.id, // Pastikan serviceId diteruskan dengan benar
                        name: widget.name, // Pastikan name diteruskan dengan benar
                        totalPrice: totalPrice,
                        payment_status: _payment_status,
                      ),
                    ),
                  );
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
      ),
    );
  }

  void _updateTotalPrice(int price, bool isIncrement) {
    setState(() {
      if (isIncrement) {
        totalPrice += price;
      } else {
        totalPrice -= price;
      }
    });
  }

  void _updateQuantity(int quantity) {
    setState(() {
      _quantity = quantity;
    });
  }
}

class ItemList extends StatelessWidget {
  final List<Service> services;
  final Function(int, bool) updateTotalPrice;
  final Function(int) updateQuantity;

  ItemList({required this.services, required this.updateTotalPrice, required this.updateQuantity});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return ItemCard(
          service: service,
          updateTotalPrice: updateTotalPrice,
          updateQuantity: updateQuantity,
        );
      },
    );
  }
}

class ItemCard extends StatefulWidget {
  final Service service;
  final Function(int, bool) updateTotalPrice;
  final Function(int) updateQuantity;

  ItemCard({
    required this.service,
    required this.updateTotalPrice,
    required this.updateQuantity,
  });

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  int _quantity = 1;
  String unitText = '/kg'; // Default satuan adalah kg


  void _incrementQuantity() {
    setState(() {
      _quantity++;
      widget.updateTotalPrice(widget.service.price.toInt(), true);
      widget.updateQuantity(_quantity);
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        widget.updateTotalPrice(widget.service.price.toInt(), false);
        widget.updateQuantity(_quantity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ubah satuan jika nama layanan adalah "Cuci Karpet"
  if (widget.service.name == 'Cuci Karpet') {
    unitText = '/pcs';
  }
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 200,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/products/tshirt_blue_without_collar_front.png',
                    width: 100,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        widget.service.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: _decrementQuantity,
                        ),
                        Text(
                          _quantity.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: _incrementQuantity,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 130),
                  child: Text(
                    'Rp ${widget.service.price}$unitText',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
