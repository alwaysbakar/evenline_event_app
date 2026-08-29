import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/app_store.dart';
import '../../../core/theme/app_theme.dart';
import '../application/password_reset_cubit.dart';

class ForgotPasswordPage extends HookWidget {
  const ForgotPasswordPage({required this.store, super.key});
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final email = useTextEditingController();
    return BlocProvider(
      create: (_) => PasswordResetCubit(store),
      child: Scaffold(
        appBar: AppBar(leading: const BackButton()),
        body: BlocBuilder<PasswordResetCubit, ResetState>(
          builder: (context, state) {
            final sent = state.status == ResetStatus.success;
            return ListView(
              padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
              children: [
                Text(
                  sent ? 'Check your inbox.' : 'Reset your password.',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  sent
                      ? 'We sent a password reset link to ${email.text}.'
                      : 'Enter the email connected to your Evenline account.',
                ),
                const SizedBox(height: 34),
                if (!sent) ...[
                  TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: state.status == ResetStatus.loading
                          ? null
                          : () => context.read<PasswordResetCubit>().send(
                              email.text,
                            ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.ink,
                        padding: const EdgeInsets.symmetric(vertical: 17),
                      ),
                      child: Text(
                        state.status == ResetStatus.loading
                            ? 'Sending...'
                            : 'Send reset link',
                      ),
                    ),
                  ),
                ] else
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => context.go('/auth'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.ink,
                        padding: const EdgeInsets.symmetric(vertical: 17),
                      ),
                      child: const Text('Back to sign in'),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
