import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const DrivoDashboardApp());

class C {
  static const blue = Color(0xFF075DFF);
  static const blueDark = Color(0xFF0045C7);
  static const bg = Color(0xFFF6F8FC);
  static const ink = Color(0xFF101828);
  static const muted = Color(0xFF667085);
  static const border = Color(0xFFE5EAF1);
  static const soft = Color(0xFFEAF2FF);
  static const green = Color(0xFF12A66A);
  static const orange = Color(0xFFF79009);
  static const purple = Color(0xFF7A5AF8);
  static const red = Color(0xFFD92D20);
  static const cyan = Color(0xFF20B8D0);
}

String tx(bool ar, String a, String e) => ar ? a : e;

enum Role { clinic, doctor }

enum Sec {
  overview,
  appointments,
  patients,
  doctors,
  consults,
  records,
  prescriptions,
  followups,
  services,
  payments,
  messages,
  alerts,
  reports,
  settings,
}

class AppCtrl extends ChangeNotifier {
  bool ar = true;
  bool collapsed = false;
  Role role = Role.clinic;
  Sec sec = Sec.overview;

  void lang() {
    ar = !ar;
    notifyListeners();
  }

  void setRole(Role r) {
    role = r;
    if (r == Role.doctor && (sec == Sec.doctors || sec == Sec.services)) {
      sec = Sec.overview;
    }
    notifyListeners();
  }

  void go(Sec s) {
    sec = s;
    notifyListeners();
  }

  void side() {
    collapsed = !collapsed;
    notifyListeners();
  }
}

class Patient {
  final String id, ar, en, initials, phone, conditionAr, conditionEn, last;
  final int age;

  const Patient(
    this.id,
    this.ar,
    this.en,
    this.initials,
    this.phone,
    this.conditionAr,
    this.conditionEn,
    this.last,
    this.age,
  );
}

class Doctor {
  final String id, ar, en, specAr, specEn, initials;
  final double rating;
  final int today;
  final bool online;

  const Doctor(
    this.id,
    this.ar,
    this.en,
    this.specAr,
    this.specEn,
    this.initials,
    this.rating,
    this.today,
    this.online,
  );
}

enum AStatus { confirmed, pending, progress, completed, cancelled }

class Appt {
  final String id, date, time;
  final Patient p;
  final Doctor d;
  final bool online;
  final int amount;
  AStatus status;
  bool paid;

  Appt(
    this.id,
    this.p,
    this.d,
    this.date,
    this.time,
    this.online,
    this.amount,
    this.status,
    this.paid,
  );
}

const patients = [
  Patient('PT-1048', 'سارة أحمد', 'Sara Ahmed', 'SA', '0100 123 4567', 'متابعة ضغط الدم', 'Blood pressure follow-up', '05 Sep 2026', 32),
  Patient('PT-1124', 'عمر خالد', 'Omar Khaled', 'OK', '0112 880 1134', 'مشاكل الجهاز الهضمي', 'Gastrointestinal symptoms', '04 Sep 2026', 41),
  Patient('PT-1188', 'نور علي', 'Nour Ali', 'NA', '0127 443 9001', 'متابعة جلدية', 'Dermatology follow-up', '03 Sep 2026', 27),
  Patient('PT-1210', 'محمد ياسر', 'Mohamed Yasser', 'MY', '0106 501 2844', 'فحص دوري', 'Routine check-up', '30 Aug 2026', 36),
  Patient('PT-1285', 'ليلى محمود', 'Laila Mahmoud', 'LM', '0155 320 7177', 'متابعة سكر', 'Diabetes follow-up', '28 Aug 2026', 55),
];

const doctors = [
  Doctor('DR-001', 'د. أحمد سامي', 'Dr. Ahmed Samy', 'باطنة وجهاز هضمي', 'Internal Medicine & Gastroenterology', 'AS', 4.9, 9, true),
  Doctor('DR-002', 'د. مريم خالد', 'Dr. Mariam Khaled', 'جلدية وتجميل', 'Dermatology & Aesthetics', 'MK', 4.8, 7, true),
  Doctor('DR-003', 'د. يوسف عمر', 'Dr. Youssef Omar', 'أسنان', 'Dentistry', 'YO', 4.7, 6, false),
  Doctor('DR-004', 'د. نورهان علي', 'Dr. Nourhan Ali', 'أطفال وحديثي الولادة', 'Pediatrics & Neonatology', 'NA', 4.9, 8, true),
];

class DemoStore extends ChangeNotifier {
  final List<Appt> appts = [
    Appt('AP-3508', patients[0], doctors[0], '05 Sep 2026', '06:30 PM', false, 450, AStatus.confirmed, true),
    Appt('AP-3510', patients[1], doctors[0], '05 Sep 2026', '07:00 PM', true, 450, AStatus.progress, true),
    Appt('AP-3514', patients[2], doctors[1], '05 Sep 2026', '07:30 PM', true, 600, AStatus.pending, false),
    Appt('AP-3517', patients[3], doctors[2], '05 Sep 2026', '08:00 PM', false, 350, AStatus.confirmed, true),
    Appt('AP-3521', patients[4], doctors[0], '06 Sep 2026', '05:30 PM', false, 450, AStatus.confirmed, true),
  ];

  void status(Appt a, AStatus s) {
    a.status = s;
    notifyListeners();
  }

  void pay(Appt a) {
    a.paid = true;
    notifyListeners();
  }
}

class DrivoDashboardApp extends StatefulWidget {
  const DrivoDashboardApp({super.key});

  @override
  State<DrivoDashboardApp> createState() => _AppState();
}

class _AppState extends State<DrivoDashboardApp> {
  final ctrl = AppCtrl();
  final store = DemoStore();

  @override
  void dispose() {
    ctrl.dispose();
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: ctrl,
        builder: (_, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Drivo Medical Dashboard',
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: C.bg,
            colorScheme: ColorScheme.fromSeed(seedColor: C.blue, surface: Colors.white),
            cardTheme: CardThemeData(
              elevation: 0,
              color: Colors.white,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: C.border),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: C.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: C.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: C.blue),
              ),
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: const BorderSide(color: C.border),
              ),
            ),
          ),
          home: Directionality(
            textDirection: ctrl.ar ? TextDirection.rtl : TextDirection.ltr,
            child: Shell(ctrl: ctrl, store: store),
          ),
        ),
      );
}

class Shell extends StatelessWidget {
  final AppCtrl ctrl;
  final DemoStore store;

