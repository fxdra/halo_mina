import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class HaloMinnaApi {
  // Ganti jika domain API production lu berbeda.
  static const String baseUrl = 'https://lapas-banceuy.web.id/api';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _tokenKey = 'halo_minna_token';

  static Future<Map<String, dynamic>> login(String kodeAkses) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/halo-minna/login'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'kode_akses': kodeAkses.trim().toUpperCase()}),
        )
        .timeout(const Duration(seconds: 20));

    final body = _decodeResponse(response);

    if (response.statusCode == 200 && body['success'] == true) {
      final token = body['token']?.toString();

      if (token == null || token.isEmpty) {
        throw Exception('Token login tidak ditemukan.');
      }

      await _storage.write(key: _tokenKey, value: token);

      return Map<String, dynamic>.from(body['data'] as Map);
    }

    throw Exception(
      body['message']?.toString() ?? 'Login gagal. Periksa kode akses lu.',
    );
  }

  static Future<Map<String, dynamic>> getProfil() async {
    final token = await _storage.read(key: _tokenKey);

    if (token == null || token.isEmpty) {
      throw Exception('Sesi login tidak ditemukan.');
    }

    final response = await http
        .get(
          Uri.parse('$baseUrl/halo-minna/me'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 20));

    final body = _decodeResponse(response);

    if (response.statusCode == 200 && body['success'] == true) {
      return Map<String, dynamic>.from(body['data'] as Map);
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      await _storage.delete(key: _tokenKey);
    }

    throw Exception(
      body['message']?.toString() ?? 'Gagal mengambil profil WBP.',
    );
  }

  static Future<void> logout() async {
    final token = await _storage.read(key: _tokenKey);

    try {
      if (token != null && token.isNotEmpty) {
        await http
            .post(
              Uri.parse('$baseUrl/halo-minna/logout'),
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
            )
            .timeout(const Duration(seconds: 15));
      }
    } finally {
      await _storage.delete(key: _tokenKey);
    }
  }

  static Future<bool> hasToken() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  static Map<String, dynamic> _decodeResponse(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } on FormatException {
      // Respons server bukan JSON yang valid.
    }

    throw Exception(
      'Respons server tidak valid '
      '(HTTP ${response.statusCode}).',
    );
  }
}
