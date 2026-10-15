import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/equalizer_activity_controller.dart';
import '../controllers/extra/application_controller.dart';
import '../controllers/extra/bluetooth_controller.dart';
import '../utils/language_util.dart';
import 'art_copy.dart';
import 'art_session.dart';
import '../generated/l10n.dart';
import 'art_theme.dart';
import 'art_widgets.dart';

Widget buildArtPage(BuildContext context, ArtSession session, {int? tab}) {
  final screen = tab == null ? session.screen : session.stacks[tab].last;
  switch (screen) {
    case ArtScreen.welcome:
      return _welcome(session);
    case ArtScreen.bluetoothAccess:
      return _bluetooth(session);
    case ArtScreen.findSpeakers:
      return _find(session);
    case ArtScreen.noSpeakers:
      return _none(session);
    case ArtScreen.connecting:
      return _connecting(session);
    case ArtScreen.setAdmin:
      return _setAdmin(session);
    case ArtScreen.adminSaved:
      return _adminSaved(session);
    case ArtScreen.devices:
      return _devices(session);
    case ArtScreen.control:
      return _control(session);
    case ArtScreen.audioSource:
      return _sources(session);
    case ArtScreen.equalizer:
      return _equalizer(session);
    case ArtScreen.settings:
      return _settings(session);
    case ArtScreen.rename:
      return _rename(session);
    case ArtScreen.audioSettings:
      return _audio(session);
    case ArtScreen.security:
      return _security(session);
    case ArtScreen.verifyAdmin:
      return _verify(session);
    case ArtScreen.changeAdmin:
      return _changeAdmin(session);
    case ArtScreen.changePin:
      return _changePin(session);
    case ArtScreen.pinOffConfirm:
      return _pinOffConfirm(context, session);
    case ArtScreen.pinOffSuccess:
      return _pinOffSuccess(context, session);
    case ArtScreen.pinUpdated:
      return _pinUpdated(context, session);
    case ArtScreen.renameSaved:
      return _renameSaved(session);
    case ArtScreen.productInfo:
      return _product(context, session);
    case ArtScreen.language:
      return _language(context, session);
    case ArtScreen.connectionLost:
      return _lost(session);
    case ArtScreen.saveFailed:
      return _saveFailed(session);
    case ArtScreen.broadcast:
      return _broadcast(session);
  }
}

Widget _scroll(List<Widget> children) {
  return ListView(
    padding: const EdgeInsets.only(bottom: 12),
    children: children,
  );
}

Widget _connectedLine(String name) {
  return Padding(
    padding: const EdgeInsets.only(left: 12, top: 4),
    child: Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF3CB371),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text('$name · ${ArtCopy.current.tr('Connected')}', style: ArtTheme.subtitle),
      ],
    ),
  );
}

Widget _section(String text) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
    child: Text(
      ArtCopy.current.tr(text),
      style: ArtTheme.subtitle.copyWith(fontSize: 12, letterSpacing: 0.4),
    ),
  );
}

Widget _welcome(ArtSession session) {
  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('Welcome'),
      subtitle: ArtCopy.current.tr('Your sound starts here'),
    ),
    if (session.linkDropped)
      ArtWash(
        child: Text(
          ArtCopy.current.tr('Connection lost'),
          style: ArtTheme.body,
        ),
      ),
    Container(
      height: 230,
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      padding: const EdgeInsets.fromLTRB(20, 22, 16, 18),
      decoration: BoxDecoration(
        color: ArtTheme.hero,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          const Positioned(
            right: 0,
            top: 8,
            child: Rings(diameter: 150, color: ArtTheme.ring),
          ),
          const Text(
            'WE SPEAK',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.05,
            ),
          ),
          const Positioned(
            top: 32,
            child: Text(
              'SOUND',
              style: TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: ArtTheme.sound,
                height: 1.05,
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Text(
              ArtCopy.current.tr('Make yourself at home.'),
              style: TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
    Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Text(
        ArtCopy.current.tr('Connect an ArtSound speaker'),
        style: TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: ArtTheme.ink,
        ),
      ),
    ),
    Padding(
      padding: EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Text(
        ArtCopy.current.tr('One connection. Your everyday controls.'),
        style: ArtTheme.subtitle,
      ),
    ),
    ArtButton(label: ArtCopy.current.tr('Find speakers'), onPressed: session.findSpeakers),
  ]);
}

Widget _bluetooth(ArtSession session) {
  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('Bluetooth access'),
      subtitle: ArtCopy.current.tr('First use only'),
      centerLogo: true,
      onBack: session.handleBack,
    ),
    const SizedBox(height: 24),
    const Center(child: Rings()),
    const SizedBox(height: 28),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        ArtCopy.current.tr('Find your nearby speaker'),
        style: TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: ArtTheme.ink,
        ),
      ),
    ),
    ArtWash(
      child: Text(
        ArtCopy.current.tr('Allow Bluetooth access to discover and control your speaker. The system asks for permission.'),
        style: ArtTheme.body,
      ),
    ),
    const SizedBox(height: 12),
    ArtButton(
      label: ArtCopy.current.tr('Continue'),
      onPressed: session.busy ? null : session.continueBluetooth,
    ),
    Center(
      child: TextButton(
        onPressed: session.handleBack,
        child: Text(ArtCopy.current.tr('Not now'), style: ArtTheme.subtitle),
      ),
    ),
  ]);
}

