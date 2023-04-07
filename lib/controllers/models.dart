//GroceryItem Model

class Product {
  String id;
  String image;
  String name;
  int quantity;
  int price;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'image': image
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        id: map['id'],
        name: map['name'],
        image: map['image'],
        quantity: map['quantity'],
        price: map['price']);
  }
}

//User Model
class User {
  String uid;
  String name;
  String address;
  String phoneNumber;

  User(
      {required this.name,
      required this.address,
      required this.phoneNumber,
      required this.uid});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      name: map['name'],
      address: map['address'],
      phoneNumber: map['phoneNumber']
    );
  }
}
