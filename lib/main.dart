import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HaloMinaApp());
}

class HaloMinaApp extends StatelessWidget {
  const HaloMinaApp({super.key});

  static const navy = Color(0xFF082B52);
  static const navyDark = Color(0xFF061F3B);
  static const gold = Color(0xFFD9A441);
  static const surface = Color(0xFFF6F8FB);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HALO MINNA',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: surface,
        colorScheme: ColorScheme.fromSeed(
          seedColor: navy,
          brightness: Brightness.light,
        ).copyWith(primary: navy, secondary: gold, surface: Colors.white),
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 17,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD8DEE8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD8DEE8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: navy, width: 1.5),
          ),
        ),
      ),
      home: const SplashScreen(),
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
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [HaloMinaApp.navyDark, HaloMinaApp.navy],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(child: Center(child: _SplashContent())),
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _SplashLogo(
                asset: 'assets/images/logo_kemenimipas.png',
                height: 64,
              ),
              const SizedBox(width: 20),
              _SplashLogo(
                asset: 'assets/images/logo_pemasyarakatan.png',
                height: 64,
              ),
            ],
          ),
          const SizedBox(height: 34),
          const Text(
            'HALO MINNA',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 31,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Monitoring Integrasi Narapidana',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFDCE7F4),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 52),
          SizedBox(
            width: 145,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const LinearProgressIndicator(
                minHeight: 4,
                backgroundColor: Color(0x406F8EAD),
                valueColor: AlwaysStoppedAnimation<Color>(HaloMinaApp.gold),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Memuat aplikasi...',
            style: TextStyle(color: Color(0xBFDCE7F4), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _SplashLogo extends StatelessWidget {
  final String asset;
  final double height;

  const _SplashLogo({required this.asset, required this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      height: height,
      width: height,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _accessCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isChecking = false;
  bool _obscureCode = false;

  @override
  void dispose() {
    _accessCodeController.dispose();
    super.dispose();
  }

  Future<void> _checkAccessCode() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isChecking = true);

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() => _isChecking = false);

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const StatusWbpPage()));
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_pemasyarakatan.png',
              width: 34,
              height: 34,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            const Text(
              'HALO MINNA',
              style: TextStyle(
                color: HaloMinaApp.navy,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 28 + bottom),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 14),
                _BrandHeader(),
                const SizedBox(height: 30),
                const Text(
                  'Monitoring Integrasi Narapidana',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: HaloMinaApp.navy,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  'Data Integrasi hanya dapat diakses menggunakan kode akses yang valid.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _accessCodeController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  autocorrect: false,
                  obscureText: _obscureCode,
                  maxLength: 20,
                  onFieldSubmitted: (_) => _checkAccessCode(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Kode akses wajib diisi.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Kode Akses',
                    hintText: 'Masukkan kode akses',
                    prefixIcon: const Icon(Icons.key_outlined),
                    suffixIcon: IconButton(
                      tooltip: _obscureCode
                          ? 'Tampilkan kode'
                          : 'Sembunyikan kode',
                      onPressed: () {
                        setState(() => _obscureCode = !_obscureCode);
                      },
                      icon: Icon(
                        _obscureCode
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 54,
                  child: FilledButton(
                    onPressed: _isChecking ? null : _checkAccessCode,
                    style: FilledButton.styleFrom(
                      backgroundColor: HaloMinaApp.navy,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF9AAABD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isChecking
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'LIHAT STATUS',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: .3,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 18),
                _InfoCard(
                  icon: Icons.info_outline_rounded,
                  text: 'Masukkan kode akses yang diberikan oleh petugas.',
                ),
                const SizedBox(height: 42),
                const Divider(color: Color(0xFFE2E8F0)),
                const SizedBox(height: 24),
                const Text(
                  'Layanan Informasi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Image.asset(
                  'assets/images/logo_upt.png',
                  width: 72,
                  height: 72,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Lapas Banceuy Bandung',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: HaloMinaApp.navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _BrandLogo(
            asset: 'assets/images/logo_kemenimipas.png',
            label: 'KEMENIMIPAS',
          ),
        ),
        const SizedBox(width: 28),
        Expanded(
          child: _BrandLogo(
            asset: 'assets/images/logo_pemasyarakatan.png',
            label: 'PEMASYARAKATAN',
          ),
        ),
      ],
    );
  }
}

class _BrandLogo extends StatelessWidget {
  final String asset;
  final String label;

  const _BrandLogo({required this.asset, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 82,
          alignment: Alignment.center,
          child: Image.asset(asset, fit: BoxFit.contain),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: HaloMinaApp.navy,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: .4,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD8E5F2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: HaloMinaApp.navy,
            size: 21,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF334155),
                fontSize: 12.5,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatusWbpPage extends StatelessWidget {
  const StatusWbpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HaloMinaApp.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 8,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: HaloMinaApp.navy,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Status WBP',
          style: TextStyle(
            color: HaloMinaApp.navy,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _WbpIdentityCard(),
              const SizedBox(height: 16),
              _StatusSummaryCard(),
              const SizedBox(height: 28),
              const Text(
                'Riwayat Program',
                style: TextStyle(
                  color: HaloMinaApp.navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              _Timeline(),
            ],
          ),
        ),
      ),
    );
  }
}

class _WbpIdentityCard extends StatelessWidget {
  const _WbpIdentityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: HaloMinaApp.navy,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nama WBP',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
                SizedBox(height: 3),
                Text(
                  'Budi Santoso',
                  style: TextStyle(
                    color: HaloMinaApp.navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'No. Registrasi: 12345678',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusSummaryCard extends StatelessWidget {
  const _StatusSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: HaloMinaApp.navy,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Status Program',
                  style: TextStyle(
                    color: Color(0xFFDCE7F4),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'AKTIF',
                  style: TextStyle(
                    color: Color(0xFF166534),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Pembebasan Bersyarat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _StatusInfo(label: 'Mulai', value: '01 Feb 2026'),
              ),
              Expanded(
                child: _StatusInfo(label: 'Berakhir', value: '01 Feb 2027'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusInfo extends StatelessWidget {
  final String label;
  final String value;

  const _StatusInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFFB8C9DC), fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _TimelineItem(
          title: 'Pengajuan Integrasi',
          date: '10 Januari 2026',
          description: 'Pengajuan program integrasi telah diterima.',
          icon: Icons.description_outlined,
          isLast: false,
          isActive: true,
        ),
        _TimelineItem(
          title: 'Verifikasi',
          date: '20 Januari 2026',
          description: 'Dokumen dan persyaratan telah diverifikasi.',
          icon: Icons.verified_outlined,
          isLast: false,
          isActive: true,
        ),
        _TimelineItem(
          title: 'Program Integrasi',
          date: '01 Februari 2026',
          description: 'WBP mulai menjalani program integrasi.',
          icon: Icons.home_work_outlined,
          isLast: false,
          isActive: true,
        ),
        _TimelineItem(
          title: 'Monitoring',
          date: 'Sedang berlangsung',
          description: 'Monitoring program integrasi masih berjalan.',
          icon: Icons.monitor_heart_outlined,
          isLast: true,
          isActive: false,
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final IconData icon;
  final bool isLast;
  final bool isActive;

  const _TimelineItem({
    required this.title,
    required this.date,
    required this.description,
    required this.icon,
    required this.isLast,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isActive
                        ? HaloMinaApp.navy
                        : const Color(0xFFE2E8F0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 19,
                    color: isActive ? Colors.white : const Color(0xFF94A3B8),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: const Color(0xFFD8E1EB),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: HaloMinaApp.navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: const TextStyle(
                        color: HaloMinaApp.gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12.5,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
