import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../data/model/restaurants.dart';
import '../../provider/database_provider.dart';
import '../../utils/constants.dart';
import '../../utils/result_state.dart';
import '../detail/detail_page.dart';
import '../search/search_page.dart';

class FavoritePage extends StatelessWidget {
  static const String favoriteTitle = 'Favorite';

  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Restauran"),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, SearchPage.routeName);
                  },
                  child: const Icon(
                    Icons.search,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: _buildList(context));
  }

  Widget _buildList(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (contex, provider, _) {
      if (provider.state == ResultState.Loaded) {
        return ListView.builder(
          itemCount: provider.restaurans.length,
          itemBuilder: (context, index) {
            return _buildRestoItem(context, provider.restaurans[index]);
          },
        );
      } else if (provider.state == ResultState.Loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.state == ResultState.Error) {
        return Center(
            child: Column(
          children: [LottieBuilder.asset(serverError), Text(provider.message)],
        ));
      } else if (provider.state == ResultState.Empty) {
        return Center(child: LottieBuilder.asset(provider.message));
      } else if (provider.state == ResultState.NoConnection) {
        return Center(child: LottieBuilder.asset(provider.message));
      } else {
        return const Text("");
      }
    });
  }

  Widget _buildRestoItem(BuildContext context, Restaurant resto) {
    return Material(
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, DetailPage.routeName, arguments: resto);
        },
        isThreeLine: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Hero(
          tag: resto.pictureId,
          child: Image.network(
            getImageSmall(resto.pictureId),
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          resto.name,
        ),
        subtitle: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.black38,
                  ),
                  Text(
                    resto.city,
                    style: const TextStyle(color: Colors.black38),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber,
                  ),
                  Text(resto.rating.toString())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