  const Shell({super.key, required this.ctrl, required this.store});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1050;
    if (!wide) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text('Drivo Medical', style: TextStyle(fontWeight: FontWeight.w900)),
          actions: [
            TextButton.icon(
              onPressed: ctrl.lang,
              icon: const Icon(Icons.language),
              label: Text(ctrl.ar ? 'EN' : 'AR'),
            ),
            const SizedBox(width: 8),
          ],
        ),
        drawer: Drawer(width: 300, child: SafeArea(child: Side(ctrl: ctrl, mobile: true))),
        body: PageHost(ctrl: ctrl, store: store),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: ctrl.collapsed ? 84 : 275,
            child: Side(ctrl: ctrl, mobile: false),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                Top(ctrl: ctrl),
                const Divider(height: 1),
                Expanded(child: PageHost(ctrl: ctrl, store: store)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Nav {
  final Sec s;
  final IconData i;
  final String a, e;
  final bool clinic;

  const Nav(this.s, this.i, this.a, this.e, {this.clinic = false});
}

const navs = [
  Nav(Sec.overview, Icons.dashboard_rounded, 'نظرة عامة', 'Overview'),
  Nav(Sec.appointments, Icons.calendar_month_rounded, 'المواعيد', 'Appointments'),
  Nav(Sec.patients, Icons.groups_2_outlined, 'المرضى', 'Patients'),
  Nav(Sec.doctors, Icons.medical_services_outlined, 'الأطباء', 'Doctors', clinic: true),
  Nav(Sec.consults, Icons.video_camera_front_outlined, 'الاستشارات أونلاين', 'Online consultations'),
  Nav(Sec.records, Icons.folder_copy_outlined, 'الملفات الطبية', 'Medical records'),
  Nav(Sec.prescriptions, Icons.medication_outlined, 'الروشتات', 'Prescriptions'),
  Nav(Sec.followups, Icons.monitor_heart_outlined, 'المتابعات', 'Follow-ups'),
  Nav(Sec.services, Icons.health_and_safety_outlined, 'الخدمات', 'Services', clinic: true),
  Nav(Sec.payments, Icons.account_balance_wallet_outlined, 'المدفوعات', 'Payments'),
  Nav(Sec.messages, Icons.forum_outlined, 'الرسائل', 'Messages'),
  Nav(Sec.alerts, Icons.notifications_none_rounded, 'الإشعارات', 'Notifications'),
  Nav(Sec.reports, Icons.analytics_outlined, 'التقارير', 'Reports'),
  Nav(Sec.settings, Icons.settings_outlined, 'الإعدادات', 'Settings'),
];

class Side extends StatelessWidget {
  final AppCtrl ctrl;
  final bool mobile;

  const Side({super.key, required this.ctrl, required this.mobile});

  @override
  Widget build(BuildContext context) {
    final col = ctrl.collapsed && !mobile;
    final list = navs.where((n) => !(n.clinic && ctrl.role == Role.doctor)).toList();
    return ColoredBox(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: col ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: C.soft, borderRadius: BorderRadius.circular(13)),
                  child: const Icon(Icons.health_and_safety_rounded, color: C.blue),
                ),
                if (!col) ...[
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Drivo Medical', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                        Text('CONTROL CENTER', style: TextStyle(color: C.muted, fontSize: 9, letterSpacing: 1.1, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!col)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: C.bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: C.border),
                ),
                child: Row(
                  children: [
                    Expanded(child: RoleBtn(ctrl: ctrl, r: Role.clinic, icon: Icons.apartment_rounded, a: 'العيادة', e: 'Clinic')),
                    Expanded(child: RoleBtn(ctrl: ctrl, r: Role.doctor, icon: Icons.medical_services_outlined, a: 'الطبيب', e: 'Doctor')),
                  ],
                ),
              ),
            ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 2),
              itemBuilder: (context, i) {
                final n = list[i];
                final sel = n.s == ctrl.sec;
                return Tooltip(
                  message: col ? tx(ctrl.ar, n.a, n.e) : '',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      ctrl.go(n.s);
                      if (mobile) Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: col ? 0 : 12, vertical: 10),
                      decoration: BoxDecoration(color: sel ? C.soft : Colors.transparent, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: col ? MainAxisAlignment.center : MainAxisAlignment.start,
                        children: [
                          Icon(n.i, color: sel ? C.blue : C.muted, size: 21),
                          if (!col) ...[
                            const SizedBox(width: 11),
                            Expanded(
                              child: Text(
                                tx(ctrl.ar, n.a, n.e),
                                style: TextStyle(
                                  fontWeight: sel ? FontWeight.w800 : FontWeight.w600,
                                  color: sel ? C.blue : C.ink,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (!mobile)
            IconButton(
              onPressed: ctrl.side,
              icon: Icon(col ? Icons.keyboard_double_arrow_right : Icons.keyboard_double_arrow_left),
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class RoleBtn extends StatelessWidget {
  final AppCtrl ctrl;
  final Role r;
  final IconData icon;
  final String a, e;

  const RoleBtn({super.key, required this.ctrl, required this.r, required this.icon, required this.a, required this.e});

  @override
  Widget build(BuildContext context) {
    final s = ctrl.role == r;
    return InkWell(
      onTap: () => ctrl.setRole(r),
      borderRadius: BorderRadius.circular(9),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
        decoration: BoxDecoration(
          color: s ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: s ? const [BoxShadow(color: Color(0x11000000), blurRadius: 8)] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: s ? C.blue : C.muted),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                tx(ctrl.ar, a, e),
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: s ? C.blue : C.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Top extends StatelessWidget {
  final AppCtrl ctrl;

  const Top({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) => Container(
        height: 76,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: const Icon(Icons.search),
                  hintText: tx(ctrl.ar, 'ابحث عن مريض، موعد أو ملف...', 'Search patient, appointment or record...'),
                ),
              ),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: ctrl.lang,
              icon: const Icon(Icons.language, size: 17),
              label: Text(ctrl.ar ? 'EN' : 'AR', style: const TextStyle(fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 8),
            IconButton(onPressed: () => ctrl.go(Sec.alerts), icon: const Badge(child: Icon(Icons.notifications_none_rounded))),
            const SizedBox(width: 8),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: C.soft, borderRadius: BorderRadius.circular(13)),
              child: Center(
                child: Text(
                  ctrl.role == Role.clinic ? 'DA' : 'AS',
                  style: const TextStyle(color: C.blue, fontWeight: FontWeight.w900),
                ),
              ),
            ),
            const SizedBox(width: 9),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ctrl.role == Role.clinic ? tx(ctrl.ar, 'إدارة العيادة', 'Clinic Admin') : tx(ctrl.ar, 'د. أحمد سامي', 'Dr. Ahmed Samy'),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
                ),
                Text(
                  ctrl.role == Role.clinic ? tx(ctrl.ar, 'مدير النظام', 'Administrator') : tx(ctrl.ar, 'باطنة وجهاز هضمي', 'Internal Medicine'),
                  style: const TextStyle(color: C.muted, fontSize: 9.5),
                ),
              ],
            ),
          ],
        ),
      );
}

class PageHost extends StatelessWidget {
  final AppCtrl ctrl;
  final DemoStore store;

  const PageHost({super.key, required this.ctrl, required this.store});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: store,
        builder: (_, __) {
          switch (ctrl.sec) {
            case Sec.overview:
              return Overview(ctrl: ctrl, store: store);
            case Sec.appointments:
              return Appointments(ctrl: ctrl, store: store);
            case Sec.patients:
              return Patients(ctrl: ctrl);
            case Sec.doctors:
              return Doctors(ctrl: ctrl, store: store);
            case Sec.consults:
              return Consults(ctrl: ctrl, store: store);
            case Sec.records:
              return Records(ctrl: ctrl);
            case Sec.prescriptions:
              return Prescriptions(ctrl: ctrl);
            case Sec.followups:
              return Followups(ctrl: ctrl);
            case Sec.services:
              return Services(ctrl: ctrl);
            case Sec.payments:
              return Payments(ctrl: ctrl, store: store);
            case Sec.messages:
              return Messages(ctrl: ctrl);
            case Sec.alerts:
              return Alerts(ctrl: ctrl);
            case Sec.reports:
              return Reports(ctrl: ctrl);
            case Sec.settings:
              return Settings(ctrl: ctrl);
          }
        },
      );
}

class Frame extends StatelessWidget {
  final AppCtrl ctrl;
  final String a, e, sa, se;
  final List<Widget> body;
  final Widget? action;

  const Frame({super.key, required this.ctrl, required this.a, required this.e, required this.sa, required this.se, required this.body, this.action});

  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.all(MediaQuery.sizeOf(context).width < 700 ? 14 : 22),
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 10,
            children: [
              SizedBox(
                width: 650,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx(ctrl.ar, a, e), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 5),
                    Text(tx(ctrl.ar, sa, se), style: const TextStyle(color: C.muted, fontSize: 12.5)),
                  ],
                ),
              ),
              if (action != null) action!,
            ],
          ),
          const SizedBox(height: 20),
          ...body,
        ],
      );
}

class Overview extends StatelessWidget {
  final AppCtrl ctrl;
  final DemoStore store;

  const Overview({super.key, required this.ctrl, required this.store});