Widget _find(ArtSession session) {
  final subtitle = session.searching
      ? 'Searching for nearby devices...'
      : session.connectFailed
          ? 'Could not connect'
          : 'Search finished';
  return Column(
    children: [
      SizedBox(
        width: double.infinity,
        height: 52,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                ArtCopy.current.tr('Find speakers'),
                textAlign: TextAlign.center,
                style: ArtTheme.title,
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          ArtCopy.current.tr(subtitle),
          textAlign: TextAlign.center,
          style: ArtTheme.subtitle,
        ),
      ),
      Expanded(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.only(bottom: 12),
              children: [
                ...session.found.map((info) {
                  return ArtCard(
                    title: session.nameOf(info),
                    detail: 'Available · ArtSound',
                    onTap: () => session.connect(info),
                  );
                }),
                ArtWash(
                  child: Text(
                    ArtCopy.current.tr(
                        'The list updates while searching.\nTap a speaker to connect and check setup.'),
                    style: ArtTheme.body,
                  ),
                ),
                const SizedBox(height: 24),
                ArtButton(
                  label: session.searching ? 'Stop search' : 'Continue search',
                  filled: false,
                  onPressed: session.searching
                      ? session.stopSearch
                      : session.startSearch,
                ),
              ],
            ),
            if (session.searching) const Positioned.fill(child: SearchRipples()),
          ],
        ),
      ),
    ],
  );
}

Widget _none(ArtSession session) {
  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('No speakers found'),
      subtitle: ArtCopy.current.tr('Search completed'),
      onBack: session.handleBack,
    ),
    const SizedBox(height: 12),
    const Center(child: Rings()),
    const SizedBox(height: 24),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        ArtCopy.current.tr('Let’s find your speaker'),
        style: TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: ArtTheme.ink,
        ),
      ),
    ),
    ArtWash(
      child: Text(
        ArtCopy.current.tr('1. Turn on the speaker.\n2. Keep the phone close to it.\n3. Check Bluetooth access in phone settings.'),
        style: ArtTheme.body,
      ),
    ),
    const SizedBox(height: 12),
    ArtButton(label: ArtCopy.current.tr('Search again'), onPressed: session.startSearch),
  ]);
}

Widget _connecting(ArtSession session) {
  final name = session.speakerName;
  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('Connecting'),
      subtitle: name,
      onBack: session.handleBack,
    ),
    const SizedBox(height: 36),
    const Center(child: Rings()),
    const SizedBox(height: 28),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Connecting to $name...',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: ArtTheme.ink,
        ),
      ),
    ),
    Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Text(
        ArtCopy.current.tr('Controls appear once connection is confirmed.'),
        textAlign: TextAlign.center,
        style: ArtTheme.subtitle,
      ),
    ),
    ArtButton(
      label: ArtCopy.current.tr('Cancel'),
      filled: false,
      onPressed: session.cancelConnect,
    ),
  ]);
}

Widget _setAdmin(ArtSession session) {
  final match = session.adminNew.length == 4 &&
      session.adminConfirm.length == 4 &&
      session.adminNew == session.adminConfirm;
  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('Set admin password'),
      subtitle: '${session.speakerName} · First setup required',
      centerLogo: true,
      onBack: session.handleBack,
    ),
    const ArtWash(
      child: Text(
        'Create an admin password to finish first setup.\nIt protects speaker name and security settings.\nIt is different from the Bluetooth connection PIN.',
        style: ArtTheme.body,
      ),
    ),
    PinBoxes(
      label: ArtCopy.current.tr('New admin password'),
      value: session.adminNew,
      focused: session.keypad == ArtPinField.adminNew,
      onTap: () => session.focusPin(ArtPinField.adminNew),
      onChanged: (_) {},
    ),
    const SizedBox(height: 12),
    PinBoxes(
      label: ArtCopy.current.tr('Confirm admin password'),
      value: session.adminConfirm,
      error: session.adminConfirm.length == 4 &&
          session.adminNew != session.adminConfirm,
      focused: session.keypad == ArtPinField.adminConfirm,
      onTap: () => session.focusPin(ArtPinField.adminConfirm),
      onChanged: (_) {},
    ),
    Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Text(
        ArtCopy.current.tr('Both four-digit entries must match.'),
        style: ArtTheme.subtitle,
      ),
    ),
    if (session.adminSaveError)
      Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Text(
          ArtCopy.current.tr('The speaker did not confirm the password.'),
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            color: ArtTheme.danger,
          ),
        ),
      ),
    const SizedBox(height: 8),
    ArtButton(
      label: ArtCopy.current.tr('Save and continue'),
      onPressed: match && !session.busy ? session.saveAdminPassword : null,
    ),
    ArtButton(
      label: ArtCopy.current.tr('Choose another speaker'),
      filled: false,
      onPressed: session.chooseAnother,
    ),
  ]);
}

Widget _adminSaved(ArtSession session) {
  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('Admin password saved'),
      subtitle: '${session.speakerName} · First setup complete',
      centerLogo: true,
      onBack: session.handleBack,
    ),
    const SizedBox(height: 12),
    const Center(
      child: SizedBox(
        width: 180,
        height: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Rings(diameter: 180),
            _CheckBadge(),
          ],
        ),
      ),
    ),
    const SizedBox(height: 16),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        ArtCopy.current.tr('Setup complete'),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: ArtTheme.ink,
        ),
      ),
    ),
    ArtWash(
      child: Text(
        ArtCopy.current.tr('Keep your admin password in a safe place.\nUse it to change protected settings.\nDaily audio controls do not require repeated entry.'),
        style: ArtTheme.body,
      ),
    ),
    ArtButton(label: ArtCopy.current.tr('Open controls'), onPressed: session.openControls),
  ]);
}

class _CheckBadge extends StatelessWidget {
  const _CheckBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        color: ArtTheme.magenta,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, color: Colors.white, size: 36),
    );
  }
}

