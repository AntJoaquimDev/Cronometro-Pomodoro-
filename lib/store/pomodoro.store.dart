import 'dart:async';

import 'package:mobx/mobx.dart';
part 'pomodoro.store.g.dart';

class PomodoroStore = _PomodoroStore with _$PomodoroStore;

enum TipoIntervalo { TRABALHO, DESCANSO }

abstract class _PomodoroStore with Store {
  @observable
  bool iniciado = false;

  @observable
  int tempoTrabalho = 2;

  @observable
  int tempoDescanso = 1;

  @observable
  int minutos = 2;

  @observable
  int segundos = 0;

  Timer? cronometro;

  @observable
  TipoIntervalo tipoIntervalo = TipoIntervalo.TRABALHO;

  @action
  void iniciar() {
    iniciado = true;
    cronometro = Timer.periodic(Duration(seconds: 1), (timer) {
      if (minutos == 0 && segundos == 0) {
        _trocaTipoIntervalo();
      } else if (segundos == 0) {
        segundos = 59;
        minutos--;
      } else {
        segundos--;
      }
    });
  }

  @action
  void parar() {
    iniciado = false;
    cronometro?.cancel();
  }

  @action
  void reiniciar() {
    iniciado = false;
    parar();
    minutos = starTrabalhando() ? tempoTrabalho : tempoDescanso;
    segundos = 0;
  }

  @action
  void incremenTempoTrabalho() {
    tempoTrabalho++;
    if (starTrabalhando()) {
      reiniciar();
    }
  }

  @action
  void decremenTempoTrabalho() {
    if (tempoTrabalho <= 0) return;
    tempoTrabalho--;
    if (starTrabalhando()) {
      reiniciar();
    }
  }

  @action
  void incremenTempoDescanso() {
    if (tempoTrabalho <= tempoDescanso) return;
    tempoDescanso++;
    if (starDescansando()) {
      reiniciar();
    }
  }

  @action
  void decremenTempoDescanso() {
    if (tempoDescanso <= 0) return;
    tempoDescanso--;
    if (starDescansando()) {
      reiniciar();
    }
  }

  bool starTrabalhando() {
    return tipoIntervalo == TipoIntervalo.TRABALHO;
  }

  bool starDescansando() {
    return tipoIntervalo == TipoIntervalo.DESCANSO;
  }

  void _trocaTipoIntervalo() {
    if (starTrabalhando()) {
      tipoIntervalo = TipoIntervalo.DESCANSO;
      minutos = tempoDescanso;
    } else {
      tipoIntervalo = TipoIntervalo.TRABALHO;
      minutos = tempoTrabalho;
    }
    segundos = 0;
  }
}
