import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app/home.dart';
import 'package:to_do_app/Editcard.dart';

void main() => runApp(const MyApp());

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return Home(key: UniqueKey());
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'editCard/:id',  
          builder: (BuildContext context, GoRouterState state) {
            final String id = state.pathParameters['id']!;
            final Map<String, dynamic>? extras = state.extra as Map<String, dynamic>?;

            final String? title = extras?['title'] as String?;
            final String? desc = extras?['desc'] as String?;

            return Editcard(id: id, title:title, desc:desc);
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget{
  const MyApp({super.key});


  @override
  Widget build(BuildContext context){
    return MaterialApp.router(
      title:'ToDo',
      routerConfig: _router,  
    );
  }
}