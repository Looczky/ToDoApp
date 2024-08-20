import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app/home.dart';
import 'package:to_do_app/editCard.dart';

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
            return Editcard(id: id);
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