# مِشكاة · Mishkat

تطبيق القرآن الكريم بـ Flutter (أندرويد و iOS): قراءة المصحف بالرسم العثماني، التفاسير، والتلاوات الصوتية مع التشغيل في الخلفية.

## التشغيل لأول مرة

المتطلبات: Flutter مستقر حديث (3.27 أو أحدث)، و Xcode لـ iOS، و Android Studio لأندرويد.

```bash
cd mishkat
bash scripts/setup.sh   # ينشئ مجلدات android/ios الناقصة، ويضبط Info.plist، ويولّد الأيقونات
flutter run
```

السكربت يشغّل `flutter create .` وهو **لا يستبدل** الملفات الموجودة، فيبقى `AndroidManifest.xml` و `MainActivity.kt` المضبوطان للتشغيل في الخلفية كما هما.

لو اشتغلت على ويندوز/لينكس: نفّذ أوامر السكربت يدويًا، وأضف في `ios/Runner/Info.plist`:
`UIBackgroundModes = [audio]` و `CFBundleLocalizations = [ar, en]`.

## مصادر المحتوى (مجانية وبدون مفاتيح)

| المحتوى | المصدر | ملاحظات الاستخدام |
|---|---|---|
| نص المصحف | Al Quran Cloud API، طبعة `quran-uthmani` من مشروع تنزيل | يُعرض كما هو دون تعديل، مع نسبة المصدر |
| التفاسير | Al Quran Cloud (طبعات `type=tafsir` العربية، الافتراضي `ar.muyassar`) | قائمة التفاسير تُجلب حيًّا من الـ API |
| التلاوات | `cdn.islamic.network` آية بآية لكل قارئ | للاستخدام الشخصي والتعليمي، وحقوق التلاوة للقرّاء |
| الخطوط | Amiri و Amiri Quran و IBM Plex Sans Arabic | رخصة SIL OFL 1.1 (الملفات في `assets/fonts`) |

شاشة **الإعدادات ← المصادر وحقوق الاستخدام** داخل التطبيق تعرض هذه النسبة.
اقرأ شروط الخدمة في https://alquran.cloud/terms-and-conditions قبل النشر، خاصة لو هتضيف إعلانات أو اشتراكات.

## البنية

يتبع المشروع قواعد `CLAUDE.md`:

```
lib/
  config/        themes (ColorsManager, text styles), routes (PageName, RouteManager)
  core/          api (ApiConsumer, DioConsumer, EndPoints), errors (safeExecute), services (DI, cache, audio), utills
  features/
    home/        آية اليوم وتابع القراءة
    surahs/      فهرس السور والأجزاء
    reader/      قراءة المصحف صفحة بصفحة واختيار الآية
    tafsir/      التفسير مع التنقّل بين الآيات والتفاسير
    player/      المشغّل: تكرار، سرعة، مؤقت نوم، تحميل للاستماع بدون إنترنت
    bookmarks/   المحفوظات وآخر موضع قراءة
    settings/    اللغة، حجم الخط، القارئ الافتراضي، المصادر
    layout/      الشريط السفلي والتبويبات
```

كل ميزة فيها `data / domain / presentation`، ومستودعات ترجع `Either<Failure, T>`، و Cubit بحالات `Initial / Loading / Success / Error`، وملف DI خاص بها.

## يعمل بدون إنترنت

- نص أي سورة فُتحت مرة يُحفظ على الجهاز.
- قائمة السور وقائمة التفاسير وقائمة القرّاء تُحفظ بعد أول تحميل.
- زر **تحميل السورة** في المشغّل يحفظ ملفات الصوت محليًا، ويُشغّلها بعد ذلك من الجهاز.
