import 'package:flutter/material.dart';
import 'package:navikit_flutter_demo/dependencies/application_deps/application_deps_provider.dart';
import 'package:navikit_flutter_demo/domain/navigation/navigation_manager.dart';
import 'package:navikit_flutter_demo/domain/navigation/navigation_suspender_manager.dart';
import 'package:navikit_flutter_demo/domain/permissions/permission_manager.dart';
import 'package:navikit_flutter_demo/features/map_screen/ui/maps/flutter_map_widget.dart';
import 'package:navikit_flutter_demo/features/settings/settings_bottomsheet.dart';
import 'package:yandex_maps_navikit/init.dart' as init;

class NavikitFlutterApp extends StatefulWidget {
  const NavikitFlutterApp({super.key});

  @override
  State<NavikitFlutterApp> createState() => _NavikitFlutterAppState();
}

class _NavikitFlutterAppState extends State<NavikitFlutterApp> {
  late final AppLifecycleListener _lifecycleListener;
  bool isAppInitialized = false;
  @override
  void initState() {
    super.initState();

    initApplicationSettings();
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    disposeApplicationDeps();
    super.dispose();
  }

  /// --- Listeners ---

  void initListener() => _lifecycleListener = AppLifecycleListener(onResume: () {
        _requestPermissionsIfNeeded();
      }, onShow: () {
        navigationSuspenderManager.registerClient(NavigationClient.application);
      }, onHide: () {
        _serializeNavigationIfNeeded();
        navigationSuspenderManager.removeClient(NavigationClient.application);
      });

  /// --- Methods ---

  void registerNavigationSuspender() => navigationSuspenderManager.registerClient(NavigationClient.application);

  void _showSettingsBottomsheet(BuildContext context) => showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) => const SettingsBottomsheet());

  void _requestPermissionsIfNeeded() {
    final permissions = [PermissionType.accessLocation];
    permissionManager.tryToRequest(permissions);
    permissionManager.showRequestDialog(permissions);
  }

  void _serializeNavigationIfNeeded() {
    if (settingsManager.restoreGuidanceState.value && navigationManager.isGuidanceActive) {
      navigationHolder.serialize();
    }
  }

  void initApplicationSettings() async {
    await initApplicationDeps();
    /**
   * Replace "your_api_key" with a valid developer key.
   */
    await init.initMapkit(apiKey: "c45d8fd7-8dac-47fc-a610-bf83eb6decf1");
    initListener();
    registerNavigationSuspender();
    _requestPermissionsIfNeeded();
    isAppInitialized = true;
    setState(() {});
  }

  /// --- Widgets ---

  @override
  Widget build(BuildContext context) => Scaffold(
      key: globalKey,
      body: Center(
          child: isAppInitialized
              ? FlutterMapWidget(showSettingsBottomsheet: _showSettingsBottomsheet)
              : const CircularProgressIndicator.adaptive()));
}
