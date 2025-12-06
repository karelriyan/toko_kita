import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';

class ProdukDetail extends StatefulWidget {
  const ProdukDetail({Key? key, required this.produk}) : super(key: key);

  final Produk produk;

  @override
  State<ProdukDetail> createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Kode : ${widget.produk.kodeProduk ?? '-'}',
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              'Nama : ${widget.produk.namaProduk ?? '-'}',
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              'Harga : Rp. ${widget.produk.hargaProduk?.toString() ?? '-'}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16),
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          child: const Text('EDIT'),
          onPressed: _editProduk,
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          child: const Text('DELETE'),
          onPressed: _confirmHapus,
        ),
      ],
    );
  }

  Future<void> _editProduk() async {
    final result = await Navigator.push<Produk>(
      context,
      MaterialPageRoute(
        builder: (context) => ProdukForm(
          produk: widget.produk,
        ),
      ),
    );

    if (result != null) {
      Navigator.pop(context, result);
    }
  }

  void _confirmHapus() {
    final alertDialog = AlertDialog(
      content: const Text('Yakin ingin menghapus data ini?'),
      actions: [
        OutlinedButton(
          child: const Text('Ya'),
          onPressed: () {
            Navigator.of(context).pop(); // close dialog
            Navigator.pop(context, {'action': 'delete', 'id': widget.produk.id});
          },
        ),
        OutlinedButton(
          child: const Text('Batal'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );

    showDialog(context: context, builder: (context) => alertDialog);
  }
}
