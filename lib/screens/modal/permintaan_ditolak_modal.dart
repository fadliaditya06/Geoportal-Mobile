import 'package:flutter/material.dart';

Future<void> showPenolakanDialogDinamis({
  required BuildContext context,
  required String jenisPermintaan, // 'tambah' atau 'hapus'
  required Function(List<String> alasan) onConfirm,
}) async {
  final bool isHapus = jenisPermintaan.toLowerCase() == 'hapus';

  final List<String> alasanList = isHapus
      ? ['Data masih valid', 'Alasan tidak jelas', 'Alasan lainnya']
      : ['Data tidak lengkap', 'Tidak relevan', 'Alasan lainnya'];

  final Map<String, bool> selected = {
    for (var alasan in alasanList) alasan: false,
  };
  final TextEditingController alasanLainController = TextEditingController();
  bool showAlasanError = false;

  await showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Silahkan Berikan Alasan Penolakan ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: isHapus ? 'Hapus Data' : 'Tambah Data',
                style: const TextStyle(
                  color: Color(0xFF358666),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...alasanList.map((alasan) {
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: const Color(0xFF358666),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(alasan),
                  value: selected[alasan],
                  onChanged: (bool? value) {
                    setState(() {
                      selected[alasan] = value ?? false;
                      if (alasan == 'Alasan lainnya') {
                        showAlasanError = false;
                      }
                    });
                  },
                );
              }).toList(),
              if (selected['Alasan lainnya'] == true) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: alasanLainController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Tuliskan alasan lainnya...',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color(0xFF358666),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color(0xFF358666),
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ),
                if (showAlasanError)
                  const Padding(
                    padding: EdgeInsets.only(top: 6.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Alasan lainnya tidak boleh kosong',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ),
              ]
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEA3535),
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  child: const Text('Batal',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final alasanTerpilih = selected.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key)
                        .toList();

                    if (alasanTerpilih.isEmpty) {
                      setState(() {
                        showAlasanError = false;
                      });
                      return;
                    }

                    if (selected['Alasan lainnya'] == true) {
                      final alasanLain = alasanLainController.text.trim();
                      if (alasanLain.isEmpty) {
                        setState(() {
                          showAlasanError = true;
                        });
                        return;
                      }
                      alasanTerpilih.remove('Alasan lainnya');
                      alasanTerpilih.add(alasanLain);
                    }

                    Navigator.of(context).pop();
                    onConfirm(alasanTerpilih);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF358666),
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  child: const Text('Konfirmasi',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
