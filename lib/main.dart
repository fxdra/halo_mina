import 'package:flutter/material.dart';

void main() => runApp(const HaloMinnaApp());

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
  Widget build(BuildContext context) => MaterialApp(
    title: 'Halo Minna',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: canvas,
      colorScheme: ColorScheme.fromSeed(seedColor: navy)
          .copyWith(primary: navy, secondary: gold, surface: Colors.white),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: navy,
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: line),
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
      if (mounted)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AccessScreen()),
        );
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
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => _loading = false);
    // UI demo: validasi kode akses akan dihubungkan ke API pada tahap berikutnya.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
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
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.account_balance_outlined),
          ),
          const SizedBox(width: 10),
          const Text('HALO MINNA'),
        ],
      ),
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
              const Text(
                'Informasi Integrasi\nWarga Binaan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HaloMinnaApp.navy,
                  fontSize: 26,
                  height: 1.2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Pantau informasi program integrasi melalui satu akses yang mudah dan resmi.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HaloMinnaApp.muted,
                  height: 1.5,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: HaloMinnaApp.line),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x090B2D50),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          color: HaloMinnaApp.navy,
                        ),
                        SizedBox(width: 9),
                        Text(
                          'Masuk dengan Kode Akses',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: HaloMinnaApp.ink,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Gunakan kode akses yang diberikan oleh petugas.',
                      style: TextStyle(
                        color: HaloMinnaApp.muted,
                        fontSize: 12.5,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _controller,
                      textCapitalization: TextCapitalization.characters,
                      autocorrect: false,
                      maxLength: 20,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _continue(),
                      obscureText: !_showCode,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Kode akses wajib diisi.'
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Kode Akses',
                        hintText: 'Contoh: BNCY-XXXXXXXX',
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
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: _loading ? null : _continue,
                        icon: _loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
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
                          backgroundColor: HaloMinnaApp.navy,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const NoticeCard(
                icon: Icons.shield_outlined,
                title: 'Akses informasi yang aman',
                message: 'Jaga kerahasiaan kode akses dan jangan membagikannya kepada pihak yang tidak berkepentingan.',
              ),
              const SizedBox(height: 30),
              const Divider(color: HaloMinnaApp.line),
              const SizedBox(height: 18),
              const Text(
                'LAYANAN INFORMASI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HaloMinnaApp.muted,
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
              const Text(
                'Lapas Banceuy Bandung',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HaloMinnaApp.navy,
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
  static const menus = <MenuData>[
    MenuData(
      'Status Program',
      'Lihat status dan tahapan integrasi',
      Icons.fact_check_outlined,
      Color(0xFFE7EFF8),
    ),
    MenuData(
      'Program Integrasi',
      'Informasi dan pembinaan',
      Icons.account_tree_outlined,
      Color(0xFFF8F0DF),
    ),
    MenuData(
      'Daftar Program Integrasi',
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
      'Informasi layanan Halo Minna',
      Icons.account_balance_outlined,
      Color(0xFFE4F1F5),
    ),
    MenuData(
      'Kritik & Saran',
      'Sampaikan masukan layanan',
      Icons.forum_outlined,
      Color(0xFFF8E9E8),
    ),
  ];
  void _open(BuildContext context, int index) {
    final pages = <Widget>[
      const StatusProgramScreen(),
      const ProgramIntegrasiScreen(),
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
                          errorBuilder: (_, __, ___) => const Icon(
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
                      IconButton(
                        onPressed: () => showDialog<void>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Informasi aplikasi'),
                            content: const Text(
                              'UI Halo Minna masih dalam tahap pengembangan. Validasi kode akses dan data aktual akan dihubungkan melalui API.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Mengerti'),
                              ),
                            ],
                          ),
                        ),
                        icon: const Icon(
                          Icons.info_outline_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Selamat datang',
                    style: TextStyle(color: Color(0xFFD2DFEC), fontSize: 13),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Layanan Informasi\nProgram Integrasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      height: 1.18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Akses informasi program, tahapan, dan kegiatan pembinaan melalui Halo Minna.',
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
                      color: Colors.white.withOpacity(.10),
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
                  const Text(
                    'Menu Layanan',
                    style: TextStyle(
                      color: HaloMinnaApp.ink,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Pilih layanan yang ingin dibuka.',
                    style: TextStyle(color: HaloMinnaApp.muted, fontSize: 13),
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
                  const SizedBox(height: 20),
                  const NoticeCard(
                    icon: Icons.info_outline_rounded,
                    title: 'Tahap pengembangan',
                    message: 'Data pada halaman berikutnya masih berupa rancangan UI. Informasi aktual akan ditampilkan setelah API terhubung.',
                  ),
                  const SizedBox(height: 22),
                  const Center(
                    child: Text(
                      'LAPAS BANCEUY BANDUNG',
                      style: TextStyle(
                        color: HaloMinnaApp.muted,
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
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(19),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: HaloMinnaApp.line),
          boxShadow: const [
            BoxShadow(
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
                color: menu.tint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(menu.icon, color: HaloMinnaApp.navy, size: 24),
            ),
            const Spacer(),
            Text(
              menu.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: HaloMinnaApp.ink,
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
              style: const TextStyle(
                color: HaloMinnaApp.muted,
                fontSize: 11,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 9),
            const Row(
              children: [
                Text(
                  'Buka menu',
                  style: TextStyle(
                    color: HaloMinnaApp.blue,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 13,
                  color: HaloMinnaApp.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class StatusProgramScreen extends StatelessWidget {
  const StatusProgramScreen({super.key});
  static const steps = <TimelineData>[
    TimelineData(
      'Pengajuan / Usulan',
      'Belum ada tanggal',
      Icons.description_outlined,
    ),
    TimelineData(
      'Pengambilan Berkas',
      'Belum ada tanggal',
      Icons.folder_open_outlined,
    ),
    TimelineData(
      'Pengembalian Berkas',
      'Belum ada tanggal',
      Icons.assignment_turned_in_outlined,
    ),
    TimelineData('Permintaan Litmas', 'Belum ada tanggal', Icons.outgoing_mail),
    TimelineData('Litmas Bapas', 'Belum ada tanggal', Icons.apartment_outlined),
    TimelineData(
      'Hasil Litmas',
      'Belum ada tanggal',
      Icons.fact_check_outlined,
    ),
    TimelineData('Sidang TPP', 'Belum ada tanggal', Icons.groups_outlined),
    TimelineData(
      'Verifikasi Ditjen',
      'Belum ada tanggal',
      Icons.verified_outlined,
    ),
    TimelineData(
      'Persetujuan Menteri',
      'Belum ada tanggal',
      Icons.gavel_outlined,
    ),
    TimelineData('Otorisasi SK', 'Belum ada tanggal', Icons.approval_outlined),
    TimelineData(
      'Pelaksanaan',
      'Belum ada tanggal',
      Icons.event_available_outlined,
    ),
    TimelineData('Pembebasan', 'Belum ada tanggal', Icons.flag_outlined),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Status Program')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
      children: [
        const SectionIntro(
          eyebrow: 'STATUS WBP',
          title: 'Ringkasan Program',
          subtitle: 'Informasi identitas dan tahapan program integrasi.',
        ),
        const SizedBox(height: 18),
        const IdentityCard(),
        const SizedBox(height: 14),
        const ProgramStatusCard(),
        const SizedBox(height: 25),
        const Text(
          'Tahapan Program',
          style: TextStyle(
            color: HaloMinnaApp.ink,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tanggal akan ditampilkan jika tersedia pada data resmi.',
          style: TextStyle(
            color: HaloMinnaApp.muted,
            fontSize: 12.5,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 17),
        ...List.generate(
          steps.length,
          (i) => TimelineRow(
            data: steps[i],
            isLast: i == steps.length - 1,
            index: i,
          ),
        ),
        const SizedBox(height: 14),
        const NoticeCard(
          icon: Icons.info_outline_rounded,
          title: 'Catatan',
          message: 'Tahapan tanpa tanggal bukan berarti gagal. Status dan tanggal aktual mengikuti data yang tersedia dari sistem.',
        ),
      ],
    ),
  );
}

class IdentityCard extends StatelessWidget {
  const IdentityCard({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: HaloMinnaApp.line),
    ),
    child: Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1F8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: HaloMinnaApp.navy,
            size: 29,
          ),
        ),
        const SizedBox(width: 13),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NAMA WBP',
                style: TextStyle(
                  color: HaloMinnaApp.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .8,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Contoh Nama WBP',
                style: TextStyle(
                  color: HaloMinnaApp.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'No. Registrasi: —',
                style: TextStyle(color: HaloMinnaApp.muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class ProgramStatusCard extends StatelessWidget {
  const ProgramStatusCard({super.key});
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
        const Row(
          children: [
            Expanded(
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
            StatusPill(label: 'Contoh'),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'Jenis Usulan',
          style: TextStyle(color: Color(0xFFD7E3EF), fontSize: 12),
        ),
        const SizedBox(height: 4),
        const Text(
          'Pembebasan Bersyarat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 19),
        const Row(
          children: [
            Expanded(
              child: DateInfo(label: 'MULAI · 1/2 PIDANA', date: '—'),
            ),
            SizedBox(width: 14),
            Expanded(
              child: DateInfo(label: 'BERAKHIR · 2/3 PIDANA', date: '—'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Tanggal contoh belum diisi; data resmi akan mengikuti sistem.',
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
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF0CE),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: Color(0xFF815B12),
        fontSize: 10,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
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
  @override
  Widget build(BuildContext context) {
    final done = index == 0;
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
                    color: done ? const Color(0xFFE0F2E8) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: done ? const Color(0xFF6DB88A) : HaloMinnaApp.line,
                    ),
                  ),
                  child: Icon(
                    data.icon,
                    size: 17,
                    color: done ? const Color(0xFF237348) : HaloMinnaApp.muted,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 1.5, color: HaloMinnaApp.line),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: HaloMinnaApp.line),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title,
                          style: const TextStyle(
                            color: HaloMinnaApp.ink,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          data.date,
                          style: const TextStyle(
                            color: HaloMinnaApp.muted,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    done ? Icons.check_circle_rounded : Icons.schedule_rounded,
                    size: 18,
                    color: done
                        ? const Color(0xFF2D8A58)
                        : const Color(0xFF9AA8B7),
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

class ProgramIntegrasiScreen extends StatelessWidget {
  const ProgramIntegrasiScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Program Integrasi')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      children: const [
        SectionIntro(
          eyebrow: 'PEMBINAAN',
          title: 'Program Integrasi',
          subtitle: 'Ruang informasi kegiatan dan pembinaan yang mendukung proses integrasi.',
        ),
        SizedBox(height: 20),
        FeatureBanner(
          icon: Icons.diversity_3_outlined,
          title: 'Pembinaan dan pengembangan diri',
          body: 'Informasi program disajikan agar keluarga dapat mengenal kegiatan yang tersedia.',
        ),
        SizedBox(height: 22),
        ProgramCard(
          title: 'Santri',
          category: 'Pembinaan kerohanian',
          icon: Icons.menu_book_rounded,
          description:
              'Kegiatan pembinaan keagamaan dan penguatan nilai spiritual.',
        ),
        ProgramCard(
          title: 'Pramuka',
          category: 'Pembinaan karakter',
          icon: Icons.explore_outlined,
          description: 'Kegiatan untuk melatih kedisiplinan, kerja sama, dan tanggung jawab.',
        ),
        ProgramCard(
          title: 'Giatja',
          category: 'Kegiatan kerja',
          icon: Icons.handyman_outlined,
          description:
              'Kegiatan kerja dan keterampilan sebagai bagian dari pembinaan.',
        ),
        ProgramCard(
          title: 'Futsal',
          category: 'Olahraga',
          icon: Icons.sports_soccer_outlined,
          description:
              'Kegiatan olahraga untuk membangun kebugaran dan sportivitas.',
        ),
        SizedBox(height: 12),
        NoticeCard(
          icon: Icons.info_outline_rounded,
          title: 'Informasi contoh',
          message: 'Daftar dan deskripsi ini merupakan rancangan UI. Konten final dapat disesuaikan dengan data program yang dikelola petugas.',
        ),
      ],
    ),
  );
}

class DaftarProgramScreen extends StatelessWidget {
  const DaftarProgramScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Daftar Program Integrasi')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      children: const [
        SectionIntro(
          eyebrow: 'DAFTAR KEGIATAN',
          title: 'Kenali program pembinaan',
          subtitle:
              'Ringkasan kegiatan pembinaan yang ditampilkan untuk keluarga.',
        ),
        SizedBox(height: 20),
        ProgramCard(
          title: 'Santri',
          category: 'Kerohanian',
          icon: Icons.menu_book_rounded,
          description: 'Pembinaan keagamaan dan pembiasaan nilai positif.',
        ),
        ProgramCard(
          title: 'Pramuka',
          category: 'Karakter dan kedisiplinan',
          icon: Icons.explore_outlined,
          description:
              'Kegiatan kelompok yang menekankan kedisiplinan dan kerja sama.',
        ),
        ProgramCard(
          title: 'Giatja',
          category: 'Kerja dan keterampilan',
          icon: Icons.handyman_outlined,
          description: 'Kegiatan kerja dan pengembangan keterampilan.',
        ),
        ProgramCard(
          title: 'Futsal',
          category: 'Olahraga',
          icon: Icons.sports_soccer_outlined,
          description: 'Olahraga tim untuk kebugaran dan sportivitas.',
        ),
      ],
    ),
  );
}

class StatistikScreen extends StatelessWidget {
  const StatistikScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Statistik')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      children: const [
        SectionIntro(
          eyebrow: 'RINGKASAN',
          title: 'Statistik Program',
          subtitle: 'Rancangan tampilan ringkasan keikutsertaan dalam program integrasi.',
        ),
        SizedBox(height: 20),
        FeatureBanner(
          icon: Icons.bar_chart_rounded,
          title: 'Data statistik belum terhubung',
          body: 'Angka partisipasi akan diisi dari data WBP setelah API tersedia.',
        ),
        SizedBox(height: 22),
        Text(
          'Status Keaktifan',
          style: TextStyle(
            color: HaloMinnaApp.ink,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 12),
        ActivityLegend(
          color: Color(0xFF23834D),
          title: 'Sangat Aktif',
          detail: 'Indikator hijau',
        ),
        ActivityLegend(
          color: Color(0xFFE4AE32),
          title: 'Aktif',
          detail: 'Indikator kuning',
        ),
        ActivityLegend(
          color: Color(0xFFD64B4B),
          title: 'Tidak Aktif',
          detail: 'Indikator merah',
        ),
        SizedBox(height: 14),
        NoticeCard(
          icon: Icons.info_outline_rounded,
          title: 'Belum ada angka statistik',
          message: 'Batas penentuan tingkat keaktifan belum ditetapkan, jadi tampilan ini belum menggunakan angka atau persentase.',
        ),
      ],
    ),
  );
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
  String _type = 'Saran';
  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Kritik & Saran')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      children: [
        const SectionIntro(
          eyebrow: 'SUARA PENGGUNA',
          title: 'Kritik & Saran',
          subtitle:
              'Masukan dapat membantu peningkatan kualitas layanan Halo Minna.',
        ),
        const SizedBox(height: 20),
        const FeatureBanner(
          icon: Icons.chat_bubble_outline_rounded,
          title: 'Sampaikan masukan',
          body: 'Form ini masih berupa rancangan. Pengiriman belum aktif karena kanal resmi belum dikonfigurasi.',
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: HaloMinnaApp.line),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Jenis masukan',
                  style: TextStyle(
                    color: HaloMinnaApp.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 9),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'Kritik',
                      label: Text('Kritik'),
                      icon: Icon(Icons.report_outlined),
                    ),
                    ButtonSegment(
                      value: 'Saran',
                      label: Text('Saran'),
                      icon: Icon(Icons.lightbulb_outline),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (v) => setState(() => _type = v.first),
                ),
                const SizedBox(height: 18),
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
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Pesan belum diisi.'
                      : null,
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'UI demo: pesan belum dikirim. Kanal pengiriman perlu dikonfigurasi.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.send_outlined),
                  label: const Text('Pratinjau Pengiriman'),
                  style: FilledButton.styleFrom(
                    backgroundColor: HaloMinnaApp.navy,
                    padding: const EdgeInsets.symmetric(vertical: 15),
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
        const InfoListTile(
          icon: Icons.fact_check_outlined,
          title: 'Status Program',
          description: 'Informasi status dan tahapan program integrasi.',
        ),
        const InfoListTile(
          icon: Icons.menu_book_outlined,
          title: 'Informasi Pembinaan',
          description: 'Ringkasan program pembinaan dan kegiatan.',
        ),
        const InfoListTile(
          icon: Icons.lock_outline_rounded,
          title: 'Akses Terbatas',
          description:
              'Informasi WBP dirancang untuk diakses menggunakan kode akses.',
        ),
        const SizedBox(height: 12),
        const NoticeCard(
          icon: Icons.info_outline_rounded,
          title: 'Informasi institusi',
          message: 'Rincian kontak, alamat, dan informasi resmi lainnya dapat dilengkapi setelah disepakati dan diverifikasi.',
        ),
      ],
    ),
  );
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
      errorBuilder: (_, __, ___) =>
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
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        eyebrow,
        style: const TextStyle(
          color: HaloMinnaApp.blue,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.3,
        ),
      ),
      const SizedBox(height: 7),
      Text(
        title,
        style: const TextStyle(
          color: HaloMinnaApp.ink,
          fontSize: 23,
          height: 1.2,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        subtitle,
        style: const TextStyle(
          color: HaloMinnaApp.muted,
          fontSize: 13,
          height: 1.5,
        ),
      ),
    ],
  );
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
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF1F8),
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: const Color(0xFFD6E2EF)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: HaloMinnaApp.navy),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: HaloMinnaApp.navy,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                body,
                style: const TextStyle(
                  color: HaloMinnaApp.ink,
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
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: HaloMinnaApp.line),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1F8),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: HaloMinnaApp.navy, size: 24),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: HaloMinnaApp.ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                category.toUpperCase(),
                style: const TextStyle(
                  color: HaloMinnaApp.blue,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .7,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                description,
                style: const TextStyle(
                  color: HaloMinnaApp.muted,
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

class InfoListTile extends StatelessWidget {
  final IconData icon;
  final String title, description;
  const InfoListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: HaloMinnaApp.line),
    ),
    child: Row(
      children: [
        Icon(icon, color: HaloMinnaApp.blue, size: 22),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: HaloMinnaApp.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: HaloMinnaApp.muted,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
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
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF8E8),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: const Color(0xFFF0E0B8)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF8A681F), size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF73551B),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: const TextStyle(
                  color: Color(0xFF6D5A35),
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
