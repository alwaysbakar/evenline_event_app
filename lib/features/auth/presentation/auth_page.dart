import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/app_store.dart';
import '../../../core/theme/app_theme.dart';
import '../application/auth_cubit.dart';

class AuthPage extends HookWidget {
  const AuthPage({required this.store, super.key});
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final createAccount = useState(false);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final name = useTextEditingController();
    final email = useTextEditingController();
    final password = useTextEditingController();
    return BlocProvider(
      create: (_) => AuthCubit(store),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.success) context.go('/home');
        },
        child: Scaffold(
          appBar: AppBar(leading: const BackButton()),
          body: SafeArea(
            child: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                children: [
                  Text(
                    createAccount.value
                        ? 'Join the good stuff.'
                        : 'Welcome back.',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    createAccount.value
                        ? 'Create an account to keep your plans together.'
                        : 'Sign in to see your tickets and saved events.',
                  ),
                  const SizedBox(height: 36),
                  if (createAccount.value) ...[
                    TextFormField(
                      controller: name,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) =>
                          value!.trim().isEmpty ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: 14),
                  ],
                  TextFormField(
                    controller: email,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) =>
                        value!.contains('@') ? null : 'Enter a valid email',
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) =>
                        value!.length >= 6 ? null : 'Use at least 6 characters',
                  ),
                  const SizedBox(height: 28),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) => Column(
                      children: [
                        if (state.message != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              state.message!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: state.status == AuthStatus.loading
                                ? null
                                : () {
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    }
                                    final cubit = context.read<AuthCubit>();
                                    if (createAccount.value) {
                                      cubit.signUp(
                                        name.text,
                                        email.text,
                                        password.text,
                                      );
                                    } else {
                                      cubit.signIn(email.text, password.text);
                                    }
                                  },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.ink,
                              padding: const EdgeInsets.symmetric(vertical: 17),
                            ),
                            child: Text(
                              state.status == AuthStatus.loading
                                  ? 'Working...'
                                  : createAccount.value
                                  ? 'Create account'
                                  : 'Sign in',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => createAccount.value = !createAccount.value,
                    child: Text(
                      createAccount.value
                          ? 'I already have an account'
                          : 'Create a new account',
                    ),
                  ),
                  if (!createAccount.value)
                    TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: const Text('Forgot password?'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