  @override
  Widget build(BuildContext context) {
    final ar = ctrl.ar;
    final doc = ctrl.role == Role.doctor;
    final stats = doc
        ? [
            (Icons.calendar_today_outlined, 'مواعيد اليوم', 'Today appointments', '9', '+2', C.blue),
            (Icons.hourglass_bottom_rounded, 'في الانتظار', 'Waiting patients', '3', '-1', C.orange),
            (Icons.video_call_outlined, 'أونلاين', 'Online consults', '4', '+1', C.purple),
            (Icons.task_alt_rounded, 'تم الكشف', 'Completed', '5', '56%', C.green),
          ]
        : [
            (Icons.calendar_month_outlined, 'حجوزات اليوم', 'Today bookings', '30', '+12.5%', C.blue),
            (Icons.groups_2_outlined, 'المرضى النشطون', 'Active patients', '1,248', '+8.2%', C.cyan),
            (Icons.payments_outlined, 'إيراد اليوم', 'Today revenue', '18,450 EGP', '+16.4%', C.green),
            (Icons.video_camera_front_outlined, 'استشارات أونلاين', 'Online consults', '11', '+3', C.purple),
          ];

    return Frame(
      ctrl: ctrl,
      a: doc ? 'مساء الخير، د. أحمد 👋' : 'لوحة تحكم العيادة',
      e: doc ? 'Good evening, Dr. Ahmed 👋' : 'Clinic overview',
      sa: doc ? 'نظرة سريعة على جدولك ومرضاك اليوم.' : 'كل مؤشرات التشغيل والحجوزات والمدفوعات في مكان واحد.',
      se: doc ? 'A quick view of your schedule and patients today.' : 'Bookings, patients, payments and operations in one place.',
      action: FilledButton.icon(
        onPressed: () => ctrl.go(Sec.appointments),
        icon: const Icon(Icons.add),
        label: Text(tx(ar, 'موعد جديد', 'New appointment')),
      ),
      body: [
        LayoutBuilder(
          builder: (_, c) {
            final n = c.maxWidth >= 1000 ? 4 : c.maxWidth >= 600 ? 2 : 1;
            final w = (c.maxWidth - (n - 1) * 12) / n;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: stats
                  .map((s) => SizedBox(width: w, child: Stat(icon: s.$1, a: s.$2, e: s.$3, val: s.$4, delta: s.$5, color: s.$6, ar: ar)))
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (_, c) {
            final chart = Card(
              child: Padding(
                padding: const EdgeInsets.all(17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(tx(ar, 'الأداء الأسبوعي', 'Weekly performance'), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15))),
                        const Text('Last 7 days', style: TextStyle(color: C.muted, fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const SizedBox(height: 210, child: CustomPaint(painter: LinePainter())),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        dot(C.blue, tx(ar, 'الحجوزات', 'Bookings')),
                        const SizedBox(width: 14),
                        dot(C.cyan, tx(ar, 'الإيراد', 'Revenue')),
                      ],
                    ),
                  ],
                ),
              ),
            );
            final mix = Card(
              child: Padding(
                padding: const EdgeInsets.all(17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx(ar, 'توزيع مواعيد اليوم', 'Today appointment mix'), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                    const SizedBox(height: 20),
                    const Center(child: SizedBox(width: 145, height: 145, child: CustomPaint(painter: DonutPainter()))),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Icon(Icons.circle, color: C.blue, size: 10),
                        const SizedBox(width: 6),
                        Expanded(child: Text(tx(ar, 'داخل العيادة', 'Clinic'))),
                        const Text('19 • 63%', style: TextStyle(fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.circle, color: C.purple, size: 10),
                        const SizedBox(width: 6),
                        Expanded(child: Text(tx(ar, 'أونلاين', 'Online'))),
                        const Text('11 • 37%', style: TextStyle(fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ],
                ),
              ),
            );

            return c.maxWidth < 850
                ? Column(children: [chart, const SizedBox(height: 12), mix])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: chart),
                      const SizedBox(width: 12),
                      Expanded(flex: 3, child: mix),
                    ],
                  );
          },
        ),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(tx(ar, 'مواعيد اليوم', "Today's appointments"), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15))),
                    TextButton(
                      onPressed: () => ctrl.go(Sec.appointments),
                      child: Text(tx(ar, 'عرض الكل', 'View all')),
                    ),
                  ],
                ),
                ...store.appts.take(4).map(
                  (a) => InkWell(
                    onTap: () => apptDialog(context, ctrl, store, a),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: Row(
                        children: [
                          Avatar(a.p.initials, 40),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tx(ar, a.p.ar, a.p.en), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                                Text('${a.time} • ${a.online ? tx(ar, 'أونلاين', 'Online') : tx(ar, 'عيادة', 'Clinic')}', style: const TextStyle(color: C.muted, fontSize: 10)),
                              ],
                            ),
                          ),
                          Status(a.status, ar),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget dot(Color c, String t) => Row(
        children: [
          Icon(Icons.circle, size: 8, color: c),
          const SizedBox(width: 5),
          Text(t, style: const TextStyle(color: C.muted, fontSize: 10)),
        ],
      );
}

class Stat extends StatelessWidget {
  final IconData icon;
  final String a, e, val, delta;
  final Color color;
  final bool ar;

  const Stat({super.key, required this.icon, required this.a, required this.e, required this.val, required this.delta, required this.color, required this.ar});

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: color.withValues(alpha: .1), borderRadius: BorderRadius.circular(12)),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const Spacer(),
                  Pill(delta, C.green),
                ],
              ),
              const SizedBox(height: 13),
              Text(val, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(tx(ar, a, e), style: const TextStyle(color: C.muted, fontSize: 11.5)),
            ],
          ),
        ),
      );
}

class LinePainter extends CustomPainter {
  const LinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = C.border;
    for (int i = 0; i < 5; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    _drawLine(canvas, size, [.55, .45, .66, .54, .8, .72, .9], C.blue);
    _drawLine(canvas, size, [.33, .4, .48, .45, .61, .68, .74], C.cyan);
  }

