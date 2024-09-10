import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/ProductModel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int offset = 0;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  List<ProductModel> products = [];

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    var resp = await http.get(Uri.parse("https://dummyjson.com/products?limit=10&skip=$offset"));
    var data = jsonDecode(resp.body);
    var list = (data["products"] as List).map((e) => ProductModel.fromJson(e)).toList();

    setState(() {
      products.addAll(list);
      offset = offset + 10;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!isLoading) {
          fetchData();
        }
      }
    });
    fetchData(); // Initial fetch
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("List of Products")),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: products.length + (isLoading ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index == products.length) {
            return Center(child: CircularProgressIndicator());
          }

          var product = products[index];
          bool isEven = product.id % 2 == 0; // Check if the product ID is even

          return Card(
            color: isEven ? Colors.orangeAccent.shade100 : Colors.green.shade100, // Blue for even, green for odd
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID: ${product.id}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Category: ${product.category}'),
                  SizedBox(height: 8),
                  Text('Price: \$${product.price.toStringAsFixed(2)}'),
                  SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
