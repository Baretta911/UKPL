import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final _formKey = GlobalKey<FormState>();
  String _kesan = '';
  String _pesan = '';
  bool _submitted = false;

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Here you would typically send the feedback to a server or store it locally.
      // For this example, we'll just update the UI.
      setState(() {
        _submitted = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terima kasih atas kesan dan pesan Anda!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status & Feedback'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const Text(
                'Kesan dan Pesan untuk Mata Kuliah Teknologi dan Pemrograman Mobile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Kesan Anda',
                  hintText: 'Apa kesan positif Anda terhadap mata kuliah ini?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon isi kesan Anda';
                  }
                  return null;
                },
                onSaved: (value) => _kesan = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Pesan/Saran Anda',
                  hintText: 'Apa pesan atau saran Anda untuk perbaikan ke depannya?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon isi pesan atau saran Anda';
                  }
                  return null;
                },
                onSaved: (value) => _pesan = value!,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitFeedback,
                child: const Text('Kirim Kesan & Pesan'),
              ),
              const SizedBox(height: 20),
              if (_submitted)
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kesan Anda:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_kesan),
                        SizedBox(height: 10),
                        Text('Pesan/Saran Anda:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_pesan),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
