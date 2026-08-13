class ProfileProvider {
  const ProfileProvider({
    required this.toolKey,
    required this.displayName,
    required this.productName,
    required this.multiCliTool,
    required this.commandPrefix,
    required this.defaultHomeName,
    required this.executable,
    required this.iconAssetPath,
    required this.credentialFiles,
    required this.supportsUsage,
    required this.supportsDeviceAuth,
    required this.showsDefaultProfile,
    this.launchArguments = const [],
  });

  final String toolKey;
  final String displayName;
  final String productName;
  final String multiCliTool;
  final String commandPrefix;
  final String defaultHomeName;
  final String executable;
  final String iconAssetPath;
  final List<String> credentialFiles;
  final bool supportsUsage;
  final bool supportsDeviceAuth;
  final bool showsDefaultProfile;
  final List<String> launchArguments;

  String profileSpec(String name) => '$multiCliTool/$name';

  String commandName(String name) => '$commandPrefix$name';

  bool showsProfileSource(String source) =>
      source != 'default' || showsDefaultProfile;
}

const supportedProfileProviders = <ProfileProvider>[
  ProfileProvider(
    toolKey: 'codex',
    displayName: 'ChatGPT',
    productName: 'Codex',
    multiCliTool: 'codex',
    commandPrefix: 'codex-',
    defaultHomeName: '.codex',
    executable: 'codex',
    iconAssetPath: 'assets/branding/chatgpt-official.png',
    credentialFiles: ['auth.json'],
    supportsUsage: true,
    supportsDeviceAuth: true,
    showsDefaultProfile: true,
    launchArguments: ['-c', 'tui.terminal_title=[]'],
  ),
  ProfileProvider(
    toolKey: 'claude-cli',
    displayName: 'Claude',
    productName: 'Claude Code',
    multiCliTool: 'claude-cli',
    commandPrefix: 'claude-cli-',
    defaultHomeName: '.claude',
    executable: 'claude',
    iconAssetPath: 'assets/branding/claude-official.png',
    credentialFiles: ['.credentials.json'],
    supportsUsage: false,
    supportsDeviceAuth: false,
    showsDefaultProfile: false,
  ),
];

ProfileProvider? profileProviderOrNull(String toolKey) {
  for (final provider in supportedProfileProviders) {
    if (provider.toolKey == toolKey) return provider;
  }
  return null;
}

ProfileProvider profileProvider(String toolKey) {
  final provider = profileProviderOrNull(toolKey);
  if (provider == null) {
    throw StateError('Herramienta de perfil no compatible: $toolKey');
  }
  return provider;
}
