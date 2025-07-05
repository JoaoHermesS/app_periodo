import 'package:flutter/material.dart';

class TelaSintomas extends StatefulWidget {
  final DateTime diaSelecionado;
  final Map<String, dynamic>? dadosIniciais;

  // Callback para remover o dia, passada do main.dart
  final VoidCallback? onRemover;

  const TelaSintomas({
    super.key,
    required this.diaSelecionado,
    this.dadosIniciais,
    this.onRemover,
  });

  @override
  State<TelaSintomas> createState() => _TelaSintomasState();
}

class _TelaSintomasState extends State<TelaSintomas> {
  String? fluxoSelecionado;
  Set<String> sintomasSelecionados = {};
  String? coletaSelecionada;
  String? relacaoSelecionada;

  @override
  void initState() {
    super.initState();

    if (widget.dadosIniciais != null) {
      fluxoSelecionado = widget.dadosIniciais!['fluxo'];
      coletaSelecionada = widget.dadosIniciais!['coleta'];
      relacaoSelecionada = widget.dadosIniciais!['relacao'];

      final sintomas = widget.dadosIniciais!['sintomas'];
      if (sintomas is List) {
        sintomasSelecionados = sintomas.map((e) => e.toString()).toSet();
      }
    }
  }

  Widget botaoSelecao(
    String texto,
    IconData icone, {
    bool selecionado = false,
    required VoidCallback aoClicar,
  }) {
    return GestureDetector(
      onTap: aoClicar,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: selecionado ? Colors.pink : Colors.pink.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icone, color: Colors.black),
          ),
          SizedBox(height: 4),
          Text(texto, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget secao(String titulo, List<Widget> botoes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          titulo,
          style: TextStyle(
            color: Colors.pinkAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Wrap(spacing: 12, runSpacing: 12, children: botoes),
      ],
    );
  }

  Future<void> _confirmarRemocao() async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.black,
            title: Text('Remover dia', style: TextStyle(color: Colors.pink)),
            content: Text(
              'Deseja realmente remover o registro do dia ${widget.diaSelecionado.day}/${widget.diaSelecionado.month}/${widget.diaSelecionado.year}?',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                child: Text('Cancelar', style: TextStyle(color: Colors.pink)),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text('Remover', style: TextStyle(color: Colors.pink)),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );

