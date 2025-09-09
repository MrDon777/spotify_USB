import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Colores base para el tema (estilo Spotify dark) fggfgfgfgffggffgfg
const Color spotifyBlack = Color(0xFF121212);
const Color spotifyGreen = Color(0xFF1DB954);
const Color spotifyGrey = Color(0xFF2B2B2B);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify-like UI Demooo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: spotifyBlack,
        primaryColor: spotifyGreen,
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Roboto',
            ),
      ),
      home: const MainShell(),
    );
  }
}

/// Main shell controla la navegación inferior y muestra la pantalla correspondiente
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Screens: 0 = Inicio, 1 = Buscar, 2 = Biblioteca, 3 = Crear (placeholder)
  final List<Widget> _screens = const [
    HomeScreen(),
    Center(child: Text('Buscar - placeholder')),
    Center(child: Text('Tu biblioteca - placeholder')),
    Center(child: Text('Crear - placeholder')),
  ];

  void _openFullPlayer() {
    // Abre el reproductor expandido como modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FullPlayerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Stack para poder superponer el mini player sobre el body
      body: Stack(
        children: [
          // Pantalla seleccionada
          _screens[_currentIndex],
          // Mini player posicionado arriba de la barra inferior
          Positioned(
            left: 12,
            right: 12,
            bottom: kBottomNavigationBarHeight + 12,
            child: GestureDetector(
              onTap: _openFullPlayer,
              child: const MiniPlayer(),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: spotifyGrey,
        currentIndex: _currentIndex,
        selectedItemColor: spotifyGreen,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Tu biblioteca'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: 'Crear'),
        ],
      ),
    );
  }
}

/// MINI PLAYER (barra compacta)
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF7B2A23), // usa tu color si quieres (yo puse marrón similar a la captura)
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Portada (reemplaza por assets)
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              'https://via.placeholder.com/56', // placeholder; reemplaza por tu asset
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          // Título y artista
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('We Are', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 2),
                Text('Big Time Rush', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),

          // Botones a la derecha (ícono, añadir, play)
          IconButton(
            onPressed: () {}, // opcional: acción
            icon: const Icon(Icons.cast),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {}, // opcional
            icon: const Icon(Icons.add_circle_outline),
            color: Colors.white,
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow, color: spotifyBlack),
          ),
        ],
      ),
    );
  }
}

/// FULL PLAYER que se muestra al tocar el mini player
class FullPlayerSheet extends StatelessWidget {
  const FullPlayerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos DraggableScrollableSheet para permitir arrastrar
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: spotifyGrey,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          controller: controller,
          children: [
            const SizedBox(height: 12),
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Album art grande
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://via.placeholder.com/400', // reemplaza por la portada de álbum
                  height: 320,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Título y sub (con botón circular verde)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Tabaco y Chanel',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text('Bacilos', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  // Botón circular verde
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: spotifyGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.pause, color: Colors.black),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Slider de tiempo (solo visual)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Slider(
                    value: 10,
                    min: 0,
                    max: 312,
                    onChanged: (_) {},
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('0:10', style: TextStyle(fontSize: 12)),
                      Text('5:12', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Controles principales
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.shuffle, size: 26),
                  Icon(Icons.skip_previous, size: 36),
                  // Play grande
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.pause, color: spotifyBlack, size: 36),
                  ),
                  Icon(Icons.skip_next, size: 36),
                  Icon(Icons.repeat, size: 26),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Fila de iconos adicionales (compartir, lista, etc)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.picture_in_picture_alt),
                  Icon(Icons.queue_music),
                  Icon(Icons.share),
                  Icon(Icons.more_vert),
                ],
              ),
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}