Widget _devices(ArtSession session) {
  final connected = session.connectedInfo;
  final others = session.found.where((item) {
    return item.device?.address != connected?.device?.address;
  });
  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('Devices'),
      subtitle: ArtCopy.current.tr('Manage your speaker connections'),
    ),
    if (!session.setupDone)
      ArtWash(
        child: Text(
          ArtCopy.current.tr('Setup is not confirmed yet. Controls stay off until the speaker reports an admin password.'),
          style: ArtTheme.body,
        ),
      ),
    if (connected != null) ...[
      _section(ArtCopy.current.tr('CONNECTED DEVICE')),
      ArtCard(
        title: session.nameOf(connected),
        detail: ArtCopy.current.tr('Connected · Current speaker'),
        selected: true,
        onTap: () {},
        trailing: const Icon(Icons.check_circle, color: ArtTheme.magenta),
      ),
      ArtButton(
        label: ArtCopy.current.tr('Open controls'),
        onPressed: session.ready ? session.openControls : null,
      ),
      ArtButton(
        label: ArtCopy.current.tr('Disconnect speaker'),
        filled: false,
        onPressed: session.disconnectSpeaker,
      ),
    ],
    _section(ArtCopy.current.tr('AVAILABLE DEVICES')),
    ...others.map((info) {
      return ArtCard(
        title: session.nameOf(info),
        detail: connected == null
            ? ArtCopy.current.tr('Available · ArtSound')
            : ArtCopy.current.tr('Available · Tap to switch speaker'),
        onTap: () => session.connect(info),
      );
    }),
    ArtButton(
      label: ArtCopy.current.tr('Find more speakers'),
      filled: false,
      onPressed: session.startSearch,
    ),
    if (connected != null)
      ArtWash(
        child: Text(
          ArtCopy.current.tr('Switching disconnects the current speaker first.'),
          style: ArtTheme.body,
        ),
      ),
  ]);
}

Widget _broadcast(ArtSession session) {
  final ready = session.ready;
  final hosts = session.auracastHosts;
  final subtitle = !ready
      ? 'Connect a speaker and finish setup first'
      : session.auracastBusy
          ? 'Sending selection…'
          : session.auracastScanning
              ? 'Scanning for broadcast hosts…'
              : hosts.isEmpty
                  ? 'No broadcast hosts yet'
                  : 'Tap a host to join';
  return Column(
    children: [
      ArtHeader(title: ArtCopy.current.tr('Broadcast')),
      if (ready)
        _connectedLine(session.speakerName)
      else
        Padding(
          padding: const EdgeInsets.only(left: 32, top: 4),
          child: Text(
            ArtCopy.current.tr('Connect a speaker and finish setup first'),
            style: ArtTheme.subtitle,
          ),
        ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Text(
          ArtCopy.current.tr(subtitle),
          textAlign: TextAlign.center,
          style: ArtTheme.subtitle,
        ),
      ),
      if (session.auracastError != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Text(
            ArtCopy.current.tr(session.auracastError!),
            textAlign: TextAlign.center,
            style: ArtTheme.body.copyWith(color: ArtTheme.magenta),
          ),
        ),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 12),
          children: [
            if (ready) ...[
              ...hosts.map((host) {
                final selected = session.auracastSelectedKey == host.addressKey;
                return ArtCard(
                  title: host.name.isEmpty
                      ? ArtCopy.current.tr('Unknown host')
                      : host.name,
                  detail: selected
                      ? '${host.addressKey} · ${ArtCopy.current.tr('Selected')}'
                      : host.addressKey,
                  onTap: session.auracastBusy
                      ? null
                      : () => session.selectAuracastHost(host),
                );
              }),
              ArtWash(
                child: Text(
                  ArtCopy.current.tr(
                      'The speaker (BP1048) asks QCC3095 to scan Auracast broadcasters.\nResults appear here. Tap one to stop scanning and send the address.'),
                  style: ArtTheme.body,
                ),
              ),
              const SizedBox(height: 16),
              ArtButton(
                label: session.auracastScanning
                    ? ArtCopy.current.tr('Stop scan')
                    : ArtCopy.current.tr('Start scan'),
                filled: !session.auracastScanning,
                onPressed: session.auracastBusy
                    ? null
                    : session.auracastScanning
                        ? () => session.stopAuracastScan()
                        : () => session.startAuracastScan(),
              ),
            ] else
              ArtWash(
                child: Text(
                  ArtCopy.current.tr(
                      'Connect and finish setup on the Devices tab before using Broadcast.'),
                  style: ArtTheme.body,
                ),
              ),
          ],
        ),
      ),
    ],
  );
}

