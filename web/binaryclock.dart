import 'dart:html';
import 'dart:async';

class BinaryClock {
  final String neutralColor = 'rgb(225, 225, 225)';
  final String backgroundColor = '#FFFFFF';

  final String clockFont = 'bold 12pt Courier';
  final String circleOutlineColor = '#003300';
  final String textColor = '#000000';
  final int midPoint = 255;
  final int square = 16;
  
  Timer _atimer = null;
  int _displayStyle = 1;
  List<String> _history = new List<String>();

  int currentRow = 0;

  CanvasElement _ca;
  CanvasRenderingContext2D _crc;

  BinaryClock() {
    if (_ca == null) {
      _ca = querySelector('#surface');
      _crc = _ca.getContext("2d");
      _ca.onClick.listen(changeDisplay);
    }
    if (_atimer == null) {
      _atimer = new Timer.periodic(
          new Duration(milliseconds: 1000), (Timer timer) => updateTime());
    }
    draw();
  }

  void draw() {
    currentRow = 0;
    for (String binaryTime in _history.reversed) {
      if (_displayStyle == 0) {
        renderAsBinaryText(binaryTime);
      } else if (_displayStyle == 1) {
        renderAsSquares(binaryTime);
      } else if (_displayStyle == 2) {
        renderAsCircles(binaryTime);
      }else if (_displayStyle == 3) {
        renderTimeAsPlainText(binaryTime);
      }
      currentRow++;
    }
  }

  void renderAsCircles(String bintime) {
    int v = (midPoint - currentRow * 10);
    int vv = 255 - (midPoint - currentRow * 10);
    for (int i = 0; i < bintime.length; i++) {
      String ch = bintime[i];

      if (ch == "1")
        _crc.fillStyle = 'rgb(255, $v, $vv)';
      else
        _crc.fillStyle = 'rgb($v, 255, 255)';

      _crc
        ..beginPath()
        ..arc(i * square, currentRow * square, square / 4, 0, 6.28, false)
        ..fill()
        ..lineWidth = 1
        ..strokeStyle = circleOutlineColor
        ..stroke();
    }
  }

  void renderAsSquares(String binaryTime) {
    int v = (midPoint - currentRow * 10);
    int vv = 255 - (midPoint - currentRow * 10);
    int rowY = 0;
    int rowX = 0;
    for (int i = 0; i < binaryTime.length; i++) {
      String ch = binaryTime[i];

      if (ch == "1")
        _crc.fillStyle = 'rgb(255, $v, $vv)';
      else
        _crc.fillStyle = 'rgb($v, 255, 255)';

      rowY = currentRow * square;
      rowX = (384 - square) - i * square;
      _crc
        ..fillRect(i * square, rowY, square, square)
        ..fillRect(rowX, rowY, square, square)
        ..strokeStyle = neutralColor
        ..strokeRect(i * square, rowY, square, square)
        ..strokeRect(rowX, rowY, square, square);
    }
  }

  void renderAsBinaryText(String binaryTime) {
    _crc
      ..fillStyle = neutralColor
      ..fillRect(12, currentRow * square, 320, square)
      ..font = clockFont
      ..fillStyle = textColor
      ..fillText("$binaryTime", 12 + square, currentRow * square);
  }

  void renderTimeAsPlainText(String binaryTime) {
    _crc
      ..fillStyle = neutralColor
      ..fillRect(12, currentRow * square, 320, square)
      ..font = clockFont
      ..fillStyle = textColor
      ..fillText("${new DateTime.now().toString()}", 12 + square, currentRow * square);
  }

  void updateTime() {
    int numtime = new DateTime.now().millisecondsSinceEpoch ~/ 1000;
    String binary = numtime.toRadixString(2);
    String value = binary.substring(binary.length - 24);
    _history.add(value);
    if (_history.length > 24) {
      _history.removeAt(0);
    }
    draw();
  }

  void changeDisplay(MouseEvent event) {
    _displayStyle++;
    if (_displayStyle > 3) _displayStyle = 0;
    _crc.fillStyle = backgroundColor;
    _crc.fillRect(0, 0, 800, 600);
    draw();
  }
}
