import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/navigation/app_router.dart';
import 'package:league/bloc/catalog/catalog_cubit.dart';
import 'package:league/utils/main_theme.dart';
import 'bloc/client/client_list_cubit.dart';

void main() {
  runApp(ClientelingApp(
    appRouter: AppRouter(),
  ));
}

class ClientelingApp extends StatelessWidget {
  final AppRouter appRouter;

  const ClientelingApp({Key key, @required this.appRouter}) : super(key: key);

  @override
  Widget build(BuildContext appContext) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CatalogCubit>(
          create: (context) => CatalogCubit(),
        ),
        BlocProvider<ClientListCubit>(
          create: (context) => ClientListCubit(),
        ),
        BlocProvider<LeagueCubit>(
          create: (context) => LeagueCubit()..init(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: mainTheme(),
        onGenerateRoute: appRouter.onGenerateRoute,
      ),
    );
  }
}
