import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stories_admin/presentation/screens/stats/bloc/stats_bloc.dart';
import 'package:stories_data/models/index.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
      ),
      body: BlocBuilder<StatsBloc, StatsState>(
        builder: (context, state) {
          switch (state.status) {
            case StatsStatus.initial:
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            case StatsStatus.success:
              return const StatsScreenBody();
            case StatsStatus.failure:
              return Center(
                child: Text(
                  state.exception?.message ?? "",
                ),
              );
          }
        },
      ),
    );
  }
}

class StatsScreenBody extends StatelessWidget {
  const StatsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StatsBloc, StatsState, ReadsStatsModel?>(
      selector: (state) {
        return state.readsStats;
      },
      builder: (context, readsStats) {
        if (readsStats == null) {
          return const SizedBox.shrink();
        }
        return RefreshIndicator(
          onRefresh: () async {
            context.read<StatsBloc>().add(const StatsInitial());
          },
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Table(
                defaultColumnWidth: const IntrinsicColumnWidth(),
                border: TableBorder.all(borderRadius: BorderRadius.circular(8)),
                children: [
                  const TableRow(
                    children: [
                      Text(
                        'Сегодня',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Неделя',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Месяц',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Всего',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text(
                        readsStats.today.toString(),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        readsStats.week.toString(),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        readsStats.month.toString(),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        readsStats.total.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
