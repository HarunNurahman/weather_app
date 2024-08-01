import 'package:flutter/material.dart';
import 'package:weather_app/pages/search-result_page.dart';
import 'package:weather_app/shared/styles.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          // Search Result
          //// Search result card if location is found by user
          searchResult(
            // Go to search result page
            ontap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchResultPage()),
            ),
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back, color: whiteColor),
      ),
      title: TextField(
        controller: null,
        onSubmitted: (value) {},
        style: whiteTextStyle.copyWith(fontWeight: medium),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: whiteTextStyle.copyWith(fontWeight: medium),
          border: InputBorder.none,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.close, color: whiteColor),
        ),
      ],
    );
  }

  Widget searchResult({VoidCallback? ontap}) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [blueColor6, blueColor7],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Name
            Text('Haurgeulis, Kab. Indramayu', style: whiteTextStyle),
            const SizedBox(height: 24),
            // Temperature and weather icon
            Row(
              children: [
                // Weather icon
                Image.asset('assets/icons/weathers/01d.png', width: 64),
                const SizedBox(width: 12),
                // Temperature
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '29° C',
                        style: whiteTextStyle.copyWith(fontSize: 20),
                      ),
                      Text(
                        'Partly Cloudy',
                        style: whiteTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: semibold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Highest, lowest and feels like temperature
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '30° / 20° Feels Like 31° C',
                  style: whiteTextStyle.copyWith(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
