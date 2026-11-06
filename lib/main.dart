import 'package:flutter/material.dart';

import 'services/halo_minna_api.dart';

import 'package:url_launcher/url_launcher.dart';

import 'theme_manager.dart';

import 'app_theme.dart';

final themeManager = ThemeManager();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await themeManager.loadTheme();

  runApp(const HaloMinnaApp());
}

class HaloMinnaApp extends StatelessWidget {
  const HaloMinnaApp({super.key});
  static const navy = Color(0xFF0B2D50);
  static const navyDark = Color(0xFF071E35);
  static const blue = Color(0xFF1D527F);
  static const gold = Color(0xFFD7A64A);
  static const canvas = Color(0xFFF4F7FB);
  static const ink = Color(0xFF1B2B3D);
  static const muted = Color(0xFF66778A);
  static const line = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeManager,
      builder: (context, child) {
        return MaterialApp(
          title: 'Halo Minna',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeManager.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1300), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AccessScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [HaloMinnaApp.navyDark, HaloMinnaApp.navy, HaloMinnaApp.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InstitutionLogos(light: true, size: 62),
                SizedBox(height: 36),
                Text(
                  'HALO MINNA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.6,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Monitoring Integrasi Narapidana',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFD8E5F2), fontSize: 14),
                ),
                SizedBox(height: 44),
                SizedBox(
                  width: 128,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: LinearProgressIndicator(
                      minHeight: 4,
                      backgroundColor: Color(0x446F8EAD),
                      valueColor: AlwaysStoppedAnimation(HaloMinnaApp.gold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class AccessScreen extends StatefulWidget {
  const AccessScreen({super.key});
  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showCode = true;
  bool _loading = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    try {
      // Prefix BNCY- sudah ditampilkan terpisah di UI.
      final kodeAkses = 'BNCY-${_controller.text.trim()}';

      await HaloMinnaApi.login(kodeAkses);

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } catch (e) {
      if (!mounted) return;

      final message = e.toString().replaceFirst('Exception: ', '');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Row(
        children: [
          Image.asset(
            'assets/images/logo_pemasyarakatan.png',
            width: 32,
            height: 32,
            errorBuilder: (_, _, _) =>
                const Icon(Icons.account_balance_outlined),
          ),
          const SizedBox(width: 10),
          const Text('HALO MINNA'),
        ],
      ),
      actions: [
        IconButton(
          tooltip: Theme.of(context).brightness == Brightness.dark
              ? 'Aktifkan Light Mode'
              : 'Aktifkan Dark Mode',
          onPressed: () {
            final isDark = Theme.of(context).brightness == Brightness.dark;

            themeManager.setThemeMode(
              isDark ? ThemeMode.light : ThemeMode.dark,
            );
          },
          icon: Icon(
            Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
          ),
        ),
        const SizedBox(width: 8),
      ],
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const InstitutionLogos(size: 76),
              const SizedBox(height: 26),
              Text(
                'Informasi Integrasi\nWarga Binaan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 26,
                  height: 1.2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Pantau informasi program integrasi melalui satu akses yang mudah dan resmi.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  boxShadow: [
                    if (Theme.of(context).brightness == Brightness.light)
                      const BoxShadow(
                        color: Color(0x090B2D50),
                        blurRadius: 24,
                        offset: Offset(0, 8),
                      ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 9),
                        Text(
                          'Masuk dengan Kode Akses',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Gunakan kode akses yang diberikan oleh petugas.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12.5,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 56,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'BNCY-',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontSize: 15,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _controller,
                            textCapitalization: TextCapitalization.characters,
                            autocorrect: false,
                            maxLength: 8,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _continue(),
                            obscureText: !_showCode,
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Kode akses wajib diisi.'
                                : v.trim().length != 8
                                ? 'Kode akses harus terdiri dari 8 karakter.'
                                : null,
                            decoration: InputDecoration(
                              labelText: 'Kode Akses',
                              hintText: 'XXXXXXXX',
                              prefixIcon: const Icon(Icons.key_rounded),
                              counterText: '',
                              suffixIcon: IconButton(
                                tooltip: _showCode
                                    ? 'Sembunyikan kode'
                                    : 'Tampilkan kode',
                                onPressed: () =>
                                    setState(() => _showCode = !_showCode),
                                icon: Icon(
                                  _showCode
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: _loading ? null : _continue,
                        icon: _loading
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary,
                                ),
                              )
                            : const Icon(Icons.arrow_forward_rounded, size: 19),
                        label: Text(
                          _loading ? 'Memeriksa...' : 'LANJUTKAN',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            letterSpacing: .4,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primary,
                          foregroundColor: Theme.of(context)
                              .colorScheme
                              .onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const NoticeCard(
                icon: Icons.shield_outlined,
                title: 'Akses informasi yang aman',
                message: 'Jaga kerahasiaan kode akses. Jangan membagikannya kepada orang lain.',
              ),

              const SizedBox(height: 15),
              Text(
                'LAYANAN INFORMASI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 62,
                child: Image.asset(
                  'assets/images/logo_upt.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Lapas Banceuy Bandung',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _showThemeDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    themeManager.setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }

  Future<void> _logout(BuildContext context) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar dari Halo Minna?'),
        content: const Text(
          'Anda perlu memasukkan kode akses lagi untuk '
          'menggunakan layanan ini.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (konfirmasi != true || !context.mounted) return;

    // Tutup semua halaman di atas Dashboard dan tampilkan indikator proses.
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 14),
                  Text('Mohon tunggu...'),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    try {
      await HaloMinnaApi.logout();
    } catch (_) {
      // Token lokal tetap dihapus oleh service logout().
      // Kegagalan request server tidak menghalangi keluar dari aplikasi.
    }

    if (!context.mounted) return;

    // Tutup dialog proses.
    Navigator.of(context, rootNavigator: true).pop();

    // Kembali ke halaman akses dan hapus riwayat navigasi sebelumnya.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AccessScreen()),
      (route) => false,
    );
  }

  static const menus = <MenuData>[
    MenuData(
      'Status Program',
      'Lihat status dan tahapan integrasi',
      Icons.fact_check_outlined,
      Color(0xFFE7EFF8),
    ),
    MenuData(
      'Program Pembinaan',
      'Informasi dan pembinaan',
      Icons.account_tree_outlined,
      Color(0xFFF8F0DF),
    ),
    MenuData(
      'Daftar Program Pembinaan',
      'Kenali kegiatan pembinaan',
      Icons.menu_book_outlined,
      Color(0xFFE5F3EC),
    ),
    MenuData(
      'Statistik',
      'Ringkasan partisipasi program',
      Icons.bar_chart_rounded,
      Color(0xFFEAE9F8),
    ),
    MenuData(
      'Tentang Kami',
      'Informasi layanan Lapas Banceuy Bandung',
      Icons.account_balance_outlined,
      Color(0xFFE4F1F5),
    ),
    MenuData(
      'Tanya Minna',
      'Ada pertanyaan? Hubungi Minna',
      Icons.forum_outlined,
      Color(0xFFF8E9E8),
    ),
  ];
  void _open(BuildContext context, int index) {
    final pages = <Widget>[
      const StatusProgramScreen(),
      const ProgramPembinaanScreen(),
      const DaftarProgramScreen(),
      const StatistikScreen(),
      const TentangKamiScreen(),
      const KritikSaranScreen(),
    ];
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => pages[index]));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    HaloMinnaApp.navyDark,
                    HaloMinnaApp.navy,
                    HaloMinnaApp.blue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Image.asset(
                          'assets/images/logo_pemasyarakatan.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.account_balance,
                            color: HaloMinnaApp.navy,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HALO MINNA',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 17,
                                letterSpacing: .8,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Monitoring Integrasi Narapidana',
                              style: TextStyle(
                                color: Color(0xFFD2DFEC),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Tombol pengaturan tema
                      IconButton(
                        tooltip: 'Pengaturan tampilan',
                        onPressed: () => _showThemeDialog(context),
                        icon: const Icon(
                          Icons.palette_outlined,
                          color: Colors.white,
                        ),
                      ),

                      // Tombol logout
                      IconButton(
                        tooltip: 'Keluar',
                        onPressed: () => _logout(context),
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Selamat datang di',
                    style: TextStyle(color: Color(0xFFD2DFEC), fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Pusat informasi bagi keluarga WBP untuk mengetahui tahapan program integrasi dan kegiatan pembinaan.',
                    style: TextStyle(
                      color: Color(0xFFE0EAF3),
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          size: 17,
                          color: HaloMinnaApp.gold,
                        ),
                        SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            'Informasi khusus melalui kode akses',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu Layanan',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 17),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: menus.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: .91,
                        ),
                    itemBuilder: (ctx, i) =>
                        MenuCard(menu: menus[i], onTap: () => _open(ctx, i)),
                  ),

                  const SizedBox(height: 22),
                  Center(
                    child: Text(
                      'LAPAS BANCEUY BANDUNG',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class MenuData {
  final String title, subtitle;
  final IconData icon;
  final Color tint;
  const MenuData(this.title, this.subtitle, this.icon, this.tint);
}

class MenuCard extends StatelessWidget {
  final MenuData menu;
  final VoidCallback onTap;
  const MenuCard({super.key, required this.menu, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = theme.colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: colors.outlineVariant),
            boxShadow: [
              if (!isDark)
                const BoxShadow(
                  color: Color(0x050B2D50),
                  blurRadius: 14,
                  offset: Offset(0, 5),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isDark ? colors.primaryContainer : menu.tint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  menu.icon,
                  color: isDark ? colors.onPrimaryContainer : HaloMinnaApp.navy,
                  size: 24,
                ),
              ),
              const Spacer(),
              Text(
                menu.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 13.5,
                  height: 1.2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                menu.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 11,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 9),
              Row(
                children: [
                  Text(
                    'Buka menu',
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 13,
                    color: colors.primary,
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

class StatusProgramScreen extends StatefulWidget {
  const StatusProgramScreen({super.key});

  @override
  State<StatusProgramScreen> createState() => _StatusProgramScreenState();
}

class _StatusProgramScreenState extends State<StatusProgramScreen> {
  Map<String, dynamic>? _profil;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfil();
  }

  Future<void> _loadProfil() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final profil = await HaloMinnaApi.getProfil();

      if (!mounted) return;

      setState(() {
        _profil = profil;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  String _nilai(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return 'Belum tersedia';
    }

    return value.toString();
  }

  String _tanggal(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return 'Belum ada tanggal';
    }

    final raw = value.toString().trim();

    // Format YYYY-MM-DD menjadi DD-MM-YYYY.
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(raw);

    if (match != null) {
      return '${match.group(3)}-${match.group(2)}-${match.group(1)}';
    }

    return raw;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Status Program')),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 14),
              Text('Mohon tunggu...'),
            ],
          ),
        ),
      );
    }

    if (_error != null || _profil == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Status Program')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off_outlined,
                  size: 36,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 12),
                Text(
                  'Data belum dapat dimuat',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _error ?? 'Terjadi kesalahan saat mengambil data.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: _loadProfil,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final profil = _profil!;
    final integrasi = profil['integrasi'] is Map
        ? Map<String, dynamic>.from(profil['integrasi'] as Map)
        : <String, dynamic>{};

    final steps = <TimelineData>[
      TimelineData(
        'Pengambilan Berkas',
        _tanggal(integrasi['tgl_pengambilan_berkas']),
        Icons.folder_open_outlined,
      ),
      TimelineData(
        'Pengembalian Berkas',
        _tanggal(integrasi['tgl_pengembalian_berkas']),
        Icons.assignment_turned_in_outlined,
      ),
      TimelineData(
        'Permintaan Litmas',
        _tanggal(integrasi['tgl_permintaan_litmas']),
        Icons.outgoing_mail,
      ),
      TimelineData(
        'Litmas Bapas',
        _tanggal(integrasi['tgl_litmas_bapas']),
        Icons.apartment_outlined,
      ),
      TimelineData(
        'Hasil Litmas',
        _tanggal(integrasi['tgl_hasil_litmas']),
        Icons.fact_check_outlined,
      ),
      TimelineData(
        'Sidang TPP',
        _tanggal(integrasi['tgl_sidang_tpp']),
        Icons.groups_outlined,
      ),
      TimelineData(
        'Otorisasi SK',
        _tanggal(integrasi['tgl_otorisasi_sk']),
        Icons.approval_outlined,
      ),
      TimelineData(
        'Pelaksanaan',
        _tanggal(integrasi['tgl_pelaksanaan']),
        Icons.event_available_outlined,
      ),
      TimelineData(
        'Pembebasan',
        _tanggal(integrasi['tgl_pembebasan']),
        Icons.flag_outlined,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Program'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang data',
            onPressed: _loadProfil,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
        children: [
          const SectionIntro(
            eyebrow: 'STATUS WBP',
            title: 'Ringkasan Program',
            subtitle: 'Informasi identitas dan tahapan program integrasi.',
          ),
          const SizedBox(height: 18),
          IdentityCard(
            nama: _nilai(profil['nama']),
            noReg: _nilai(profil['no_reg_instansi']),
          ),
          const SizedBox(height: 14),
          ProgramStatusCard(
            jenisUsulan: _nilai(integrasi['jenis_usulan']),
            status: _nilai(integrasi['status_program']),
            masa12: _tanggal(profil['masa_1_2']),
            masa23: _tanggal(profil['masa_2_3']),
          ),
          const SizedBox(height: 25),
          Text(
            'Tahapan Program',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tanggal mengikuti data yang tersedia dari sistem.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(
            steps.length,
            (i) => TimelineRow(
              data: steps[i],
              isLast: i == steps.length - 1,
              index: i,
            ),
          ),
          const SizedBox(height: 3),
          const NoticeCard(
            icon: Icons.info_outline_rounded,
            title: 'Catatan',
            message: 'Status dan tanggal aktual mengikuti data yang tersedia dari sistem.',
          ),
        ],
      ),
    );
  }
}

class AlurProgramIntegrasiScreen extends StatefulWidget {
  const AlurProgramIntegrasiScreen({super.key});

  @override
  State<AlurProgramIntegrasiScreen> createState() =>
      _AlurProgramIntegrasiScreenState();
}

class _AlurProgramIntegrasiScreenState
    extends State<AlurProgramIntegrasiScreen> {
  late final PageController _pageController;

  int _currentPage = 0;
  String _programTerpilih = 'Cuti Bersyarat';

  List<AlurTahapData> _buatTahapanStandar(String aktivitasPendataan) {
    return [
      AlurTahapData(
        nomor: 1,
        instansi: 'UPT',
        judul: 'Persiapan dan Sidang TPP',
        icon: Icons.groups_rounded,
        deskripsi: 'Tahap awal pengusulan program integrasi.',
        aktivitas: [
          AlurAktivitas(aktivitasPendataan, Icons.person_search_rounded),
          AlurAktivitas(
            'Melengkapi input data dan dokumen',
            Icons.edit_document,
          ),
          AlurAktivitas(
            'Membuat daftar usulan sidang TPP',
            Icons.playlist_add_check_rounded,
          ),
          AlurAktivitas('Melaksanakan sidang TPP', Icons.gavel_rounded),
        ],
      ),
      AlurTahapData(
        nomor: 2,
        instansi: 'KANWIL',
        judul: 'Verifikasi Hasil Sidang',
        icon: Icons.fact_check_rounded,
        deskripsi: 'Pemeriksaan usulan oleh Kantor Wilayah.',
        aktivitas: [
          AlurAktivitas(
            'Melakukan verifikasi hasil sidang TPP',
            Icons.verified_user_rounded,
          ),
          AlurAktivitas(
            'Jangka waktu maksimal 3 hari sejak usulan diterima dari UPT',
            Icons.timer_outlined,
          ),
        ],
      ),
      AlurTahapData(
        nomor: 3,
        instansi: 'UPT',
        judul: 'Verifikasi dan Konsolidasi',
        icon: Icons.sync_rounded,
        deskripsi: 'Tindak lanjut hasil verifikasi dari Kanwil.',
        aktivitas: [
          AlurAktivitas(
            'Menerima hasil verifikasi dari Kanwil',
            Icons.mark_email_read_rounded,
          ),
          AlurAktivitas('Kontrol sidang', Icons.rule_rounded),
          AlurAktivitas(
            'Verifikasi sidang TPP',
            Icons.assignment_turned_in_rounded,
          ),
          AlurAktivitas(
            'Upload surat pengantar',
            Icons.drive_folder_upload_rounded,
          ),
          AlurAktivitas(
            'Kirim terima data dan dokumen (konsolidasi)',
            Icons.compare_arrows_rounded,
          ),
        ],
      ),
      AlurTahapData(
        nomor: 4,
        instansi: 'DITJEN PAS',
        judul: 'Persetujuan dan Penerbitan SK',
        icon: Icons.approval_rounded,
        deskripsi: 'Proses verifikasi dan persetujuan di tingkat pusat.',
        aktivitas: [
          AlurAktivitas(
            'Melakukan verifikasi usulan',
            Icons.manage_search_rounded,
          ),
          AlurAktivitas('Membuat persetujuan', Icons.task_alt_rounded),
          AlurAktivitas('Generate SK', Icons.description_rounded),
        ],
      ),
      AlurTahapData(
        nomor: 5,
        instansi: 'KANWIL',
        judul: 'Pencetakan SK',
        icon: Icons.print_rounded,
        deskripsi: 'Kantor Wilayah memproses dokumen keputusan.',
        aktivitas: [AlurAktivitas('Cetak SK', Icons.print_outlined)],
      ),
      AlurTahapData(
        nomor: 6,
        instansi: 'UPT',
        judul: 'Penerimaan SK',
        icon: Icons.inventory_rounded,
        deskripsi: 'Tahap akhir penerimaan dokumen keputusan.',
        aktivitas: [
          AlurAktivitas(
            'Menerima data dari Pusat',
            Icons.download_for_offline_rounded,
          ),
          AlurAktivitas(
            'Melaksanakan pencetakan SK',
            Icons.local_print_shop_rounded,
          ),
        ],
      ),
    ];
  }

  static const List<AlurTahapData> _tahapanAsimilasi = [
    AlurTahapData(
      nomor: 1,
      instansi: 'UPT',
      judul: 'Persiapan dan Sidang TPP',
      icon: Icons.groups_rounded,
      deskripsi: 'Persiapan dan pengusulan program Asimilasi.',
      aktivitas: [
        AlurAktivitas(
          'Melakukan pendaftaran narapidana',
          Icons.person_search_rounded,
        ),
        AlurAktivitas('Melengkapi input data dan dokumen', Icons.edit_document),
        AlurAktivitas(
          'Membuat daftar usulan sidang TPP',
          Icons.playlist_add_check_rounded,
        ),
        AlurAktivitas('Melaksanakan sidang TPP', Icons.gavel_rounded),
        AlurAktivitas('Kontrol sidang', Icons.rule_rounded),
        AlurAktivitas('Verifikasi sidang', Icons.assignment_turned_in_rounded),
        AlurAktivitas(
          'Upload surat pengantar',
          Icons.drive_folder_upload_rounded,
        ),
        AlurAktivitas(
          'Kirim/terima data dan dokumen (konsolidasi)',
          Icons.compare_arrows_rounded,
        ),
      ],
    ),
    AlurTahapData(
      nomor: 2,
      instansi: 'KANWIL',
      judul: 'Verifikasi Usulan',
      icon: Icons.fact_check_rounded,
      deskripsi: 'Pemeriksaan usulan oleh Kantor Wilayah.',
      aktivitas: [
        AlurAktivitas(
          'Melakukan verifikasi usulan',
          Icons.verified_user_rounded,
        ),
        AlurAktivitas(
          'Jangka waktu maksimal 3 hari sejak usulan diterima dari UPT',
          Icons.timer_outlined,
        ),
      ],
    ),
    AlurTahapData(
      nomor: 3,
      instansi: 'UPT',
      judul: 'Verifikasi dan Konsolidasi',
      icon: Icons.sync_rounded,
      deskripsi: 'Tindak lanjut hasil verifikasi dari Kanwil.',
      aktivitas: [
        AlurAktivitas(
          'Hasil verifikasi diterima dari Kanwil',
          Icons.mark_email_read_rounded,
        ),
        AlurAktivitas('Kontrol sidang', Icons.rule_rounded),
        AlurAktivitas(
          'Verifikasi sidang TPP',
          Icons.assignment_turned_in_rounded,
        ),
        AlurAktivitas(
          'Upload surat pengantar',
          Icons.drive_folder_upload_rounded,
        ),
        AlurAktivitas(
          'Kirim terima data dan dokumen (konsolidasi)',
          Icons.compare_arrows_rounded,
        ),
      ],
    ),
    AlurTahapData(
      nomor: 4,
      instansi: 'DITJEN PAS',
      judul: 'Persetujuan dan Penerbitan SK',
      icon: Icons.approval_rounded,
      deskripsi: 'Proses verifikasi dan persetujuan di tingkat pusat.',
      aktivitas: [
        AlurAktivitas(
          'Melakukan verifikasi usulan',
          Icons.manage_search_rounded,
        ),
        AlurAktivitas('Membuat persetujuan', Icons.task_alt_rounded),
        AlurAktivitas('Generate SK', Icons.description_rounded),
      ],
    ),
    AlurTahapData(
      nomor: 5,
      instansi: 'KANWIL',
      judul: 'Pencetakan SK',
      icon: Icons.print_rounded,
      deskripsi: 'Kantor Wilayah memproses dokumen keputusan.',
      aktivitas: [AlurAktivitas('Cetak SK', Icons.print_outlined)],
    ),
  ];

  List<AlurTahapData> get _tahapan {
    switch (_programTerpilih) {
      case 'Cuti Bersyarat':
        return _buatTahapanStandar('Melakukan pendaftaran narapidana');

      case 'Pembebasan Bersyarat':
        return _buatTahapanStandar('Melakukan pendataan narapidana');

      case 'Asimilasi':
        return _tahapanAsimilasi;

      default:
        return [];
    }
  }

  void _pilihProgram(String program) {
    if (_programTerpilih == program) return;

    setState(() {
      _programTerpilih = program;
      _currentPage = 0;
    });

    _pageController.jumpToPage(0);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _pindahTahap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tahapan = _tahapan;

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Alur Program Integrasi')),
      body: ListView(
        padding: const EdgeInsets.only(top: 20, bottom: 30),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PROSEDUR PENGUSULAN',
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tahapan Pengusulan',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pelajari tahapan pengusulan hingga penerbitan SK.',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                // PEMILIHAN PROGRAM
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _pilihanProgram('Cuti Bersyarat'),
                    _pilihanProgram('Pembebasan Bersyarat'),
                    _pilihanProgram('Asimilasi'),
                  ],
                ),

                const SizedBox(height: 13),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: colors.onPrimaryContainer,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _programTerpilih == 'Asimilasi'
                              ? 'Dasar hukum: Permenham Nomor 03 Tahun 2018.'
                              : 'Dasar hukum: Permenkumham Nomor 7 Tahun 2022.',
                          style: TextStyle(
                            color: colors.onPrimaryContainer,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 460,
            child: PageView.builder(
              key: ValueKey(_programTerpilih),
              controller: _pageController,
              itemCount: tahapan.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: _AlurTahapCard(
                    tahap: tahapan[index],
                    aktif: _currentPage == index,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              tahapan.length,
              (index) => GestureDetector(
                onTap: () => _pindahTahap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 23 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? HaloMinnaApp.gold
                        : colors.outlineVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pilihanProgram(String program) {
    final colors = Theme.of(context).colorScheme;
    final aktif = _programTerpilih == program;

    return ChoiceChip(
      label: Text(program),
      selected: aktif,
      onSelected: (_) => _pilihProgram(program),
      selectedColor: colors.primary,
      backgroundColor: colors.surface,
      labelStyle: TextStyle(
        color: aktif ? colors.onPrimary : colors.onSurface,
        fontSize: 11,
        fontWeight: FontWeight.w800,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: aktif ? colors.primary : colors.outlineVariant),
      ),
      showCheckmark: false,
    );
  }
}

class AlurTahapData {
  final int nomor;
  final String instansi;
  final String judul;
  final String deskripsi;
  final IconData icon;
  final List<AlurAktivitas> aktivitas;

  const AlurTahapData({
    required this.nomor,
    required this.instansi,
    required this.judul,
    required this.icon,
    required this.deskripsi,
    required this.aktivitas,
  });
}

class AlurAktivitas {
  final String judul;
  final IconData icon;

  const AlurAktivitas(this.judul, this.icon);
}

class _AlurTahapCard extends StatelessWidget {
  final AlurTahapData tahap;
  final bool aktif;

  const _AlurTahapCard({required this.tahap, required this.aktif});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardGradient = LinearGradient(
      colors: isDark
          ? [
              colors.surface,
              aktif ? const Color(0xFF1B3048) : const Color(0xFF101F30),
            ]
          : aktif
          ? [Colors.white, const Color(0xFFF0F5FC)]
          : [Colors.white, const Color(0xFFF7F9FC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: aktif ? HaloMinnaApp.gold : colors.outlineVariant,
          width: aktif ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? (aktif ? 0.20 : 0.10) : (aktif ? 0.12 : 0.05),
            ),
            blurRadius: aktif ? 18 : 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: aktif ? HaloMinnaApp.gold : colors.primary,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  tahap.nomor.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: aktif ? const Color(0xFF071E35) : colors.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 19),

          Center(
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF493A1D)
                    : const Color(0xFFFFF1D6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                tahap.icon,
                size: 45,
                color: isDark ? const Color(0xFFFFD580) : HaloMinnaApp.navy,
              ),
            ),
          ),

          const SizedBox(height: 13),

          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                tahap.instansi,
                style: TextStyle(
                  color: colors.onPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),

          const SizedBox(height: 17),

          Text(
            tahap.judul,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            tahap.deskripsi,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 11.5,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 17),
          Divider(color: colors.outlineVariant),
          const SizedBox(height: 8),

          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: tahap.aktivitas.length,
              separatorBuilder: (_, _) => const SizedBox(height: 13),
              itemBuilder: (context, index) {
                final aktivitas = tahap.aktivitas[index];

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        aktivitas.icon,
                        size: 19,
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          aktivitas.judul,
                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 12,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class IdentityCard extends StatelessWidget {
  final String nama;
  final String noReg;

  const IdentityCard({super.key, required this.nama, required this.noReg});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: isDark ? colors.primaryContainer : const Color(0xFFEAF1F8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: isDark ? colors.onPrimaryContainer : colors.primary,
              size: 29,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NAMA WBP',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  nama,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'No. Registrasi: $noReg',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProgramStatusCard extends StatelessWidget {
  final String jenisUsulan;
  final String status;
  final String masa12;
  final String masa23;

  const ProgramStatusCard({
    super.key,
    required this.jenisUsulan,
    required this.status,
    required this.masa12,
    required this.masa23,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(19),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [HaloMinnaApp.navy, HaloMinnaApp.blue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(19),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'STATUS PROGRAM',
                style: TextStyle(
                  color: Color(0xFFD7E3EF),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            StatusPill(label: status),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Jenis Usulan',
          style: TextStyle(color: Color(0xFFD7E3EF), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          jenisUsulan,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 19),
        Row(
          children: [
            Expanded(
              child: DateInfo(label: '1/2 PIDANA', date: masa12),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: DateInfo(label: '2/3 PIDANA', date: masa23),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Informasi mengikuti data yang tersedia pada sistem.',
          style: TextStyle(
            color: Color(0xFFD7E3EF),
            fontSize: 10.5,
            height: 1.4,
          ),
        ),
      ],
    ),
  );
}

class StatusPill extends StatelessWidget {
  final String label;

  const StatusPill({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final String status = label.toLowerCase().trim();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor;
    final Color textColor;
    final String description;

    switch (status) {
      case 'aktif':
        backgroundColor = isDark
            ? const Color(0xFF173D2B)
            : const Color(0xFFDDF5E5);
        textColor = isDark ? const Color(0xFF8BE0AA) : const Color(0xFF23834D);
        description = 'Program integrasi sedang berjalan.';
        break;

      case 'batal':
        backgroundColor = isDark
            ? const Color(0xFF492525)
            : const Color(0xFFFFE0E0);
        textColor = isDark ? const Color(0xFFFFA0A0) : const Color(0xFFD64B4B);
        description = 'Program integrasi telah dibatalkan. Tanya Minna untuk informasi lebih lanjut.';
        break;

      case 'tidak aktif':
        backgroundColor = isDark
            ? const Color(0xFF493A1D)
            : const Color(0xFFFFF0CE);
        textColor = isDark ? const Color(0xFFFFD580) : const Color(0xFF815B12);
        description = 'WBP belum masuk tahap pengusulan program integrasi.';
        break;

      default:
        backgroundColor = isDark
            ? const Color(0xFF29394B)
            : const Color(0xFFE8EDF3);
        textColor = isDark ? const Color(0xFFCAD5E2) : const Color(0xFF526174);
        description = 'Informasi untuk status ini belum tersedia.';
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          showDialog<void>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Informasi Status Program',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Mengerti'),
                ),
              ],
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class DateInfo extends StatelessWidget {
  final String label, date;
  const DateInfo({super.key, required this.label, required this.date});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Color(0xFFBFD0E0),
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        date,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w900,
        ),
      ),
    ],
  );
}

class TimelineData {
  final String title, date;
  final IconData icon;
  const TimelineData(this.title, this.date, this.icon);
}

class TimelineRow extends StatelessWidget {
  final TimelineData data;
  final bool isLast;
  final int index;

  const TimelineRow({
    super.key,
    required this.data,
    required this.isLast,
    required this.index,
  });

  DateTime? _parseDate(String value) {
    final raw = value.trim();

    if (raw.isEmpty ||
        raw.toLowerCase() == 'belum ada tanggal' ||
        raw.toLowerCase() == 'belum tersedia' ||
        raw == '-') {
      return null;
    }

    // Mendukung format DD-MM-YYYY dan YYYY-MM-DD.
    final dmy = RegExp(r'^(\d{2})-(\d{2})-(\d{4})$').firstMatch(raw);

    if (dmy != null) {
      return DateTime(
        int.parse(dmy.group(3)!),
        int.parse(dmy.group(2)!),
        int.parse(dmy.group(1)!),
      );
    }

    final ymd = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(raw);

    if (ymd != null) {
      return DateTime(
        int.parse(ymd.group(1)!),
        int.parse(ymd.group(2)!),
        int.parse(ymd.group(3)!),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final tanggal = _parseDate(data.date);

    /// Tahap bertanggal dianggap selesai jika tanggalnya sudah lewat
    // atau sama dengan hari ini. Tanggal mendatang belum selesai.
    final now = DateTime.now();
    final hariIni = DateTime(now.year, now.month, now.day);

    final done =
        tanggal != null &&
        !DateTime(tanggal.year, tanggal.month, tanggal.day).isAfter(hariIni);

    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color warnaStatus = done
        ? (isDark ? const Color(0xFF75D69A) : const Color(0xFF2D8A58))
        : colors.onSurfaceVariant;

    final Color iconBackground = done
        ? (isDark ? const Color(0xFF173D2B) : const Color(0xFFE0F2E8))
        : colors.surface;

    final Color iconForeground = done
        ? (isDark ? const Color(0xFF8BE0AA) : const Color(0xFF237348))
        : colors.onSurfaceVariant;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 42,
            child: Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: done ? warnaStatus : colors.outlineVariant,
                    ),
                  ),
                  child: Icon(data.icon, size: 17, color: iconForeground),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 1.5, color: colors.outlineVariant),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.outlineVariant),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title,
                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          data.date,
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    done ? Icons.check_circle_rounded : Icons.schedule_rounded,
                    size: 18,
                    color: warnaStatus,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProgramPembinaanScreen extends StatefulWidget {
  const ProgramPembinaanScreen({super.key});

  @override
  State<ProgramPembinaanScreen> createState() => _ProgramPembinaanScreenState();
}

class _ProgramPembinaanScreenState extends State<ProgramPembinaanScreen> {
  late Future<Map<String, dynamic>> _programFuture;

  @override
  void initState() {
    super.initState();
    _programFuture = HaloMinnaApi.getProgramDiikuti();
  }

  Future<void> _refreshProgram() async {
    final future = HaloMinnaApi.getProgramDiikuti();

    setState(() {
      _programFuture = future;
    });

    await future;
  }

  IconData _iconProgram(String nama) {
    final program = nama.toLowerCase();

    if (program.contains('santri')) {
      return Icons.menu_book_rounded;
    }
    if (program.contains('pramuka')) {
      return Icons.explore_outlined;
    }
    if (program.contains('skb') || program.contains('belajar')) {
      return Icons.school_outlined;
    }
    if (program.contains('futsal')) {
      return Icons.sports_soccer_outlined;
    }
    if (program.contains('barbershop')) {
      return Icons.content_cut_outlined;
    }
    if (program.contains('budidaya')) {
      return Icons.eco_outlined;
    }
    if (program.contains('tataboga') || program.contains('pangan')) {
      return Icons.restaurant_outlined;
    }
    if (program.contains('produksi') || program.contains('manufaktur')) {
      return Icons.handyman_outlined;
    }

    return Icons.diversity_3_outlined;
  }

  String _formatTanggal(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return '-';
    }

    final parsed = DateTime.tryParse(value.toString());

    if (parsed == null) {
      return value.toString();
    }

    final day = parsed.day.toString().padLeft(2, '0');
    final month = parsed.month.toString().padLeft(2, '0');

    return '$day-$month-${parsed.year}';
  }

  Color _statusColor(String status, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (status) {
      case 'Aktif':
        return isDark ? const Color(0xFF75D69A) : const Color(0xFF23834D);

      case 'Selesai':
        return isDark ? const Color(0xFF8BB9E5) : const Color(0xFF2563A6);

      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }

  Widget _buildProgramCard(BuildContext context, Map<String, dynamic> program) {
    final nama = program['nama_program']?.toString() ?? 'Program';
    final kategori = program['kategori']?.toString() ?? '-';
    final status = program['status_keikutsertaan']?.toString() ?? '-';
    final indikator = program['indikator_keaktifan']?.toString() ?? '-';

    final tanggalMulai = _formatTanggal(program['tanggal_mulai']);

    final colors = Theme.of(context).colorScheme;
    final statusColor = _statusColor(status, context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_iconProgram(nama), size: 28, color: colors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nama,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        kategori,
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _detailProgram(context, 'Indikator keaktifan', indikator),
            const SizedBox(height: 8),
            _detailProgram(context, 'Tanggal mulai', tanggalMulai),
            if ((program['keterangan']?.toString() ?? '')
                .trim()
                .isNotEmpty) ...[
              const SizedBox(height: 8),
              _detailProgram(
                context,
                'Keterangan',
                program['keterangan'].toString(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _detailProgram(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        const Text(': '),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Program Pembinaan')),
      body: RefreshIndicator(
        onRefresh: _refreshProgram,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          children: [
            const SectionIntro(
              eyebrow: 'PEMBINAAN',
              title: 'Program Pembinaan',
              subtitle: 'Pantau program pembinaan yang diikuti beserta status dan perkembangan keaktifan.',
            ),
            const SizedBox(height: 20),
            const FeatureBanner(
              icon: Icons.school_outlined,
              title: 'Kewajiban Mengikuti Program Pembinaan',
              body: 'Setiap WBP wajib mengikuti program pembinaan yang tersedia di Lembaga Pemasyarakatan Banceuy.',
            ),
            const SizedBox(height: 22),
            FutureBuilder<Map<String, dynamic>>(
              future: _programFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.cloud_off_outlined,
                          size: 42,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Data program pembinaan belum dapat dimuat.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _refreshProgram,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                final response = snapshot.data;
                final rawData = response?['data'];

                if (response?['success'] != true || rawData is! List) {
                  return const Text(
                    'Respons data program tidak valid.',
                    textAlign: TextAlign.center,
                  );
                }

                final programs = rawData
                    .whereType<Map>()
                    .map((item) => Map<String, dynamic>.from(item))
                    .toList();

                if (programs.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          size: 42,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Belum ada program pembinaan yang tercatat diikuti.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final kepribadian = programs
                    .where((item) => item['kategori'] == 'Kepribadian')
                    .toList();

                final kemandirian = programs
                    .where((item) => item['kategori'] == 'Kemandirian')
                    .toList();

                final lainnya = programs
                    .where(
                      (item) =>
                          item['kategori'] != 'Kepribadian' &&
                          item['kategori'] != 'Kemandirian',
                    )
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mengikuti ${programs.length} program pembinaan',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 16),

                    if (kepribadian.isNotEmpty)
                      _ProgramDropdown(
                        title: 'Pembinaan Kepribadian',
                        subtitle: 'Pembentukan karakter, pendidikan, dan nilai spiritual.',
                        icon: Icons.psychology_outlined,
                        programs: kepribadian
                            .map((item) => _buildProgramCard(context, item))
                            .toList(),
                      ),

                    if (kepribadian.isNotEmpty &&
                        (kemandirian.isNotEmpty || lainnya.isNotEmpty))
                      const SizedBox(height: 16),

                    if (kemandirian.isNotEmpty)
                      _ProgramDropdown(
                        title: 'Pembinaan Kemandirian',
                        subtitle:
                            'Pengembangan keterampilan dan kemampuan kerja.',
                        icon: Icons.handyman_outlined,
                        programs: kemandirian
                            .map((item) => _buildProgramCard(context, item))
                            .toList(),
                      ),

                    if (lainnya.isNotEmpty) ...[
                      if (kepribadian.isNotEmpty || kemandirian.isNotEmpty)
                        const SizedBox(height: 16),
                      ...lainnya.map(
                        (item) => _buildProgramCard(context, item),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramDropdown extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> programs;

  const _ProgramDropdown({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.programs,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: colors.onPrimaryContainer),
            ),
            title: Text(
              title,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                subtitle,
                style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
              ),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colors.onSurfaceVariant,
            ),
            children: programs
                .map(
                  (program) => Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: program,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class DaftarProgramScreen extends StatefulWidget {
  const DaftarProgramScreen({super.key});

  @override
  State<DaftarProgramScreen> createState() => _DaftarProgramScreenState();
}

class _DaftarProgramScreenState extends State<DaftarProgramScreen> {
  late Future<Map<String, dynamic>> _programFuture;

  @override
  void initState() {
    super.initState();
    _programFuture = HaloMinnaApi.getProgramPembinaan();
  }

  Future<void> _refreshProgram() async {
    final future = HaloMinnaApi.getProgramPembinaan();

    setState(() {
      _programFuture = future;
    });

    await future;
  }

  IconData _iconProgram(String kategori, String nama) {
    final program = nama.toLowerCase();

    if (program.contains('santri')) {
      return Icons.menu_book_rounded;
    }
    if (program.contains('pramuka')) {
      return Icons.explore_outlined;
    }
    if (program.contains('sekolah') ||
        program.contains('belajar') ||
        program.contains('skb')) {
      return Icons.school_outlined;
    }
    if (program.contains('futsal')) {
      return Icons.sports_soccer_outlined;
    }
    if (program.contains('barbershop')) {
      return Icons.content_cut_outlined;
    }
    if (program.contains('budidaya')) {
      return Icons.eco_outlined;
    }
    if (program.contains('pangan') || program.contains('tataboga')) {
      return Icons.restaurant_outlined;
    }
    if (program.contains('produksi') || program.contains('manufaktur')) {
      return Icons.handyman_outlined;
    }

    return kategori == 'Kepribadian'
        ? Icons.groups_outlined
        : Icons.work_outline_rounded;
  }

  String _kategoriLabel(String kategori) {
    switch (kategori) {
      case 'Kepribadian':
        return 'Pembinaan Kepribadian';
      case 'Kemandirian':
        return 'Pembinaan Kemandirian';
      default:
        return kategori;
    }
  }

  String _deskripsiProgram(String kategori, String nama) {
    final program = nama.toLowerCase();

    if (program.contains('santri')) {
      return 'Pembinaan keagamaan dan pembiasaan nilai positif.';
    }
    if (program.contains('pramuka')) {
      return 'Kegiatan yang menekankan kedisiplinan, karakter, dan kerja sama.';
    }
    if (program.contains('sekolah') ||
        program.contains('belajar') ||
        program.contains('skb')) {
      return 'Kegiatan pendidikan dan pembelajaran untuk mendukung pengembangan diri.';
    }
    if (program.contains('futsal')) {
      return 'Kegiatan olahraga untuk kebugaran dan sportivitas.';
    }
    if (program.contains('barbershop')) {
      return 'Pengembangan keterampilan di bidang pangkas rambut.';
    }
    if (program.contains('budidaya')) {
      return 'Pengembangan keterampilan dalam kegiatan budidaya.';
    }
    if (program.contains('pangan') || program.contains('tataboga')) {
      return 'Pengembangan keterampilan dalam pengolahan makanan.';
    }
    if (program.contains('produksi') || program.contains('manufaktur')) {
      return 'Pengembangan keterampilan dalam bidang produksi dan manufaktur.';
    }

    return kategori == 'Kepribadian'
        ? 'Kegiatan untuk mendukung pembentukan karakter dan pengembangan diri.'
        : 'Kegiatan untuk mengembangkan keterampilan dan kemandirian.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Program Pembinaan')),
      body: RefreshIndicator(
        onRefresh: _refreshProgram,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          children: [
            const SectionIntro(
              eyebrow: 'DAFTAR KEGIATAN',
              title: 'Kenali program pembinaan',
              subtitle:
                  'Kegiatan program pembinaan di Lapas Kelas IIA Banceuy.',
            ),
            const SizedBox(height: 20),

            FutureBuilder<Map<String, dynamic>>(
              future: _programFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.cloud_off_outlined,
                          size: 42,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Program pembinaan belum dapat dimuat.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _refreshProgram,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                final response = snapshot.data;
                final rawData = response?['data'];

                if (response?['success'] != true ||
                    rawData is! List ||
                    rawData.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'Belum ada program pembinaan yang tersedia.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final programs = rawData
                    .whereType<Map>()
                    .map((item) => Map<String, dynamic>.from(item))
                    .toList();

                final kepribadian = programs
                    .where((item) => item['kategori'] == 'Kepribadian')
                    .toList();

                final kemandirian = programs
                    .where((item) => item['kategori'] == 'Kemandirian')
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (kepribadian.isNotEmpty) ...[
                      Text(
                        'PEMBINAAN KEPRIBADIAN',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 10),
                      ...kepribadian.map((program) {
                        final nama =
                            program['nama_program']?.toString() ?? 'Program';
                        final kategori = program['kategori']?.toString() ?? '';

                        return ProgramCard(
                          title: nama,
                          category: _kategoriLabel(kategori),
                          icon: _iconProgram(kategori, nama),
                          description: _deskripsiProgram(kategori, nama),
                        );
                      }),
                      const SizedBox(height: 12),
                    ],

                    if (kemandirian.isNotEmpty) ...[
                      Text(
                        'PEMBINAAN KEMANDIRIAN',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 10),
                      ...kemandirian.map((program) {
                        final nama =
                            program['nama_program']?.toString() ?? 'Program';
                        final kategori = program['kategori']?.toString() ?? '';

                        return ProgramCard(
                          title: nama,
                          category: _kategoriLabel(kategori),
                          icon: _iconProgram(kategori, nama),
                          description: _deskripsiProgram(kategori, nama),
                        );
                      }),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class StatistikScreen extends StatefulWidget {
  const StatistikScreen({super.key});

  @override
  State<StatistikScreen> createState() => _StatistikScreenState();
}

class _StatistikScreenState extends State<StatistikScreen> {
  bool _loadingPembinaan = true;
  String? _errorPembinaan;
  Map<String, dynamic>? _statistikPembinaan;

  bool _loadingIntegrasi = true;
  String? _errorIntegrasi;
  Map<String, dynamic>? _statistikIntegrasi;

  @override
  void initState() {
    super.initState();
    _loadStatistik();
  }

  Future<void> _loadStatistik() async {
    await Future.wait([_loadStatistikPembinaan(), _loadStatistikIntegrasi()]);
  }

  Future<void> _loadStatistikPembinaan() async {
    if (mounted) {
      setState(() {
        _loadingPembinaan = true;
        _errorPembinaan = null;
      });
    }

    try {
      final response = await HaloMinnaApi.getStatistikPembinaan();

      if (!mounted) return;

      setState(() {
        _statistikPembinaan = Map<String, dynamic>.from(
          response['data'] as Map,
        );
        _loadingPembinaan = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorPembinaan = e.toString().replaceFirst('Exception: ', '');
        _loadingPembinaan = false;
      });
    }
  }

  Future<void> _loadStatistikIntegrasi() async {
    if (mounted) {
      setState(() {
        _loadingIntegrasi = true;
        _errorIntegrasi = null;
      });
    }

    try {
      final response = await HaloMinnaApi.getStatistikIntegrasi();

      if (!mounted) return;

      setState(() {
        _statistikIntegrasi = Map<String, dynamic>.from(
          response['data'] as Map,
        );
        _loadingIntegrasi = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorIntegrasi = e.toString().replaceFirst('Exception: ', '');
        _loadingIntegrasi = false;
      });
    }
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  List<_StatistikItem> _buildItemsPembinaan() {
    final rawItems = _statistikPembinaan?['per_program'];

    if (rawItems is! List) return [];

    return rawItems.whereType<Map>().map((raw) {
      final item = Map<String, dynamic>.from(raw);

      return _StatistikItem(
        title: item['nama_program']?.toString() ?? 'Program',
        jumlah: _toInt(item['jumlah_wbp']),
      );
    }).toList();
  }

  List<_StatistikItem> _buildItemsIntegrasi() {
    final rawItems = _statistikIntegrasi?['per_tahapan'];

    if (rawItems is! List) return [];

    return rawItems.whereType<Map>().map((raw) {
      final item = Map<String, dynamic>.from(raw);

      return _StatistikItem(
        title: item['tahapan']?.toString() ?? 'Tahapan',
        jumlah: _toInt(item['jumlah_wbp']),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final loading = _loadingPembinaan || _loadingIntegrasi;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang statistik',
            onPressed: loading ? null : _loadStatistik,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: RefreshIndicator(
          onRefresh: _loadStatistik,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
            children: [
              const SectionIntro(
                eyebrow: 'RINGKASAN',
                title: 'Statistik Program',
                subtitle:
                    'Ringkasan jumlah WBP berdasarkan tahapan program '
                    'integrasi dan kegiatan pembinaan di Lapas Banceuy.',
              ),
              const SizedBox(height: 22),

              // PROGRAM INTEGRASI
              if (_loadingIntegrasi)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else if (_errorIntegrasi != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.cloud_off_outlined, size: 36),
                        const SizedBox(height: 10),
                        const Text(
                          'Statistik integrasi gagal dimuat.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(_errorIntegrasi!, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: _loadStatistikIntegrasi,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                _StatistikDropdown(
                  title: 'Program Integrasi',
                  subtitle: 'Jumlah WBP berdasarkan tahapan program',
                  icon: Icons.account_tree_outlined,
                  items: _buildItemsIntegrasi(),
                ),

              const SizedBox(height: 16),

              // PROGRAM PEMBINAAN
              if (_loadingPembinaan)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else if (_errorPembinaan != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.cloud_off_outlined, size: 36),
                        const SizedBox(height: 10),
                        const Text(
                          'Statistik pembinaan gagal dimuat.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(_errorPembinaan!, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: _loadStatistikPembinaan,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                _StatistikDropdown(
                  title: 'Program Pembinaan',
                  subtitle: 'Jumlah WBP yang mengikuti setiap program',
                  icon: Icons.diversity_3_outlined,
                  showPercentage: false,
                  items: _buildItemsPembinaan(),
                ),

              const SizedBox(height: 18),

              const NoticeCard(
                icon: Icons.info_outline_rounded,
                title: 'Informasi Statistik',
                message:
                    'Statistik Program Integrasi menampilkan jumlah WBP '
                    'berdasarkan tahapan terakhir proses integrasi yang tercatat. '
                    'Sementara itu, Statistik Pembinaan menampilkan jumlah WBP '
                    'yang mengikuti masing-masing program pembinaan.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatistikItem {
  final String title;
  final int jumlah;

  const _StatistikItem({required this.title, required this.jumlah});
}

class _StatistikDropdown extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool showPercentage;
  final List<_StatistikItem> items;

  const _StatistikDropdown({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.items,
    this.showPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final total = items.fold<int>(0, (sum, item) => sum + item.jumlah);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 15),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: colors.onPrimaryContainer),
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: colors.onSurfaceVariant, fontSize: 12),
              ),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down_rounded),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Total berdasarkan kategori',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                    Text(
                      '$total WBP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: colors.onSurface, fontSize: 13),
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(minWidth: 38),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          '${item.jumlah}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: colors.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityLegend extends StatelessWidget {
  final Color color;
  final String title, detail;
  const ActivityLegend({
    super.key,
    required this.color,
    required this.title,
    required this.detail,
  });
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: HaloMinnaApp.line),
    ),
    child: Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: HaloMinnaApp.ink,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          detail,
          style: const TextStyle(color: HaloMinnaApp.muted, fontSize: 11),
        ),
      ],
    ),
  );
}

class KritikSaranScreen extends StatefulWidget {
  const KritikSaranScreen({super.key});

  @override
  State<KritikSaranScreen> createState() => _KritikSaranScreenState();
}

class _KritikSaranScreenState extends State<KritikSaranScreen> {
  final _formKey = GlobalKey<FormState>();
  final _message = TextEditingController();
  final _pertanyaan = TextEditingController();

  final _type = 'Saran';

  String _activeFeature = 'Kritik & Saran';
  String _namaWbp = '';

  // GANTI dengan nomor WhatsApp Admin Bimkemaswat.
  // Format: kode negara + nomor, tanpa tanda +.
  static const String _adminWhatsApp = '6282128000497';

  @override
  void initState() {
    super.initState();
    _loadProfilWbp();
  }

  Future<void> _loadProfilWbp() async {
    try {
      final profil = await HaloMinnaApi.getProfil();

      if (!mounted) return;

      setState(() {
        _namaWbp = profil['nama']?.toString().trim() ?? '';
      });
    } catch (e) {
      debugPrint('Gagal mengambil profil WBP: $e');
    }
  }

  @override
  void dispose() {
    _message.dispose();
    _pertanyaan.dispose();
    super.dispose();
  }

  Future<void> _bukaWhatsApp(String pesan) async {
    final nomor = _adminWhatsApp;

    if (!RegExp(r'^62[0-9]{8,13}$').hasMatch(nomor)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Nomor WhatsApp Admin belum dikonfigurasi dengan benar.',
          ),
        ),
      );
      return;
    }

    final uri = Uri.parse(
      'https://wa.me/$nomor?text=${Uri.encodeComponent(pesan)}',
    );

    try {
      final berhasil = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!berhasil && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WhatsApp tidak dapat dibuka.')),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kendala saat membuka WhatsApp.')),
      );
    }
  }

  Future<void> _kirimKritikSaran() async {
    if (!_formKey.currentState!.validate()) return;

    final nama = _namaWbp.isNotEmpty ? _namaWbp : 'WBP';

    final pesan =
        '''
Assalamu'alaikum Admin Bimkemaswat.

Saya keluarga dari wbp atas nama $nama ingin menyampaikan $_type melalui aplikasi Halo Minna.

Pesan:
${_message.text.trim()}

Terima kasih.
''';

    await _bukaWhatsApp(pesan);
  }

  Future<void> _tanyaMinna() async {
    final pertanyaan = _pertanyaan.text.trim();

    if (pertanyaan.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pertanyaan belum diisi.')));
      return;
    }

    final nama = _namaWbp.isNotEmpty ? _namaWbp : 'WBP';

    final pesan =
        '''
Assalamu'alaikum Admin Bimkemaswat.

Saya keluarga dari wbp atas nama $nama ingin bertanya

$pertanyaan

Terima kasih.
''';

    await _bukaWhatsApp(pesan);
  }

  Widget _buildKritikSaranForm() {
    final colors = Theme.of(context).colorScheme;
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('kritik_saran'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.rate_review_outlined, color: colors.primary),
              const SizedBox(width: 5),
              Text(
                'Kritik & Saran',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Sampaikan masukan atau kritik untuk meningkatkan kualitas layanan kami.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _message,
            minLines: 4,
            maxLines: 7,
            maxLength: 1000,
            decoration: const InputDecoration(
              labelText: 'Pesan',
              hintText: 'Tulis kritik atau saran...',
              alignLabelWithHint: true,
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Pesan belum diisi.' : null,
          ),
          const SizedBox(height: 1),
          FilledButton.icon(
            onPressed: _kirimKritikSaran,
            icon: const Icon(Icons.chat_rounded),
            label: const Text('Lanjutkan ke WhatsApp'),
            style: FilledButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTanyaMinnaForm() {
    final colors = Theme.of(context).colorScheme;

    return Column(
      key: const ValueKey('tanya_minna'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.question_answer_outlined, color: colors.primary),
            const SizedBox(width: 5),
            Text(
              'Tanya Minna',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          'Ada pertanyaan seputar program integrasi?',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontSize: 12,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _pertanyaan,
          minLines: 4,
          maxLines: 7,
          maxLength: 1000,
          decoration: const InputDecoration(
            hintText: 'Apa yang ingin Anda tanyakan?',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 1),
        FilledButton.icon(
          onPressed: _tanyaMinna,
          icon: const Icon(Icons.chat_rounded),
          label: const Text('Tanyakan ke Admin'),
          style: FilledButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Pusat Bantuan')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        const SectionIntro(
          eyebrow: 'PUSAT BANTUAN',
          title: 'Ada yang bisa kami bantu?',
          subtitle: 'Sampaikan masukan atau tanyakan informasi seputar layanan Integrasi.',
        ),

        const SizedBox(height: 22),
        SegmentedButton<String>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(
              value: 'Kritik & Saran',
              label: Text('Kritik & Saran'),
              icon: Icon(Icons.rate_review_outlined),
            ),
            ButtonSegment(
              value: 'Tanya Minna',
              label: Text('Tanya Minna'),
              icon: Icon(Icons.question_answer_outlined),
            ),
          ],
          selected: {_activeFeature},
          onSelectionChanged: (value) {
            FocusScope.of(context).unfocus();
            _formKey.currentState?.reset();
            setState(() {
              _activeFeature = value.first;
            });
          },
        ),

        const SizedBox(height: 16),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.03, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Container(
            key: ValueKey(_activeFeature),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: _activeFeature == 'Kritik & Saran'
                ? _buildKritikSaranForm()
                : _buildTanyaMinnaForm(),
          ),
        ),
      ],
    ),
  );
}

class TentangKamiScreen extends StatelessWidget {
  const TentangKamiScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tentang Kami')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                HaloMinnaApp.navyDark,
                HaloMinnaApp.navy,
                HaloMinnaApp.blue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            children: [
              InstitutionLogos(light: true, size: 58),
              SizedBox(height: 23),
              Text(
                'HALO MINNA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Monitoring Integrasi Narapidana',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFD8E5F2), fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const SectionIntro(
          eyebrow: 'TENTANG LAYANAN',
          title: 'Informasi dalam satu akses',
          subtitle: 'Halo Minna dirancang sebagai sarana informasi status program integrasi dan kegiatan pembinaan bagi keluarga WBP.',
        ),
        const SizedBox(height: 18),
        InfoListTile(
          icon: Icons.domain_outlined,
          title: 'Profil UPT',
          description: 'Informasi mengenai profil, tugas, dan fungsi Unit Pelaksana Teknis Pemasyarakatan.',
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const VisiMisiScreen()));
          },
        ),
        InfoListTile(
          icon: Icons.phone_android_rounded,
          title: 'Halo Minna',
          description: 'Sarana informasi dan edukasi bagi keluarga WBP untuk memahami program integrasi, tahapan, serta prosedur pemasyarakatan.',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HaloMinnaInfoScreen()),
            );
          },
        ),
        InfoListTile(
          icon: Icons.account_tree_rounded,
          title: 'Alur Program Integrasi',
          description: 'Informasi tahapan proses program integrasi, mulai dari pengusulan hingga penerbitan SK.',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AlurProgramIntegrasiScreen(),
              ),
            );
          },
        ),
      ],
    ),
  );
}

class VisiMisiScreen extends StatelessWidget {
  const VisiMisiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visi & Misi')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        children: const [
          SectionIntro(
            eyebrow: 'PROFIL PEMASYARAKATAN',
            title: 'Visi & Misi',
            subtitle: 'Arah dan tujuan penyelenggaraan pemasyarakatan dalam mewujudkan pelayanan dan pembinaan yang PRIMA.',
          ),
          SizedBox(height: 18),
          VisiMisiSection(),
        ],
      ),
    );
  }
}

class HaloMinnaInfoScreen extends StatelessWidget {
  const HaloMinnaInfoScreen({super.key});

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Halo Minna')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 40),
          children: [
            Text(
              'Informasi yang mudah dipahami',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 22),

            // Tujuan Halo Minna
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    HaloMinnaApp.navyDark,
                    HaloMinnaApp.navy,
                    HaloMinnaApp.blue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    color: Color(0xFFF2BD55),
                    size: 30,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Mengapa Halo Minna Hadir?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Informasi mengenai proses pemasyarakatan perlu '
                    'dapat dipahami tidak hanya oleh WBP, tetapi juga '
                    'oleh keluarga. Halo Minna hadir untuk membantu '
                    'mendekatkan informasi tersebut melalui layanan '
                    'digital yang lebih mudah diakses dan dipahami.',
                    style: TextStyle(
                      color: Color(0xFFD8E5F2),
                      fontSize: 13,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            Text(
              'Tujuan dan Manfaat',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 14),

            _buildInfoCard(
              context,
              icon: Icons.info_outline_rounded,
              title: 'Pusat Informasi',
              description:
                  'Membantu keluarga memperoleh informasi mengenai '
                  'status program integrasi dan kegiatan pembinaan WBP.',
              color: const Color(0xFF2875B8),
            ),
            const SizedBox(height: 12),

            _buildInfoCard(
              context,
              icon: Icons.school_outlined,
              title: 'Sarana Edukasi',
              description:
                  'Memberikan pemahaman mengenai tahapan, persyaratan, '
                  'dan prosedur program integrasi agar keluarga '
                  'lebih memahami proses yang dijalani.',
              color: const Color(0xFF2E8B65),
            ),
            const SizedBox(height: 12),

            _buildInfoCard(
              context,
              icon: Icons.family_restroom_rounded,
              title: 'Pendamping Keluarga',
              description:
                  'Membantu keluarga memahami informasi pemasyarakatan '
                  'sehingga dapat mengikuti proses dan memberikan '
                  'dukungan yang tepat kepada WBP.',
              color: const Color(0xFFB47A27),
            ),

            const SizedBox(height: 26),

            Text(
              'Prinsip Layanan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 14),

            _buildInfoCard(
              context,
              icon: Icons.info_outline_rounded,
              title: 'Informatif',
              description:
                  'Menyajikan informasi yang relevan dan mudah dipahami.',
              color: const Color(0xFF2875B8),
            ),
            const SizedBox(height: 12),

            _buildInfoCard(
              context,
              icon: Icons.menu_book_rounded,
              title: 'Edukatif',
              description: 'Mendorong pemahaman keluarga terhadap proses dan prosedur pemasyarakatan.',
              color: const Color(0xFF2E8B65),
            ),
            const SizedBox(height: 12),

            _buildInfoCard(
              context,
              icon: Icons.accessibility_new_rounded,
              title: 'Mudah Diakses',
              description:
                  'Menghadirkan akses informasi melalui satu layanan digital.',
              color: const Color(0xFFB47A27),
            ),

            const SizedBox(height: 10),

            const SizedBox(height: 2),
            Center(
              child: Text(
                'Mendekatkan Informasi, Membangun Pemahaman.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VisiMisiSection extends StatelessWidget {
  const VisiMisiSection({super.key});

  static const Color _gold = Color(0xFFF2BD55);
  static const Color _navy = Color(0xFF061A30);

  static const List<String> _misi = [
    'Melaksanakan pembinaan warga binaan berbasis kompetensi dan kepribadian unggul.',
    'Memberikan pelayanan dan perlindungan hukum serta HAM yang berkeadilan.',
    'Mewujudkan pengelolaan anggaran dan kinerja yang akuntabel dan transparan.',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 650;

        final visiCard = _buildVisiCard();
        final misiCard = _buildMisiCard(context);

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: visiCard),
              const SizedBox(width: 16),
              Expanded(child: misiCard),
            ],
          );
        }

        return Column(
          children: [visiCard, const SizedBox(height: 16), misiCard],
        );
      },
    );
  }

  Widget _buildVisiCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, Color(0xFF123B60)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 9),
          const Text(
            'VISI',
            style: TextStyle(
              color: _gold,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              style: const TextStyle(
                color: _gold,
                fontSize: 23,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                height: 1.3,
              ),
              children: [
                TextSpan(text: '"Menjadi Penyelenggara Pemasyarakatan yang '),
                TextSpan(
                  text: 'PRIMA',
                  style: TextStyle(color: Colors.white),
                ),
                TextSpan(text: '"'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Profesional, Responsif, Integritas, Modern, Akuntabel.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildMisiCard(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 12),
              Text(
                'Misi',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          ..._misi.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF2E8B65),
                    size: 21,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InstitutionLogos extends StatelessWidget {
  final bool light;
  final double size;
  const InstitutionLogos({super.key, this.light = false, this.size = 64});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      LogoBox(asset: 'assets/images/logo_kemenimipas.png', size: size),
      SizedBox(width: size * .22),
      LogoBox(asset: 'assets/images/logo_pemasyarakatan.png', size: size),
    ],
  );
}

class LogoBox extends StatelessWidget {
  final String asset;
  final double size;
  const LogoBox({super.key, required this.asset, required this.size});
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    padding: EdgeInsets.all(size * .08),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(size * .18),
    ),
    child: Image.asset(
      asset,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) =>
          const Icon(Icons.account_balance_outlined, color: HaloMinnaApp.navy),
    ),
  );
}

class SectionIntro extends StatelessWidget {
  final String eyebrow, title, subtitle;

  const SectionIntro({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: TextStyle(
            color: colors.primary,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.3,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          title,
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 23,
            height: 1.2,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            color: colors.onSurfaceVariant,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class FeatureBanner extends StatelessWidget {
  final IconData icon;
  final String title, body;

  const FeatureBanner({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: colors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colors.onPrimaryContainer,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: TextStyle(
                    color: colors.onPrimaryContainer,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProgramCard extends StatelessWidget {
  final String title, category, description;
  final IconData icon;

  const ProgramCard({
    super.key,
    required this.title,
    required this.category,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: colors.onPrimaryContainer, size: 24),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontSize: 15, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  category.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.primary,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .7,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoListTile extends StatelessWidget {
  final IconData icon;
  final String title, description;
  final VoidCallback? onTap;

  const InfoListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Icon(icon, color: colors.primary, size: 22),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: colors.onSurface,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: colors.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NoticeCard extends StatelessWidget {
  final IconData icon;
  final String title, message;

  const NoticeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF332B1B)
        : const Color(0xFFFFF8E8);

    final borderColor = isDark
        ? const Color(0xFF65502B)
        : const Color(0xFFF0E0B8);

    final iconColor = isDark
        ? const Color(0xFFFFD580)
        : const Color(0xFF8A681F);

    final titleColor = isDark
        ? const Color(0xFFFFD580)
        : const Color(0xFF73551B);

    final messageColor = isDark
        ? const Color(0xFFE5D5B5)
        : const Color(0xFF6D5A35);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: messageColor,
                    fontSize: 11.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
