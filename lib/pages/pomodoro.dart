import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pomodoro/componets/cronometro.dart';
import 'package:pomodoro/componets/entrada_tempo.dart';
import 'package:pomodoro/store/pomodoro.store.dart';
import 'package:provider/provider.dart';

class Pomodoro extends StatelessWidget {
  const Pomodoro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<PomodoroStore>(context);
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: Cronometro()),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Observer(
            builder: (_) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                EntradaTempo(
                  title: 'Trabalho',
                  valor: store.tempoTrabalho,
                  inc: store.iniciado && store.starTrabalhando()
                      ? null
                      : store.incremenTempoTrabalho,
                  dec: store.iniciado && store.starTrabalhando()
                      ? null
                      : store.decremenTempoTrabalho,
                ),
                EntradaTempo(
                  title: 'Descanso',
                  valor: store.tempoDescanso,
                  inc: store.iniciado && store.starDescansando()
                      ? null
                      : store.incremenTempoDescanso,
                  dec: store.iniciado && store.starDescansando()
                      ? null
                      : store.decremenTempoDescanso,
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}
