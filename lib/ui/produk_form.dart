import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';

class ProdukForm extends StatefulWidget {
  const ProdukForm({Key? key, this.produk}) : super(key: key);

  final Produk? produk;

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String judul = 'TAMBAH PRODUK';
  String tombolSubmit = 'SIMPAN';

  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setUpdateState();
  }

  @override
  void dispose() {
    _kodeProdukTextboxController.dispose();
    _namaProdukTextboxController.dispose();
    _hargaProdukTextboxController.dispose();
    super.dispose();
  }

  void _setUpdateState() {
    if (widget.produk != null) {
      judul = 'UBAH PRODUK';
      tombolSubmit = 'UBAH';
      _kodeProdukTextboxController.text = widget.produk!.kodeProduk ?? '';
      _namaProdukTextboxController.text = widget.produk!.namaProduk ?? '';
      _hargaProdukTextboxController.text =
          widget.produk!.hargaProduk?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _kodeProdukTextField(),
                _namaProdukTextField(),
                _hargaProdukTextField(),
                const SizedBox(height: 20),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _kodeProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Kode Produk'),
      keyboardType: TextInputType.text,
      controller: _kodeProdukTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Kode Produk harus diisi';
        }
        return null;
      },
    );
  }

  Widget _namaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Nama Produk'),
      keyboardType: TextInputType.text,
      controller: _namaProdukTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama Produk harus diisi';
        }
        return null;
      },
    );
  }

  Widget _hargaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Harga'),
      keyboardType: TextInputType.number,
      controller: _hargaProdukTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Harga harus diisi';
        }
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
      onPressed: _isLoading ? null : _handleSubmit,
      child: _isLoading
          ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(tombolSubmit),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final produk = Produk(
        id: widget.produk?.id,
        kodeProduk: _kodeProdukTextboxController.text,
        namaProduk: _namaProdukTextboxController.text,
        hargaProduk:
            num.tryParse(_hargaProdukTextboxController.text) ?? _hargaProdukTextboxController.text,
      );

      Navigator.pop(context, produk);
    }
  }
}
