import 'package:flutter/foundation.dart';
import '../../models/site_content.dart';

/// Almacén compartido de los contenidos del sitio.
/// Lo usan la página "Contenidos Sitio" (para crear/editar) y el Inicio
/// (para mostrar el texto de algunas secciones). Así, lo que se guarda en
/// Contenidos Sitio aparece actualizado en el Inicio.
class SiteContentsStore extends ChangeNotifier {
  SiteContentsStore._();
  static final SiteContentsStore instance = SiteContentsStore._();

  // Mismos valores que SiteContentsController.mainPage / secondaryPage
  static const String _mainPage = 'Sección Página Principal';
  static const String _secondaryPage = 'Página Secundaria';

  // Nombres de sección que usa el Inicio
  static const String simposioSection = 'Simposio Santandereano de Sismología';
  static const String seismologyLettersSection = 'Seismology Letters';

  final List<SiteContent> _contents = [
    SiteContent(
      id: 1,
      section: 'Lo que necesita saber',
      text: '¿Sabías que los sismos pueden ocurrir en cualquier momento y lugar? '
          'Conocer cómo se producen, qué hacer durante y después de uno, puede '
          'salvar vidas. ¡Infórmate y protege a tu familia!',
      destination: _mainPage,
    ),
    SiteContent(
      id: 2,
      section: 'Estaciones Sísmicas',
      text: '¿Sabes dónde están ubicadas las estaciones sismológicas que '
          'monitorean la actividad sísmica en tiempo real en Bucaramanga y si '
          'área metropolitana? ¡Conoce más sobre estos puntos clave de '
          'vigilancia sísmica!!',
      destination: _mainPage,
    ),
    SiteContent(
      id: 3,
      section: 'Proyectos',
      text: 'Conoce los diferentes proyectos de investigación realizados desde '
          'el observatorio sismológico que nos permiten comprender la actividad '
          'sísmica en nuestra región.',
      destination: _mainPage,
    ),
    SiteContent(
      id: 4,
      section: 'Observatorio',
      text: '¿Quieres conocer el Observatorio Sismológico, quienes somos, como '
          'trabajamos y descubrir cómo se monitorean los sismos? ¡Aquí te '
          'presentamos el OSNOC!',
      destination: _mainPage,
    ),
    SiteContent(
      id: 5,
      section: 'Observatorio',
      text: '¿QUIENES SOMOS?\n\n'
          'El Observatorio Sismológico UDES - CDMB, está adscrito a la Facultad '
          'de Ingeniería y la Vicerrectoría de Extensión de la Universidad de '
          'Santander. El Observatotio Sismológico realiza y promueve la '
          'investigación y extensión en Sismología, Geofísica, Ingeniería '
          'Sísmica y la Gestión del Riesgo de Desastres en el nororiente '
          'colombiano.',
      destination: _secondaryPage,
    ),
    SiteContent(
      id: 6,
      section: 'Sismos Recientes',
      text: 'Consulta los últimos sismos registrados por nuestra red de '
          'estaciones: magnitud, profundidad, hora y ubicación del epicentro, '
          'actualizados en tiempo real.',
      destination: _mainPage,
    ),
    SiteContent(
      id: 7,
      section: 'Publicaciones',
      text: 'Accede a los artículos, boletines e informes técnicos elaborados '
          'por los investigadores del observatorio sobre la sismicidad del '
          'nororiente colombiano.',
      destination: _mainPage,
    ),
    SiteContent(
      id: 8,
      section: 'Lo que necesita saber',
      text: '¿QUÉ HACER ANTE UN SISMO?\n\n'
          'Antes: identifica las zonas seguras de tu hogar y ten listo un kit de '
          'emergencia. Durante: mantén la calma, aléjate de ventanas y protégete '
          'bajo una mesa resistente. Después: revisa si hay heridos, evita usar '
          'ascensores y sigue las indicaciones de las autoridades.',
      destination: _secondaryPage,
    ),
    SiteContent(
      id: 9,
      section: 'Estaciones Sísmicas',
      text: 'NUESTRA RED DE MONITOREO\n\n'
          'La red del observatorio está conformada por estaciones sismológicas y '
          'acelerográficas instaladas en Bucaramanga, Floridablanca, Girón y la '
          'Mesa de Los Santos, que registran de forma continua el movimiento del '
          'suelo.',
      destination: _secondaryPage,
    ),
    SiteContent(
      id: 10,
      section: 'Proyectos',
      text: 'LÍNEAS DE INVESTIGACIÓN\n\n'
          'Desarrollamos proyectos en microzonificación sísmica, caracterización '
          'de fuentes sismogénicas, instrumentación sísmica y apropiación social '
          'del conocimiento para la gestión del riesgo.',
      destination: _secondaryPage,
    ),
    SiteContent(
      id: 11,
      section: 'Contacto',
      text: '¿Sentiste un sismo o tienes alguna inquietud? Comunícate con el '
          'Observatorio Sismológico UDES - CDMB a través de nuestros canales de '
          'atención y redes sociales.',
      destination: _mainPage,
    ),
    // Secciones del inicio que se completan desde esta página.
    // TEXTOS DE EJEMPLO (ficticios): reemplázalos desde Contenidos Sitio.
    SiteContent(
      id: 12,
      section: simposioSection,
      text: 'V SIMPOSIO SANTANDEREANO DE SISMOLOGÍA (texto de ejemplo)\n\n'
          'Un espacio para investigadores, estudiantes y entidades de gestión del '
          'riesgo del nororiente colombiano. Habrá conferencias sobre sismicidad '
          'del Nido de Bucaramanga, instrumentación sísmica y microzonificación, '
          'además de talleres de divulgación para colegios.\n\n'
          'Fecha: por confirmar · Lugar: Campus UDES Bucaramanga · '
          'Inscripciones abiertas próximamente.',
      destination: _mainPage,
    ),
    SiteContent(
      id: 13,
      section: seismologyLettersSection,
      text: 'BOLETÍN SEISMOLOGY LETTERS (texto de ejemplo)\n\n'
          'Publicación periódica del observatorio con notas breves sobre los '
          'sismos más relevantes del trimestre, el funcionamiento de la red de '
          'estaciones y avances de los proyectos de investigación.\n\n'
          'En este número: análisis de la actividad sísmica reciente en la Mesa '
          'de Los Santos y balance de la nueva estación Vivero la Rosita.',
      destination: _mainPage,
    ),
  ];

