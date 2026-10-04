// lib/screens/diet/diet_screen.dart
import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Plans'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryDark,
          unselectedLabelColor: AppColors.textLight,
          indicatorColor: AppColors.primaryDark,
          tabs: const [
            Tab(text: 'Meal Plan'),
            Tab(text: 'Foods to Eat'),
            Tab(text: 'Foods to Avoid'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMealPlan(),
          _buildFoodsToEat(),
          _buildFoodsToAvoid(),
        ],
      ),
    );
  }

  Widget _buildMealPlan() {
    final meals = [
      {
        'time': 'Early Morning (6-7 AM)',
        'icon': '🌅',
        'image':
            'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400',
        'items': [
          'Warm water with lemon and chia seeds',
          '1 tsp cinnamon in warm water',
          'Handful of soaked almonds (5-6)',
        ],
        'tip': 'Cinnamon helps regulate blood sugar levels.',
      },
      {
        'time': 'Breakfast (8-9 AM)',
        'icon': '🍳',
        'image':
            'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400',
        'items': [
          'Option A: Oats with berries and almond milk',
          'Option B: Moong dal cheela with mint chutney',
          'Option C: Quinoa upma with vegetables',
          'Option D: 2 boiled eggs + whole wheat toast',
        ],
        'tip': 'High-protein breakfast prevents blood sugar spikes.',
      },
      {
        'time': 'Mid-Morning Snack (11 AM)',
        'icon': '🍎',
        'image':
            'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400',
        'items': [
          'A small bowl of mixed fruits (low-GI)',
          'Or: Greek yogurt with honey',
          'Or: Handful of mixed seeds',
        ],
        'tip': 'Choose snacks with fiber to stay full longer.',
      },
      {
        'time': 'Lunch (1-2 PM)',
        'icon': '🥗',
        'image':
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
        'items': [
          '1 cup brown rice or 2 rotis (whole wheat)',
          'Dal or legume curry',
          'Sabzi with lots of vegetables',
          'Large salad with olive oil dressing',
        ],
        'tip': 'Make lunch your largest meal of the day.',
      },
      {
        'time': 'Evening Snack (4-5 PM)',
        'icon': '🥜',
        'image':
            'https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=400',
        'items': [
          'Green tea + small handful of walnuts',
          'Or: Sprouts chaat with lemon',
          'Or: Roasted makhana (fox nuts)',
        ],
        'tip': 'Never skip your evening snack.',
      },
      {
        'time': 'Dinner (7-8 PM)',
        'icon': '🍲',
        'image':
            'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400',
        'items': [
          'Light protein: grilled fish/chicken or tofu',
          'Large portion of vegetables',
          'Small portion of complex carbs',
          'Avoid rice and heavy rotis at night',
        ],
        'tip': 'Finish dinner at least 2 hours before sleeping.',
      },
      {
        'time': 'Bedtime (10 PM)',
        'icon': '🌙',
        'image':
            'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400',
        'items': [
          'Golden milk: warm turmeric milk',
          'Or: Chamomile tea',
          'Or: Ashwagandha in warm milk',
        ],
        'tip': 'Turmeric reduces inflammation.',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: meals.length + 1,
      itemBuilder: (ctx, i) {
        if (i == 0) {
          return Column(
            children: [
              _buildDietBanner(),
              const SizedBox(height: 16),
            ],
          );
        }
        return _buildMealCard(meals[i - 1]);
      },
    );
  }

  Widget _buildDietBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800',
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (ctx, _, __) => Container(
              height: 180,
              color: AppColors.primaryLight,
              child: const Center(
                  child: Text('🥗', style: TextStyle(fontSize: 64))),
            ),
          ),
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PCOS-Friendly Diet 🥑',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Anti-inflammatory, low-GI meal plan',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9), fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              meal['image'] as String,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (ctx, _, __) => Container(
                height: 150,
                color: AppColors.primaryLight,
                child: Center(
                    child: Text(meal['icon'] as String,
                        style: const TextStyle(fontSize: 48))),
              ),
              loadingBuilder: (ctx, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 150,
                  color: AppColors.primaryLight,
                  child: const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(meal['icon'] as String,
                        style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Text(meal['time'] as String,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark)),
                  ],
                ),
                const SizedBox(height: 10),
                ...(meal['items'] as List<String>).map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold)),
                          Expanded(
                              child: Text(item,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textDark))),
                        ],
                      ),
                    )),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const Text('💡 ', style: TextStyle(fontSize: 16)),
                      Expanded(
                          child: Text(meal['tip'] as String,
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF856404)))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodsToEat() {
    final categories = [
      {
        'cat': '🥦 Vegetables',
        'image':
            'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400',
        'items': [
          'Spinach, kale, broccoli',
          'Cauliflower, cabbage',
          'Bell peppers, tomatoes',
          'Cucumber, zucchini',
          'Sweet potatoes',
          'Onions, garlic'
        ],
        'color': const Color(0xFFE8F5E9),
      },
      {
        'cat': '🍎 Fruits (Low-GI)',
        'image':
            'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=400',
        'items': [
          'Berries (blueberry, strawberry)',
          'Papaya, kiwi',
          'Pear, apple, plum',
          'Pomegranate',
          'Avocado',
          'Guava'
        ],
        'color': const Color(0xFFFCE4EC),
      },
      {
        'cat': '🌾 Grains & Carbs',
        'image':
            'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400',
        'items': [
          'Brown rice, quinoa',
          'Whole wheat roti',
          'Oats, millets',
          'Barley',
          'Sweet potato'
        ],
        'color': const Color(0xFFFFF3E0),
      },
      {
        'cat': '🥩 Proteins',
        'image':
            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
        'items': [
          'Lentils, dal',
          'Chickpeas, kidney beans',
          'Lean chicken, fish',
          'Eggs',
          'Tofu, paneer, Greek yogurt'
        ],
        'color': const Color(0xFFE3F2FD),
      },
      {
        'cat': '🫙 Healthy Fats',
        'image':
            'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',
        'items': [
          'Olive oil, coconut oil',
          'Avocado',
          'Walnuts, almonds, flaxseeds',
          'Chia seeds',
          'Fatty fish (omega-3)'
        ],
        'color': const Color(0xFFF3E5F5),
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: categories
          .map((c) => _buildFoodCard(
                c['cat'] as String,
                c['image'] as String,
                c['items'] as List<String>,
                c['color'] as Color,
                true,
              ))
          .toList(),
    );
  }

  Widget _buildFoodsToAvoid() {
    final avoidFoods = [
      {
        'cat': '🍬 High Sugar Foods',
        'image':
            'https://images.unsplash.com/photo-1581798459219-318e76aecc7b?w=400',
        'items': [
          'White sugar, jaggery in excess',
          'Candy, chocolates, sweets',
          'Sugary drinks',
          'Ice cream, pastries'
        ],
        'reason': 'Spike blood sugar and insulin levels',
        'color': const Color(0xFFFFEBEE),
      },
      {
        'cat': '🍞 Refined Carbs',
        'image':
            'https://images.unsplash.com/photo-1549931319-a545dcf3bc7b?w=400',
        'items': [
          'White bread, white rice',
          'Maida-based products',
          'Pasta, pizza bases',
          'Cornflakes, puffed rice'
        ],
        'reason': 'Cause rapid blood sugar fluctuations',
        'color': const Color(0xFFFFF3E0),
      },
      {
        'cat': '🍟 Processed/Junk Foods',
        'image':
            'https://images.unsplash.com/photo-1561758033-d89a9ad46330?w=400',
        'items': [
          'Chips, namkeen, fried snacks',
          'Fast food (burgers, fries)',
          'Packaged processed foods',
          'Instant noodles'
        ],
        'reason': 'Contain trans fats that increase inflammation',
        'color': const Color(0xFFFCE4EC),
      },
      {
        'cat': '🫖 Certain Beverages',
        'image':
            'https://images.unsplash.com/photo-1527960471264-932f39eb5846?w=400',
        'items': [
          'Alcohol',
          'Caffeine in excess',
          'Carbonated drinks',
          'Packed fruit juices'
        ],
        'reason': 'Interfere with hormone regulation',
        'color': const Color(0xFFF3E5F5),
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: avoidFoods
          .map((c) => _buildFoodCard(
                c['cat'] as String,
                c['image'] as String,
                c['items'] as List<String>,
                c['color'] as Color,
                false,
                reason: c['reason'] as String,
              ))
          .toList(),
    );
  }

  Widget _buildFoodCard(String category, String imageUrl, List<String> items,
      Color color, bool isGood,
      {String? reason}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              imageUrl,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (ctx, _, __) => Container(
                height: 130,
                color: color,
                child: Center(
                    child: Text(category.split(' ').first,
                        style: const TextStyle(fontSize: 48))),
              ),
              loadingBuilder: (ctx, child, progress) {
                if (progress == null) return child;
                return Container(
                    height: 130,
                    color: color,
                    child: const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary)));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Icon(
                              isGood
                                  ? Icons.check_circle_outline
                                  : Icons.cancel_outlined,
                              size: 14,
                              color:
                                  isGood ? AppColors.success : AppColors.error),
                          const SizedBox(width: 6),
                          Expanded(
                              child: Text(item,
                                  style: const TextStyle(fontSize: 13))),
                        ],
                      ),
                    )),
                if (reason != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Text('⚠️ ', style: TextStyle(fontSize: 14)),
                        Expanded(
                            child: Text('Why avoid: $reason',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMedium))),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
