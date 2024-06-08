import 'package:money_manage/data/userInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Lớp quản lý local store
class LocalStorageManager {
  //Function lưu thông tin người dùng
  static Future<void> saveUserInfo(UserInfo userInfo) async {
    //Đợi lấy dữ liệu
    final prefs = await SharedPreferences.getInstance();

    // Chỉ cập nhật thông tin dòng tiền và bắt lỗi null
    //Chỉ cập nhật thông tin dòng tiền vì nếu cập nhật cả giao dịch thì
    //giao dịch được lưu mới sẽ ghi đè lên giao dịch cũ
    await prefs.setString('inflow', userInfo.inflow ?? '');
    await prefs.setString('outflow', userInfo.outflow ?? '');

    // Tính lại tổng tiền
    int inflowValue = int.parse(userInfo.inflow ?? '0');
    int outflowValue = int.parse(userInfo.outflow ?? '0');
    int totalBalance = inflowValue - outflowValue;
    await prefs.setString('totalBalance', totalBalance.toString());

    // Thông báo thay đổi
    userInfo.notifyListeners();
  }

  //Funtion lưu giao dịch
  static Future<void> saveTransaction(Transaction transaction) async {
    final prefs = await SharedPreferences.getInstance();
    //Lưu sô giao dịch và bắt lỗi không phải int, không có số mặc định là 0
    final int transactionCount = prefs.getInt('transactionCount') ?? 0;
    final int index = transactionCount; // Use the next available index

    //Lưu các trường dữ liệu với index và bắt lỗi null
    await prefs.setString(
        'transactionType$index', transaction.transactionType ?? '');
    await prefs.setString(
        'itemCategoryType$index', transaction.itemCategoryType ?? '');
    await prefs.setString('itemName$index', transaction.itemName ?? '');
    await prefs.setString('amount$index', transaction.amount ?? '');
    await prefs.setString('date$index', transaction.date ?? '');

    // Cập nhật bộ đếm + 1
    await prefs.setInt('transactionCount', transactionCount + 1);
  }
  //Funtion load thông tin
  static Future<UserInfo?> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    //Lấy tên và kiểm tra có khác null không
    String? name = prefs.getString('name');
    if (name != null) {
      //Khác null thì lấy các dữ liệu khác
      String? gender = prefs.getString('gender');
      String? birthday = prefs.getString('birthday');

      int inflowTotal = 0;
      int outflowTotal = 0;
      //Lấy số từ bộ đém đã lưu
      int? transactionCount = prefs.getInt('transactionCount');
      //Tạo danh sách rỗng
      List<Transaction> transactions = [];
      //Nếu bộ đếm không null
      if (transactionCount != null) {
        for (int i = 0; i < transactionCount; i++) {
          //Gọi funtion load dữ liệu 
          Transaction? transaction = await loadTransaction(index: i);
          //Kiểm tra dữ liệu null không
          if (transaction != null) {
            //Nếu không null
            //Thêm vào danh sách
            transactions.add(transaction);
            //Tính tổng các dòng tiền
            if (transaction.transactionType == 'Thu') {
              inflowTotal += int.parse(transaction.amount ?? '0');
            } else if (transaction.transactionType == 'Chi') {
              outflowTotal += int.parse(transaction.amount ?? '0');
            }
          }
        }
      }
      //Tính tổng tiền
      int totalBalance = inflowTotal - outflowTotal;
      //Tạo biến userInfo để lưu
      UserInfo userInfo = UserInfo(
        name: name,
        gender: gender,
        birthday: birthday,
        totalBalance: totalBalance.toString(), // Convert to string
        inflow: inflowTotal.toString(), // Convert to string
        outflow: outflowTotal.toString(), // Convert to string
        transactions: transactions,
      );
      //Thông báo thay đổi
      userInfo.notifyListeners();
      return userInfo;
    }
    //Nếu tên null trả về null
    return null;
  }
  //Funtion load dữ liệu giaao dịch
  static Future<Transaction?> loadTransaction({required int index}) async {
    final prefs = await SharedPreferences.getInstance();
    //Lấy dữ liệu
    String? transactionType = prefs.getString('transactionType$index');
    String? itemCategoryType = prefs.getString('itemCategoryType$index');
    String? itemName = prefs.getString('itemName$index');
    String? amount = prefs.getString('amount$index');
    String? date = prefs.getString('date$index');
    //Kiểm tra dữ liệu null không
    if (transactionType != null &&
        itemCategoryType != null &&
        itemName != null &&
        amount != null &&
        date != null) {
          //Trả về lớp với dữ liệu vừa lấy
      return Transaction(
        transactionType: transactionType,
        itemCategoryType: itemCategoryType,
        itemName: itemName,
        amount: amount,
        date: date,
      );
    }
    return null;
  }
}
