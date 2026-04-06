import 'package:flutter/material.dart';

class ExploreCourseCard extends StatelessWidget {
  final Map item;
  const ExploreCourseCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Image.asset(item['image'], height: 120, width: double.infinity, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  color: Colors.teal.withOpacity(0.7),
                  child: Text(item['title'], style: const TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${item['coursesCount']} دورة متاحة", style: const TextStyle(color: Colors.grey)),
                    const Icon(Icons.arrow_forward_ios, size: 14),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1ABC9C),
                    minimumSize: const Size(double.infinity, 40)
                  ),
                  child: const Text("+ استكشف الدورة", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}