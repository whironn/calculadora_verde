import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  final String _limpar = 'C';
  final String _apagar = '<';
  String _expressao = '';
  String _resultado = '';

  void _pressionaBotao(String valor) {
    setState(() {
      if (valor == _apagar) {
        _expressao = _expressao.substring(0, _expressao.length - 1);
      } else if (valor == _limpar) {
        _expressao = '';
        _resultado = '';
      } else if (valor == '=') {
        _calculaResultado();
      } else {
        _expressao += valor;
      }
    });
  }

  Widget _botao(String valor) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0.7),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(20.0),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              valor,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          onPressed: () => _pressionaBotao(valor),
        ),
      ),
    );
  }

  void _calculaResultado() {
    try {
      _resultado = _expressao.split('=').last;
      _resultado = _avaliaExpressao(_expressao).toString();
    } catch (e) {
      _resultado = 'Erro. Não foi possível calcular';
    }
  }

  double _avaliaExpressao(String expressao) {
    expressao = expressao.replaceAll('x', '*');
    expressao = expressao.replaceAll('÷', '/');
    ExpressionEvaluator avaliador = const ExpressionEvaluator();
    double resultado = avaliador.eval(Expression.parse(expressao), {});
    return resultado;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            Expanded(
              child: Text(
                _expressao,
                style: TextStyle(fontSize: constraints.maxHeight * 0.05),
              ),
            ),
            Expanded(
              child: Text(
                _resultado,
                style: TextStyle(fontSize: constraints.maxHeight * 0.05),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: _botao(_limpar), // Botão "C" em uma linha separada
            ),
            Expanded(
              flex: 3,
              child: GridView.count(
                crossAxisCount: 4,
                childAspectRatio:
                    constraints.maxWidth / (constraints.maxHeight / 3) / 2,

                padding: const EdgeInsets.all(10.0),
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                //Bloqueia o rolamento na interface
                //physics: const NeverScrollableScrollPhysics(),

                children: [
                  _botao('7'),
                  _botao('8'),
                  _botao('9'),
                  _botao('÷'),
                  _botao('4'),
                  _botao('5'),
                  _botao('6'),
                  _botao('*'),
                  _botao('1'),
                  _botao('2'),
                  _botao('3'),
                  _botao('-'),
                  _botao('<'),
                  _botao('0'),
                  _botao('='),
                  _botao('+'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
