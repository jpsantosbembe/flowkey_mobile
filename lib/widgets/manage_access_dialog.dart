import 'package:flutter/material.dart';
import '../models/key_model.dart'; // Importa o modelo da chave

class ManageAccessDialog extends StatefulWidget {
  final KeyModel keyModel; // 🔥 Recebe a chave para exibir os detalhes

  ManageAccessDialog({required this.keyModel});

  @override
  _ManageAccessDialogState createState() => _ManageAccessDialogState();
}

class _ManageAccessDialogState extends State<ManageAccessDialog> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 500, // Tamanho máximo do Dialog
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **Título e botão de fechar**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Gerenciar Acessos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o Dialog
                  },
                )
              ],
            ),
            SizedBox(height: 5),

            Text(
              widget.keyModel.label + " - " + widget.keyModel.description, // 🔥 Exibe o nome do laboratório
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 15),

            // **Campo de pesquisa**
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Adicionar pessoa...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // No futuro, chamaremos a função de busca aqui
              },
            ),
            SizedBox(height: 10),

            // **Lista de usuários autorizados (Por enquanto, vazia)**
            Container(
              height: 200, // Definindo altura fixa para evitar problemas de layout
              child: Center(
                child: Text(
                  "Nenhum usuário autorizado.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
