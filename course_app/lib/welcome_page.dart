import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Willkommen')),
      body: Center(
        child: user == null
            ? const Text('Keine Benutzerdaten gefunden')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Erfolgreich angemeldet!', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  Text('E-Mail: ${user.email}'),
                  Text('Benutzer-ID: ${user.id}'),
                  ElevatedButton(
                    onPressed: () async {
                      await Supabase.instance.client.auth.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Abmelden'),
                  ),
                ],
              ),
      ),
    );
  }
} 