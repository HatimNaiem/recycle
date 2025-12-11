import 'package:flutter/material.dart';

class Listing {
  final String id;
  final String title;
  final String category;
  final double price;
  final String imageUrl;
  final String condition;

  Listing({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.condition,
  });
}

final List<Listing> sampleListings = List.generate(
  6,
      (i) => Listing(
    id: 'l$i',
    title: 'Product $i',
    category: i % 2 == 0 ? 'Electronics' : 'Fashion',
    price: 20.0 + i * 15,
    imageUrl: 'https://picsum.photos/seed/$i/400/300',
    condition: i % 3 == 0 ? 'Excellent' : (i % 3 == 1 ? 'Good' : 'Fair'),
  ),
);


class SellerHome extends StatelessWidget {
  const SellerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SellerTopCard(),
            const SizedBox(height: 16),
            const _QuickStatsRow(),
            const SizedBox(height: 18),
            const Text('Your Listings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _SellerListingsGrid(listings: sampleListings),
            const SizedBox(height: 24),
            const Text('Recent Conversations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const _RecentChatsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to add listing screen
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Listing'),
      ),
      bottomNavigationBar: const _SellerBottomNav(),
    );
  }
}


class _SellerTopCard extends StatelessWidget {
  const _SellerTopCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 32,
              backgroundImage: NetworkImage('https://picsum.photos/seed/avatar/200'),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Hi, Alex', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('Total sales: 24  •  Rating: 4.7'),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Open analytics page
              },
              icon: const Icon(Icons.analytics_outlined),
              label: const Text('Analytics'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _StatCard(title: 'Listed', value: '12')),
        SizedBox(width: 12),
        Expanded(child: _StatCard(title: 'Sold', value: '24')),
        SizedBox(width: 12),
        Expanded(child: _StatCard(title: 'Views', value: '3.2k')),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  const _StatCard({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _SellerListingsGrid extends StatelessWidget {
  final List<Listing> listings;
  const _SellerListingsGrid({required this.listings, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: listings.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final item = listings[index];
        return GestureDetector(
          onTap: () {
            // TODO: navigate to item details / edit listing
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // image
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  child: Image.network(item.imageUrl, height: 110, width: double.infinity, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 110,
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image, size: 36, color: Colors.grey),
                        );
                      }),
                ),
                // details
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(item.category, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Chip(label: Text(item.condition, style: const TextStyle(fontSize: 12))),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RecentChatsList extends StatelessWidget {
  const _RecentChatsList({super.key});

  @override
  Widget build(BuildContext context) {
    // mock chats
    final chats = List.generate(3, (i) => {'name': 'Buyer $i', 'msg': 'Is this still available?'});
    return Column(
      children: chats
          .map((c) => ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(c['name']!),
        subtitle: Text(c['msg']!),
        trailing: IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {
          // TODO: open chat thread
        }),
      ))
          .toList(),
    );
  }
}

class _SellerBottomNav extends StatelessWidget {
  const _SellerBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(icon: const Icon(Icons.home_filled), onPressed: () {}),
            IconButton(icon: const Icon(Icons.chat_bubble_outline), onPressed: () {}),
            const SizedBox(width: 40), // space for FAB notch
            IconButton(icon: const Icon(Icons.local_offer_outlined), onPressed: () {}),
            IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
