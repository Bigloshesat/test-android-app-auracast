import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'art_copy.dart';
import 'art_theme.dart';

class ArtLogo extends StatelessWidget {
  /// [size] is the overall logo strip height. Default matches 「数字人民币」
  /// glyph size to ~60% of [ArtTheme.title] (欢迎), based on the cropped asset ratio.
  const ArtLogo({Key? key, this.size}) : super(key: key);

  final double? size;

  /// Chinese wordmark ≈ this fraction of [digital-rmb-logo.png] height.
  static const double chineseHeightRatio = 0.47;

  /// Overall strip height so 「数字人民币」visual height ≈ title (32) × 0.6.
  static double get defaultHeight =>
      ArtTheme.title.fontSize! / chineseHeightRatio * 0.6;

  @override
  Widget build(BuildContext context) {
    final height = size ?? defaultHeight;
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(ArtTheme.ink, BlendMode.srcIn),
      child: Image.asset(
        'assets/images/digital-rmb-logo.png',
        height: height,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

class Rings extends StatelessWidget {
  const Rings({Key? key, this.diameter = 140, this.color = ArtTheme.ring})
      : super(key: key);

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(diameter),
      painter: _RingsPainter(color),
    );
  }
}

class _RingsPainter extends CustomPainter {
  _RingsPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = color;
    final center = Offset(size.width / 2, size.height / 2);
    final step = size.width / 10;
    for (var i = 1; i <= 5; i++) {
      canvas.drawCircle(center, step * i, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingsPainter oldDelegate) =>
      oldDelegate.color != color;
}

class ArtHeader extends StatelessWidget {
  const ArtHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.centerLogo = false,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final bool centerLogo;

  @override
  Widget build(BuildContext context) {
    final shellChrome = onBack != null || centerLogo;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!shellChrome)
            const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: ArtLogo(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(ArtCopy.current.tr(title), style: ArtTheme.title),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
              child: Text(ArtCopy.current.tr(subtitle!), style: ArtTheme.subtitle),
            ),
        ],
      ),
    );
  }
}

class ArtButton extends StatelessWidget {
  const ArtButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.filled = true,
  }) : super(key: key);

  final String label;
  final VoidCallback? onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final background = filled
        ? (enabled ? ArtTheme.magenta : ArtTheme.magenta.withValues(alpha: 0.35))
        : ArtTheme.card;
    final foreground = filled ? Colors.white : ArtTheme.ink.withValues(alpha: enabled ? 1 : 0.35);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(28),
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: onPressed,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: filled ? null : Border.all(color: ArtTheme.line),
              ),
              child: Text(ArtCopy.current.tr(label),
                  style: ArtTheme.button.copyWith(color: foreground)),
            ),
          ),
        ),
      ),
    );
  }
}

