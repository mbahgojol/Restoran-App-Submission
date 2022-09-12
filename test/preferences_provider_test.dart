import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_submision/data/model/restaurants.dart';

var testRestaurant = {
  "id": "123123",
  "name": "Dapur Mama",
  "description":
      "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
  "pictureId": "1",
  "city": "Jakarta",
  "rating": 1
};

void main() {
  test("Test Parsing", () async {
    var result = Restaurant.fromJson(testRestaurant).id;

    expect(result, "123123");
  });
}
