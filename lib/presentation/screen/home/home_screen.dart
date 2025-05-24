import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_admin/config/router/routers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Админка',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Истории'),
              onTap: () {
                Navigator.pop(context);
                // Навигация или логика
              },
            ),
            ListTile(
              title: Text('Категории'),
              onTap: () {
                context.pop();
                context.pushNamed(Routers.pathCategoriesScreen);
              },
            ),
          ],
        ),
      ),
      body: HomeScreenBody(),
    );
  }
}

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Главный экран"));
  }
}