class ArtWash extends StatelessWidget {
  const ArtWash({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ArtTheme.wash,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class ArtCard extends StatelessWidget {
  const ArtCard({
    Key? key,
    required this.title,
    this.detail,
    this.onTap,
    this.trailing,
    this.inactiveNote,
    this.selected = false,
    this.translateTitle = true,
    this.translateDetail = true,
  }) : super(key: key);

  final String title;
  final String? detail;
  final VoidCallback? onTap;
  final Widget? trailing;
  final String? inactiveNote;
  final bool selected;
  final bool translateTitle;
  final bool translateDetail;

  @override
  Widget build(BuildContext context) {
    final inactive = onTap == null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Opacity(
        opacity: inactive && inactiveNote != null ? 0.55 : 1,
        child: Material(
          color: selected ? ArtTheme.magentaSoft : ArtTheme.card,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected
                      ? ArtTheme.magenta.withValues(alpha: 0.35)
                      : ArtTheme.line,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            translateTitle ? ArtCopy.current.tr(title) : title,
                            style: ArtTheme.body.copyWith(
                                fontWeight: FontWeight.w700, fontSize: 16)),
                        if (detail != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                                translateDetail
                                    ? ArtCopy.current.tr(detail!)
                                    : detail!,
                                style: ArtTheme.subtitle.copyWith(fontSize: 13)),
                          ),
                        if (inactiveNote != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(ArtCopy.current.tr(inactiveNote!),
                                style: ArtTheme.subtitle.copyWith(
                                    fontSize: 12, color: ArtTheme.danger)),
                          ),
                      ],
                    ),
                  ),
                  trailing ??
                      (selected
                          ? const Icon(Icons.check_circle, color: ArtTheme.magenta)
                          : Icon(Icons.chevron_right,
                              color: inactive ? ArtTheme.muted : ArtTheme.ink)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PinBoxes extends StatefulWidget {
  const PinBoxes({
    Key? key,
    required this.value,
    required this.onChanged,
    this.error = false,
    this.label,
    this.focused = false,
    this.onTap,
  }) : super(key: key);

  final String value;
  final ValueChanged<String> onChanged;
  final bool error;
  final String? label;
  final bool focused;
  final VoidCallback? onTap;

  @override
  State<PinBoxes> createState() => _PinBoxesState();
}

class _PinBoxesState extends State<PinBoxes> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value;
  }

  @override
  void didUpdateWidget(PinBoxes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.collapsed(offset: widget.value.length);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.error ? ArtTheme.danger : ArtTheme.ink;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(widget.label!, style: ArtTheme.subtitle.copyWith(fontSize: 13)),
            ),
          Stack(
            children: [
              Row(
                children: [
                  for (var index = 0; index < 4; index++) ...[
                    if (index > 0) const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 64,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ArtTheme.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor, width: 1.4),
                        ),
                        child: index < widget.value.length
                            ? Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: ArtTheme.ink,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : widget.focused && index == widget.value.length
                                ? Container(
                                    width: 18,
                                    height: 2,
                                    color: ArtTheme.magenta,
                                  )
                                : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ],
              ),
              if (widget.onTap != null)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: widget.onTap,
                  ),
                )
              else
              Positioned.fill(
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(color: Colors.transparent, fontSize: 1),
                  cursorColor: Colors.transparent,
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (raw) {
                    final next = raw.length > 4 ? raw.substring(0, 4) : raw;
                    widget.onChanged(next);
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(ArtCopy.current.tr('4 digits · Numbers only (0–9)'),
                style: ArtTheme.subtitle),
          ),
        ],
      ),
    );
  }
}

class ArtTabBar extends StatelessWidget {
  const ArtTabBar({
    Key? key,
    required this.position,
    required this.onSelect,
  }) : super(key: key);

  final double position;
  final ValueChanged<int> onSelect;

  static const double _pillWidth = 54;
  static const double _pillHeight = 34;

  @override
  Widget build(BuildContext context) {
    return _bar(position);
  }

  Widget _bar(double pos) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: ArtTheme.card,
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final slot = constraints.maxWidth / 4;
            final left = slot * pos + (slot - _pillWidth) / 2;
            return Stack(
              children: [
                Positioned(
                  left: left,
                  top: 0,
                  width: _pillWidth,
                  height: _pillHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: ArtTheme.magentaSoft,
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                ),
                Row(
                  children: [
                    _tab(0, pos, Icons.smartphone_outlined, 'Devices'),
                    _tab(1, pos, Icons.tune, 'Control'),
                    _tab(2, pos, Icons.settings_outlined, 'Settings'),
                    _tab(3, pos, Icons.wifi_tethering, 'Broadcast'),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _tab(int i, double pos, IconData icon, String label) {
    final emphasis = (1 - (pos - i).abs()).clamp(0.0, 1.0);
    final color = Color.lerp(ArtTheme.muted, ArtTheme.magenta, emphasis)!;
    return Expanded(
      child: InkWell(
        onTap: () => onSelect(i),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 34,
              child: Center(child: Icon(icon, color: color, size: 22)),
            ),
            const SizedBox(height: 2),
            Text(ArtCopy.current.tr(label),
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                )),
          ],
        ),
      ),
    );
  }
}

class ArtKeypad extends StatelessWidget {
  const ArtKeypad({
    Key? key,
    required this.onDigit,
    required this.onDelete,
  }) : super(key: key);

