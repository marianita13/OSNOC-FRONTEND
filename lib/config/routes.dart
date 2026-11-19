import 'package:flutter/material.dart';
import 'package:flutter_sismo/features/auth/presentation/pages/event_logs_page.dart';
import 'package:flutter_sismo/features/auth/presentation/pages/home_page.dart';
import 'package:flutter_sismo/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_sismo/features/auth/presentation/pages/news_page.dart';
import 'package:flutter_sismo/features/auth/presentation/pages/projects_page.dart';
import 'package:flutter_sismo/features/auth/presentation/pages/publications_page.dart';
import 'package:flutter_sismo/features/auth/presentation/pages/seismic_reports_page.dart';
import 'package:flutter_sismo/features/auth/presentation/pages/site_contents_page.dart';
import 'package:flutter_sismo/features/auth/presentation/pages/social_networks_page.dart';
import 'package:flutter_sismo/features/auth/presentation/pages/stations_page.dart';
import 'package:flutter_sismo/features/auth/presentation/pages/user_profile_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String stations = '/stations';
  static const String profile = '/profile';
  static const String publications = '/publications';
  static const String siteContents = '/site-contents';
  static const String projects = '/projects';
  static const String news = '/news';
  static const String seismicReports = '/seismic-reports';
  static const String eventLogs = '/event-logs';
  static const String socialNetworks = '/social-networks';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginPage(),
      home: (context) => const HomePage(),
      stations: (context) => const StationsPage(),
      profile: (context) => const UserProfilePage(),
      publications: (context) => const PublicationsPage(),
      siteContents: (context) => const SiteContentsPage(),
      projects: (context) => const ProjectsPage(),
      news: (context) => const NewsPage(),
      seismicReports: (context) => const SeismicReportsPage(),
      eventLogs: (context) => const EventLogsPage(),
      socialNetworks: (context) => const SocialNetworksPage(),
    };
  }
}