Widget _control(ArtSession session) {
  final ready = session.ready;
  final shown =
      session.bt.isInitPlayStatus ? session.bt.volume.clamp(0, 100) : 0;
  return _scroll([
    ArtHeader(title: ArtCopy.current.tr('Control')),
    if (ready)
      _connectedLine(session.speakerName)
    else
      Padding(
        padding: EdgeInsets.only(left: 32, top: 4),
        child: Text(
          ArtCopy.current.tr('Connect a speaker and finish setup first'),
          style: ArtTheme.subtitle,
        ),
      ),
    const SizedBox(height: 12),
    ArtCard(
      title: ArtCopy.current.tr('Audio source'),
      detail: ready
          ? '${ArtCopy.current.tr(session.inputLabel())} · ${ArtCopy.current.tr('Change input')}'
          : ArtCopy.current.tr('Unavailable'),
      inactiveNote: ready ? null : ArtCopy.current.tr('Waiting for a confirmed connection'),
      onTap: ready ? () => session.push(ArtScreen.audioSource) : null,
    ),
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: BoxDecoration(
        color: ArtTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ArtTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ArtCopy.current.tr('Volume'),
              style: TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ArtTheme.ink,
              )),
          const SizedBox(height: 8),
          Text(
            session.bt.isInitPlayStatus ? '$shown' : '—',
            style: const TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: ArtTheme.ink,
              height: 1,
            ),
          ),
          Slider(
            value: shown.toDouble().clamp(0, 100),
            min: 0,
            max: 100,
            activeColor: ArtTheme.magenta,
            inactiveColor: ArtTheme.line,
            onChanged: ready && session.bt.isInitPlayStatus
                ? (value) => session.setVolume(value.round())
                : null,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0', style: ArtTheme.subtitle),
              Text('100', style: ArtTheme.subtitle),
            ],
          ),
          if (session.volumeUpdating)
            Text(ArtCopy.current.tr('Updating'), style: ArtTheme.subtitle),
          if (session.volumeFailed)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => session.setVolume(session.bt.volume),
                child: Text(ArtCopy.current.tr('Retry')),
              ),
            ),
        ],
      ),
    ),
    ArtCard(
      title: ArtCopy.current.tr('Equalizer'),
      detail: ready
          ? ArtCopy.current.tr(session.equalizerLabel())
          : ArtCopy.current.tr('Unavailable'),
      inactiveNote: ready ? null : ArtCopy.current.tr('Waiting for a confirmed connection'),
      onTap: ready ? () => session.push(ArtScreen.equalizer) : null,
    ),
    _switchRow(
      title: 'Indicator light',
      value: session.bt.isIndicatorLightOn,
      enabled: ready,
      onChanged: session.setIndicatorLight,
    ),
    _switchRow(
      title: 'Voice prompt',
      value: session.bt.isSoundTipsOn,
      enabled: ready,
      onChanged: session.setVoicePrompt,
    ),
  ]);
}

Widget _switchRow({
  required String title,
  required bool value,
  required bool enabled,
  required ValueChanged<bool> onChanged,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
    padding: const EdgeInsets.fromLTRB(16, 6, 10, 6),
    decoration: BoxDecoration(
      color: ArtTheme.card,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: ArtTheme.line),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            ArtCopy.current.tr(title),
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: enabled ? ArtTheme.ink : ArtTheme.muted,
            ),
          ),
        ),
        Switch(
          value: value,
          activeThumbColor: Colors.white,
          activeTrackColor: ArtTheme.magenta,
          onChanged: enabled ? onChanged : null,
        ),
      ],
    ),
  );
}

Widget _sources(ArtSession session) {
  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('Audio source'),
      subtitle:
          '${session.speakerName} · ${ArtCopy.current.tr('Select an input')}',
      centerLogo: true,
      onBack: session.handleBack,
    ),
    if (!session.inputsLoaded)
      ArtWash(
        child: Text(ArtCopy.current.tr('Waiting for the speaker to report its inputs.'),
            style: ArtTheme.body),
      ),
    ...artInputs.where((input) => session.inputReported(input.id)).map((input) {
      final current = session.inputCurrent(input.id);
      return ArtCard(
        title: ArtCopy.current.tr(input.label),
        detail: current ? ArtCopy.current.tr('Current input') : ArtCopy.current.tr('Switch to this input'),
        selected: current,
        onTap: current ? null : () => session.selectInput(input.id),
        trailing: current
            ? const Icon(Icons.check_circle, color: ArtTheme.magenta)
            : null,
      );
    }),
  ]);
}

Widget _equalizer(ArtSession session) {
  final on = session.bt.isEqualizerOn;
  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('Equalizer'),
      centerLogo: true,
      onBack: session.handleBack,
    ),
    _connectedLine(session.speakerName),
    const SizedBox(height: 8),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(ArtCopy.current.tr('Equalizer'),
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ArtTheme.ink,
                )),
          ),
          Switch(
            value: on,
            activeThumbColor: Colors.white,
            activeTrackColor: ArtTheme.magenta,
            onChanged: session.ready ? session.toggleEqualizer : null,
          ),
        ],
      ),
    ),
    if (!on) ...[
      const SizedBox(height: 24),
      const Center(child: Rings()),
      const SizedBox(height: 16),
      Text(
        ArtCopy.current.tr('Equalizer is off'),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: ArtTheme.ink,
        ),
      ),
      ArtWash(
        child: Text(
          ArtCopy.current.tr('Turn on EQ to select a preset or adjust bands.\nYour last settings are kept for the next use.'),
          style: ArtTheme.body,
        ),
      ),
    ] else ...[
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Text(ArtCopy.current.tr('Mode selection'),
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ArtTheme.ink,
            )),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _presetChip(session, EqualizerType.FLAT, 'Flat'),
            _presetChip(session, EqualizerType.CLASSICAL, 'Classic'),
            _presetChip(session, EqualizerType.POP, 'Pop'),
            _presetChip(session, EqualizerType.ROCK, 'Rock'),
            _presetChip(session, EqualizerType.JAZZ, 'Jazz'),
            _presetChip(session, EqualizerType.VOCAL, 'Vocal boost'),
            _presetChip(session, EqualizerType.CUSTOM, 'Custom'),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
        child: Text(ArtCopy.current.tr('Equalizer'),
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ArtTheme.ink,
            )),
      ),
      _bands(session),
      if (session.bt.selectEqualizerMode == EqualizerType.CUSTOM)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            ArtCopy.current.tr('Changes apply in real time.'),
            textAlign: TextAlign.center,
            style: ArtTheme.subtitle,
          ),
        ),
    ],
    if (session.eqUpdating)
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          ArtCopy.current.tr('Updating'),
          textAlign: TextAlign.center,
          style: ArtTheme.subtitle,
        ),
      ),
    if (session.eqFailed)
      ArtButton(
        label: ArtCopy.current.tr('Retry'),
        onPressed: session.busy ? null : session.retryEqualizer,
      ),
  ]);
}