  void _drawLine(Canvas canvas, Size size, List<double> values, Color color) {
    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height * (1 - values[i]);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2.5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DonutPainter extends CustomPainter {
  const DonutPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final r = Offset.zero & size;
    final sw = size.width * .13;
    final p = Paint()..style = PaintingStyle.stroke..strokeWidth = sw..strokeCap = StrokeCap.round;
    canvas.drawArc(r.deflate(sw / 2), -math.pi / 2, math.pi * 1.22, false, p..color = C.blue);
    canvas.drawArc(r.deflate(sw / 2), math.pi * .82, math.pi * .67, false, p..color = C.purple);

    final tp = TextPainter(
      text: const TextSpan(
        text: '30\nToday',
        style: TextStyle(color: C.ink, fontWeight: FontWeight.w900, fontSize: 17),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Appointments extends StatefulWidget {
  final AppCtrl ctrl;
  final DemoStore store;

  const Appointments({super.key, required this.ctrl, required this.store});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  String q = '';
  String f = 'all';

  @override
  Widget build(BuildContext context) {
    final ar = widget.ctrl.ar;
    final list = widget.store.appts.where((a) {
      final haystack = '${a.id} ${a.p.ar} ${a.p.en} ${a.d.ar} ${a.d.en}'.toLowerCase();
      final matchesQuery = q.isEmpty || haystack.contains(q.toLowerCase());
      final matchesFilter =
          f == 'all' ||
          (f == 'online' && a.online) ||
          (f == 'clinic' && !a.online) ||
          (f == 'pending' && a.status == AStatus.pending);
      return matchesQuery && matchesFilter;
    }).toList();

    return Frame(
      ctrl: widget.ctrl,
      a: 'إدارة المواعيد',
      e: 'Appointments management',
      sa: 'تابع الحجوزات وحالة الدفع ونوع الاستشارة.',
      se: 'Manage bookings, payment status and consultation type.',
      action: FilledButton.icon(
        onPressed: () => toast(context, tx(ar, 'إنشاء موعد جديد - Demo', 'Create appointment - Demo')),
        icon: const Icon(Icons.add),
        label: Text(tx(ar, 'موعد جديد', 'New appointment')),
      ),
      body: [
        Filter(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SizedBox(
                width: 280,
                child: TextField(
                  onChanged: (v) => setState(() => q = v),
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: const Icon(Icons.search),
                    hintText: tx(ar, 'بحث بالاسم أو رقم الحجز', 'Search name or booking ID'),
                  ),
                ),
              ),
              FBtn(tx(ar, 'الكل', 'All'), f == 'all', () => setState(() => f = 'all')),
              FBtn(tx(ar, 'عيادة', 'Clinic'), f == 'clinic', () => setState(() => f = 'clinic')),
              FBtn(tx(ar, 'أونلاين', 'Online'), f == 'online', () => setState(() => f = 'online')),
              FBtn(tx(ar, 'انتظار', 'Pending'), f == 'pending', () => setState(() => f = 'pending')),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1020,
              child: Column(
                children: [
                  TH([
                    tx(ar, 'المريض', 'Patient'),
                    tx(ar, 'الطبيب', 'Doctor'),
                    tx(ar, 'الموعد', 'Schedule'),
                    tx(ar, 'النوع', 'Type'),
                    tx(ar, 'الدفع', 'Payment'),
                    tx(ar, 'الحالة', 'Status'),
                    '',
                  ]),
                  ...list.map(
                    (a) => InkWell(
                      onTap: () => apptDialog(context, widget.ctrl, widget.store, a),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        decoration: const BoxDecoration(border: Border(top: BorderSide(color: C.border))),
                        child: Row(
                          children: [
                            cell(
                              Row(
                                children: [
                                  Avatar(a.p.initials, 36),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(tx(ar, a.p.ar, a.p.en), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
                                        Text(a.p.id, style: const TextStyle(color: C.muted, fontSize: 9)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              20,
                            ),
                            cell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tx(ar, a.d.ar, a.d.en), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10.5)),
                                  Text(
                                    tx(ar, a.d.specAr, a.d.specEn),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: C.muted, fontSize: 9),
                                  ),
                                ],
                              ),
                              20,
                            ),
                            cell(Text('${a.date}\n${a.time}', style: const TextStyle(fontSize: 10.5)), 15),
                            cell(
                              Text(
                                a.online ? tx(ar, 'أونلاين', 'Online') : tx(ar, 'عيادة', 'Clinic'),
                                style: TextStyle(color: a.online ? C.purple : C.blue, fontWeight: FontWeight.w800, fontSize: 10),
                              ),
                              10,
                            ),
                            cell(
                              Text(
                                a.paid ? tx(ar, 'مدفوع', 'Paid') : tx(ar, 'غير مدفوع', 'Unpaid'),
                                style: TextStyle(color: a.paid ? C.green : C.orange, fontWeight: FontWeight.w800, fontSize: 10),
                              ),
                              10,
                            ),
                            cell(Status(a.status, ar), 12),
                            cell(
                              IconButton(
                                onPressed: () => apptDialog(context, widget.ctrl, widget.store, a),
                                icon: const Icon(Icons.more_horiz),
                              ),
                              6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void apptDialog(BuildContext context, AppCtrl ctrl, DemoStore store, Appt a) {
  final ar = ctrl.ar;
  showDialog(
    context: context,
    builder: (d) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tx(ar, 'تفاصيل الموعد', 'Appointment details'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                        Text(a.id, style: const TextStyle(color: C.muted, fontSize: 10)),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(d), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 14),
              Box(
                Row(
                  children: [
                    Avatar(a.p.initials, 50),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tx(ar, a.p.ar, a.p.en), style: const TextStyle(fontWeight: FontWeight.w900)),
                          Text('${a.p.id} • ${a.p.age} ${tx(ar, 'سنة', 'yrs')}', style: const TextStyle(color: C.muted, fontSize: 10)),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(d);
                        ctrl.go(Sec.patients);
                      },
                      child: Text(tx(ar, 'فتح الملف', 'Open profile')),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              KV(tx(ar, 'الطبيب', 'Doctor'), tx(ar, a.d.ar, a.d.en)),
              KV(tx(ar, 'الموعد', 'Schedule'), '${a.date} • ${a.time}'),
              KV(tx(ar, 'نوع الزيارة', 'Visit type'), a.online ? tx(ar, 'استشارة أونلاين', 'Online consultation') : tx(ar, 'داخل العيادة', 'Clinic visit')),
              KV(tx(ar, 'الدفع', 'Payment'), '${a.amount} EGP • ${a.paid ? tx(ar, 'مدفوع', 'Paid') : tx(ar, 'غير مدفوع', 'Unpaid')}'),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (a.status == AStatus.pending)
                    FilledButton.icon(
                      onPressed: () {
                        store.status(a, AStatus.confirmed);
                        Navigator.pop(d);
                        toast(context, tx(ar, 'تم تأكيد الموعد', 'Appointment confirmed'));
                      },
                      icon: const Icon(Icons.check),
                      label: Text(tx(ar, 'تأكيد', 'Confirm')),
                    ),
                  if (a.online)
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(d);
                        ctrl.go(Sec.consults);
                      },
                      icon: const Icon(Icons.video_call),
                      label: Text(tx(ar, 'فتح الاستشارة', 'Open consultation')),
                    ),
                  if (!a.paid)
                    OutlinedButton.icon(
                      onPressed: () {
                        store.pay(a);
                        Navigator.pop(d);
                        toast(context, tx(ar, 'تم تسجيل الدفع', 'Payment marked paid'));
                      },
                      icon: const Icon(Icons.payments),
                      label: Text(tx(ar, 'تسجيل الدفع', 'Mark paid')),
                    ),
                  OutlinedButton.icon(
                    onPressed: () {
                      store.status(a, AStatus.completed);
                      Navigator.pop(d);
                      toast(context, tx(ar, 'تم إنهاء الزيارة', 'Visit completed'));
                    },
                    icon: const Icon(Icons.task_alt),
                    label: Text(tx(ar, 'إنهاء الزيارة', 'Complete')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void patientDialog(BuildContext context, AppCtrl ctrl, Patient p) {
  final ar = ctrl.ar;
  showDialog(
    context: context,
    builder: (d) => Dialog.fullscreen(
      child: Directionality(
        textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: C.bg,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(tx(ar, 'ملف المريض', 'Patient profile'), style: const TextStyle(fontWeight: FontWeight.w900)),
            leading: IconButton(onPressed: () => Navigator.pop(d), icon: const Icon(Icons.close)),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Avatar(p.initials, 70),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tx(ar, p.ar, p.en), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                            Text('${p.id} • ${p.age} ${tx(ar, 'سنة', 'years')}', style: const TextStyle(color: C.muted)),
                            Text(p.phone, style: const TextStyle(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      Pill(tx(ar, 'ملف نشط', 'Active'), C.green),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (_, c) {
                  final left = Card(
                    child: Padding(
                      padding: const EdgeInsets.all(17),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tx(ar, 'ملخص الحالة', 'Clinical summary'), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                          const SizedBox(height: 12),
                          KV(tx(ar, 'الحالة الحالية', 'Current condition'), tx(ar, p.conditionAr, p.conditionEn)),
                          KV(tx(ar, 'الحساسية', 'Allergies'), tx(ar, 'لا يوجد مسجل', 'None recorded')),
                          KV(tx(ar, 'فصيلة الدم', 'Blood group'), 'A+'),
                          KV(tx(ar, 'آخر زيارة', 'Last visit'), p.last),
                        ],
                      ),
                    ),
                  );
                  final right = Card(
                    child: Padding(
                      padding: const EdgeInsets.all(17),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tx(ar, 'إجراءات سريعة', 'Quick actions'), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              FilledButton.icon(
                                onPressed: () {
                                  Navigator.pop(d);
                                  ctrl.go(Sec.prescriptions);
                                },
                                icon: const Icon(Icons.medication),
                                label: Text(tx(ar, 'روشتة جديدة', 'New prescription')),
                              ),
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(d);
                                  ctrl.go(Sec.followups);
                                },
                                icon: const Icon(Icons.monitor_heart),
                                label: Text(tx(ar, 'متابعة', 'Follow-up')),
                              ),
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(d);
                                  ctrl.go(Sec.messages);
                                },
                                icon: const Icon(Icons.chat),
                                label: Text(tx(ar, 'رسالة', 'Message')),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                  return c.maxWidth < 800
                      ? Column(children: [left, const SizedBox(height: 12), right])
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: left),
                            const SizedBox(width: 12),
                            Expanded(child: right),
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class Patients extends StatefulWidget {
  final AppCtrl ctrl;

  const Patients({super.key, required this.ctrl});

  @override
  State<Patients> createState() => _PatientsState();
}

class _PatientsState extends State<Patients> {
  String q = '';

  @override
  Widget build(BuildContext context) {
    final ar = widget.ctrl.ar;
    final list = patients.where((p) => '${p.ar} ${p.en} ${p.id} ${p.phone}'.toLowerCase().contains(q.toLowerCase())).toList();

    return Frame(
      ctrl: widget.ctrl,
      a: 'سجل المرضى',
      e: 'Patient directory',
      sa: 'ملفات المرضى، الزيارات، التحاليل والمتابعات.',
      se: 'Patient profiles, visits, records and follow-up.',
      action: FilledButton.icon(
        onPressed: () => toast(context, tx(ar, 'إضافة مريض - Demo', 'Add patient - Demo')),
        icon: const Icon(Icons.person_add),
        label: Text(tx(ar, 'مريض جديد', 'New patient')),
      ),
      body: [
        Filter(
          child: TextField(
            onChanged: (v) => setState(() => q = v),
            decoration: InputDecoration(
              isDense: true,
              prefixIcon: const Icon(Icons.search),
              hintText: tx(ar, 'ابحث بالاسم أو رقم الملف أو الهاتف', 'Search name, ID or phone'),
            ),
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (_, c) {
            final n = c.maxWidth >= 1000 ? 3 : c.maxWidth >= 650 ? 2 : 1;
            final w = (c.maxWidth - (n - 1) * 12) / n;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: list
                  .map((p) => SizedBox(
                        width: w,
                        child: Card(
                          child: InkWell(
                            onTap: () => patientDialog(context, widget.ctrl, p),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Avatar(p.initials, 48),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(tx(ar, p.ar, p.en), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5)),
                                            Text('${p.id} • ${p.age} ${tx(ar, 'سنة', 'yrs')}', style: const TextStyle(color: C.muted, fontSize: 10)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Info(Icons.monitor_heart_outlined, tx(ar, p.conditionAr, p.conditionEn)),
                                  const SizedBox(height: 7),
                                  Info(Icons.history, p.last),
                                  const SizedBox(height: 7),
                                  Info(Icons.phone_outlined, p.phone),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () => patientDialog(context, widget.ctrl, p),
                                          child: Text(tx(ar, 'فتح الملف', 'Open profile')),
                                        ),
                                      ),
                                      const SizedBox(width: 7),
                                      IconButton(
                                        onPressed: () => widget.ctrl.go(Sec.messages),
                                        icon: const Icon(Icons.chat_outlined, color: C.blue),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class Doctors extends StatelessWidget {
  final AppCtrl ctrl;
  final DemoStore store;

  const Doctors({super.key, required this.ctrl, required this.store});

  @override
  Widget build(BuildContext context) {
    final ar = ctrl.ar;
    return Frame(
      ctrl: ctrl,
      a: 'الأطباء والجدول التشغيلي',
      e: 'Doctors & operations',
      sa: 'إدارة التخصصات والتوافر وجدول اليوم.',
      se: 'Manage specialties, availability and daily workload.',
      action: FilledButton.icon(
        onPressed: () => toast(context, tx(ar, 'إضافة طبيب - Demo', 'Add doctor - Demo')),
        icon: const Icon(Icons.person_add),
        label: Text(tx(ar, 'إضافة طبيب', 'Add doctor')),
      ),
      body: [
        LayoutBuilder(
          builder: (_, c) {
            final n = c.maxWidth >= 1000 ? 4 : c.maxWidth >= 650 ? 2 : 1;
            final w = (c.maxWidth - (n - 1) * 12) / n;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: doctors
                  .map((d) => SizedBox(
                        width: w,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Avatar(d.initials, 48),
                                    const SizedBox(width: 9),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(tx(ar, d.ar, d.en), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                                          Text(tx(ar, d.specAr, d.specEn), maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: C.muted, fontSize: 9.5)),
                                        ],
                                      ),
                                    ),
                                    Pill(d.online ? tx(ar, 'متاح', 'Available') : tx(ar, 'غير متاح', 'Offline'), d.online ? C.green : C.muted),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(child: Metric(tx(ar, 'اليوم', 'Today'), '${d.today}')),
                                    Expanded(child: Metric(tx(ar, 'التقييم', 'Rating'), '${d.rating} ★')),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () => doctorDialog(context, ctrl, store, d),
                                    child: Text(tx(ar, 'عرض الجدول', 'View schedule')),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

void doctorDialog(BuildContext context, AppCtrl ctrl, DemoStore store, Doctor d) {
  final ar = ctrl.ar;
  showDialog(
    context: context,
    builder: (x) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Avatar(d.initials, 50),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tx(ar, d.ar, d.en), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
                        Text(tx(ar, d.specAr, d.specEn), style: const TextStyle(color: C.muted, fontSize: 10)),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(x), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 16),
              Text(tx(ar, 'جدول اليوم', "Today's schedule"), style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              ...store.appts.where((a) => a.d.id == d.id).map(
                (a) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Avatar(a.p.initials, 38),
                  title: Text(tx(ar, a.p.ar, a.p.en), style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text('${a.time} • ${a.online ? tx(ar, 'أونلاين', 'Online') : tx(ar, 'عيادة', 'Clinic')}'),
                  trailing: Status(a.status, ar),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(x);
                    ctrl.setRole(Role.doctor);
                  },
                  icon: const Icon(Icons.login),
                  label: Text(tx(ar, 'فتح لوحة الطبيب', 'Open doctor dashboard')),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class Consults extends StatelessWidget {
  final AppCtrl ctrl;
  final DemoStore store;

  const Consults({super.key, required this.ctrl, required this.store});

  @override
  Widget build(BuildContext context) {
    final ar = ctrl.ar;
    final list = store.appts.where((a) => a.online).toList();
    return Frame(
      ctrl: ctrl,
      a: 'مركز الاستشارات الأونلاين',
      e: 'Online consultation center',
      sa: 'غرفة انتظار وجلسات مباشرة وملاحظات الكشف.',
      se: 'Waiting room, live sessions and consultation notes.',
      body: [
        LayoutBuilder(
          builder: (_, c) {
            final queue = Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(tx(ar, 'غرفة الانتظار', 'Waiting room'), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15))),
                        Pill(tx(ar, 'النظام متصل', 'System online'), C.green),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...list.map(
                      (a) => Box(
                        Row(
                          children: [
                            Avatar(a.p.initials, 42),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tx(ar, a.p.ar, a.p.en), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                                  Text('${a.time} • ${tx(ar, a.d.ar, a.d.en)}', style: const TextStyle(color: C.muted, fontSize: 9.5)),
                                ],
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: () => videoRoom(context, ctrl, store, a),
                              icon: const Icon(Icons.video_call, size: 18),
                              label: Text(tx(ar, 'دخول', 'Join')),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
            final stats = Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx(ar, 'حالة اليوم', 'Today status'), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                    const SizedBox(height: 12),
                    Big(Icons.video_call, C.purple, tx(ar, 'جلسات اليوم', 'Sessions today'), '11'),
                    const SizedBox(height: 10),
                    Big(Icons.schedule, C.orange, tx(ar, 'متوسط الانتظار', 'Avg. wait'), '04:20'),
                    const SizedBox(height: 10),
                    Big(Icons.thumb_up_alt_outlined, C.green, tx(ar, 'رضا المرضى', 'Satisfaction'), '96%'),
                  ],
                ),
              ),
            );
            return c.maxWidth < 850
                ? Column(children: [queue, const SizedBox(height: 12), stats])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: queue),
                      const SizedBox(width: 12),
                      Expanded(flex: 3, child: stats),
                    ],
                  );
          },
        ),
      ],
    );
  }
}

void videoRoom(BuildContext context, AppCtrl ctrl, DemoStore store, Appt a) {
  final ar = ctrl.ar;
  showDialog(
    context: context,
    builder: (d) => Dialog.fullscreen(
      child: Directionality(
        textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: const Color(0xFF0D1322),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0D1322),
            foregroundColor: Colors.white,
            title: Text(tx(ar, 'الاستشارة الأونلاين', 'Online consultation')),
            leading: IconButton(onPressed: () => Navigator.pop(d), icon: const Icon(Icons.close)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF171E30),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Avatar(a.p.initials, 110),
                                const SizedBox(height: 14),
                                Text(tx(ar, a.p.ar, a.p.en), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                                const Text('Connected', style: TextStyle(color: Color(0xFF8BE2B7))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          Call(Icons.mic, 'Mic', () => toast(context, 'Microphone toggled')),
                          Call(Icons.videocam, 'Camera', () => toast(context, 'Camera toggled')),
                          Call(Icons.screen_share, 'Share', () => toast(context, 'Screen share demo')),
                          Call(
                            Icons.call_end,
                            'End',
                            () {
                              store.status(a, AStatus.completed);
                              Navigator.pop(d);
                            },
                            danger: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tx(ar, 'ملف المريض', 'Patient panel'), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                        const SizedBox(height: 10),
                        KV(tx(ar, 'رقم الملف', 'Patient ID'), a.p.id),
                        KV(tx(ar, 'الحالة', 'Condition'), tx(ar, a.p.conditionAr, a.p.conditionEn)),
                        const Divider(),
                        Text(tx(ar, 'ملاحظات الجلسة', 'Consultation notes'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
                        const SizedBox(height: 7),
                        Expanded(
                          child: TextField(
                            expands: true,
                            maxLines: null,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(hintText: tx(ar, 'اكتب التشخيص والملاحظات...', 'Write diagnosis and notes...')),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () => toast(context, tx(ar, 'تم حفظ الملاحظات', 'Notes saved')),
                            child: Text(tx(ar, 'حفظ', 'Save')),
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
      ),
    ),
  );
}

class Records extends StatelessWidget {
  final AppCtrl ctrl;

  const Records({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final ar = ctrl.ar;
    final records = [
      ('CBC - Complete Blood Count', patients[0], 'Lab test', '02 Sep 2026', 'PDF', Icons.biotech_outlined),
      ('Abdominal Ultrasound', patients[1], 'Imaging', '01 Sep 2026', 'JPG', Icons.image_outlined),
      ('HbA1c Test', patients[4], 'Lab test', '27 Aug 2026', 'PDF', Icons.science_outlined),
    ];

    return Frame(
      ctrl: ctrl,
      a: 'الملفات الطبية',
      e: 'Medical records',
      sa: 'تحاليل وأشعات وتقارير المرضى في مكان واحد.',
      se: 'Labs, imaging and reports in one workspace.',
      action: FilledButton.icon(
        onPressed: () => toast(context, tx(ar, 'رفع ملف - Demo', 'Upload record - Demo')),
        icon: const Icon(Icons.upload_file),
        label: Text(tx(ar, 'رفع ملف', 'Upload')),
      ),
      body: [
        Card(
          child: Column(
            children: [
              TH([
                tx(ar, 'الملف', 'Record'),
                tx(ar, 'المريض', 'Patient'),
                tx(ar, 'النوع', 'Type'),
                tx(ar, 'التاريخ', 'Date'),
                tx(ar, 'الصيغة', 'Format'),
                '',
              ]),
              ...records.map(
                (e) => Container(
                  padding: const EdgeInsets.all(13),
                  decoration: const BoxDecoration(border: Border(top: BorderSide(color: C.border))),
                  child: Row(
                    children: [
                      cell(
                        Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(color: C.soft, borderRadius: BorderRadius.circular(11)),
                              child: Icon(e.$6, color: C.blue, size: 19),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(e.$1, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10.5))),
                          ],
                        ),
                        25,
                      ),
                      cell(Text(tx(ar, e.$2.ar, e.$2.en), style: const TextStyle(fontSize: 10.5)), 20),
                      cell(Text(e.$3, style: const TextStyle(color: C.muted, fontSize: 10)), 14),
                      cell(Text(e.$4, style: const TextStyle(fontSize: 10)), 13),
                      cell(Text(e.$5, style: const TextStyle(color: C.blue, fontWeight: FontWeight.w900, fontSize: 10)), 8),
                      cell(
                        IconButton(
                          onPressed: () => recordDialog(context, ctrl, e.$1, e.$2, e.$5, e.$6),
                          icon: const Icon(Icons.visibility_outlined, size: 18),
                        ),
                        7,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void recordDialog(BuildContext context, AppCtrl ctrl, String title, Patient p, String type, IconData icon) {
  final ar = ctrl.ar;
  showDialog(
    context: context,
    builder: (d) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                        Text(tx(ar, p.ar, p.en), style: const TextStyle(color: C.muted, fontSize: 10)),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(d), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(color: C.bg, borderRadius: BorderRadius.circular(17), border: Border.all(color: C.border)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 60, color: C.blue),
                    const SizedBox(height: 10),
                    Text(type, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
                    Text(tx(ar, 'معاينة تجريبية', 'Demo preview'), style: const TextStyle(color: C.muted)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => toast(context, tx(ar, 'مشاركة - Demo', 'Share - Demo')),
                    icon: const Icon(Icons.share),
                    label: Text(tx(ar, 'مشاركة', 'Share')),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => toast(context, tx(ar, 'تنزيل - Demo', 'Download - Demo')),
                    icon: const Icon(Icons.download),
                    label: Text(tx(ar, 'تنزيل', 'Download')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class Prescriptions extends StatelessWidget {
  final AppCtrl ctrl;

  const Prescriptions({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final ar = ctrl.ar;
    return Frame(
      ctrl: ctrl,
      a: 'الروشتات والأدوية',
      e: 'Prescriptions & medication',
      sa: 'كتابة الروشتات وتعليمات الجرعات ومراجعة الوصفات السابقة.',
      se: 'Create prescriptions, dosage instructions and review history.',
      action: FilledButton.icon(
        onPressed: () => prescDialog(context, ctrl),
        icon: const Icon(Icons.add),
        label: Text(tx(ar, 'روشتة جديدة', 'New prescription')),
      ),
      body: [
        ...patients.take(3).map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(14),
                leading: Avatar(p.initials, 44),
                title: Text(tx(ar, p.ar, p.en), style: const TextStyle(fontWeight: FontWeight.w900)),
                subtitle: Text('RX-${2098 - p.age} • ${p.last}', style: const TextStyle(color: C.muted, fontSize: 10)),
                trailing: OutlinedButton(
                  onPressed: () => prescDialog(context, ctrl, p: p),
                  child: Text(tx(ar, 'عرض', 'Open')),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void prescDialog(BuildContext context, AppCtrl ctrl, {Patient? p}) {
  final ar = ctrl.ar;
  showDialog(
    context: context,
    builder: (d) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tx(ar, 'كتابة روشتة', 'Create prescription'),
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 19),
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(d), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: (p ?? patients.first).id,
                decoration: InputDecoration(labelText: tx(ar, 'المريض', 'Patient')),
                items: patients.map((x) => DropdownMenuItem(value: x.id, child: Text(tx(ar, x.ar, x.en)))).toList(),
                onChanged: (_) {},
              ),
              const SizedBox(height: 10),
              TextField(decoration: InputDecoration(labelText: tx(ar, 'التشخيص', 'Diagnosis'))),
              const SizedBox(height: 10),
              Box(
                Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.medication, color: C.blue),
                      title: const Text('Gastro Calm 20mg'),
                      subtitle: Text(tx(ar, 'مرة يوميًا قبل الإفطار', 'Once daily before breakfast')),
                    ),
                    ListTile(
                      leading: const Icon(Icons.medication, color: C.blue),
                      title: const Text('Vitamin D3'),
                      subtitle: Text(tx(ar, 'قرص بعد الغداء', 'One tablet after lunch')),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextField(maxLines: 3, decoration: InputDecoration(labelText: tx(ar, 'تعليمات إضافية', 'Additional instructions'))),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(d);
                    toast(context, tx(ar, 'تم حفظ الروشتة وإرسالها للمريض', 'Prescription saved and sent'));
                  },
                  icon: const Icon(Icons.send),
                  label: Text(tx(ar, 'حفظ وإرسال', 'Save & send')),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class Followups extends StatelessWidget {
  final AppCtrl ctrl;

  const Followups({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final ar = ctrl.ar;
    return Frame(
      ctrl: ctrl,
      a: 'متابعة الحالات',
      e: 'Patient follow-up',
      sa: 'راقب تقدم المرضى بعد الكشف وحدد من يحتاج مراجعة.',
      se: 'Track recovery and identify patients who need review.',
      body: [
        LayoutBuilder(
          builder: (_, c) {
            final n = c.maxWidth >= 900 ? 3 : c.maxWidth >= 600 ? 2 : 1;
            final w = (c.maxWidth - (n - 1) * 12) / n;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: patients.take(3).toList().asMap().entries.map((e) {
                final p = e.value;
                final score = [8, 6, 9][e.key];
                return SizedBox(
                  width: w,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Avatar(p.initials, 42),
                              const SizedBox(width: 8),
                              Expanded(child: Text(tx(ar, p.ar, p.en), style: const TextStyle(fontWeight: FontWeight.w900))),
                              Pill('$score/10', score >= 8 ? C.green : C.orange),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            tx(ar, 'تم تسجيل متابعة جديدة للحالة. راجع الملاحظات وحدد الإجراء التالي.', 'A new follow-up was submitted. Review notes and decide the next action.'),
                            style: const TextStyle(color: C.muted, fontSize: 10.5, height: 1.4),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => patientDialog(context, ctrl, p),
                                  child: Text(tx(ar, 'فتح الملف', 'Open patient')),
                                ),
                              ),
                              const SizedBox(width: 7),
                              IconButton(
                                onPressed: () => ctrl.go(Sec.messages),
                                icon: const Icon(Icons.chat_outlined, color: C.blue),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class Services extends StatelessWidget {
  final AppCtrl ctrl;

  const Services({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final ar = ctrl.ar;
    final list = [
      (Icons.biotech_outlined, 'باقة تحاليل دورية', 'Routine lab package', '750 EGP', '34'),
      (Icons.monitor_heart_outlined, 'متابعة ضغط وسكر', 'BP & glucose follow-up', '300 EGP', '51'),
      (Icons.vaccines_outlined, 'تطعيم موسمي', 'Seasonal vaccination', '550 EGP', '19'),
      (Icons.home_outlined, 'زيارة منزلية', 'Home visit', '900 EGP', '12'),
    ];
    return Frame(
      ctrl: ctrl,
      a: 'الخدمات والباقات',
      e: 'Services & packages',
      sa: 'إدارة الخدمات المتاحة للحجز ومتابعة الأداء.',
      se: 'Manage bookable services and monitor performance.',
      action: FilledButton.icon(
        onPressed: () => toast(context, tx(ar, 'إضافة خدمة - Demo', 'Add service - Demo')),
        icon: const Icon(Icons.add),
        label: Text(tx(ar, 'خدمة جديدة', 'New service')),
      ),
      body: [
        LayoutBuilder(
          builder: (_, c) {
            final n = c.maxWidth >= 900 ? 4 : c.maxWidth >= 600 ? 2 : 1;
            final w = (c.maxWidth - (n - 1) * 12) / n;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: list
                  .map((x) => SizedBox(
                        width: w,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(color: C.soft, borderRadius: BorderRadius.circular(13)),
                                  child: Icon(x.$1, color: C.blue),
                                ),
                                const SizedBox(height: 12),
                                Text(tx(ar, x.$2, x.$3), style: const TextStyle(fontWeight: FontWeight.w900)),
                                Text(x.$4, style: const TextStyle(color: C.blue, fontWeight: FontWeight.w900)),
                                const Divider(height: 24),
                                Row(
                                  children: [
                                    Expanded(child: Metric(tx(ar, 'الحجوزات', 'Bookings'), x.$5)),
                                    Expanded(child: Metric(tx(ar, 'الحالة', 'Status'), tx(ar, 'نشطة', 'Active'))),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () => toast(context, tx(ar, 'إدارة الخدمة - Demo', 'Manage service - Demo')),
                                    child: Text(tx(ar, 'إدارة', 'Manage')),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class Payments extends StatelessWidget {
  final AppCtrl ctrl;
  final DemoStore store;

  const Payments({super.key, required this.ctrl, required this.store});

  @override
  Widget build(BuildContext context) {
    final ar = ctrl.ar;
    final list = store.appts.where((a) => a.paid).toList();
    return Frame(
      ctrl: ctrl,
      a: 'المدفوعات والتسويات',
      e: 'Payments & settlements',
      sa: 'تابع المدفوعات والإيرادات وطرق التحصيل.',
      se: 'Track payments, revenue and collection methods.',
      action: OutlinedButton.icon(
        onPressed: () => toast(context, tx(ar, 'تصدير التقرير - Demo', 'Export report - Demo')),
        icon: const Icon(Icons.download),
        label: Text(tx(ar, 'تصدير', 'Export')),
      ),
      body: [
        LayoutBuilder(
          builder: (_, c) {
            final n = c.maxWidth >= 850 ? 3 : 1;
            final w = (c.maxWidth - (n - 1) * 12) / n;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(width: w, child: Stat(icon: Icons.payments, a: 'إجمالي اليوم', e: 'Today collected', val: '18,450 EGP', delta: '+16.4%', color: C.green, ar: ar)),
                SizedBox(width: w, child: Stat(icon: Icons.credit_card, a: 'بطاقات', e: 'Cards', val: '12,300 EGP', delta: '67%', color: C.blue, ar: ar)),
                SizedBox(width: w, child: Stat(icon: Icons.account_balance_wallet, a: 'محافظ', e: 'Wallets', val: '6,150 EGP', delta: '33%', color: C.purple, ar: ar)),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              TH([
                tx(ar, 'العملية', 'Transaction'),
                tx(ar, 'المريض', 'Patient'),
                tx(ar, 'الوصف', 'Description'),
                tx(ar, 'المبلغ', 'Amount'),
                tx(ar, 'الحالة', 'Status'),
              ]),
              ...list.map(
                (a) => Container(
                  padding: const EdgeInsets.all(13),
                  decoration: const BoxDecoration(border: Border(top: BorderSide(color: C.border))),
                  child: Row(
                    children: [
                      cell(Text('TX-${a.id.substring(3)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10.5)), 15),
                      cell(Text(tx(ar, a.p.ar, a.p.en), style: const TextStyle(fontSize: 10.5)), 20),
                      cell(
                        Text(
                          a.online ? tx(ar, 'استشارة أونلاين', 'Online consultation') : tx(ar, 'كشف بالعيادة', 'Clinic consultation'),
                          style: const TextStyle(color: C.muted, fontSize: 9.5),
                        ),
                        25,
                      ),
                      cell(Text('${a.amount} EGP', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10.5)), 15),
                      cell(Pill(tx(ar, 'ناجحة', 'Successful'), C.green), 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Messages extends StatefulWidget {
  final AppCtrl ctrl;

  const Messages({super.key, required this.ctrl});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  int sel = 0;
  final input = TextEditingController();
  final extra = <String>[];

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = widget.ctrl.ar;
    final p = patients[sel];
    return Frame(
      ctrl: widget.ctrl,
      a: 'الرسائل والتواصل',
      e: 'Messages & communication',
      sa: 'تواصل مع المرضى من داخل لوحة التحكم.',
      se: 'Communicate with patients from the dashboard.',
      body: [
        Card(
          child: SizedBox(
            height: 590,
            child: Row(
              children: [
                SizedBox(
                  width: 280,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: const Icon(Icons.search),
                            hintText: tx(ar, 'بحث', 'Search'),
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: ListView.builder(
                          itemCount: patients.length,
                          itemBuilder: (_, i) {
                            final x = patients[i];
                            return InkWell(
                              onTap: () => setState(() => sel = i),
                              child: Container(
                                color: sel == i ? C.soft : null,
                                padding: const EdgeInsets.all(11),
                                child: Row(
                                  children: [
                                    Avatar(x.initials, 40),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(tx(ar, x.ar, x.en), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5)),
                                          Text(
                                            i == 0
                                                ? tx(ar, 'هل أقدر أرفع التحليل هنا؟', 'Can I upload the test here?')
                                                : tx(ar, 'شكرًا لحضرتك', 'Thank you'),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(color: C.muted, fontSize: 9.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Avatar(p.initials, 40),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tx(ar, p.ar, p.en), style: const TextStyle(fontWeight: FontWeight.w900)),
                                  Text(p.id, style: const TextStyle(color: C.muted, fontSize: 9)),
                                ],
                              ),
                            ),
                            IconButton(onPressed: () => patientDialog(context, widget.ctrl, p), icon: const Icon(Icons.folder_shared_outlined)),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            Bubble(false, tx(ar, 'هل أقدر أرفع نتيجة التحليل هنا قبل موعدي؟', 'Can I upload my test result before my appointment?')),
                            Bubble(true, tx(ar, 'أكيد، ارفعي الملف من قسم الملفات الطبية وسيظهر للطبيب.', 'Yes. Upload it from Medical Records and it will be visible to the doctor.')),
                            ...extra.map((m) => Bubble(true, m)),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => toast(context, tx(ar, 'إرفاق ملف - Demo', 'Attach - Demo')),
                              icon: const Icon(Icons.attach_file),
                            ),
                            Expanded(
                              child: TextField(
                                controller: input,
                                onSubmitted: (_) => send(),
                                decoration: InputDecoration(isDense: true, hintText: tx(ar, 'اكتب رسالة...', 'Type a message...')),
                              ),
                            ),
                            const SizedBox(width: 7),
                            FilledButton(onPressed: send, child: const Icon(Icons.send)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void send() {
    final s = input.text.trim();
    if (s.isEmpty) return;
    setState(() {
      extra.add(s);
      input.clear();
    });
  }
}

class Alerts extends StatelessWidget {
  final AppCtrl ctrl;

  const Alerts({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final ar = ctrl.ar;
    final items = [
      (Icons.event_available, C.blue, 'حجز جديد', 'New booking', 'تم إضافة موعد جديد اليوم.', 'A new appointment was added today.'),
      (Icons.payments, C.green, 'تم استلام دفعة', 'Payment received', 'تم تسجيل دفعة بقيمة 450 EGP.', 'A 450 EGP payment was received.'),
      (Icons.upload_file, C.purple, 'ملف طبي جديد', 'New medical record', 'تم رفع تحليل جديد للمريض PT-1048.', 'A new lab result was uploaded for PT-1048.'),
      (Icons.notification_important, C.orange, 'متابعة مطلوبة', 'Follow-up due', 'يوجد مرضى بحاجة لمراجعة المتابعة.', 'Patients are due for follow-up.'),
    ];
    return Frame(
      ctrl: ctrl,
      a: 'الإشعارات',
      e: 'Notifications',
      sa: 'تنبيهات الحجوزات والدفع والملفات والمتابعات.',
      se: 'Booking, payment, record and follow-up alerts.',
      body: [
        Card(
          child: Column(
            children: items
                .map((x) => ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(color: x.$2.withValues(alpha: .1), borderRadius: BorderRadius.circular(13)),
                        child: Icon(x.$1, color: x.$2),
                      ),
                      title: Text(tx(ar, x.$3, x.$4), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                      subtitle: Text(tx(ar, x.$5, x.$6), style: const TextStyle(fontSize: 10.5)),
                      trailing: const Icon(Icons.circle, size: 7, color: C.blue),
                      onTap: () => toast(context, tx(ar, x.$3, x.$4)),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class Reports extends StatelessWidget {
  final AppCtrl ctrl;

  const Reports({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final ar = ctrl.ar;
    return Frame(
      ctrl: ctrl,
      a: 'التقارير والتحليلات',
      e: 'Reports & analytics',
      sa: 'مؤشرات تشغيلية تساعد على فهم أداء العيادة.',
      se: 'Operational analytics for clinic performance.',
      action: OutlinedButton.icon(
        onPressed: () => toast(context, tx(ar, 'تصدير PDF - Demo', 'Export PDF - Demo')),
        icon: const Icon(Icons.download),
        label: const Text('PDF'),
      ),
      body: [
        LayoutBuilder(
          builder: (_, c) {
            final a = BarCard(tx(ar, 'الحجوزات حسب اليوم', 'Bookings by day'), const [22, 29, 25, 34, 31, 38, 30], C.blue);
            final b = BarCard(tx(ar, 'الإيرادات اليومية', 'Daily revenue'), const [11, 14, 12, 18, 16, 20, 18], C.green);
            return c.maxWidth < 800
                ? Column(children: [a, const SizedBox(height: 12), b])
                : Row(children: [Expanded(child: a), const SizedBox(width: 12), Expanded(child: b)]);
          },
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (_, c) {
            final n = c.maxWidth >= 900 ? 4 : c.maxWidth >= 600 ? 2 : 1;
            final w = (c.maxWidth - (n - 1) * 12) / n;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(width: w, child: Stat(icon: Icons.person_add_alt, a: 'مرضى جدد', e: 'New patients', val: '184', delta: '+11%', color: C.cyan, ar: ar)),
                SizedBox(width: w, child: Stat(icon: Icons.cancel_outlined, a: 'نسبة الإلغاء', e: 'Cancellation rate', val: '4.2%', delta: '-1.1%', color: C.orange, ar: ar)),
                SizedBox(width: w, child: Stat(icon: Icons.timelapse, a: 'متوسط الانتظار', e: 'Avg. wait', val: '9 min', delta: '-2 min', color: C.purple, ar: ar)),
                SizedBox(width: w, child: Stat(icon: Icons.star_outline, a: 'متوسط التقييم', e: 'Average rating', val: '4.87', delta: '+0.08', color: C.green, ar: ar)),
              ],
            );
          },
        ),
      ],
    );
  }
}

class BarCard extends StatelessWidget {
  final String title;
  final List<int> v;
  final Color color;

  const BarCard(this.title, this.v, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    final m = v.reduce(math.max);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
            const SizedBox(height: 18),
            SizedBox(
              height: 180,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  v.length,
                  (i) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${v[i]}', style: const TextStyle(color: C.muted, fontSize: 8.5)),
                          const SizedBox(height: 3),
                          Container(
                            height: 115 * v[i] / m,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'][i], style: const TextStyle(color: C.muted, fontSize: 8.5)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Settings extends StatefulWidget {
  final AppCtrl ctrl;

  const Settings({super.key, required this.ctrl});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool reminders = true;
  bool pay = true;
  bool follow = true;
  bool online = true;

  @override
  Widget build(BuildContext context) {
    final ar = widget.ctrl.ar;
    return Frame(
      ctrl: widget.ctrl,
      a: 'إعدادات النظام',
      e: 'System settings',
      sa: 'إعدادات العيادة والتنبيهات والحجز والاستشارات.',
      se: 'Clinic, notification, booking and consultation settings.',
      body: [
        LayoutBuilder(
          builder: (_, c) {
            final clinic = Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx(ar, 'بيانات العيادة', 'Clinic profile'), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: TextEditingController(text: 'Drivo Medical Center'),
                      decoration: InputDecoration(labelText: tx(ar, 'اسم العيادة', 'Clinic name')),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: TextEditingController(text: '+20 2 2345 6789'),
                      decoration: InputDecoration(labelText: tx(ar, 'رقم التواصل', 'Contact number')),
                    ),
                    const SizedBox(height: 10),
                    FilledButton.icon(
                      onPressed: () => toast(context, tx(ar, 'تم الحفظ', 'Saved')),
                      icon: const Icon(Icons.save),
                      label: Text(tx(ar, 'حفظ', 'Save')),
                    ),
                  ],
                ),
              ),
            );
            final prefs = Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx(ar, 'التشغيل والتنبيهات', 'Operations & notifications'), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                    const SizedBox(height: 8),
                    Sw(tx(ar, 'تذكير المواعيد', 'Appointment reminders'), reminders, (v) => setState(() => reminders = v)),
                    Sw(tx(ar, 'تنبيهات الدفع', 'Payment alerts'), pay, (v) => setState(() => pay = v)),
                    Sw(tx(ar, 'متابعات المرضى', 'Patient follow-up alerts'), follow, (v) => setState(() => follow = v)),
                    Sw(tx(ar, 'الاستشارات الأونلاين', 'Online consultations'), online, (v) => setState(() => online = v)),
                  ],
                ),
              ),
            );
            return c.maxWidth < 800
                ? Column(children: [clinic, const SizedBox(height: 12), prefs])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: clinic),
                      const SizedBox(width: 12),
                      Expanded(child: prefs),
                    ],
                  );
          },
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(14),
            leading: const Icon(Icons.language, color: C.blue),
            title: Text(tx(ar, 'لغة لوحة التحكم', 'Dashboard language'), style: const TextStyle(fontWeight: FontWeight.w900)),
            subtitle: Text(tx(ar, 'العربية والإنجليزية مع RTL / LTR', 'Arabic and English with RTL / LTR')),
            trailing: OutlinedButton(onPressed: widget.ctrl.lang, child: Text(ar ? 'English' : 'العربية')),
          ),
        ),
      ],
    );
  }
}

class Sw extends StatelessWidget {
  final String t;
  final bool v;
  final ValueChanged<bool> c;

  const Sw(this.t, this.v, this.c, {super.key});

  @override
  Widget build(BuildContext context) => SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(t, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5)),
        value: v,
        onChanged: c,
      );
}

class Filter extends StatelessWidget {
  final Widget child;

  const Filter({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: C.border),
        ),
        child: child,
      );
}

class FBtn extends StatelessWidget {
  final String t;
  final bool s;
  final VoidCallback tap;

  const FBtn(this.t, this.s, this.tap, {super.key});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: tap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: s ? C.soft : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: s ? C.blue.withValues(alpha: .2) : C.border),
          ),
          child: Text(t, style: TextStyle(color: s ? C.blue : C.muted, fontWeight: FontWeight.w800, fontSize: 10.5)),
        ),
      );
}

class Avatar extends StatelessWidget {
  final String t;
  final double size;

  const Avatar(this.t, this.size, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: C.soft, borderRadius: BorderRadius.circular(size * .3)),
        child: Center(
          child: Text(t, style: TextStyle(color: C.blue, fontWeight: FontWeight.w900, fontSize: size * .29)),
        ),
      );
}

class Pill extends StatelessWidget {
  final String t;
  final Color c;

  const Pill(this.t, this.c, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(color: c.withValues(alpha: .09), borderRadius: BorderRadius.circular(99)),
        child: Text(t, style: TextStyle(color: c, fontWeight: FontWeight.w800, fontSize: 9)),
      );
}

class Status extends StatelessWidget {
  final AStatus s;
  final bool ar;

  const Status(this.s, this.ar, {super.key});

  @override
  Widget build(BuildContext context) => switch (s) {
        AStatus.confirmed => Pill(tx(ar, 'مؤكد', 'Confirmed'), C.blue),
        AStatus.pending => Pill(tx(ar, 'انتظار', 'Pending'), C.orange),
        AStatus.progress => Pill(tx(ar, 'جاري', 'In progress'), C.purple),
        AStatus.completed => Pill(tx(ar, 'مكتمل', 'Completed'), C.green),
        AStatus.cancelled => Pill(tx(ar, 'ملغي', 'Cancelled'), C.red),
      };
}

class Info extends StatelessWidget {
  final IconData i;
  final String t;

  const Info(this.i, this.t, {super.key});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(i, size: 15, color: C.muted),
          const SizedBox(width: 6),
          Expanded(child: Text(t, style: const TextStyle(color: C.muted, fontSize: 10))),
        ],
      );
}

class Metric extends StatelessWidget {
  final String a, v;

  const Metric(this.a, this.v, {super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(v, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5)),
          Text(a, textAlign: TextAlign.center, style: const TextStyle(color: C.muted, fontSize: 8.5)),
        ],
      );
}

class Big extends StatelessWidget {
  final IconData i;
  final Color c;
  final String a, v;

  const Big(this.i, this.c, this.a, this.v, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(color: C.bg, borderRadius: BorderRadius.circular(13), border: Border.all(color: C.border)),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: c.withValues(alpha: .1), borderRadius: BorderRadius.circular(10)),
              child: Icon(i, color: c, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(a, style: const TextStyle(color: C.muted, fontSize: 10))),
            Text(v, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
          ],
        ),
      );
}

class Box extends StatelessWidget {
  final Widget child;

  const Box(this.child, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(color: C.bg, borderRadius: BorderRadius.circular(13), border: Border.all(color: C.border)),
        child: child,
      );
}

class KV extends StatelessWidget {
  final String a, v;

  const KV(this.a, this.v, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 120, child: Text(a, style: const TextStyle(color: C.muted, fontSize: 10))),
            Expanded(child: Text(v, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10.5))),
          ],
        ),
      );
}

class Call extends StatelessWidget {
  final IconData i;
  final String t;
  final VoidCallback tap;
  final bool danger;

  const Call(this.i, this.t, this.tap, {this.danger = false, super.key});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: tap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: danger ? C.red : Colors.white.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: danger ? C.red : Colors.white24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(i, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(t, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      );
}

class Bubble extends StatelessWidget {
  final bool own;
  final String t;

  const Bubble(this.own, this.t, {super.key});

  @override
  Widget build(BuildContext context) => Align(
        alignment: own ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
        child: Container(
          margin: const EdgeInsets.only(bottom: 9),
          padding: const EdgeInsets.all(11),
          constraints: const BoxConstraints(maxWidth: 430),
          decoration: BoxDecoration(
            color: own ? C.blue : C.bg,
            borderRadius: BorderRadius.circular(14),
            border: own ? null : Border.all(color: C.border),
          ),
          child: Text(t, style: TextStyle(color: own ? Colors.white : C.ink, fontSize: 10.5, height: 1.4)),
        ),
      );
}

class TH extends StatelessWidget {
  final List<String> h;

  const TH(this.h, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: const BoxDecoration(color: C.bg, borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
        child: Row(
          children: List.generate(
            h.length,
            (i) => Expanded(
              flex: i == 0 || i == 1 ? 20 : i == 2 ? 15 : 10,
              child: Text(h[i], style: const TextStyle(color: C.muted, fontWeight: FontWeight.w800, fontSize: 9.5)),
            ),
          ),
        ),
      );
}

Widget cell(Widget w, int flex) => Expanded(flex: flex, child: w);

void toast(BuildContext c, String m) {
  ScaffoldMessenger.of(c).hideCurrentSnackBar();
  ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(m), behavior: SnackBarBehavior.floating));
}
