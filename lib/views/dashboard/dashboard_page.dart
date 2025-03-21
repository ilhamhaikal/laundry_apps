import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: GridView.count(
        padding: EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildMenuCard(
            context,
            'Customers',
            Icons.people,
            () => Navigator.pushNamed(context, '/customers'),
          ),
          _buildMenuCard(
            context,
            'Products',
            Icons.shopping_basket,
            () => Navigator.pushNamed(context, '/products'),
          ),
          _buildMenuCard(
            context,
            'Employees',
            Icons.badge,
            () => Navigator.pushNamed(context, '/employees'),
          ),
          _buildMenuCard(
            context,
            'Bills',
            Icons.receipt_long,
            () => Navigator.pushNamed(context, '/bills'),
          ),
          _buildMenuCard(
            context,
            'UOM',
            Icons.scale,
            () => Navigator.pushNamed(context, '/uom'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