/// PANTALLA HOME (inicio con secciones tipo Spotify)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openPlaylist(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PlaylistScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          // Cabecera con chips (Todas, Música, Siguiendo, Podcasts)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Circular avatar left (tu perfil)
                const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://via.placeholder.com/80')),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _HeaderChip(label: 'Todas', selected: false),
                        const SizedBox(width: 8),
                        _HeaderChip(label: 'Música', selected: true),
                        const SizedBox(width: 8),
                        _HeaderChip(label: 'Siguiendo', selected: false),
                        const SizedBox(width: 8),
                        _HeaderChip(label: 'Podcasts', selected: false),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Grid superior (tarjetas de tus playlists / mezclas)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              shrinkWrap: true,
              childAspectRatio: 3.5,
              children: [
                // "Tus me gusta" debe navegar a la playlist
                GestureDetector(
                  onTap: () => _openPlaylist(context),
                  child: _SmallCard(
                    color: const LinearGradient(colors: [Color(0xFF8E44AD), Color(0xFF4A00E0)]),
                    title: 'Tus me gusta',
                    leading: const Icon(Icons.favorite, color: Colors.white),
                  ),
                ),
                _SmallCard(
                  title: 'Phineas and Ferb',
                  imageUrl: 'https://via.placeholder.com/80',
                ),
                _SmallCard(title: 'Chill', imageUrl: 'https://via.placeholder.com/80'),
                _SmallCard(title: 'Finding my place', imageUrl: 'https://via.placeholder.com/80'),
                _SmallCard(title: '2000s', imageUrl: 'https://via.placeholder.com/80'),
                _SmallCard(title: 'DJ', imageUrl: 'https://via.placeholder.com/80'),
                _SmallCard(title: 'Love Is Like', imageUrl: 'https://via.placeholder.com/80'),
                _SmallCard(title: 'A Whole New Sound', imageUrl: 'https://via.placeholder.com/80'),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // Sección "Fiesta" con fila horizontal
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Fiesta', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => SizedBox(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network('https://via.placeholder.com/160x120', height: 120, width: 160, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 8),
                    const Text('Girls\' Night', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('Taylor Swift, Sabrina...', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 22),

          // Otra sección ("Vistazo al pasado")
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Vistazo al pasado', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => SizedBox(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network('https://via.placeholder.com/160x160', height: 160, width: 160, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 8),
                    const Text('Some Album', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('Artist name', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 120), // espacio para que el ListView no quede debajo del mini player
        ],
      ),
    );
  }
}

/// Tarjeta pequeña reutilizable para grid superior
class _SmallCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final Widget? leading;
  final LinearGradient? color;

  const _SmallCard({
    required this.title,
    this.imageUrl,
    this.leading,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: color,
        color: color == null ? spotifyGrey : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (leading != null)
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: leading,
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                imageUrl ?? 'https://via.placeholder.com/48',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

/// Chip header (seleccionable visual)
class _HeaderChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _HeaderChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? spotifyGreen : spotifyGrey,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

/// PANTALLA Playlist "Tus me gusta"
class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de canciones de ejemplo (ustedes reemplazan con sus datos)
    final songs = List.generate(10, (i) => {
          'title': ['Hero', 'The Sweet Escape', 'Take on Me', "Don't You Worry Child", 'Yo Quisiera', 'La De La Mala Suerte', 'Dueles'][i % 7],
          'artist': ['Enrique Iglesias','Gwen Stefani','a-ha','Swedish House Mafia','Reik','Jesse & Joy','Jesse & Joy'][i % 7],
          'image': 'https://via.placeholder.com/56'
        });

    return Scaffold(
      backgroundColor: spotifyBlack,
      appBar: AppBar(
        backgroundColor: spotifyGrey,
        elevation: 0,
        title: const Text('Tus me gusta', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          // Header grande de playlist
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network('https://via.placeholder.com/140', width: 140, height: 140, fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tus me gusta', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      const Text('520 canciones', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.download),
                            label: const Text('Descargar'),
                            style: ElevatedButton.styleFrom(backgroundColor: spotifyGrey),
                          ),
                          const SizedBox(width: 12),
                          FloatingActionButton(
                            backgroundColor: spotifyGreen,
                            onPressed: () {},
                            child: const Icon(Icons.pause, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Botón "Agregar a esta playlist"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: spotifyGrey, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: const [
                  Icon(Icons.add_box_outlined),
                  SizedBox(width: 12),
                  Text('Agregar a esta playlist'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Lista de canciones
          ...songs.map((s) {
            return ListTile(
              leading: ClipRRect(borderRadius: BorderRadius.circular(6), child: Image.network(s['image']!, width: 56, height: 56, fit: BoxFit.cover)),
              title: Text(s['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(s['artist']!, style: const TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.more_vert),
              onTap: () {
                // opcional: abrir detalle de canción
              },
            );
          }).toList(),

          const SizedBox(height: 120), // espacio para mini player
        ],
      ),
    );
  }
}

