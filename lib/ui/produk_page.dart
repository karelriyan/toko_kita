import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/service/app_store.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/produk_form.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({Key? key}) : super(key: key);

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  List<Produk> _produks = [];

  @override
  void initState() {
    super.initState();
    _refreshProduk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Produk'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: _tambahProduk,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _produks.length,
        itemBuilder: (context, index) {
          final produk = _produks[index];
          return ItemProduk(produk: produk, onTap: () => _bukaDetail(produk));
        },
      ),
    );
  }

  Future<void> _tambahProduk() async {
    final result = await Navigator.push<Produk>(
      context,
      MaterialPageRoute(builder: (context) => const ProdukForm()),
    );

    if (result != null) {
      await AppStore.instance.addProduk(result);
      _refreshProduk();
    }
  }

  Future<void> _bukaDetail(Produk produk) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (context) => ProdukDetail(produk: produk)),
    );

    if (result is Produk) {
      await AppStore.instance.updateProduk(result);
      _refreshProduk();
    } else if (result is Map && result['action'] == 'delete') {
      final id = result['id'];
      if (id != null) {
        await AppStore.instance.deleteProduk(id.toString());
        _refreshProduk();
      }
    }
  }

  void _refreshProduk() {
    setState(() {
      _produks = List<Produk>.from(AppStore.instance.getProdukList());
    });
  }

  void _logout() {
    AppStore.instance.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }
}

class ItemProduk extends StatelessWidget {
  const ItemProduk({Key? key, required this.produk, required this.onTap})
    : super(key: key);

  final Produk produk;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: ListTile(
          title: Text(produk.namaProduk ?? '-'),
          subtitle: Text(produk.hargaProduk?.toString() ?? '-'),
        ),
      ),
    );
  }
}
