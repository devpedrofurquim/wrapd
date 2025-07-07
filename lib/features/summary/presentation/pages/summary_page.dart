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
                                    "Here's your 2024 GitHub Wrapd",
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset('lib/assets/logo_wrapd.png', height: 32),
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
    if (state is SummaryLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading your GitHub data...'),
          ],
        ),
      );
    } else if (state is SummaryError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: ${state.message}'),
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
              child: const Text('Retry'),
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
    return ListView(
      children: [
        // User info card
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (state.user.avatarUrl != null)
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(state.user.avatarUrl!),
                  )
                else
                  const CircleAvatar(radius: 24, child: Icon(Icons.person)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.user.name.isNotEmpty
                            ? state.user.name
                            : state.user.login,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('@${state.user.login}'),
                      if (state.user.bio != null &&
                          state.user.bio!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          state.user.bio!,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // GitHub stats
        ..._buildGitHubStats(context, state.user),
      ],
    );
  }

  List<Widget> _buildGitHubStats(BuildContext context, user) {
    final textTheme = Theme.of(context).textTheme;

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
      _buildStatCard(
        context,
        title: 'Profile',
        value: '@${user.login}',
        icon: Icons.account_circle_outlined,
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
