import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_micheladas_appmovil/services/cart_service.dart';
import 'package:proyecto_micheladas_appmovil/services/api_services.dart';

class MenuTab extends StatefulWidget {
  const MenuTab({super.key});

  @override
  State<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  List<dynamic> products = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final fetchedProducts = await ApiService.getProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF121212), // Dark background
      child: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        "Error al cargar productos",
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.white54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchProducts,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber),
                        child: const Text("Reintentar",
                            style: TextStyle(color: Colors.black)),
                      )
                    ],
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.0),
                        child: Text(
                          "Menu de Super Mentadas Micheladas",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = products[index];
                            return _buildMenuItem(
                              context: context,
                              productId: product['id'].toString(), // Pass ID
                              title: product['name'] ?? 'Producto',
                              description:
                                  product['description'] ?? 'Sin descripción',
                              price: "\$${product['price']}",
                              originalPrice: "", 
                              imageAsset: (product['image'] != null && product['image'].toString().isNotEmpty)
                                  ? "images/${product['image']}"
                                  : "",
                            ); 
                                  
                          
                          },
                          childCount: products.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String productId, // Add productId
    required String title,
    required String description,
    required String price,
    required String originalPrice,
    required String imageAsset,
    bool isMultiPrice = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: imageAsset.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          imageAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image,
                                color: Colors.white);
                          },
                        ),
                      )
                    : const Icon(Icons.local_drink, color: Colors.white),
              ),
              const SizedBox(width: 8),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Price and Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (originalPrice.isNotEmpty)
                    Text(
                      originalPrice,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // Parse price (remove $ and take first if multi)
                  double parsedPrice = 0.0;
                  try {
                    String priceStr = price.replaceAll('\$', '').trim();
                    if (isMultiPrice) {
                       final match = RegExp(r'\d+').firstMatch(priceStr);
                       if (match != null) {
                         parsedPrice = double.parse(match.group(0)!);
                       }
                    } else {
                      parsedPrice = double.parse(priceStr);
                    }
                  } catch (e) {
                    print("Error parsing price: $e");
                  }

                  Provider.of<CartService>(context, listen: false).addItem(
                    productId, // Use actual product ID
                    title,
                    parsedPrice,
                    imageAsset,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$title agregado al carrito'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B6B), // Salmon color
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  minimumSize: const Size(0, 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  "Agregar al\ncarrito",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
