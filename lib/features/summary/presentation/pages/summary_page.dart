import 'package:flutter/material.dart';
import 'package:wrapd/app/theme/app_colors.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your GitHub Summary',
          style: textTheme.titleLarge?.copyWith(color: colors.brandPrimary),
        ),
        centerTitle: true,
        backgroundColor: scheme.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back!', style: textTheme.headlineLarge),
            const SizedBox(height: 12),
            Text(
              'Your activity from GitHub will be summarized here.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 2,
              color: colors.surfaceCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✨ Most Active Repo:',
                      style: textTheme.titleMedium?.copyWith(
                        color: colors.brandPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'wrapd/summary-generator',
                      style: textTheme.bodyLarge?.copyWith(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.star_border,
                          size: 18,
                          color: colors.warning,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Stars: 42',
                          style: textTheme.bodyMedium?.copyWith(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.commit, size: 18, color: colors.success),
                        const SizedBox(width: 8),
                        Text(
                          'Commits: 128',
                          style: textTheme.bodyMedium?.copyWith(),
                        ),
                      ],
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
}
