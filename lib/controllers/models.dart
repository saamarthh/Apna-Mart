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
      'image': image,
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
class UserModal {
  String uid;
  String name;
  String address1;
  String address2;
  String address3;
  String phoneNumber;

  UserModal(
      {required this.name,
      required this.address1,
      required this.address2,
      required this.address3,
      required this.phoneNumber,
      required this.uid});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'address1': address1,
      'address2': address2,
      'address3': address3,
      'phoneNumber': phoneNumber
    };
  }

  factory UserModal.fromMap(Map<String, dynamic> map) {
    return UserModal(
        uid: map['uid'],
        name: map['name'],
        address1: map['address1'],
        address2: map['address2'],
        address3: map['address3'],
        phoneNumber: map['phoneNumber']);
  }
}

class Orders {
  String productName;
  String customerName;
  int quantity;
  double totalCost;
  String address;
  String phoneNumber;
  int productCost;
  String orderId;
  String date;

  Orders(
      {required this.productName,
      required this.customerName,
      required this.quantity,
      required this.productCost,
      required this.totalCost,
      required this.phoneNumber,
      required this.address,
      required this.orderId,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'customerName': customerName,
      'productCost': productCost,
      'quantity': quantity,
      'totalCost': totalCost,
      'phoneNumber': phoneNumber,
      'address': address,
      'orderId': orderId,
      'date': date,
    };
  }

  factory Orders.fromMap(Map<String, dynamic> map) {
    return Orders(
        productName: map['productName'],
        customerName: map['customerName'],
        quantity: map['quantity'],
        totalCost: map['totalCost'],
        address: map['address'],
        phoneNumber: map['phoneNumber'],
        productCost: map['productCost'],
        orderId: map['orderId'],
        date: map['date']);
  }
}
