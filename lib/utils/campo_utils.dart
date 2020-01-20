import 'package:campo_minado_async_redux/models/linha.dart';

class CampoUtils {

  static bool campoValido(int x, int y, List<Linha> linhas) {
    bool flag = false;
    if (x > 0 && y >= 0 && x < linhas.length && y < linhas[0].blocos.length) {
      flag = linhas[x].blocos[y].isMina;
    }
    return flag;
  }

  static int minasProximas(int x, int y, List<Linha> linhas) {
    int count = 0;
    if (campoValido(x, y + 1, linhas)) {
      count = count + 1;
    }
    if (campoValido(x + 1, y + 1, linhas)) {
      count = count + 1;
    }
    if (campoValido(x + 1, y, linhas)) {
      count = count + 1;
    }
    if (campoValido(x + 1, y - 1, linhas)) {
      count = count + 1;
    }
    if (campoValido(x, y - 1, linhas)) {
      count = count + 1;
    }
    if (campoValido(x - 1, y - 1, linhas)) {
      count = count + 1;
    }
    if (campoValido(x - 1, y, linhas)) {
      count = count + 1;
    }
    if (campoValido(x - 1, y + 1, linhas)) {
      count = count + 1;
    }
    return count;
  }

}