class Review {
  String id;
  String name;
  int rating;
  String review;

  Review({
    this.id,
    this.name,
    this.rating,
    this.review,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["_id"],
        name: json["name"],
        rating: json["rating"] == null ? 0 : json["rating"],
        review: json["review"],
      );

  static List<Review> listFromJson(List<dynamic> json) {
    List<Review> reviews = List();
    if (json == null) return reviews;
    for (int i = 0; i < json.length; i++) {
      Review review = Review.fromJson(json[i]);
      reviews.add(review);
    }
    return reviews;
  }
}

class Address {
  String address_id;
  String address_line1;
  String address_line2;
  String pincode;
  String landmark;
  double lat;
  double lng;
  getFullAddress(){
    return address_line1+"\n"+address_line2+"\n"+landmark;
  }

  Address({
    this.address_id,
    this.address_line1,
    this.address_line2,
    this.landmark,
    this.pincode,
    this.lat,
    this.lng,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        address_id: json["address_id"],
        address_line1: json["address_line1"],
        address_line2: json["address_line2"],
        landmark: json["landmark"],
        pincode: json["pincode"],
        lat: json["lat"] == null ? 0 : json["lat"],
        lng: json["lng"] == null ? 0 : json["lng"],
      );

  static List<Address> listFromJson(List<dynamic> json) {
    List<Address> addresses = List();
    if (json == null) return addresses;
    for (int i = 0; i < json.length; i++) {
      Address address = Address.fromJson(json[i]);
      addresses.add(address);
    }
    return addresses;
  }
}

class ILocation {
  double lat;
  double lng;

  ILocation({this.lng, this.lat});

  factory ILocation.fromJson(Map<String, dynamic> json) => ILocation(
        lat: json["lat"] == null ? 0.0 : double.parse(json["lat"].toString()),
        lng: json["lng"] == null ? 0.0 : double.parse(json["lng"].toString()),
      );
}

class User {
  String date_created;
  String id;
  String name;
  String email;
  String password;
  String user_id;
  String phone_no;
  String img_url;
  String google_address;
  List<Address> address;
  List<Review> rating_review;
  ILocation location;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.user_id,
    this.phone_no,
    this.img_url,
    this.address,
    this.rating_review,
    this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        user_id: json["user_id"],
        phone_no: json["phone_no"],
        img_url: json["img_url"],
        address: json["address"] == null
            ? null
            : Address.listFromJson(json["address"]),
        location: json["location"] == null
            ? null
            : ILocation.fromJson(json["location"]),
        rating_review: json["rating_review"] == null
            ? null
            : Review.listFromJson(json["rating_review"]),
      );

  static List<User> listFromJson(List<dynamic> json) {
    List<User> users = List();
    if (json == null) return users;
    for (int i = 0; i < json.length; i++) {
      User user = User.fromJson(json[i]);
      users.add(user);
    }
    return users;
  }
}

class UserInfoResponse {
  bool success;
  List<User> user;

  UserInfoResponse({
    this.success,
    this.user,
  });

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) {
    return UserInfoResponse(
      success: json["success"] == null ? false : json["success"],
      user: json["msg"] == null ? null : User.listFromJson(json["msg"]),
    );
  }
}
