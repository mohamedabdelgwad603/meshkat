// Holds every translation key used by the UI.
class TextManager {
  TextManager._();

  // App
  static const String appName = 'appName';
  static const String appTagline = 'appTagline';
  static const String lightUponLight = 'lightUponLight';

  // App update
  static const String updateBadge = 'updateBadge';
  static const String updateTitle = 'updateTitle';
  static const String updateBody = 'updateBody';
  static const String updateRequiredBody = 'updateRequiredBody';
  static const String updateCurrentVersion = 'updateCurrentVersion';
  static const String updateNewVersion = 'updateNewVersion';
  static const String updateNow = 'updateNow';
  static const String updateLater = 'updateLater';

  // Daily reminders
  static const String reminderQuran = 'reminderQuran';
  static const String reminderSalawat = 'reminderSalawat';
  static const String reminderSayAllah = 'reminderSayAllah';
  static const String reminderTahlil = 'reminderTahlil';
  static const String reminderTawbah = 'reminderTawbah';

  // Errors & generic
  static const String errorTimeout = 'errorTimeout';
  static const String errorNoInternet = 'errorNoInternet';
  static const String errorServer = 'errorServer';
  static const String errorUnknown = 'errorUnknown';
  static const String errorCache = 'errorCache';
  static const String retry = 'retry';
  static const String close = 'close';

  // Bottom navigation
  static const String navHome = 'navHome';
  static const String navMushaf = 'navMushaf';
  static const String navListen = 'navListen';
  static const String navSaved = 'navSaved';
  static const String navSettings = 'navSettings';

  // Home
  static const String greeting = 'greeting';
  static const String searchQuran = 'searchQuran';
  static const String continueReading = 'continueReading';
  static const String continueAction = 'continueAction';
  static const String startReading = 'startReading';
  static const String startReadingHint = 'startReadingHint';
  static const String startAction = 'startAction';
  static const String lastReadMeta = 'lastReadMeta';
  static const String ayahProgress = 'ayahProgress';
  static const String quickSurahs = 'quickSurahs';
  static const String quickJuz = 'quickJuz';
  static const String quickTafsir = 'quickTafsir';
  static const String quickRecitations = 'quickRecitations';
  static const String dailyAyah = 'dailyAyah';
  static const String surahAyahRef = 'surahAyahRef';

  // Surah index
  static const String mushafIndex = 'mushafIndex';
  static const String searchSurahHint = 'searchSurahHint';
  static const String tabSurahs = 'tabSurahs';
  static const String tabJuz = 'tabJuz';
  static const String tabBookmarks = 'tabBookmarks';
  static const String meccan = 'meccan';
  static const String medinan = 'medinan';
  static const String ayahsCount = 'ayahsCount';
  static const String juzNumber = 'juzNumber';
  static const String juzStart = 'juzStart';
  static const String noResults = 'noResults';
  static const String noBookmarks = 'noBookmarks';
  static const String noBookmarksHint = 'noBookmarksHint';

  // Reader
  static const String juzPage = 'juzPage';
  static const String ayahsLabel = 'ayahsLabel';
  static const String ayahN = 'ayahN';
  static const String surahName = 'surahName';
  static const String tafsirAction = 'tafsirAction';
  static const String listenAction = 'listenAction';
  static const String copyAction = 'copyAction';
  static const String shareAction = 'shareAction';
  static const String saveAction = 'saveAction';
  static const String savedAction = 'savedAction';
  static const String copied = 'copied';
  static const String bookmarkAdded = 'bookmarkAdded';
  static const String bookmarkRemoved = 'bookmarkRemoved';
  static const String readFullTafsir = 'readFullTafsir';
  static const String bookmarkPage = 'bookmarkPage';
  static const String readingSettings = 'readingSettings';
  static const String backAction = 'backAction';

  // Tafsir
  static const String tafsirTitle = 'tafsirTitle';
  static const String prevAyah = 'prevAyah';
  static const String nextAyah = 'nextAyah';
  static const String surahAyah = 'surahAyah';
  static const String tafsirSources = 'tafsirSources';

  // Player
  static const String nowPlaying = 'nowPlaying';
  static const String changeReciter = 'changeReciter';
  static const String chooseReciter = 'chooseReciter';
  static const String ayahOf = 'ayahOf';
  static const String surahOrdinal = 'surahOrdinal';
  static const String riwaya = 'riwaya';
  static const String repeatTimes = 'repeatTimes';
  static const String repeatOff = 'repeatOff';
  static const String sleepTimer = 'sleepTimer';
  static const String sleepIn = 'sleepIn';
  static const String downloadSurah = 'downloadSurah';
  static const String downloading = 'downloading';
  static const String downloaded = 'downloaded';
  static const String minimizePlayer = 'minimizePlayer';
  static const String playAction = 'playAction';
  static const String pauseAction = 'pauseAction';
  static const String loopSurah = 'loopSurah';
  static const String speed = 'speed';

