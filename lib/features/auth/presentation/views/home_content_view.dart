import 'package:flutter/material.dart';
import '../../../../config/routes.dart';
import '../../models/news.dart';
import '../../models/seismic_report.dart';
import '../../models/site_content.dart';
import '../../models/station.dart';
import '../controllers/news_controller.dart';
import '../controllers/seismic_reports_controller.dart';
import '../controllers/site_contents_store.dart';
import '../controllers/stations_controller.dart';
import '../theme/home_styles.dart';
import '../widgets/home_footer.dart';
import '../widgets/home_stations_map.dart';
import '../widgets/responsive.dart';
import '../widgets/seismic_event_card.dart';

class HomeContentView extends StatefulWidget {
  const HomeContentView({super.key});

  @override
  State<HomeContentView> createState() => _HomeContentViewState();
}

class _HomeContentViewState extends State<HomeContentView> {
  // Se reutilizan los mismos controllers de las páginas de
  // Estaciones, Reportes Sísmicos y Noticias para no duplicar datos.
  final StationsController _stationsController = StationsController();
  final SeismicReportsController _reportsController = SeismicReportsController();
  final NewsController _newsController = NewsController();

  // Desplazamiento de las 4 tarjetas de la sección 2 (flechas en el celular)
  final ScrollController _infoScroll = ScrollController();

  // Información de la sección 2 (4 columnas)
  static const List<_InfoItem> _infoItems = <_InfoItem>[
    _InfoItem(
      icon: Icons.record_voice_over_outlined,
      title: 'Lo que necesita saber',
      text: '¿Sabías que los sismos pueden ocurrir en cualquier momento y lugar? '
          'Conocer cómo se producen, qué hacer durante y después de uno, puede '
          'salvar vidas. ¡Infórmate y protege a tu familia!',
    ),
    _InfoItem(
      icon: Icons.track_changes,
      title: 'Observatorio',
      text: '¿Quieres conocer el Observatorio Sismológico, quienes somos, como '
          'trabajamos y descubrir cómo se monitorean los sismos? ¡Aquí te '
          'presentamos el OSNOC!',
    ),
    _InfoItem(
      icon: Icons.location_on_outlined,
      title: 'Estaciones Sísmicas',
      text: '¿Sabes dónde están ubicadas las estaciones sismológicas que '
          'monitorean la actividad sísmica en tiempo real en Bucaramanga y su '
          'área metropolitana? ¡Conoce más sobre estos puntos clave de '
          'vigilancia sísmica!',
    ),
    _InfoItem(
      icon: Icons.architecture,
      title: 'Proyectos',
      text: 'Conoce los diferentes proyectos de investigación realizados desde '
          'el observatorio sismológico que nos permiten comprender la actividad '
          'sísmica en nuestra región.',
    ),
  ];

