import 'package:multi_cli_ai/core/database/app_database.dart';

enum UsageCheckState {
  success,
  partial,
  unavailable,
  timeout,
  authRequired,
  toolMissing,
  profileMissing,
  error;

  String get storageValue => switch (this) {
    authRequired => 'auth_required',
    toolMissing => 'tool_missing',
    profileMissing => 'profile_missing',
    _ => name,
  };

  static UsageCheckState fromStorage(String value) => switch (value) {
    'success' => success,
    'partial' => partial,
    'unavailable' => unavailable,
    'timeout' => timeout,
    'auth_required' => authRequired,
    'tool_missing' => toolMissing,
    'profile_missing' => profileMissing,
    _ => error,
  };
}

class DiscoveredProfile {
  const DiscoveredProfile({
    required this.toolKey,
    required this.profileName,
    required this.commandName,
    required this.displayName,
    required this.profileHome,
    required this.profileSource,
    required this.profileType,
    required this.hasAuthFile,
    required this.isAvailable,
  });

  final String toolKey;
  final String profileName;
  final String? commandName;
  final String displayName;
  final String profileHome;
  final String profileSource;
  final String profileType;
  final bool hasAuthFile;
  final bool isAvailable;
}

class QuotaSnapshot {
  const QuotaSnapshot({
    required this.limitId,
    required this.windowType,
    this.limitName,
    this.usedPercent,
    this.windowDurationMinutes,
    this.resetsAt,
    this.reachedType,
    this.planType,
  });

  final String limitId;
  final String windowType;
  final String? limitName;
  final double? usedPercent;
  final int? windowDurationMinutes;
  final DateTime? resetsAt;
  final String? reachedType;
  final String? planType;

  double? get remainingPercent =>
      usedPercent == null ? null : (100 - usedPercent!).clamp(0, 100);
}

class DailyUsageSnapshot {
  const DailyUsageSnapshot({
    required this.day,
    required this.tokens,
    required this.source,
    this.activeMinutes,
    this.messageCount,
  });

  final DateTime day;
  final int tokens;
  final int? activeMinutes;
  final int? messageCount;
  final String source;
}

class CodexRefreshResult {
  const CodexRefreshResult({
    required this.state,
    required this.startedAt,
    required this.completedAt,
    this.planType,
    this.accountEmail,
    this.accountDisplayName,
    this.errorCode,
    this.errorMessage,
    this.windows = const [],
    this.dailyUsage = const [],
    this.resetCredits = 0,
    this.nextCreditExpiry,
  });

  final UsageCheckState state;
  final DateTime startedAt;
  final DateTime completedAt;
  final String? planType;
  final String? accountEmail;
  final String? accountDisplayName;
  final String? errorCode;
  final String? errorMessage;
  final List<QuotaSnapshot> windows;
  final List<DailyUsageSnapshot> dailyUsage;
  final int resetCredits;
  final DateTime? nextCreditExpiry;

  int get durationMs => completedAt.difference(startedAt).inMilliseconds;
}

class AccountCardData {
  const AccountCardData({
    required this.profile,
    required this.metadata,
    required this.costShares,
    required this.currentCheck,
    required this.currentWindows,
    required this.lastSuccessfulCheck,
    required this.lastSuccessfulWindows,
    required this.resetCredits,
  });

  final CliProfile profile;
  final ProfileMetadata? metadata;
  final List<CostShare> costShares;
  final UsageCheck? currentCheck;
  final List<QuotaWindow> currentWindows;
  final UsageCheck? lastSuccessfulCheck;
  final List<QuotaWindow> lastSuccessfulWindows;
  final ResetCreditSnapshot? resetCredits;

  UsageCheckState? get currentState => currentCheck == null
      ? null
      : UsageCheckState.fromStorage(currentCheck!.status);

  bool get currentIsUsable =>
      currentState == UsageCheckState.success ||
      currentState == UsageCheckState.partial;

  List<QuotaWindow> get visibleWindows =>
      currentIsUsable ? currentWindows : lastSuccessfulWindows;

  double? get lowestAvailablePercent {
    double? lowest;
    for (final window in visibleWindows) {
      final used = window.usedPercent?.clamp(0, 100).toDouble();
      if (used == null) continue;
      final remaining = 100 - used;
      if (lowest == null || remaining < lowest) lowest = remaining;
    }
    return lowest;
  }

  String get observedPlan =>
      currentCheck?.planType ?? lastSuccessfulCheck?.planType ?? '';

  String get displayPlan =>
      metadata?.planName.isNotEmpty == true ? metadata!.planName : observedPlan;

  String get displayEmail => metadata?.accountEmail.isNotEmpty == true
      ? metadata!.accountEmail
      : (currentCheck?.accountEmail ?? lastSuccessfulCheck?.accountEmail ?? '');
}

class CalendarDayData {
  const CalendarDayData({
    required this.day,
    required this.tokens,
    required this.successfulChecks,
    required this.failedChecks,
    required this.lowestRemaining,
    required this.resetCount,
    required this.renewalCount,
    this.accounts = const [],
  });

  final DateTime day;
  final int tokens;
  final int successfulChecks;
  final int failedChecks;
  final double? lowestRemaining;
  final int resetCount;
  final int renewalCount;
  final List<AccountDayUsage> accounts;

  bool get hasActivity =>
      tokens > 0 ||
      successfulChecks > 0 ||
      failedChecks > 0 ||
      resetCount > 0 ||
      renewalCount > 0;
}

class AccountDayUsage {
  const AccountDayUsage({
    required this.profileId,
    required this.displayName,
    required this.email,
    required this.tokens,
    required this.successfulChecks,
    required this.failedChecks,
    required this.lowestRemaining,
    required this.resetCount,
    required this.renewalCount,
  });

  final String profileId;
  final String displayName;
  final String email;
  final int tokens;
  final int successfulChecks;
  final int failedChecks;
  final double? lowestRemaining;
  final int resetCount;
  final int renewalCount;

  bool get hasActivity =>
      tokens > 0 ||
      successfulChecks > 0 ||
      failedChecks > 0 ||
      resetCount > 0 ||
      renewalCount > 0;
}