  // Memorization
  static const String quickHifz = 'quickHifz';
  static const String hifzTitle = 'hifzTitle';
  static const String hifzSubtitle = 'hifzSubtitle';
  static const String hifzSurah = 'hifzSurah';
  static const String hifzChooseSurah = 'hifzChooseSurah';
  static const String hifzAyahCount = 'hifzAyahCount';
  static const String hifzRange = 'hifzRange';
  static const String hifzFrom = 'hifzFrom';
  static const String hifzTo = 'hifzTo';
  static const String hifzRangeLength = 'hifzRangeLength';
  static const String hifzAyahRepeat = 'hifzAyahRepeat';
  static const String hifzRangeRepeat = 'hifzRangeRepeat';
  static const String hifzRangeRepeatHint = 'hifzRangeRepeatHint';
  static const String hifzOff = 'hifzOff';
  static const String hifzRecitePause = 'hifzRecitePause';
  static const String hifzRecitePauseHint = 'hifzRecitePauseHint';
  static const String hifzSpeed = 'hifzSpeed';
  static const String hifzProgress = 'hifzProgress';
  static const String hifzStart = 'hifzStart';
  static const String hifzTest = 'hifzTest';
  static const String hifzAyahOf = 'hifzAyahOf';
  static const String hifzRepetitionOf = 'hifzRepetitionOf';
  static const String hifzReviewOf = 'hifzReviewOf';
  static const String hifzListen = 'hifzListen';
  static const String hifzReciteNow = 'hifzReciteNow';
  static const String hifzPaused = 'hifzPaused';
  static const String hifzPrevious = 'hifzPrevious';
  static const String hifzNext = 'hifzNext';
  static const String hifzRestart = 'hifzRestart';
  static const String hifzFinishedTitle = 'hifzFinishedTitle';
  static const String hifzFinishedBody = 'hifzFinishedBody';
  static const String hifzTestHint = 'hifzTestHint';
  static const String hifzFirstWordHint = 'hifzFirstWordHint';
  static const String hifzRevealWord = 'hifzRevealWord';
  static const String hifzRevealAyah = 'hifzRevealAyah';
  static const String hifzHide = 'hifzHide';
  static const String hifzMemorized = 'hifzMemorized';
  static const String hifzNeedsReview = 'hifzNeedsReview';
  static const String hifzScore = 'hifzScore';
  static const String hifzTestAgain = 'hifzTestAgain';

  // Mutashabihat
  static const String mutashabihatTitle = 'mutashabihatTitle';
  static const String mutashabihatBanner = 'mutashabihatBanner';
  static const String mutashabihatView = 'mutashabihatView';
  static const String mutashabihatBadge = 'mutashabihatBadge';
  static const String mutashabihatIntro = 'mutashabihatIntro';
  static const String mutashabihatStats = 'mutashabihatStats';
  static const String mutashabihatShowAll = 'mutashabihatShowAll';
  static const String mutashabihatShowLess = 'mutashabihatShowLess';
  static const String noMutashabihat = 'noMutashabihat';
  static const String mutashabihatBrowseTitle = 'mutashabihatBrowseTitle';
  static const String mutashabihatHomeTitle = 'mutashabihatHomeTitle';
  static const String mutashabihatHomeBody = 'mutashabihatHomeBody';
  static const String mutashabihatSearchHint = 'mutashabihatSearchHint';
  static const String mutashabihatAllSurahs = 'mutashabihatAllSurahs';
  static const String mutashabihatSortMushaf = 'mutashabihatSortMushaf';
  static const String mutashabihatSortRepeated = 'mutashabihatSortRepeated';
  static const String mutashabihatResults = 'mutashabihatResults';
  static const String mutashabihatFirstAt = 'mutashabihatFirstAt';
  static const String noMutashabihatResults = 'noMutashabihatResults';

  // Reflections
  static const String reflectAction = 'reflectAction';
  static const String reflectedAction = 'reflectedAction';
  static const String bookmarksTab = 'bookmarksTab';
  static const String reflectionsTab = 'reflectionsTab';
  static const String newReflection = 'newReflection';
  static const String editReflection = 'editReflection';
  static const String reflectionHint = 'reflectionHint';
  static const String saveReflection = 'saveReflection';
  static const String deleteReflection = 'deleteReflection';
  static const String deleteReflectionTitle = 'deleteReflectionTitle';
  static const String deleteReflectionBody = 'deleteReflectionBody';
  static const String cancel = 'cancel';
  static const String reflectionSaved = 'reflectionSaved';
  static const String reflectionDeleted = 'reflectionDeleted';
  static const String noReflections = 'noReflections';
  static const String noReflectionsHint = 'noReflectionsHint';
  static const String openInMushaf = 'openInMushaf';
  static const String editedOn = 'editedOn';

  // Saved
  static const String savedTitle = 'savedTitle';
  static const String removeBookmark = 'removeBookmark';

  // Settings
  static const String settingsTitle = 'settingsTitle';
  static const String language = 'language';
  static const String arabic = 'arabic';
  static const String english = 'english';
  static const String quranFontSize = 'quranFontSize';
  static const String defaultReciter = 'defaultReciter';
  static const String sourcesTitle = 'sourcesTitle';
  static const String basmala = 'basmala';
  static const String version = 'version';
  static const String shareApp = 'shareApp';
  static const String rateApp = 'rateApp';
  static const String contactUs = 'contactUs';
  static const String contactUsSubtitle = 'contactUsSubtitle';
  static const String instagram = 'instagram';
  static const String facebook = 'facebook';
  static const String shareAppMessage = 'shareAppMessage';
  static const String shareAndroidLink = 'shareAndroidLink';
  static const String shareIosLink = 'shareIosLink';
  static const String storeLinkUnavailable = 'storeLinkUnavailable';
  static const String linkOpenFailed = 'linkOpenFailed';

  // Credits
  static const String creditsQuranTitle = 'creditsQuranTitle';
  static const String creditsQuranBody = 'creditsQuranBody';
  static const String creditsTafsirTitle = 'creditsTafsirTitle';
  static const String creditsTafsirBody = 'creditsTafsirBody';
  static const String creditsAudioTitle = 'creditsAudioTitle';
  static const String creditsAudioBody = 'creditsAudioBody';
  static const String creditsFontsTitle = 'creditsFontsTitle';
  static const String creditsFontsBody = 'creditsFontsBody';
  static const String creditsMutashabihatTitle = 'creditsMutashabihatTitle';
  static const String creditsMutashabihatBody = 'creditsMutashabihatBody';
}
