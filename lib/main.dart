import 'package:flutter/material.dart';
import 'views/auth/login_page.dart';
import 'views/auth/register_page.dart';
import 'views/dashboard/dashboard_page.dart';
import 'views/uom/uom_list.dart';
import 'views/customer/customer_list.dart';
import 'views/customer/customer_detail.dart';
import 'views/customer/add_customer_page.dart';
import 'views/product/product_list.dart';
import 'views/product/product_detail.dart';
import 'views/product/add_product_page.dart';
// import 'views/employee/employee_list.dart';
// import 'views/bill/bill_list.dart';
import 'data/models/customer.dart';
import 'data/models/product.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Laundry Apps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => LoginPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/dashboard': (context) => DashboardPage(),
        '/uom': (context) => UomPage(),
        '/customers': (context) => CustomerListPage(),
        '/add_customer': (context) => AddCustomerPage(),
        '/products': (context) => ProductListScreen(),
        '/add_product': (context) => AddProductPage(),
        // '/employees': (context) => EmployeeListPage(),
        // '/bills': (context) => BillListPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/customer_detail') {
          final customer = settings.arguments as Customer;
          return MaterialPageRoute(
            builder: (context) => CustomerDetailPage(customer: customer),
          );
        } else if (settings.name == '/product_detail') {
          final product = settings.arguments as Product;
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          );
        }
        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text('Halaman tidak ditemukan'),
            ),
          ),
        );
      },
    );
  }
}
