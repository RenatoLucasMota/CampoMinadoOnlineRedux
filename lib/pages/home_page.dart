import 'dart:async';

import 'package:campo_minado_async_redux/models/campo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Campo campo = Campo();
  String elapsedTime = '';
  Timer timer;
  Stopwatch watch = new Stopwatch();

  updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      });
    }
  }

  onTapBloco(int x, int y) {
    setState(() {
      campo.onBlocoTap(x, y);
    });
  }

  onLongPressBloco(int x, int y) {
    if (campo.emJogo) {
      campo.flagMina(x, y);
    }
  }

  startGame(int coluna, linha, minas) {
    campo = campo.buildCampo(coluna, linha, minas);
    campo.startGame();
  }

  Widget _buildGridItems(BuildContext context, int index) {
    int gridStateLength = campo.linhas[0].blocos.length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
      onLongPress: () {
        setState(() {
          onLongPressBloco(x, y);
        });
      },
      onTap: () {
        onTapBloco(x, y);
        if (campo.ganhou) {}
      },
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Center(
            child: _buildGridItem(x, y),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(int linha, int coluna) {
    int minasProximas = 0;
    bool revelado = false;
    bool isMina = false;
    bool revelarMinas = false;
    bool flag = false;
    minasProximas = campo.getBloco(linha, coluna).valor;
    revelado = campo.getBloco(linha, coluna).revelado;
    isMina = campo.getBloco(linha, coluna).isMina;
    flag = campo.getBloco(linha, coluna).flag;
    revelarMinas = campo.revelarMinas;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: revelado ? Colors.grey[300] : Colors.orange,
      ),
      child: revelarMinas && isMina
          ? Padding(
              padding: const EdgeInsets.all(0),
              child: Padding(
                child: AnimatedContainer(
                  child: Image.asset(
                    'assets/images/bomba.png',
                  ),
                  duration: Duration(milliseconds: 200),
                ),
                padding: EdgeInsets.all(1),
              ),
            )
          : Center(
              child: !flag
                  ? revelado
                      ? minasProximas > 0
                          ? Text(
                              minasProximas.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          : Container()
                      : Container()
                  : Icon(
                      Icons.flag,
                      color: Colors.black,
                    ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            campo.emJogo ? Text('Tempo: $elapsedTime') : Container(),
            SizedBox(
              width: 30,
            ),
            campo.emJogo
                ? Text('Minas Restantes: ${campo.minasRestantes}')
                : Container(),
          ],
        ),
      ),
      body: ((campo.linhas != null) || (campo.emJogo))
          ? AnimationLimiter(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: campo.linhas[0].blocos.length,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredGrid(
                    child: ScaleAnimation(
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: _buildGridItems(context, index),
                      ),
                    ),
                    columnCount: campo.linhas[0].blocos.length,
                    position: index,
                    duration: const Duration(milliseconds: 375),
                  );
                },
                itemCount:
                    (campo.linhas[0].blocos.length * campo.linhas.length),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Jogar'),
                      onPressed: () {
                        setState(
                          () {
                            startGame(10, 15, 10);
                            startWatch();
                          },
                        );
                      },
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    RaisedButton(
                      child: Text('Assistir'),
                      onPressed: () {},
                    )
                  ],
                ),
              ],
            ),
    );
  }

  startWatch() {
    watch.start();
    timer = new Timer.periodic(new Duration(milliseconds: 100), updateTime);
  }

  stopWatch() {
    watch.stop();
    setTime();
  }

  resetWatch() {
    watch.reset();
    setTime();
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
    });
  }

  transformMilliSeconds(int milliseconds) {
    //Thanks to Andrew
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }
}
