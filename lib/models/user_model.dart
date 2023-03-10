//
const tblUser = 'User',
    colUsName = 'name',
    colAddress = 'address',
    colEmaile = 'email',
    // colIsStop = 'isStop',
    ColIsAdmin = 'isAdmin';
const colUid = 'uid',
    colUrlImage = 'imageUrl',
    colAmount = 'amount',
    colTheNumber = 'theNumber',
    colIsActive = 'isActive',
    // colEmaile = 'emaile',
    colphoneNumber = 'phoneNumber';

const colCityId = 'cityId', colSexId = 'sexId';

class UserModel {
  final String theNumber;
  final String uid;
  final String profilePic;
  final String name;
  final String address;
  final String phoneNumber;
  final String emaile;

  final String cityId;
  final String sexId;
  UserModel({
    this.theNumber = '',
    required this.name,
    required this.uid,
    required this.address,
    required this.emaile,
    this.profilePic = '',
    this.phoneNumber = '',

    //
    this.sexId = ' ',
    this.cityId = ' ',
  });

  Map<String, dynamic> toMap() {
    return {
      colTheNumber: theNumber,
      colUsName: name,
      colUid: uid,
      colAddress: address,
      colUrlImage: profilePic,

      colphoneNumber: phoneNumber,
      colEmaile: emaile,

      //
      colSexId: sexId,
      colCityId: cityId,
    };
  }

  factory UserModel.fromMap(String uiId, Map<String, dynamic> map) {
    return UserModel(
      uid: uiId,

      theNumber: map[colTheNumber] ?? '',
      name: map[colUsName] ?? '',
      address: map[colAddress] ?? '',
      cityId: map[colCityId] ?? '',
      emaile: map[colEmaile] ?? '',
      phoneNumber: map[colphoneNumber] ?? '',
      // sexId: map[colSexId] ?? '',
      // profilePic: map[colUrlImage] ?? '',
    );
  }
}
