import 'package:flutter/material.dart';
import 'package:laundry/main.dart';
import 'ServiceDetailPage.dart';
import 'outletSelect.dart';
import 'api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Outlet? selectedOutlet;
  int _selectedIndex = 1;
  String userName = name;
  
  static String get name => 'maman';

  @override
  void initState() {
    super.initState();
    fetchUserNameFromApi();
  }

  Future<void> fetchUserNameFromApi() async {
    try {
      String name = await fetchUserName();
      setState(() {
        userName = name;
      });
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      if (index == 1) {
        Navigator.pushReplacementNamed(context, '/history');
      } else if (index == 2) {
        Navigator.pushReplacementNamed(context, '/myorder');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GetStartedPage(),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/images/profile/user.png'),
            ),
          ),
        ),
        title: Text(
          userName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Logika untuk notifikasi
              },
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/banners/banner_6.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xFFF1E9E1),
                  Color(0xFFF1E9E1).withOpacity(0.0),
                ],
                stops: [0.8, 1.0],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 70),
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OutletSelectPage()),
                    );
                    if (result != null && result is Outlet) {
                      setState(() {
                        selectedOutlet = result;
                      });
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(12),
                    child: selectedOutlet == null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pilih Outlet Laundry',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Align(
                                alignment: Alignment.center,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => OutletSelectPage()),
                                    );
                                    if (result != null && result is Outlet) {
                                      setState(() {
                                        selectedOutlet = result;
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.search),
                                  label: Text('Cari Outlet Terdekat'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFF1E9E1),
                                    foregroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    selectedOutlet!.name,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 280, // Lebar maksimal teks
                                        child: Text(
                                          selectedOutlet!.location,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4), 
                                      Text(
                                        selectedOutlet!.open,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Align(
                                alignment: Alignment.center,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final phoneNumber = selectedOutlet!.phone;
                                    final urlString = 'whatsapp://send?phone=$phoneNumber';
                                    final url = Uri.parse(urlString);

                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    } else {
                                      print('Unable to launch WhatsApp');
                                    }
                                  },
                                  icon: Icon(Icons.phone),
                                  label: Text('Hubungi'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFF1E9E1),
                                    foregroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Service>>(
                    future: fetchServices(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final services = snapshot.data!;
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            final service = services[index];
                            return ServiceCard(service: service, userName: userName); // Pass userName here
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 40),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: 40),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, size: 40),
            label: 'My Order',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF986E39),
        onTap: _onItemTapped,
      ),
    );
  }
}

class ServiceCard extends StatefulWidget {
  final Service service;
  final String userName; // Add this line

  ServiceCard({required this.service, required this.userName}); // Add userName to the constructor

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailPage(
              service: widget.service,
              name: widget.userName, // Pass userName here
            ),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_laundry_service,
                size: 40,
                color: Color(0xFF986E39),
              ),
              SizedBox(height: 12),
              Text(
                widget.service.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