    if (confirmado == true) {
      // Retorna uma flag especial para remover o dia no main
      Navigator.pop(context, 'remover');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Monitoramento",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Fluxo
              secao("Fluxo sanguíneo", [
                botaoSelecao(
                  "Leve",
                  Icons.water_drop,
                  selecionado: fluxoSelecionado == "Leve",
                  aoClicar: () => setState(() => fluxoSelecionado = "Leve"),
                ),
                botaoSelecao(
                  "Médio",
                  Icons.water_drop,
                  selecionado: fluxoSelecionado == "Médio",
                  aoClicar: () => setState(() => fluxoSelecionado = "Médio"),
                ),
                botaoSelecao(
                  "Intenso",
                  Icons.water_drop,
                  selecionado: fluxoSelecionado == "Intenso",
                  aoClicar: () => setState(() => fluxoSelecionado = "Intenso"),
                ),
                botaoSelecao(
                  "Super intenso",
                  Icons.water_drop,
                  selecionado: fluxoSelecionado == "Super intenso",
                  aoClicar:
                      () => setState(() => fluxoSelecionado = "Super intenso"),
                ),
              ]),

              // Sintomas
              secao("Sintomas/Dores", [
                botaoSelecao(
                  "Sem Dor",
                  Icons.sentiment_satisfied,
                  selecionado: sintomasSelecionados.contains("Sem Dor"),
                  aoClicar:
                      () => setState(() {
                        sintomasSelecionados.contains("Sem Dor")
                            ? sintomasSelecionados.remove("Sem Dor")
                            : sintomasSelecionados.add("Sem Dor");
                      }),
                ),
                botaoSelecao(
                  "Cólica",
                  Icons.mood_bad,
                  selecionado: sintomasSelecionados.contains("Cólica"),
                  aoClicar:
                      () => setState(() {
                        sintomasSelecionados.contains("Cólica")
                            ? sintomasSelecionados.remove("Cólica")
                            : sintomasSelecionados.add("Cólica");
                      }),
                ),
                botaoSelecao(
                  "Ovulação",
                  Icons.circle,
                  selecionado: sintomasSelecionados.contains("Ovulação"),
                  aoClicar:
                      () => setState(() {
                        sintomasSelecionados.contains("Ovulação")
                            ? sintomasSelecionados.remove("Ovulação")
                            : sintomasSelecionados.add("Ovulação");
                      }),
                ),
                botaoSelecao(
                  "Lombar",
                  Icons.accessibility,
                  selecionado: sintomasSelecionados.contains("Lombar"),
                  aoClicar:
                      () => setState(() {
                        sintomasSelecionados.contains("Lombar")
                            ? sintomasSelecionados.remove("Lombar")
                            : sintomasSelecionados.add("Lombar");
                      }),
                ),
              ]),

              // Coleta
              secao("Método de Coleta", [
                botaoSelecao(
                  "Absorvente",
                  Icons.local_hospital,
                  selecionado: coletaSelecionada == "Absorvente",
                  aoClicar:
                      () => setState(() => coletaSelecionada = "Absorvente"),
                ),
                botaoSelecao(
                  "Protetor diário",
                  Icons.layers,
                  selecionado: coletaSelecionada == "Protetor diário",
                  aoClicar:
                      () =>
                          setState(() => coletaSelecionada = "Protetor diário"),
                ),
                botaoSelecao(
                  "Coletor",
                  Icons.coffee,
                  selecionado: coletaSelecionada == "Coletor",
                  aoClicar: () => setState(() => coletaSelecionada = "Coletor"),
                ),
                botaoSelecao(
                  "Calcinha",
                  Icons.emoji_people,
                  selecionado: coletaSelecionada == "Calcinha",
                  aoClicar:
                      () => setState(() => coletaSelecionada = "Calcinha"),
                ),
              ]),

              // Relação
              secao("Relação Sexual", [
                botaoSelecao(
                  "Protegido",
                  Icons.favorite,
                  selecionado: relacaoSelecionada == "Protegido",
                  aoClicar:
                      () => setState(() => relacaoSelecionada = "Protegido"),
                ),
                botaoSelecao(
                  "Desprotegido",
                  Icons.warning,
                  selecionado: relacaoSelecionada == "Desprotegido",
                  aoClicar:
                      () => setState(() => relacaoSelecionada = "Desprotegido"),
                ),
                botaoSelecao(
                  "Feito a sós",
                  Icons.pan_tool,
                  selecionado: relacaoSelecionada == "Feito a sós",
                  aoClicar:
                      () => setState(() => relacaoSelecionada = "Feito a sós"),
                ),
                botaoSelecao(
                  "Não ocorreu",
                  Icons.sentiment_dissatisfied,
                  selecionado: relacaoSelecionada == "Não ocorreu",
                  aoClicar:
                      () => setState(() => relacaoSelecionada = "Não ocorreu"),
                ),
              ]),

              Spacer(),

              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        // Se não tiver fluxo selecionado, talvez queira remover o dia
                        if (fluxoSelecionado == null) {
                          // Perguntar se quer remover mesmo sem fluxo
                          _confirmarRemocao();
                        } else {
                          Navigator.pop(context, {
                            'fluxo': fluxoSelecionado,
                            'sintomas': sintomasSelecionados.toList(),
                            'coleta': coletaSelecionada,
                            'relacao': relacaoSelecionada,
                          });
                        }
                      },
                      child: Text(
                        "Salvar",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                      onPressed: _confirmarRemocao,
                      child: Text(
                        "Remover dia",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
