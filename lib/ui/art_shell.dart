import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../controllers/extra/application_controller.dart';
import '../controllers/extra/bluetooth_controller.dart';
import 'art_copy.dart';
import 'art_pages.dart';
import 'art_session.dart';
import 'art_theme.dart';
import 'art_widgets.dart';

class ArtSoundApp extends StatefulWidget {
  const ArtSoundApp({Key? key}) : super(key: key);

  @override
  State<ArtSoundApp> createState() => _ArtSoundAppState();
}

class _ArtSoundAppState extends State<ArtSoundApp>
    with SingleTickerProviderStateMixin {
  ArtSession? _session;
  late final AnimationController _slide;
  late final CurvedAnimation _slideCurve;
  bool _introDone = false;
  int _paintedTab = 0;
  int _slideFrom = 0;
  int _direction = 1;
  Widget? _leaving;

  @override
  void initState() {
    super.initState();
    _slide = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: 1,
    );
    _slideCurve = CurvedAnimation(parent: _slide, curve: Curves.easeOutCubic);
    _slide.addStatusListener((status) {
      if (status == AnimationStatus.completed && _leaving != null && mounted) {
        setState(() {
          _leaving = null;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_session != null) return;
    _session = ArtSession(context.read<BluetoothController>());
    _session!.addListener(_onSession);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ApplicationController.getInstance().init();
    });
  }

  void _onSession() {
    final session = _session;
    if (!mounted || session == null) return;
    if (session.tab != _paintedTab) {
      final from = _paintedTab;
      _slideFrom = from;
      _direction = session.tab > from ? 1 : -1;
      _leaving = buildArtPage(context, session, tab: from);
      _paintedTab = session.tab;
      _slide.forward(from: 0);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _slideCurve.dispose();
    _slide.dispose();
    _session?.removeListener(_onSession);
    _session?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_introDone) {
      return ArtIntro(onDone: () {
        if (mounted) setState(() => _introDone = true);
      });
    }
    final session = _session;
    if (session == null) {
      return const ColoredBox(color: ArtTheme.background);
    }
    ArtCopy.bind(Localizations.localeOf(context).languageCode);
    final keyboard = MediaQuery.viewInsetsOf(context).bottom > 0 || session.keypad != null;
    final showTabs = session.showTabs && !keyboard;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (session.showTabs &&
            !session.discardDialog &&
            session.keypad == null) {
          SystemNavigator.pop();
          return;
        }
        session.handleBack();
      },
      child: Scaffold(
        backgroundColor: ArtTheme.background,
        body: SafeArea(
          child: Stack(
            children: [
              KeyedSubtree(
                key: ValueKey<String>(ArtCopy.current.code),
                child: Column(
                children: [
                  if (!session.showTabs) _subBar(session),
                  Expanded(child: _tabBody(context, session)),
                  if (session.keypad != null)
                    ArtKeypad(
                      onDigit: session.typeDigit,
                      onDelete: session.deleteDigit,
                    ),
                  if (showTabs)
                    AnimatedBuilder(
                      animation: _slideCurve,
                      builder: (context, _) {
                        final from = _slideFrom.toDouble();
                        final to = session.tab.toDouble();
                        final pos = from + (to - from) * _slideCurve.value;
                        return ArtTabBar(
                          position: pos,
                          onSelect: session.goTab,
                        );
                      },
                    ),
                ],
                ),
              ),
              if (session.discardDialog) _discard(session),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabBody(BuildContext context, ArtSession session) {
    final incoming = buildArtPage(context, session);
    final leaving = _leaving;
    if (leaving == null) return incoming;
    return ClipRect(
      child: AnimatedBuilder(
        animation: _slideCurve,
        builder: (context, _) {
          final t = _slideCurve.value;
          final dir = _direction.toDouble();
          return Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              FractionalTranslation(
                translation: Offset(-dir * t, 0),
                child: leaving,
              ),
              FractionalTranslation(
                translation: Offset(dir * (1 - t), 0),
                child: incoming,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _subBar(ArtSession session) {
    final logoH = ArtLogo.defaultHeight;
    return SizedBox(
      height: logoH + 16,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ArtLogo(size: logoH),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: session.handleBack,
              icon: const Icon(Icons.chevron_left, size: 30),
              color: ArtTheme.ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _discard(ArtSession session) {
    return ColoredBox(
      color: const Color(0x66000000),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
          decoration: BoxDecoration(
            color: ArtTheme.card,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ArtCopy.current.tr('Discard changes?'),
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: ArtTheme.ink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ArtCopy.current.tr(
                    'Your changes have not been saved.\nKeep editing or discard them and go back.'),
                style: ArtTheme.body,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ArtButton(
                      label: ArtCopy.current.tr('Discard'),
                      onPressed: session.discardRename,
                    ),
                  ),
                  TextButton(
                    onPressed: session.keepEditing,
                    child: Text(
                      ArtCopy.current.tr('Keep editing'),
                      style: const TextStyle(
                        fontFamily: 'HelveticaNeue',
                        fontWeight: FontWeight.w700,
                        color: ArtTheme.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