Widget _presetChip(ArtSession session, EqualizerType type, String label) {
  final selected = session.bt.selectEqualizerMode == type;
  return _chip(ArtCopy.current.tr(label), selected, () => session.applyPreset(type));
}

Widget _chip(String label, bool selected, VoidCallback onTap) {
  return Material(
    color: selected ? ArtTheme.magentaSoft : ArtTheme.card,
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 104,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? ArtTheme.magenta : ArtTheme.line),
        ),
        child: Text(ArtCopy.current.tr(label),
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontWeight: FontWeight.w600,
              color: selected ? ArtTheme.magenta : ArtTheme.ink,
            )),
      ),
    ),
  );
}

Widget _bands(ArtSession session) {
  const labels = ['60', '150', '400', '1k', '2.4k', '5k'];
  final loaded = session.bandsLoaded;
  return Container(
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
    padding: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: ArtTheme.card,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: ArtTheme.line),
    ),
    child: Column(
      children: [
        SizedBox(
          height: 180,
          child: Row(
            children: List.generate(6, (index) {
              final value = loaded ? session.bandValue(index).toDouble() : 0.0;
              return Expanded(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Slider(
                    value: value,
                    min: 0,
                    max: 24,
                    activeColor: ArtTheme.magenta,
                    onChanged: loaded &&
                            session.bt.selectEqualizerMode ==
                                EqualizerType.CUSTOM
                        ? (next) => session.setBand(index, next.round())
                        : null,
                  ),
                ),
              );
            }),
          ),
        ),
        Row(
          children: labels
              .map((label) => Expanded(
                    child: Text(label,
                        textAlign: TextAlign.center,
                        style: ArtTheme.subtitle.copyWith(fontSize: 12)),
                  ))
              .toList(),
        ),
        Row(
          children: List.generate(6, (index) {
            final text = loaded ? '${session.bandValue(index)}' : '—';
            return Expanded(
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontWeight: FontWeight.w700,
                    color: ArtTheme.ink,
                  )),
            );
          }),
        ),
        if (!loaded)
          Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(ArtCopy.current.tr('Band values are not reported yet.'),
                style: ArtTheme.subtitle),
          ),
      ],
    ),
  );
}

Widget _settings(ArtSession session) {
  final ready = session.ready;
  return _scroll([
    ArtHeader(title: ArtCopy.current.tr('Settings')),
    if (session.sessionConnected)
      _connectedLine(session.speakerName)
    else
      Padding(
        padding: EdgeInsets.only(left: 32),
        child: Text(ArtCopy.current.tr('No speaker connected'), style: ArtTheme.subtitle),
      ),
    _section(ArtCopy.current.tr('DEVICE · PROTECTED SETTINGS')),
    ArtCard(
      title: ArtCopy.current.tr('Speaker name'),
      detail: ready ? session.speakerName : ArtCopy.current.tr('Unavailable'),
      inactiveNote: ready ? null : ArtCopy.current.tr('Finish connection and setup first'),
      onTap: ready ? () => session.openProtected(ArtGuard.name) : null,
      trailing: const Icon(Icons.chevron_right, color: ArtTheme.ink),
    ),
    ArtCard(
      title: ArtCopy.current.tr('Audio settings'),
      detail: ArtCopy.current.tr('Stereo / mono · Volume limit'),
      inactiveNote: ready ? null : ArtCopy.current.tr('Finish connection and setup first'),
      onTap: ready ? () => session.openProtected(ArtGuard.audio) : null,
    ),
    ArtCard(
      title: 'Connection PIN',
      detail: ready ? _pinStatusKey(session) : 'Unavailable',
      inactiveNote: ready ? null : 'Finish connection and setup first',
      onTap: ready ? () => session.openProtected(ArtGuard.pin) : null,
    ),
    ArtCard(
      title: 'Admin password',
      detail: ready ? _adminStatusKey(session) : 'Unavailable',
      inactiveNote: ready ? null : 'Finish connection and setup first',
      onTap: ready ? () => session.openProtected(ArtGuard.admin) : null,
    ),
    _section(ArtCopy.current.tr('GENERAL')),
    ArtCard(
      title: ArtCopy.current.tr('Product information'),
      detail: ArtCopy.current.tr('Model and versions'),
      inactiveNote: session.sessionConnected ? null : ArtCopy.current.tr('Connect a speaker first'),
      onTap: session.sessionConnected ? session.openProduct : null,
    ),
    ArtCard(
      title: ArtCopy.current.tr('Language'),
      detail: session.languageName(),
      translateDetail: false,
      onTap: session.openLanguage,
    ),
  ]);
}

Widget _rename(ArtSession session) {
  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('Rename speaker'),
      centerLogo: true,
      onBack: session.handleBack,
    ),
    _connectedLine(session.speakerName),
    _section(ArtCopy.current.tr('SPEAKER NAME')),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _NameField(
        value: session.renameDraft,
        onChanged: session.editName,
      ),
    ),
    Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(ArtCopy.current.tr('Quick names'),
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: ArtTheme.ink,
          )),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: artQuickNames.map((name) {
          return SizedBox(
            width: 150,
            child: OutlinedButton(
              onPressed: () => session.editName(ArtCopy.current.tr(name)),
              child: Text(ArtCopy.current.tr(name)),
            ),
          );
        }).toList(),
      ),
    ),
    ArtWash(
      child: Text(
        ArtCopy.current.tr('Tap a room to fill the name, then Save.\nChoose a name that is easy to recognise.'),
        style: ArtTheme.body,
      ),
    ),
    if (session.errorLine != null)
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(session.errorLine!,
            style: const TextStyle(
              fontFamily: 'HelveticaNeue',
              color: ArtTheme.danger,
            )),
      ),
    ArtButton(
      label: ArtCopy.current.tr('Save name'),
      onPressed: session.renameDraft.trim().isEmpty || session.busy
          ? null
          : session.saveName,
    ),
  ]);
}

