import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const StreamingHub());

class Service {
  const Service(this.name, this.url, this.icon);
  final String name, url;
  final IconData icon;
}

class StreamingHub extends StatelessWidget {
  const StreamingHub({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Streaming Hub',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark)),
    home: const HomePage(),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final services = <Service>[
    const Service('YouTube', 'https://www.youtube.com', Icons.smart_display),
    const Service('TV4 Play', 'https://www.tv4play.se', Icons.live_tv),
    const Service('SVT Play', 'https://www.svtplay.se', Icons.tv),
  ];
  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('custom_services') ?? [];
    if (!mounted) { return; }
    setState(() {
      for (final entry in saved) {
        final parts = entry.split('|');
        if (parts.length == 2) { services.add(Service(parts[0], parts[1], Icons.play_circle)); }
      }
    });
  }
  Future<void> _add() async {
    final name = TextEditingController(), url = TextEditingController();
    final accepted = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Lägg till streamingtjänst'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: name, decoration: const InputDecoration(labelText: 'Namn')),
        TextField(controller: url, decoration: const InputDecoration(labelText: 'https://...')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Avbryt')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Lägg till')),
      ],
    ));
    final uri = Uri.tryParse(url.text.trim());
    if (accepted != true || name.text.trim().isEmpty || uri == null ||
        uri.scheme != 'https' || uri.host.isEmpty) { return; }
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList('custom_services') ?? [];
    items.add('${name.text.trim()}|${uri.toString()}');
    await prefs.setStringList('custom_services', items);
    setState(() => services.add(Service(name.text.trim(), uri.toString(), Icons.play_circle)));
  }
  Future<void> _open(Service service) async {
    final uri = Uri.parse(service.url);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kunde inte öppna ${service.name}.')));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ingen app eller webbläsare kunde öppna ${service.name}.')));
      }
    }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Streaming Hub'), actions: [
      IconButton(tooltip: 'Lägg till tjänst', onPressed: _add, icon: const Icon(Icons.add)),
    ]),
    body: Padding(padding: const EdgeInsets.all(24), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Dina streamingtjänster', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text('Välj en tjänst för att öppna den i webbläsaren eller dess app. Inbyggd uppspelning och reklamfilter återstår.'),
        const SizedBox(height: 24),
        Expanded(child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 260, mainAxisSpacing: 16, crossAxisSpacing: 16,
            childAspectRatio: 1.6),
          itemCount: services.length,
          itemBuilder: (context, i) {
            final service = services[i];
            return Card(child: InkWell(
              onTap: () => _open(service),
              borderRadius: BorderRadius.circular(12),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(service.icon, size: 42, color: Colors.lightBlueAccent),
                const SizedBox(height: 12),
                Text(service.name, style: Theme.of(context).textTheme.titleLarge),
              ]),
            ));
          },
        )),
      ],
    )),
  );
}
