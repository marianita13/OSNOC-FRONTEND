import 'package:flutter/material.dart';
import '../../models/social_network.dart';
import '../theme/social_networks_styles.dart';
import 'social_network_icon.dart';

class SocialNetworkCard extends StatelessWidget {
  final SocialNetwork network;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SocialNetworkCard({
    super.key,
    required this.network,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasUrl = network.postUrl.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SocialNetworksStyles.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícono, Nombre, ID / Orden y Badge Activa
            Row(
              children: [
                SocialNetworkIcon(iconKey: network.icon, size: 36, logo: network.logo),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        network.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: SocialNetworksStyles.titleColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ID ${network.id}  ·  Orden ${network.order}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: SocialNetworksStyles.subtextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: network.isActive
                        ? SocialNetworksStyles.activeBg
                        : SocialNetworksStyles.inactiveBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    network.isActive ? 'Activa' : 'Inactiva',
                    style: TextStyle(
                      color: network.isActive
                          ? SocialNetworksStyles.activeText
                          : SocialNetworksStyles.inactiveText,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 16, color: SocialNetworksStyles.borderColor),

            // PostURL y botones de acción (Editar, Eliminar)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'POST URL',
                        style: TextStyle(
                          fontSize: 10,
                          color: SocialNetworksStyles.dataLabelColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasUrl ? network.postUrl : 'Sin URL',
                        style: TextStyle(
                          fontSize: 12,
                          color: hasUrl
                              ? SocialNetworksStyles.bodyTextColor
                              : SocialNetworksStyles.dataLabelColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.edit,
                  color: SocialNetworksStyles.editBlue,
                  onTap: onEdit,
                ),
                const SizedBox(width: 6),
                _buildActionButton(
                  icon: Icons.delete,
                  color: SocialNetworksStyles.deleteRed,
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, size: 16, color: Colors.white),
        ),
      ),
    );
  }
}