  @override
  void dispose() {
    _stationsController.dispose();
    _reportsController.dispose();
    _newsController.dispose();
    _infoScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // En computador: contenido centrado y secciones de a dos columnas
    final bool desktop = Responsive.isDesktop(context);

    return SingleChildScrollView(
      padding: Responsive.pagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- Sección 1: Título + imagen principal ----------
          const Text(
            'Observatorio Sismológico del Nororiente Colombiano',
            style: HomeStyles.mainTitle,
          ),
          const SizedBox(height: 12),
          _buildMainImage(),
          const SizedBox(height: 20),

          // ---------- Sección 2: 4 columnas informativas ----------
          _buildInfoColumns(),
          const SizedBox(height: 20),

          // ---------- Secciones 3 y 4: Simposio y Seismology Letters ----------
          // (texto desde Contenidos Sitio; en computador van lado a lado)
          _buildPair(
            desktop,
            _buildSiteContentSection(SiteContentsStore.simposioSection),
            _buildSiteContentSection(SiteContentsStore.seismologyLettersSection),
          ),
          const SizedBox(height: 16),

          // ---------- Sección 5: Estaciones Sísmicas + mapa ----------
          _buildSection(
            title: 'Estaciones Sísmicas',
            child: _buildStationsMap(),
          ),
          const SizedBox(height: 16),

          // ---------- Secciones 6 y 7: Reportes Sísmicos y Noticias ----------
          // (en computador van lado a lado)
          _buildPair(
            desktop,
            _buildSection(
              title: 'Reportes Sísmicos',
              child: _buildSeismicReports(context),
            ),
            _buildSection(
              title: 'Noticias',
              child: _buildLatestNews(context),
            ),
          ),
          const SizedBox(height: 32),

          // Footer Institucional con Logos de UDES, CDMB y Servicio Geológico
          const HomeFooter(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Dos bloques: uno debajo del otro en celular, lado a lado en computador
  Widget _buildPair(bool sideBySide, Widget first, Widget second) {
    if (!sideBySide) {
      return Column(
        children: [
          first,
          const SizedBox(height: 16),
          second,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        const SizedBox(width: 16),
        Expanded(child: second),
      ],
    );
  }

  // ===================== Sección 1 =====================
  Widget _buildMainImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        'assets/images/ReportesDeInicio.jpeg',
        width: double.infinity,
        // En pantallas anchas se limita el alto para que no ocupe toda la vista
        height: Responsive.isWide(context) ? 380 : null,
        fit: BoxFit.cover,
        // Si la imagen todavía no está en assets/images, se muestra un aviso
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 180,
            color: HomeStyles.cardHeaderBlue,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.image_outlined, color: Colors.white70, size: 36),
                SizedBox(height: 8),
                Text(
                  'Agrega la imagen ReportesDeInicio.jpeg\nen la carpeta assets/images',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ===================== Sección 2 =====================
  // En pantallas anchas las 4 columnas ocupan todo el ancho; en el celular
  // se ve una tarjeta por vez y se cambia con las flechas o deslizando.
  Widget _buildInfoColumns() {
    return Container(
      width: double.infinity,
      decoration: HomeStyles.sectionDecoration,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool wide = constraints.maxWidth >= 800;
          final double cardWidth = constraints.maxWidth;
          final List<Widget> children = <Widget>[];
          for (int i = 0; i < _infoItems.length; i++) {
            // Las líneas divisorias solo van cuando se ven las 4 juntas
            if (i > 0 && wide) {
              children.add(const VerticalDivider(width: 1, thickness: 1, color: HomeStyles.borderSide));
            }
            final Widget column = _InfoColumn(item: _infoItems[i]);
            children.add(wide ? Expanded(child: column) : SizedBox(width: cardWidth, child: column));
          }

          final Widget row = IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          );

          if (wide) return row;

          // Celular: una tarjeta por vez + flechas y puntitos abajo
          return Column(
            children: [
              SingleChildScrollView(
                controller: _infoScroll,
                scrollDirection: Axis.horizontal,
                // Al deslizar con el dedo, la tarjeta queda siempre centrada
                physics: const PageScrollPhysics(),
                child: row,
              ),
              ListenableBuilder(
                listenable: _infoScroll,
                builder: (context, _) {
                  final int last = _infoItems.length - 1;
                  final int page = _infoScroll.hasClients && cardWidth > 0
                      ? (_infoScroll.offset / cardWidth).round().clamp(0, last).toInt()
                      : 0;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildArrowButton(
                          icon: Icons.chevron_left,
                          tooltip: 'Anterior',
                          onTap: page > 0 ? () => _goToInfoCard(page - 1, cardWidth) : null,
                        ),
                        const SizedBox(width: 12),
                        for (int i = 0; i <= last; i++)
                          GestureDetector(
                            onTap: () => _goToInfoCard(i, cardWidth),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: i == page ? 18 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: i == page ? HomeStyles.osnocBlue : HomeStyles.borderSide,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        const SizedBox(width: 12),
                        _buildArrowButton(
                          icon: Icons.chevron_right,
                          tooltip: 'Siguiente',
                          onTap: page < last ? () => _goToInfoCard(page + 1, cardWidth) : null,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // Lleva la sección 2 a la tarjeta indicada (con animación)
  void _goToInfoCard(int index, double cardWidth) {
    if (!_infoScroll.hasClients) return;
    _infoScroll.animateTo(
      index * cardWidth,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Flecha redonda; sin onTap queda gris (primera o última tarjeta)
  Widget _buildArrowButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback? onTap,
  }) {
    final bool enabled = onTap != null;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: enabled ? HomeStyles.osnocBlue : HomeStyles.borderSide,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, size: 22, color: enabled ? Colors.white : Colors.white70),
          ),
        ),
      ),
    );
  }

  // ===================== Secciones 3 y 4 =====================
  // Muestra el texto de los contenidos de "Contenidos Sitio" cuya sección se
  // llama igual que el título. Se actualiza sola al crear o editar uno.
  Widget _buildSiteContentSection(String title) {
    return ListenableBuilder(
      listenable: SiteContentsStore.instance,
      builder: (context, _) {
        final List<SiteContent> items = SiteContentsStore.instance.contentsForSection(title);
        return _buildSection(
          title: title,
          child: items.isEmpty
              // Sin texto ni imagen: queda en blanco
              ? const SizedBox(height: 120)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < items.length; i++) ...[
                      if (i > 0) const SizedBox(height: 16),
                      _buildSiteContentItem(items[i]),
                    ],
                  ],
                ),
        );
      },
    );
  }

  // Imagen (si tiene) arriba y texto debajo
  Widget _buildSiteContentItem(SiteContent item) {
    final image = item.image;
    final String text = item.text.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              image,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
        if (image != null && text.isNotEmpty) const SizedBox(height: 10),
        if (text.isNotEmpty) Text(text, style: HomeStyles.infoText),
      ],
    );
  }

  // ===================== Sección 5 =====================
  Widget _buildStationsMap() {
    final List<Station> stations = _stationsController.allStations;
    int active = 0;
    for (final Station station in stations) {
      if (station.isActive) active++;
    }
    final int inactive = stations.length - active;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeStationsMap(
          stations: stations,
          height: Responsive.isWide(context) ? 440 : 300,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: HomeStyles.osnocGreen),
            const SizedBox(width: 4),
            Text('Activas ($active)', style: HomeStyles.smallText),
            const SizedBox(width: 16),
            const Icon(Icons.location_on, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text('Inactivas ($inactive)', style: HomeStyles.smallText),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Toca un marcador para ver el nombre de la estación.',
          style: HomeStyles.hintText,
        ),
      ],
    );
  }

  // ===================== Sección 6 =====================
  Widget _buildSeismicReports(BuildContext context) {
    // Más recientes primero (por tiempo de origen) y solo los activos
    final List<SeismicReport> reports = _reportsController.allReports
        .where((r) => r.isActive)
        .toList()
      ..sort((a, b) => b.originTime.compareTo(a.originTime));
    final List<SeismicReport> latest = reports.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Detalle del último evento (tarjeta que ya tenía el inicio)
        const SeismicEventCard(),
        const SizedBox(height: 12),
        const Text('Últimos reportes', style: HomeStyles.subheadingText),
        const SizedBox(height: 8),
        for (final SeismicReport report in latest) _buildReportRow(report),
        const SizedBox(height: 8),
        _buildSeeAllButton(
          label: 'VER TODOS LOS REPORTES',
          onTap: () => Navigator.pushNamed(context, AppRoutes.seismicReports),
        ),
      ],
    );
  }

  Widget _buildReportRow(SeismicReport report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: HomeStyles.scaffoldBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: HomeStyles.borderSide),
      ),
      child: Row(
        children: [
          const Icon(Icons.show_chart, size: 20, color: HomeStyles.osnocBlue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.description, style: HomeStyles.itemTitle),
                const SizedBox(height: 2),
                Text(
                  '${report.formattedOriginTime}  ·  ${report.epicenter}',
                  style: HomeStyles.smallText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== Sección 7 =====================
  Widget _buildLatestNews(BuildContext context) {
    // 4 noticias activas más recientes (por fecha de publicación)
    final List<News> news = _newsController.allNews
        .where((n) => n.isActive)
        .toList()
      ..sort((a, b) => b.publicationDate.compareTo(a.publicationDate));
    final List<News> latest = news.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final News item in latest) _buildNewsItem(item),
        const SizedBox(height: 4),
        _buildSeeAllButton(
          label: 'VER TODAS LAS NOTICIAS',
          onTap: () => Navigator.pushNamed(context, AppRoutes.news),
        ),
      ],
    );
  }

  Widget _buildNewsItem(News item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: HomeStyles.borderSide),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 56,
            decoration: BoxDecoration(
              color: HomeStyles.osnocGreen,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 12, color: HomeStyles.mutedText),
                    const SizedBox(width: 4),
                    Text(item.formattedPublicationDate, style: HomeStyles.smallText),
                  ],
                ),
                const SizedBox(height: 4),
                Text(item.title, style: HomeStyles.itemTitle),
                const SizedBox(height: 4),
                Text(
                  item.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: HomeStyles.smallText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== Comunes =====================
  // Bloque blanco con título, usado por las secciones 3 a 7
  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: HomeStyles.sectionDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: HomeStyles.sectionTitle),
          const SizedBox(height: 8),
          const Divider(height: 1, color: HomeStyles.borderSide),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSeeAllButton({required String label, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: HomeStyles.osnocBlue,
          side: const BorderSide(color: HomeStyles.osnocBlue),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// Datos de cada columna de la sección 2
class _InfoItem {
  final IconData icon;
  final String title;
  final String text;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.text,
  });
}

// Columna de la sección 2: ícono sobre fondo gris, título y texto centrado
class _InfoColumn extends StatelessWidget {
  final _InfoItem item;

  const _InfoColumn({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              color: HomeStyles.infoIconBg,
              border: Border(bottom: BorderSide(color: HomeStyles.borderSide)),
            ),
            child: Icon(item.icon, size: 48, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: HomeStyles.infoTitle,
          ),
          const SizedBox(height: 8),
          Text(
            item.text,
            textAlign: TextAlign.center,
            style: HomeStyles.infoText,
          ),
        ],
      ),
    );
  }
}