class _NameField extends StatefulWidget {
  const _NameField({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<_NameField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(_NameField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
      _controller.selection =
          TextSelection.collapsed(offset: widget.value.length);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      style: ArtTheme.body,
      decoration: InputDecoration(
        filled: true,
        fillColor: ArtTheme.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ArtTheme.line),
        ),
      ),
    );
  }
}

Widget _audio(ArtSession session) {
  final step = session.draftLimit;
  final percent =
      step == null ? null : ArtSession.limitPercentForType(step);
  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('Audio settings'),
      centerLogo: true,
      onBack: session.handleBack,
    ),
    _connectedLine(session.speakerName),
    Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(ArtCopy.current.tr('Channel mode'),
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: ArtTheme.ink,
          )),
    ),
    if (!session.audioLoaded)
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(ArtCopy.current.tr('Waiting for the speaker.'), style: ArtTheme.subtitle),
      ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _modeButton(ArtCopy.current.tr('Stereo'), session.draftMono == false, () => session.setDraftMono(false))),
          const SizedBox(width: 10),
          Expanded(child: _modeButton(ArtCopy.current.tr('Mono'), session.draftMono == true, () => session.setDraftMono(true))),
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Text(
        percent == null
            ? ArtCopy.current.tr('Maximum volume · not reported')
            : '${ArtCopy.current.tr('Maximum volume')} · $percent%',
        style: ArtTheme.subtitle,
      ),
    ),
    Slider(
      value: (percent ?? 25).toDouble(),
      min: 25,
      max: 100,
      divisions: 3,
      activeColor: ArtTheme.magenta,
      inactiveColor: ArtTheme.line,
      onChanged: step == null
          ? null
          : (value) {
              session.beginDragAudioLimit();
              final snapped = value.round();
              session.setDraftLimit(
                  ArtSession.limitTypeForUiPercent(snapped));
            },
      onChangeEnd: (_) => session.endDragAudioLimit(),
    ),
    ArtWash(
      child: Text(
        ArtCopy.current.tr('This sets the speaker maximum output (25 / 50 / 75 / 100).\nDaily volume remains on the Control tab.\nControl volume is separate from this limiter setting.'),
        style: ArtTheme.body,
      ),
    ),
    if (session.errorLine != null)
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(session.errorLine!,
            style: const TextStyle(
              fontFamily: 'HelveticaNeue',
              color: ArtTheme.danger,
            )),
      ),
    ArtButton(
      label: ArtCopy.current.tr('Save changes'),
      onPressed: session.audioSettingsDirty &&
              session.draftLimit != null &&
              !session.busy
          ? session.saveAudio
          : null,
    ),
  ]);
}

Widget _modeButton(String label, bool selected, VoidCallback onTap) {
  return Material(
    color: selected ? ArtTheme.magenta : ArtTheme.card,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? ArtTheme.magenta : ArtTheme.line),
        ),
        child: Text(label,
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : ArtTheme.ink,
            )),
      ),
    ),
  );
}

String _pinStatusKey(ArtSession session) {
  if (!session.bt.isInitPinStatus) return 'Waiting · Used for Bluetooth pairing';
  return session.bt.isPinOn
      ? 'On · Used for Bluetooth pairing'
      : 'Off · Used for Bluetooth pairing';
}

String _adminStatusKey(ArtSession session) {
  if (session.bt.adminPasswordStatus == AdminPasswordStatus.HaveSet ||
      session.setupDone) {
    return 'Set · Protects speaker settings';
  }
  return 'Not confirmed · Protects speaker settings';
}

Widget _security(ArtSession session) {
  final pin = _pinStatusKey(session);
  final admin = _adminStatusKey(session);
  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('Security'),
      centerLogo: true,
      onBack: session.handleBack,
    ),
    _connectedLine(session.speakerName),
    const SizedBox(height: 8),
    ArtCard(
      title: ArtCopy.current.tr('Connection PIN'),
      detail: pin,
      onTap: session.openChangePin,
    ),
    ArtCard(
      title: ArtCopy.current.tr('Admin password'),
      detail: admin,
      onTap: session.openChangeAdmin,
    ),
    ArtWash(
      child: Text(
        ArtCopy.current.tr('PIN controls who can pair to the speaker.\nAdmin password protects selected settings.\nFirst setup requires an admin password.'),
        style: ArtTheme.body,
      ),
    ),
  ]);
}

String _fill(String english, String target) {
  return ArtCopy.current.tr(english).replaceAll('{target}', target);
}

