class User {
  final String id; // Changed to String
  final String name; // Changed from username to name
  final String email;
  final String role;
  final String? token; // Token can be optional here, usually managed by AuthService

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['username'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': name,
        'email': email,
        'role': role,
      };

  // Factory constructor to create a User from a map (e.g., JSON from API)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: (map['_id'] ?? map['id'])?.toString() ?? '', // Ensure ID is a string
      name: map['name'] ?? map['username'] ?? '', // Prefer name, fallback to username
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
      token: map['token'],
    );
  }

  // Method to convert User instance to a map (e.g., for storing in SharedPreferences or sending to API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      // Token is usually not sent back in toMap for updates, but depends on API
      // 'token': token,
    };
  }
}
