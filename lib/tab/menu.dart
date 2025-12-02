import 'package:flutter/material.dart';

class MenuTab extends StatelessWidget {
  const MenuTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF121212), // Dark background
      child: CustomScrollView(
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
              delegate: SliverChildListDelegate([
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column: Micheladas
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16.0, left: 8.0),
                            child: Text(
                              "Micheladas",
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            title: "Michelada Clasica",
                            description:
                                "Producto: Sabor original y artesanal con retoque picosito",
                            price: "\$30",
                            originalPrice: "\$35",
                            imageAsset: "asset/michelada_clasica.png",
                          ),
                          _buildMenuItem(
                            title: "Michelada Tamarindo",
                            description:
                                "Producto: Sabor original y artesanal con sabor a Tamarindo",
                            price: "\$30",
                            originalPrice: "\$35",
                            imageAsset: "asset/michelada_tamarindo.png",
                          ),
                          _buildMenuItem(
                            title: "Michelada Mango",
                            description:
                                "Producto: Sabor original y artesanal con sabor a mango",
                            price: "\$30",
                            originalPrice: "\$35",
                            imageAsset: "asset/michelada_mango.png",
                          ),
                          _buildMenuItem(
                            title: "Michelada habanero",
                            description:
                                "Producto: Sabor original y artesanal sabor a chile a habanero",
                            price: "\$30",
                            originalPrice: "\$35",
                            imageAsset: "asset/michelada_habanero.png",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Right Column: Fuera de contexto
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16.0, left: 8.0),
                            child: Text(
                              "Fuera de contexto",
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            title: "Daiquirys",
                            description:
                                "Producto: Coctel sin alcohol de sabor mango",
                            price: "\$40",
                            originalPrice: "\$50",
                            imageAsset: "asset/daiquiri.png",
                          ),
                          _buildMenuItem(
                            title: "Piña coladas",
                            description:
                                "Producto: Coctel sin alcohol de sabor piña con trozos de coco",
                            price: "\$40",
                            originalPrice: "\$50",
                            imageAsset: "asset/pina_colada.png",
                          ),
                          _buildMenuItem(
                            title: "Azulitos",
                            description:
                                "Producto: Preparado con refresco con energizante al gusto",
                            price: "\$40",
                            originalPrice: "\$50",
                            imageAsset: "asset/azulito.png",
                          ),
                          _buildMenuItem(
                            title: "Medios y Litros",
                            description:
                                "Producto: Concentrado de michelada con complementos",
                            price: "Medio \$75\nLitro \$130",
                            originalPrice: "",
                            imageAsset: "asset/medios_litros.png",
                            isMultiPrice: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
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
                child: const Icon(Icons.local_drink, color: Colors.white),
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
                onPressed: () {},
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
