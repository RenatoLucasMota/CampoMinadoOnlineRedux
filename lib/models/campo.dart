import 'package:campo_minado_async_redux/classes/campo_builder.dart';
import 'package:campo_minado_async_redux/models/bloco.dart';
import 'package:campo_minado_async_redux/models/linha.dart';

class Campo {
  List<Linha> linhas;
  bool revelarMinas = false;
  int minasRestantes = 0;
  bool emJogo = false;
  bool ganhou = false;
  int id;

  Bloco getBloco(int x, int y){
    return linhas[x].blocos[y];  
  }

  gameOver() {
    revelarMinas = true;
    emJogo = false;
  }

  startGame() {
    emJogo = true;
  }

  Campo buildCampo(int colunas, int linhas, int minas) {
    var buildCampo =
        BuildCampo(colunasCount: colunas, linhasCount: linhas, minasCount: minas);
    return buildCampo.newCampo();
  }

  onBlocoTap(int x, int y) {
    if (emJogo) {
      if (!linhas[x].blocos[y].flag) {
        if (linhas[x].blocos[y].isMina) {
          gameOver();
        } else {
          descobrirVazios(x: x, y: y);
          linhas[x].blocos[y].revelado = true;
          if(minasRestantes == 0){
            ganhou = true;
          }
        }
      }
    }
  }

  flagMina(int x, int y) {
    if (!linhas[x].blocos[y].flag) {
      linhas[x].blocos[y].flag = true;
      if (linhas[x].blocos[y].isMina) {
        minasRestantes--;
      }
    } else {
      linhas[x].blocos[y].flag = false;
      if (linhas[x].blocos[y].isMina) {
        minasRestantes++;
      }
    }
  }

  Campo({this.linhas, this.minasRestantes});

  descobrirVazios({int x, int y}) {
    if (x > 0 && y >= 0 && x < linhas.length && y < linhas[0].blocos.length) {
      if (linhas[x].blocos[y].revelado == false) {
        linhas[x].blocos[y].revelado = true;
        if (linhas[x].blocos[y].valor == 0) {
          descobrirVazios(x: x - 1, y: y);
          descobrirVazios(x: x + 1, y: y);
          descobrirVazios(x: x, y: y - 1);
          descobrirVazios(x: x, y: y + 1);
        }
      }
    }
  }
}
