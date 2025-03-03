import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class GuardaSection extends StatelessWidget {
  const GuardaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final userName = authViewModel.user?.name ?? "Guarda";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),

                // Ícone grande
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.security,
                    size: 50,
                    color: Colors.green[800],
                  ),
                ),

                SizedBox(height: 30),

                Text(
                  "Módulo do Guarda",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 20),

                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Olá, $userName",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 16),

                      Text(
                        "O módulo do guarda para gerenciamento de empréstimos de chaves está em desenvolvimento para o aplicativo móvel.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 20),

                      _buildInfoCard(
                        icon: Icons.computer,
                        title: "Acesse pelo computador",
                        description: "Utilize o sistema web para realizar o controle de empréstimos de chaves",
                      ),

                      SizedBox(height: 12),

                      _buildInfoCard(
                        icon: Icons.new_releases,
                        title: "Versão Mobile",
                        description: "Disponível na próxima atualização",
                        isHighlighted: true,
                      ),

                      SizedBox(height: 12),

                      _buildInfoCard(
                        icon: Icons.link,
                        title: "Portal do Guarda",
                        description: "guarda.flowkey.com",
                        isLink: true,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // Botão de sair
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await authViewModel.logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    icon: Icon(Icons.exit_to_app, color: Colors.white),
                    label: Text(
                      "SAIR",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
    bool isLink = false,
    bool isHighlighted = false,
  }) {
    Color backgroundColor;
    Color borderColor;
    Color iconBackgroundColor;
    Color iconColor;
    Color titleColor;
    Color descriptionColor;

    if (isLink) {
      backgroundColor = Colors.blue[50]!;
      borderColor = Colors.blue[200]!;
      iconBackgroundColor = Colors.blue[100]!;
      iconColor = Colors.blue[800]!;
      titleColor = Colors.blue[800]!;
      descriptionColor = Colors.blue[700]!;
    } else if (isHighlighted) {
      backgroundColor = Colors.amber[50]!;
      borderColor = Colors.amber[200]!;
      iconBackgroundColor = Colors.amber[100]!;
      iconColor = Colors.amber[800]!;
      titleColor = Colors.amber[800]!;
      descriptionColor = Colors.amber[700]!;
    } else {
      backgroundColor = Colors.grey[50]!;
      borderColor = Colors.grey[300]!;
      iconBackgroundColor = Colors.grey[200]!;
      iconColor = Colors.grey[700]!;
      titleColor = Colors.grey[800]!;
      descriptionColor = Colors.grey[600]!;
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: descriptionColor,
                    fontWeight: isLink || isHighlighted ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}