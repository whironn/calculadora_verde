import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  final String _limpar = 'C';
  String _expressao = '';
  String _resultado = '';
  final List<String> _historico = [];
  bool _cientifica = false;

  void _pressionarBotao(String valor) {
    setState(() {
      if (valor == _limpar) {
        _expressao = '';
        _resultado = '';
      } else if (valor == '=') {
        _calcularResultado();
      } else if (valor == '⌫') {
        if (_expressao.isNotEmpty) {
          _expressao = _expressao.substring(0, _expressao.length - 1);
        }
      } else if (valor == '⇅') {
        _cientifica = !_cientifica;
      } else {
        _expressao += valor;
      }
    });
  }

  void _calcularResultado() {
    try {
      _resultado = _avaliarExpressao(_expressao).toString();
      _historico.insert(0, '$_expressao = $_resultado');
    } catch (e) {
      _resultado = 'Erro';
    }
  }

  double _avaliarExpressao(String expressao) {
    // Substitui operadores para o parser entender corretamente
    expressao = expressao.replaceAll('x', '*');
    expressao = expressao.replaceAll('÷', '/');
    expressao = expressao.replaceAllMapped(RegExp(r'√(\d+\.?\d*)'), (match) => 'sqrt(${match[1]})');

    // Garante que funções como sin, cos, tan e log sejam interpretadas corretamente
    expressao = expressao.replaceAllMapped(
        RegExp(r'(sin|cos|tan|log)\s*(\d+(\.\d*)?)'),
        (match) => '${match[1]}(${match[2]})');

    try {
      Expression exp = Expression.parse(expressao);
      const evaluator = ExpressionEvaluator();

      final contexto = {
        'sin': (num x) => sin(x * pi / 180), // Converte graus para radianos
        'cos': (num x) => cos(x * pi / 180),
        'tan': (num x) => tan(x * pi / 180), // Pode gerar valores muito grandes para ângulos como 90°
        'log': (num x) => log(x) / log(10), // Agora usa base 10 (log₁₀)
        'sqrt': (num x) => sqrt(x),
      };

      var resultado = evaluator.eval(exp, contexto);
      return resultado is num ? resultado.toDouble() : double.nan;
    } catch (e) {
      return double.nan;
    }
  }

  Widget _botao(String valor) {
    return TextButton(
      child: Text(
        valor,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      onPressed: () => _pressionarBotao(valor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Text(
            _expressao,
            style: const TextStyle(fontSize: 24.0),
          ),
        ),
        Expanded(
          child: Text(
            _resultado,
            style: const TextStyle(fontSize: 24.0),
          ),
        ),
        Expanded(
          flex: 3,
          child: GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 2,
            children: [
              _botao('⌫'), _botao(_limpar), _botao('⇅'), _botao('÷'),
              _botao('7'), _botao('8'), _botao('9'), _botao('x'),
              _botao('4'), _botao('5'), _botao('6'), _botao('-'),
              _botao('1'), _botao('2'), _botao('3'), _botao('+'),
              _botao('0'), _botao('.'), _botao('='),
            ] + (_cientifica ? [
              _botao('sin'), _botao('cos'), _botao('tan'), _botao('log'),
              _botao('√'),
            ] : []),
          ),
        ),
        Expanded(
          flex: 1,
          child: ListView.builder(
            itemCount: _historico.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_historico[index]),
              );
            },
          ),
        )
      ],
    );
  }
}