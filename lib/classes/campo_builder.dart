import 'package:campo_minado_async_redux/models/bloco.dart';
import 'package:campo_minado_async_redux/models/campo.dart';
import 'package:campo_minado_async_redux/models/linha.dart';
import 'dart:math';

import 'package:campo_minado_async_redux/utils/campo_utils.dart';

class BuildCampo {
  final int linhasCount;
  final int colunasCount;
  final int minasCount;

  BuildCampo({this.linhasCount, this.colunasCount, this.minasCount});

  Campo newCampo() {
    List<Bloco> blocos = [];
    List<Linha> linhas = [];
    for (var i = 0; i < linhasCount; i++) {
      blocos = [];
      for (var j = 0; j < colunasCount; j++) {
        blocos.add(Bloco());
      }
      linhas.add(new Linha(blocos: blocos));
    }

    Random randomValue = Random();
    int minasRestantes = minasCount;
    while (minasRestantes > 0) {
      int pos = randomValue.nextInt(linhasCount * colunasCount);
      int row = pos ~/ linhasCount;
      int col = pos % colunasCount;
      if (!linhas[row].blocos[col].isMina) {
        linhas[row].blocos[col].isMina = true;
        minasRestantes--;
      }
    }

    linhas.forEach((f) {
      f.blocos.forEach((b) {
        if (!linhas[linhas.indexOf(f)].blocos[f.blocos.indexOf(b)].isMina) {
          linhas[linhas.indexOf(f)].blocos[f.blocos.indexOf(b)].valor =
              CampoUtils.minasProximas(
                  linhas.indexOf(f), f.blocos.indexOf(b), linhas);
        } else {
          linhas[linhas.indexOf(f)].blocos[f.blocos.indexOf(b)].valor = -1;
        }
      });
    });

    return Campo(linhas: linhas, minasRestantes: minasCount);
  }
}