Widget _verify(ArtSession session) {
  String target = ArtCopy.current.tr('Speaker name');
  if (session.guard == ArtGuard.audio) target = ArtCopy.current.tr('Audio settings');
  if (session.guard == ArtGuard.security) target = ArtCopy.current.tr('Security');
  if (session.guard == ArtGuard.pin) target = ArtCopy.current.tr('Connection PIN');
  if (session.guard == ArtGuard.admin) target = ArtCopy.current.tr('Admin password');
  final complete = session.verifyPin.length == 4;
  final crumb = _fill('Settings → {target}', target);
  final subtitle = complete ? crumb : _fill('Settings → {target} · Enter 4 digits', target);
  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('Verify admin'),
      subtitle: subtitle,
      centerLogo: true,
      onBack: session.handleBack,
    ),
    ArtWash(
      child: Text(
        _fill(
            'Verify to change {target}.\nAfter verification, protected settings stay open until disconnect.',
            target),
        style: ArtTheme.body,
      ),
    ),
    PinBoxes(
      label: ArtCopy.current.tr('Current password'),
      value: session.verifyPin,
      error: session.verifyError,
      focused: session.keypad == ArtPinField.verify,
      onTap: () => session.focusPin(ArtPinField.verify),
      onChanged: (_) {},
    ),
    if (session.verifyError)
      Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Text(
          ArtCopy.current.tr('Incorrect password. Try again.'),
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            color: ArtTheme.danger,
          ),
        ),
      ),
    const SizedBox(height: 8),
    ArtButton(
      label: ArtCopy.current.tr('Continue'),
      onPressed: complete && !session.busy ? session.verifyAdmin : null,
    ),
    if (!complete)
      Padding(
        padding: EdgeInsets.only(top: 4),
        child: Text(
          ArtCopy.current.tr('Enter all four digits to continue.'),
          textAlign: TextAlign.center,
          style: ArtTheme.subtitle,
        ),
      ),
  ]);
}

Widget _changeAdmin(ArtSession session) {
  final match = session.changeAdminNew.length == 4 &&
      session.changeAdminNew == session.changeAdminConfirm;
  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('Admin password'),
      subtitle: '${session.speakerName} · Change password',
      centerLogo: true,
      onBack: session.handleBack,
    ),
    PinBoxes(
      label: ArtCopy.current.tr('New password'),
      value: session.changeAdminNew,
      focused: session.keypad == ArtPinField.changeNew,
      onTap: () => session.focusPin(ArtPinField.changeNew),
      onChanged: (_) {},
    ),
    const SizedBox(height: 12),
    PinBoxes(
      label: ArtCopy.current.tr('Confirm password'),
      value: session.changeAdminConfirm,
      error: session.changeAdminConfirm.length == 4 && !match,
      focused: session.keypad == ArtPinField.changeConfirm,
      onTap: () => session.focusPin(ArtPinField.changeConfirm),
      onChanged: (_) {},
    ),
    ArtWash(
      child: Text(
        ArtCopy.current.tr('Use four digits. Both entries must match.\nKeep your password in a safe place.'),
        style: ArtTheme.body,
      ),
    ),
    if (session.adminSaveError)
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          ArtCopy.current.tr('The speaker did not confirm the password.'),
          style: TextStyle(fontFamily: 'HelveticaNeue', color: ArtTheme.danger),
        ),
      ),
    ArtButton(
      label: ArtCopy.current.tr('Save password'),
      onPressed: match && !session.busy ? session.saveChangedAdmin : null,
    ),
  ]);
}

Widget _changePin(ArtSession session) {
  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('Connection PIN'),
      centerLogo: true,
      onBack: session.handleBack,
    ),
    _connectedLine(session.speakerName),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(ArtCopy.current.tr('PIN protection'),
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ArtTheme.ink,
                )),
          ),
          Switch(
            value: session.bt.isPinOn,
            activeThumbColor: Colors.white,
            activeTrackColor: ArtTheme.magenta,
            onChanged: session.bt.isInitPinStatus && !session.busy
                ? session.setPinProtection
                : null,
          ),
        ],
      ),
    ),
    if (!session.bt.isInitPinStatus)
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(ArtCopy.current.tr('Waiting for PIN status.'), style: ArtTheme.subtitle),
      ),
    PinBoxes(
      label: ArtCopy.current.tr('New connection pin'),
      value: session.connectionPin,
      focused: session.keypad == ArtPinField.pinNew,
      onTap: () => session.focusPin(ArtPinField.pinNew),
      onChanged: (_) {},
    ),
    ArtWash(
      child: Text(
        ArtCopy.current.tr('New pairings will require this four-digit PIN.\nChanging it may disconnect this device.'),
        style: ArtTheme.body,
      ),
    ),
    if (session.errorLine != null)
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(session.errorLine!,
            style: const TextStyle(
              fontFamily: 'HelveticaNeue',
              color: ArtTheme.danger,
            )),
      ),
    ArtButton(
      label: ArtCopy.current.tr('Save PIN'),
      onPressed: session.connectionPin.length == 4 && !session.busy
          ? session.saveConnectionPin
          : null,
    ),
  ]);
}

Widget _pinOffConfirm(BuildContext context, ArtSession session) {
  final copy = S.of(context);
  return _scroll([
    ArtHeader(
      title: copy.dialog_will_pin_off_title,
      centerLogo: true,
      onBack: session.handleBack,
    ),
    const SizedBox(height: 24),
    ArtButton(
      label: copy.dialog_update_pin_code_now_button_text,
      onPressed: session.busy ? null : session.confirmPinOffReboot,
    ),
    ArtButton(
      label: copy.cancel,
      filled: false,
      onPressed: session.busy ? null : session.cancelPinOff,
    ),
  ]);
}

Widget _pinOffSuccess(BuildContext context, ArtSession session) {
  final copy = S.of(context);
  return _scroll([
    ArtHeader(
      title: copy.dialog_pin_off_title,
      centerLogo: true,
      onBack: session.handleBack,
    ),
    ArtWash(
      child: Text(copy.dialog_pin_off_tips, style: ArtTheme.body),
    ),
    ArtButton(
      label: copy.dialog_bluetooth_settings_text,
      onPressed: session.openBluetoothSettings,
    ),
  ]);
}

