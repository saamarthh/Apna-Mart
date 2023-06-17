//GroceryItem Model

class Product {
  String id;
  String image;
  String name;
  int quantity;
  int price;
  String category;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'image': image,
      'category': category,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        id: map['id'],
        name: map['name'],
        image: map['image'],
        quantity: map['quantity'],
        price: map['price'],
        category: map['category']);
  }
}

//User Model
class UserModal {
  String uid;
  String name;
  String address1;
  String address2;
  String phoneNumber;
  String pinCode;

  UserModal(
      {required this.name,
      required this.address1,
      required this.address2,
      required this.phoneNumber,
      required this.uid,
      required this.pinCode});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'address1': address1,
      'address2': address2,
      'phoneNumber': phoneNumber,
      'pinCode': pinCode
    };
  }

  factory UserModal.fromMap(Map<String, dynamic> map) {
    return UserModal(
        uid: map['uid'],
        name: map['name'],
        address1: map['address1'],
        address2: map['address2'],
        phoneNumber: map['phoneNumber'],
        pinCode: map['pinCode']);
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
  String dateTime;

  Orders(
      {required this.productName,
      required this.customerName,
      required this.quantity,
      required this.productCost,
      required this.totalCost,
      required this.phoneNumber,
      required this.address,
      required this.orderId,
      required this.dateTime});

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
      'date': dateTime,
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
        dateTime: map['date']);
  }
}

class Category {
  String categoryName;
  String categoryImage;

  Category({required this.categoryName, required this.categoryImage});

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'categoryImage': categoryImage,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
        categoryImage: map['categoryImage'], categoryName: map['categoryName']);
  }
}