  final ValueChanged<String> onDigit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'del'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.1,
        children: keys.map((key) {
          if (key.isEmpty) return const SizedBox.shrink();
          final delete = key == 'del';
          return Material(
            color: ArtTheme.card,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => delete ? onDelete() : onDigit(key),
              child: Center(
                child: delete
                    ? const Icon(Icons.backspace_outlined, color: ArtTheme.ink)
                    : Text(key,
                        style: const TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: ArtTheme.ink,
                        )),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SearchRipples extends StatefulWidget {
  const SearchRipples({Key? key}) : super(key: key);

  @override
  State<SearchRipples> createState() => _SearchRipplesState();
}

class _SearchRipplesState extends State<SearchRipples>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4000),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _SearchRipplePainter(_controller.value),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _SearchRipplePainter extends CustomPainter {
  _SearchRipplePainter(this.t);

  final double t;
  static const Color _blue = Color(0xFF2F80ED);

  /// Baseline stroke; each wave scales 150% → 50% over its lifecycle.
  static const double _stroke = 2.2;
  static const double _strokeMaxMul = 1.5;
  static const double _strokeMinMul = 0.5;

  static const int _waveCount = 3;

  /// Cap so the outermost arc stays under ~1/3 of the screen long edge
  /// (portrait height; landscape width).
  static const double _maxRadiusFactor = 1.0 / 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    final center = Offset(size.width / 2, size.height);
    final maxRadius = math.max(size.width, size.height) * _maxRadiusFactor;
    for (var i = 0; i < _waveCount; i++) {
      final phase = (t + i / _waveCount) % 1.0;
      final strokeMul = _strokeMaxMul - phase * (_strokeMaxMul - _strokeMinMul);
      final opacity =
          ((strokeMul - _strokeMinMul) / (_strokeMaxMul - _strokeMinMul))
              .clamp(0.0, 1.0);
      if (opacity <= 0.01) continue;
      final radius = phase * maxRadius;
      if (radius <= 0.5) continue;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _stroke * strokeMul
        ..color = _blue.withValues(alpha: opacity);
      final rect = Rect.fromCircle(center: center, radius: radius);
      canvas.drawArc(rect, 3.141592653589793, 3.141592653589793, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SearchRipplePainter oldDelegate) =>
      oldDelegate.t != t;
}

/// Boot splash: plays [assets/videos/boot-logo-clean.mp4] once, then [onDone].
/// [BoxFit.contain] on white [#FFFFFFFF] so the full 1080×1920 frame is visible
/// without horizontal crop; empty bands stay white, not black letterbox.
/// [VideoPlayerOptions.mixWithOthers] so playback does not steal audio focus.
class ArtIntro extends StatefulWidget {
  const ArtIntro({Key? key, required this.onDone}) : super(key: key);

  final VoidCallback onDone;

  static const String assetPath = 'assets/videos/boot-logo-clean.mp4';

  @override
  State<ArtIntro> createState() => _ArtIntroState();
}

class _ArtIntroState extends State<ArtIntro> {
  static const Color _backdrop = Color(0xFFFFFFFF);

  VideoPlayerController? _controller;
  bool _finished = false;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final controller = VideoPlayerController.asset(
      ArtIntro.assetPath,
      // Silent splash must not pause other apps' music (Android AudioFocus).
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    try {
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      await controller.setVolume(0);
      await controller.setLooping(false);
      controller.addListener(_onTick);
      setState(() => _controller = controller);
      await controller.play();
      _started = true;
      // Safety: if the player never reports completion, advance anyway.
      final duration = controller.value.duration;
      final wait = duration > Duration.zero
          ? duration + const Duration(milliseconds: 800)
          : const Duration(seconds: 8);
      Future<void>.delayed(wait, _finish);
    } catch (_) {
      await controller.dispose();
      _finish();
    }
  }

  void _onTick() {
    final c = _controller;
    if (c == null || _finished) return;
    final v = c.value;
    if (!_started || !v.isInitialized) return;
    final d = v.duration;
    if (d <= Duration.zero) return;
    // Treat near-end or stopped-after-start as complete.
    if (v.position + const Duration(milliseconds: 120) >= d ||
        (!v.isPlaying && v.position > Duration.zero)) {
      _finish();
    }
  }

  void _finish() {
    if (_finished) return;
    _finished = true;
    if (mounted) widget.onDone();
  }

  @override
  void dispose() {
    final c = _controller;
    c?.removeListener(_onTick);
    c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Zero insets so SafeArea / notch padding cannot shift or squeeze the splash.
    final media = MediaQuery.of(context);
    final fullBleed = media.copyWith(
      padding: EdgeInsets.zero,
      viewPadding: EdgeInsets.zero,
    );
    final c = _controller;
    final Widget layer;
    if (c == null || !c.value.isInitialized) {
      layer = const ColoredBox(color: _backdrop, child: SizedBox.expand());
    } else {
      layer = ColoredBox(
        color: _backdrop,
        child: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.center,
            child: SizedBox(
              width: c.value.size.width,
              height: c.value.size.height,
              child: VideoPlayer(c),
            ),
          ),
        ),
      );
    }
    return MediaQuery(
      data: fullBleed,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: layer,
      ),
    );
  }
}
