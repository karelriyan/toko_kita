import 'dart:async';

import 'package:tokokita/model/produk.dart';
import 'package:tokokita/model/user.dart';

class AppStore {
  AppStore._internal() {
    _seed();
  }

  static final AppStore instance = AppStore._internal();

  final Map<String, User> _users = {};
  final List<Produk> _produkList = [];
  User? _currentUser;

  User? get currentUser => _currentUser;

  void _seed() {
    _users['demo@tokokita.com'] =
        User(name: 'Demo User', email: 'demo@tokokita.com', password: '123456');

    _produkList.addAll([
      Produk(id: '1', kodeProduk: 'A001', namaProduk: 'Kamera', hargaProduk: 5000000),
      Produk(id: '2', kodeProduk: 'A002', namaProduk: 'Kulkas', hargaProduk: 2500000),
      Produk(id: '3', kodeProduk: 'A003', namaProduk: 'Mesin Cuci', hargaProduk: 2000000),
    ]);
  }

  Future<void> register(User user) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (user.email == null || user.password == null) {
      throw Exception('Email dan password harus diisi');
    }
    if (_users.containsKey(user.email)) {
      throw Exception('Email sudah terdaftar');
    }
    _users[user.email!] = user;
  }

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final user = _users[email];
    if (user == null || user.password != password) {
      throw Exception('Email atau password salah');
    }
    _currentUser = user;
  }

  void logout() {
    _currentUser = null;
  }

  List<Produk> getProdukList() => List.unmodifiable(_produkList);

  Future<Produk> addProduk(Produk produk) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final newProduk = Produk(
      id: produk.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      kodeProduk: produk.kodeProduk,
      namaProduk: produk.namaProduk,
      hargaProduk: produk.hargaProduk,
    );
    _produkList.add(newProduk);
    return newProduk;
  }

  Future<Produk> updateProduk(Produk produk) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (produk.id == null) throw Exception('ID produk tidak ditemukan');
    final index = _produkList.indexWhere((p) => p.id == produk.id);
    if (index == -1) throw Exception('Produk tidak ditemukan');
    _produkList[index] = produk;
    return produk;
  }

  Future<void> deleteProduk(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _produkList.removeWhere((p) => p.id == id);
  }
}
