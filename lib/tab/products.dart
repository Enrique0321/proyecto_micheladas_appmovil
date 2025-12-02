import 'package:flutter/material.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> products = [
      {
        'name': 'Michelada Clasica',
        'price': '\$30',
        'originalPrice': '\$35',
        'image': 'asset/michelada_clasica.png' // Placeholder
      },
      {
        'name': 'Michelada Tamarindo',
        'price': '\$30',
        'originalPrice': '\$35',
        'image': 'asset/michelada_tamarindo.png' // Placeholder
      },
      {
        'name': 'Michelada Mango',
        'price': '\$30',
        'originalPrice': '\$35',
        'image': 'asset/michelada_mango.png' // Placeholder
      },
      {
        'name': 'Preparado de Medio',
        'price': '\$70',
        'originalPrice': '\$75',
        'image': 'asset/preparado.png' // Placeholder
      },
    ];

    return Container(
      color: const Color(0xFFF2EBE0), // Light beige background
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
              child: Center(
                child: Text(
                  "Los mentados productos",
                  style: TextStyle(
                    color: Color(0xFF1A1A1A), // Dark text
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Arial', // Fallback
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65, // Adjusted for taller cards
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildProductCard(products[index]);
              }, childCount: products.length),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Image Placeholder
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    // Using Icon as placeholder for now, but styled to look like the image area
                    child: Icon(
                      Icons.local_drink,
                      size: 80,
                      color: Colors.amber.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Product Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  product['name'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF4A2010), // Dark brown
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Price Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product['price'],
                    style: const TextStyle(
                      color: Color(0xFF4A2010), // Dark brown
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    product['originalPrice'],
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      decoration: TextDecoration.lineThrough,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // View Product Button
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    "View Product",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Sale Badge
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                "Sale",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
