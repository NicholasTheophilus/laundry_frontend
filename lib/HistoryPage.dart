import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      // Already on HistoryPage, do nothing
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/myorder');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF986E39),
        title: Text('History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildHistoryItem('Laundry', 'Rp. 38.000', '26 Des 2022', '5 Kg'),
                  _buildHistoryItem('Laundry', 'Rp. 25.000', '24 Des 2022', '2 Kg'),
                  _buildHistoryItem('Laundry', 'Rp. 32.000', '20 Des 2022', '4 Kg'),
                  _buildHistoryItem('Laundry', 'Rp. 41.000', '17 Des 2022', '6 Kg'),
                  _buildHistoryItem('Laundry', 'Rp. 38.000', '14 Des 2022', '5 Kg'),
                  _buildHistoryItem('Laundry', 'Rp. 33.000', '12 Des 2022', '4 Kg'),
                ],
              ),
            ),
          ],
        ),
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

  Widget _buildHistoryItem(String title, String price, String date, String weight) {
    return ListTile(
      leading: Icon(Icons.local_laundry_service),
      title: Text(title),
      subtitle: Text(date),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(price),
          Text(weight),
        ],
      ),
    );
  }
}