  List<SiteContent> get contents => List<SiteContent>.unmodifiable(_contents);

  int get nextId {
    int maxId = 0;
    for (final SiteContent c in _contents) {
      if (c.id > maxId) maxId = c.id;
    }
    return maxId + 1;
  }

  void add(SiteContent content) {
    _contents.add(content);
    notifyListeners();
  }

  // Reemplaza el contenido que tenga el mismo ID
  void update(SiteContent updated) {
    final int index = _contents.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      _contents[index] = updated;
      notifyListeners();
    }
  }

  // Contenidos de una sección que tienen texto o imagen.
  // La comparación ignora mayúsculas, tildes y espacios de más.
  List<SiteContent> contentsForSection(String section) {
    final String wanted = _normalize(section);
    final List<SiteContent> result = <SiteContent>[];
    for (final SiteContent c in _contents) {
      final bool hasData = c.text.trim().isNotEmpty || c.image != null;
      if (_normalize(c.section) == wanted && hasData) {
        result.add(c);
      }
    }
    return result;
  }

  static String _normalize(String value) {
    const String from = 'áéíóúüñÁÉÍÓÚÜÑ';
    const String to = 'aeiouunAEIOUUN';
    final StringBuffer buffer = StringBuffer();
    for (final int rune in value.trim().runes) {
      final String ch = String.fromCharCode(rune);
      final int i = from.indexOf(ch);
      buffer.write(i == -1 ? ch : to[i]);
    }
    return buffer.toString().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }
}
