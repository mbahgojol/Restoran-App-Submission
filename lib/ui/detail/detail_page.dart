import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restoran_submision/data/model/restaurants.dart';
import 'package:restoran_submision/provider/database_provider.dart';
import 'package:restoran_submision/utils/constants.dart';

import '../../utils/styles.dart';

class DetailPage extends StatelessWidget {
  static const routeName = "/restauran_detail";

  final Restaurant restaurants;

  const DetailPage({Key? key, required this.restaurants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      floatingActionButton: Consumer<DatabaseProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<bool>(
            future: provider.isFavorite(restaurants.id),
            builder: (context, snapshot) {
              var isFavorite = snapshot.data ?? false;
              return FloatingActionButton(
                onPressed: () {
                  if (isFavorite) {
                    provider.removeFavorite(restaurants.id);
                  } else {
                    provider.addFavorite(restaurants);
                  }
                },
                backgroundColor: primaryColor,
                child: isFavorite
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.pink,
                      )
                    : const Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
              );
            },
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
                tag: restaurants.pictureId,
                child: Image.network(getImageLarge(restaurants.pictureId),
                    errorBuilder: (context, _, __) {
                  return Lottie.asset(animNoInternet);
                })),
            Container(
              margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurants.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.black38,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(restaurants.city)
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(restaurants.rating.toDouble().toString())
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(restaurants.description)
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
