import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class HaloMinnaApi {
  // URL API production.
  static const String baseUrl = 'https://lapas-banceuy.web.id/api';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _tokenKey = 'halo_minna_token';

  // ==================== LOGIN ====================

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

  // ==================== PROFIL WBP ====================

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

  // ==================== KATALOG PROGRAM PEMBINAAN ====================

  static Future<Map<String, dynamic>> getProgramPembinaan() async {
    return _getAuthenticated('/halo-minna/program-pembinaan');
  }

  // ==================== PROGRAM YANG DIIKUTI WBP ====================

  static Future<Map<String, dynamic>> getProgramDiikuti() async {
    return _getAuthenticated('/halo-minna/program-pembinaan/diikuti');
  }

  // ==================== STATISTIK PEMBINAAN ====================

  static Future<Map<String, dynamic>> getStatistikPembinaan() async {
    return _getAuthenticated('/halo-minna/program-pembinaan/statistik');
  }

  // ==================== REQUEST TERAUTENTIKASI ====================

  static Future<Map<String, dynamic>> _getAuthenticated(String endpoint) async {
    final token = await _storage.read(key: _tokenKey);

    if (token == null || token.isEmpty) {
      throw Exception('Sesi login tidak ditemukan. Silakan login kembali.');
    }

    final response = await http
        .get(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 20));

    final body = _decodeResponse(response);

    if (response.statusCode == 200 && body['success'] == true) {
      return Map<String, dynamic>.from(body);
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      await _storage.delete(key: _tokenKey);
    }

    throw Exception(
      body['message']?.toString() ?? 'Gagal mengambil data pembinaan.',
    );
  }

  // ==================== LOGOUT ====================

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

  // ==================== STATUS TOKEN ====================

  static Future<bool> hasToken() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  // ==================== DECODE RESPONSE ====================

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