Widget _pinUpdated(BuildContext context, ArtSession session) {
  final copy = S.of(context);
  final code = session.savedConnectionPin;
  return _scroll([
    ArtHeader(
      title: copy.dialog_update_pin_success_title,
      centerLogo: true,
      onBack: session.handleBack,
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
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
                  border: Border.all(color: ArtTheme.ink, width: 1.4),
                ),
                child: Text(
                  index < code.length ? code[index] : '',
                  style: const TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: ArtTheme.ink,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    ),
    ArtWash(
      child: Text(copy.dialog_update_pin_success_tips, style: ArtTheme.body),
    ),
    ArtButton(
      label: 'Confirm',
      onPressed: session.handleBack,
    ),
  ]);
}

Widget _renameSaved(ArtSession session) {
  return _scroll([
    ArtHeader(
      title: 'Name saved',
      centerLogo: true,
      onBack: session.handleBack,
    ),
    Padding(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
      child: Text(
        session.savedName,
        style: const TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: ArtTheme.ink,
        ),
      ),
    ),
    ArtButton(
      label: 'Confirm',
      onPressed: session.handleBack,
    ),
  ]);
}

Widget _product(BuildContext context, ArtSession session) {
  final app = context.read<ApplicationController>();
  final version = _appVersion(app);
  String field(String? value) {
    if (session.productLoading) return ArtCopy.current.tr('Loading...');
    if (value == null || value.isEmpty) return ArtCopy.current.tr('Not available');
    return value;
  }

  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('Product information'),
      subtitle: session.productFailed
          ? '${session.speakerName} · Information unavailable'
          : '${session.speakerName} · Connected',
      centerLogo: true,
      onBack: session.handleBack,
    ),
    _connectedLine(session.speakerName),
    _infoRow(ArtCopy.current.tr('Speaker name'), session.speakerName),
    _infoRow(ArtCopy.current.tr('Product model'), field(session.bt.productModel)),
    _infoRow(ArtCopy.current.tr('Firmware version'), field(session.bt.firmware)),
    _infoRow(ArtCopy.current.tr('Hardware version'), field(session.bt.hardware)),
    _infoRow(ArtCopy.current.tr('App version'), version.isEmpty ? ArtCopy.current.tr('Not available') : version),
    if (session.productFailed) ...[
      Padding(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Text(
          ArtCopy.current.tr('Could not read device information.'),
          style: TextStyle(fontFamily: 'HelveticaNeue', color: ArtTheme.danger),
        ),
      ),
      ArtButton(label: ArtCopy.current.tr('Retry'), onPressed: session.loadProduct),
    ],
  ]);
}

String _appVersion(ApplicationController app) {
  try {
    return app.version;
  } catch (_) {
    return '';
  }
}

Widget _infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ArtTheme.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: ArtTheme.subtitle.copyWith(fontSize: 13)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: ArtTheme.ink,
              )),
        ],
      ),
    ),
  );
}

Widget _language(BuildContext context, ArtSession session) {
  final current = LanguageUtil.getSelectLanguageLocale().languageCode;
  final pending = session.chosenLanguage ?? current;
  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('Language'),
      subtitle:
          '${ArtCopy.current.tr('Settings')} · ${_languageLabel(pending)}',
      centerLogo: true,
      onBack: session.handleBack,
    ),
    ...artLanguages.map((item) {
      final selected = item.code == pending;
      return ArtCard(
        title: _languageLabel(item.code),
        translateTitle: false,
        selected: selected,
        onTap: () => session.chooseLanguage(item.code),
        trailing: selected
            ? const Icon(Icons.check, color: ArtTheme.magenta)
            : const Icon(Icons.chevron_right, color: ArtTheme.magenta),
      );
    }),
    ArtButton(
      label: ArtCopy.current.tr('Apply'),
      onPressed: pending == current ? null : session.applyLanguage,
    ),
  ]);
}

String _languageLabel(String code) {
  for (final item in artLanguages) {
    if (item.code == code) return item.label;
  }
  return code;
}

Widget _lost(ArtSession session) {
  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('Connection lost'),
      subtitle:
          '${session.speakerName} · ${ArtCopy.current.tr('Disconnected')}',
      onBack: session.handleBack,
    ),
    const SizedBox(height: 24),
    const Center(child: Rings()),
    const SizedBox(height: 20),
    Text(
ArtCopy.current.tr('Speaker disconnected'),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: ArtTheme.ink,
      ),
    ),
    ArtWash(
      child: Text(
        ArtCopy.current.tr(
            'Controls are paused until reconnection.\nCheck power and keep the speaker nearby.'),
        style: ArtTheme.body,
      ),
    ),
    ArtButton(label: ArtCopy.current.tr('Reconnect'), onPressed: session.reconnect),
    ArtButton(
      label: ArtCopy.current.tr('Choose another speaker'),
      filled: false,
      onPressed: session.chooseAnother,
    ),
  ]);
}

Widget _saveFailed(ArtSession session) {
  return _scroll([
    ArtHeader(
      title: ArtCopy.current.tr('Save unsuccessful'),
      centerLogo: true,
      onBack: session.handleBack,
    ),
    _connectedLine(session.savedName),
    _section(ArtCopy.current.tr('SPEAKER NAME')),
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ArtTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ArtTheme.line),
      ),
      child: Text(session.renameDraft, style: ArtTheme.body),
    ),
    ArtWash(
      child: Text(
        ArtCopy.current.tr(
            'The speaker did not confirm the name.\nYour previous name is still kept.'),
        style: ArtTheme.body,
      ),
    ),
    ArtButton(
      label: ArtCopy.current.tr('Retry saving'),
      onPressed: session.busy ? null : session.saveName,
    ),
    ArtButton(
      label: ArtCopy.current.tr('Keep editing'),
      filled: false,
      onPressed: session.handleBack,
    ),
  ]);
}

