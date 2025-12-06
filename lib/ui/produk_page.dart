import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/produk_form.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({Key? key}) : super(key: key);

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  final List<Produk> _produks = [
    Produk(
      id: '1',
      kodeProduk: 'A001',
      namaProduk: 'Kamera',
      hargaProduk: 5000000,
    ),
    Produk(
      id: '2',
      kodeProduk: 'A002',
      namaProduk: 'Kulkas',
      hargaProduk: 2500000,
    ),
    Produk(
      id: '3',
      kodeProduk: 'A003',
      namaProduk: 'Mesin Cuci',
      hargaProduk: 2000000,
    ),
  ];

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
              title: const Text('Logout KAREL'),
              trailing: const Icon(Icons.logout),
              onTap: () => Navigator.pop(context),
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
      setState(() {
        result.id =
            result.id ?? DateTime.now().millisecondsSinceEpoch.toString();
        _produks.add(result);
      });
    }
  }

  Future<void> _bukaDetail(Produk produk) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (context) => ProdukDetail(produk: produk)),
    );

    if (result is Produk) {
      setState(() {
        final index = _produks.indexWhere((p) => p.id == result.id);
        if (index != -1) {
          _produks[index] = result;
        }
      });
    } else if (result is Map && result['action'] == 'delete') {
      setState(() {
        _produks.removeWhere((p) => p.id == result['id']);
      });
    }
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
