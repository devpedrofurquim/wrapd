import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wrapd/app/theme/app_colors.dart';
import 'package:wrapd/core/session/presentation/bloc/session_bloc.dart';
import 'package:wrapd/core/session/presentation/bloc/session_state.dart';
import '../bloc/summary_bloc.dart';
import '../bloc/summary_event.dart';
import '../bloc/summary_state.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<SummaryBloc>(),
      child: const _SummaryView(),
    );
  }
}

class _SummaryView extends StatefulWidget {
  const _SummaryView();

  @override
  State<_SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<_SummaryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sessionState = context.read<SessionBloc>().state;
      if (sessionState is SessionAuthenticated) {
        context.read<SummaryBloc>().add(LoadUserData(sessionState.token));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: BlocBuilder<SummaryBloc, SummaryState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Avatar + welcome
                      Expanded(
                        child: Row(
                          children: [
                            // Avatar
                            _buildAvatar(state),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getWelcomeText(state),
                                    style: textTheme.titleMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "Share your 2024 GitHub Wrapd",
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colors.brandPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () {
                          // TODO: Navigate to story features
                          // Your button action here
                        },
                        icon: const Icon(
                          Icons.navigate_next_sharp,
                          size: 32,
                        ), // <-- wrapped in Icon()
                        label: const Text(''),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          foregroundColor: colors
                              .brandPrimary, // 👈 change icon and text color here
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Content
                  Expanded(child: _buildContent(context, state)),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: colors.brandPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAvatar(SummaryState state) {
    if (state is SummaryLoaded && state.user.avatarUrl != null) {
      return CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(state.user.avatarUrl!),
        onBackgroundImageError: (_, __) {
          print('❌ Error loading avatar image');
        },
      );
    } else if (state is SummaryLoading) {
      return const CircleAvatar(
        radius: 28,
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    } else {
      return const CircleAvatar(radius: 28, child: Icon(Icons.person));
    }
  }

  String _getWelcomeText(SummaryState state) {
    if (state is SummaryLoaded) {
      final name = state.user.name.isNotEmpty
          ? state.user.name
          : state.user.login;
      final firstName = name.split(' ').first;
      return 'Welcome back, $firstName';
    }
    return 'Welcome back';
  }

  Widget _buildContent(BuildContext context, SummaryState state) {
    final colors = Theme.of(context).extension<AppColors>()!;

    if (state is SummaryLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colors.brandPrimary),
            const SizedBox(height: 16),
          ],
        ),
      );
    } else if (state is SummaryError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colors.brandPrimary),
            const SizedBox(height: 16),
            Text('An error ocurred :('),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final sessionState = context.read<SessionBloc>().state;
                if (sessionState is SessionAuthenticated) {
                  context.read<SummaryBloc>().add(
                    LoadUserData(sessionState.token),
                  );
                }
              },
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    } else if (state is SummaryLoaded) {
      return _buildUserContent(context, state);
    } else {
      return const Center(child: Text('No data available'));
    }
  }

  Widget _buildUserContent(BuildContext context, SummaryLoaded state) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return ListView(
      children: [
        Card(
          color: colors.surfaceCard,
          surfaceTintColor: colors.brandPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.user.name.isNotEmpty
                                ? state.user.name
                                : state.user.login,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '@${state.user.login}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          if (state.user.company != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.business, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  state.user.company!,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                          if (state.user.location != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  state.user.location!,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (state.user.bio != null && state.user.bio!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    state.user.bio!,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (state.user.createdAt != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'GitHub member since ${state.user.createdAt!.year} • ${state.user.yearsOnGitHub} years on GitHub',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Enhanced GitHub stats
        ..._buildEnhancedGitHubStats(context, state.user),
      ],
    );
  }

  List<Widget> _buildEnhancedGitHubStats(BuildContext context, user) {
    return [
      _buildStatCard(
        context,
        title: 'Public Repositories',
        value: '${user.publicRepos}',
        icon: Icons.folder_outlined,
      ),
      _buildStatCard(
        context,
        title: 'Followers',
        value: '${user.followers}',
        icon: Icons.people_outlined,
      ),
      _buildStatCard(
        context,
        title: 'Following',
        value: '${user.following}',
        icon: Icons.person_add_outlined,
      ),
      if (user.email != null)
        _buildStatCard(
          context,
          title: 'Email',
          value: user.email!,
          icon: Icons.email_outlined,
        ),
      if (user.blog != null && user.blog!.isNotEmpty)
        _buildStatCard(
          context,
          title: 'Website',
          value: user.blog!,
          icon: Icons.web_outlined,
        ),
      if (user.twitterUsername != null)
        _buildStatCard(
          context,
          title: 'Twitter',
          value: '@${user.twitterUsername!}',
          icon: Icons.alternate_email,
        ),
      if (user.createdAt != null)
        _buildStatCard(
          context,
          title: 'Years on GitHub',
          value: '${user.yearsOnGitHub} years',
          icon: Icons.calendar_today_outlined,
        ),
    ];
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title, style: textTheme.bodyMedium),
        subtitle: Text(
          value,
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.open_in_new, size: 18),
        onTap: () {
          // TODO: Navigate to detail screen
        },
      ),
    );
  }
}
