class UserModel {
  final String id;
  final String name;
  final String email;
  final bool isPremiumUser;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double monthlyBudget;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.isPremiumUser = false,
    this.isSynced = false,
    required this.createdAt,
    required this.updatedAt,
    this.monthlyBudget = 0.0,
  });

  /// ✅ ADD THIS
  UserModel copyWith({
    String? name,
    String? email,
    bool? isPremiumUser,
    bool? isSynced,
    DateTime? updatedAt,
    double? monthlyBudget,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      isPremiumUser: isPremiumUser ?? this.isPremiumUser,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isPremiumUser: json['isPremiumUser'] ?? false,
      isSynced: json['isSynced'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      monthlyBudget: (json['monthlyBudget'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isPremiumUser': isPremiumUser,
      'isSynced': isSynced,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'monthlyBudget': monthlyBudget,
    };
  }
}