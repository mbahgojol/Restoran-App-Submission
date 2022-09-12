import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restoran_submision/ui/search/search_page_provider.dart';
import 'package:restoran_submision/utils/constants.dart';

import '../../data/model/restaurants.dart';
import '../../utils/result_state.dart';
import '../detail/detail_page.dart';

class SearchPage extends StatefulWidget {
  static const routeName = "/search-restauran";

  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pencarian Restoran"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onEditingComplete: () {
                var provider =
                    Provider.of<SearchPageProvider>(context, listen: false);
                provider.fetchRestauran(editingController.text);
              },
              controller: editingController,
              decoration: const InputDecoration(
                  labelText: "Search",
                  hintText: "Masukan Nama Restoran",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(child: _buildList(context))
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<SearchPageProvider>(builder: (contex, provider, _) {
      if (provider.resultState == ResultState.Loaded) {
        return ListView.builder(
          itemCount: provider.restaurants.restaurants.length,
          itemBuilder: (context, index) {
            return _buildRestoItem(
                context, provider.restaurants.restaurants[index]);
          },
        );
      } else if (provider.resultState == ResultState.Loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.resultState == ResultState.Error) {
        return Center(
            child: Column(
          children: [
            Expanded(child: LottieBuilder.asset(serverError)),
            Expanded(child: Text(provider.message))
          ],
        ));
      } else if (provider.resultState == ResultState.Empty) {
        return LottieBuilder.asset(provider.message);
      } else if (provider.resultState == ResultState.NoConnection) {
        return LottieBuilder.asset(provider.message);
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
