class EmployeeListModel {
  int? id;
  String? name;
  String? username;
  String? email;
  String? profileImage;
  Address? address;
  String? phone;
  String? website;
  Company? company;

  EmployeeListModel({
    this.id,
    this.name,
    this.username,
    this.email,
    this.profileImage,
    this.website,
    this.company,
    this.address,
    this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'profile_image': profileImage,
      'address': address,
      'phone': phone,
      'website': website,
      'company': company
    };
  }
  Map<String, dynamic> toMap2() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'profile_image': profileImage,
      // 'address': address,
      'phone': phone,
      'website': website,
      // 'company': company
    };
  }

  EmployeeListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? "";
    username = json['username'] ?? "";
    email = json['email'] ?? "";
    profileImage = json['profile_image'] ?? "";
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    phone = json['phone'] ?? "";
    website = json['website'] ?? "";
    company =
        json['company'] != null ? Company.fromJson(json['company']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['profile_image'] = this.profileImage;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['phone'] = this.phone;
    data['website'] = this.website;
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    return data;
  }
}

class Address {
  int ?employee_id;
  String? street;
  String? suite;
  String? city;
  String? zipcode;

  Address({
    this.employee_id,
    this.street,
    this.suite,
    this.city,
    this.zipcode,
  });

  Map<String, dynamic> toMap() {
    return {
      'employee_id':employee_id,
      'street': street,
      'suite': suite,
      'city': city,
      'zipcode': zipcode,
    };
  }

  Address.fromJson(Map<String, dynamic> json) {
    employee_id = json['employee_id'] ?? 0;
    street = json['street'] ?? "";
    suite = json['suite'] ?? "";
    city = json['city'] ?? "";
    zipcode = json['zipcode'] ?? "";
    // geo = json['geo'] != null ? new Geo.fromJson(json['geo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_id']= this.employee_id;
    data['street'] = this.street;
    data['suite'] = this.suite;
    data['city'] = this.city;
    data['zipcode'] = this.zipcode;
    // if (this.geo != null) {
    //   data['geo'] = this.geo!.toJson();
    // }
    return data;
  }
}

class Geo {
  String? lat;
  String? lng;

  Geo({this.lat, this.lng});

  Geo.fromJson(Map<String, dynamic> json) {
    lat = json['lat'] ?? "";
    lng = json['lng'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Company {
  int ?employee_id;
  String? cname;
  String? catchPhrase;
  String? bs;

  Company({this.employee_id,this.cname, this.catchPhrase, this.bs});

  Map<String, dynamic> toMap() {
    return {
      'employee_id':employee_id,
      'name': cname ?? "",
      'catchPhrase': catchPhrase ?? "",
      'bs': bs ?? "",
    };
  }

  Company.fromJson(Map<String, dynamic> json) {
    employee_id = json['employee_id'] ?? 0;
    cname = json['name'] ?? "";
    catchPhrase = json['catchPhrase'] ?? "";
    bs = json['bs'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_id'] =this.employee_id;
    data['name'] = this.cname;
    data['catchPhrase'] = this.catchPhrase;
    data['bs'] = this.bs;
    return data;
  }
}
