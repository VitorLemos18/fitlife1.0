import 'package:flutter/material.dart';

enum UserRole {
  aluno,
  personal,
  nutricionista,
  academia;

  String get apiValue {
    switch (this) {
      case UserRole.aluno:
        return 'ALUNO';
      case UserRole.personal:
        return 'PERSONAL';
      case UserRole.nutricionista:
        return 'NUTRICIONISTA';
      case UserRole.academia:
        return 'ACADEMIA';
    }
  }

  String get label {
    switch (this) {
      case UserRole.aluno:
        return 'Aluno';
      case UserRole.personal:
        return 'Personal';
      case UserRole.nutricionista:
        return 'Nutricionista';
      case UserRole.academia:
        return 'Academia';
    }
  }

  String get description {
    switch (this) {
      case UserRole.aluno:
        return 'Perfil focado em rotina de treino, metas, evolução física e alimentação.';
      case UserRole.personal:
        return 'Perfil voltado para acompanhamento de alunos, fichas de treino e agenda.';
      case UserRole.nutricionista:
        return 'Perfil para criação de planos alimentares, consultas e acompanhamento nutricional.';
      case UserRole.academia:
        return 'Perfil de gestão da unidade, equipe, operação e visão geral da academia.';
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.aluno:
        return Icons.fitness_center_rounded;
      case UserRole.personal:
        return Icons.sports_gymnastics_rounded;
      case UserRole.nutricionista:
        return Icons.restaurant_menu_rounded;
      case UserRole.academia:
        return Icons.apartment_rounded;
    }
  }

  static UserRole fromApi(String? value) {
    switch ((value ?? '').toUpperCase()) {
      case 'ALUNO':
        return UserRole.aluno;
      case 'PERSONAL':
        return UserRole.personal;
      case 'NUTRICIONISTA':
        return UserRole.nutricionista;
      case 'ACADEMIA':
        return UserRole.academia;
      default:
        return UserRole.aluno;
    }
  }
}

class AppUser {
  final String? id;
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final String phone;
  final String goal;
  final double weight;
  final double height;
  final DateTime? birthDate;
  final String extra1;
  final String extra2;
  final String extra3;
  final double? imc;

  const AppUser({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.phone,
    required this.goal,
    required this.weight,
    required this.height,
    this.birthDate,
    required this.extra1,
    required this.extra2,
    required this.extra3,
    this.imc,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': name,
      'email': email,
      'senha': password,
      'role': role.apiValue,
      'telefone': phone,
      'objetivo': goal,
      'peso': weight,
      'altura': height,
      'dataNascimento': birthDate != null ? _formatDateOnly(birthDate!) : null,
      'extra1': extra1,
      'extra2': extra2,
      'extra3': extra3,
      'imc': imc,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id']?.toString(),
      name: json['nome']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['senha']?.toString() ?? '',
      role: UserRole.fromApi(json['role']?.toString()),
      phone: json['telefone']?.toString() ?? '',
      goal: json['objetivo']?.toString() ?? '',
      weight: _toDouble(json['peso']),
      height: _toDouble(json['altura']),
      birthDate: _parseDate(json['dataNascimento']),
      extra1: json['extra1']?.toString() ?? '',
      extra2: json['extra2']?.toString() ?? '',
      extra3: json['extra3']?.toString() ?? '',
      imc: json['imc'] != null ? _toDouble(json['imc']) : null,
    );
  }

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    UserRole? role,
    String? phone,
    String? goal,
    double? weight,
    double? height,
    DateTime? birthDate,
    String? extra1,
    String? extra2,
    String? extra3,
    double? imc,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      goal: goal ?? this.goal,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      birthDate: birthDate ?? this.birthDate,
      extra1: extra1 ?? this.extra1,
      extra2: extra2 ?? this.extra2,
      extra3: extra3 ?? this.extra3,
      imc: imc ?? this.imc,
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().replaceAll(',', '.')) ?? 0.0;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    final raw = value.toString().trim();
    if (raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  static String _formatDateOnly(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}