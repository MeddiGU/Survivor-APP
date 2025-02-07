import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final Function(int) onTap;

  CustomNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMobileMenuItem(context, 'Dashboard', 0, Icons.dashboard),
              _buildMobileMenuItem(context, 'Coaches', 1, Icons.person),
              _buildMobileMenuItem(context, 'Customers', 2, Icons.group),
              _buildMobileMenuItem(context, 'Tips', 3, Icons.lightbulb),
              _buildMobileMenuItem(context, 'Events', 4, Icons.event),
              _buildMobileMenuItem(context, 'Astro', 5, Icons.star),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileMenuItem(BuildContext context, String title, int index, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        color: selectedIndex == index ? Colors.blue : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: selectedIndex == index ? Colors.blue : Colors.grey[800],
          fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: selectedIndex == index,
      onTap: () {
        onTap(index);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildDesktopNavItem(String title, int index) {
    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selectedIndex == index ? Colors.blue : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selectedIndex == index ? Colors.blue : Colors.grey,
            fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: LayoutBuilder(
        builder: (context, constraints) {
          // Check if we're on a mobile device
          final bool isMobile = MediaQuery.of(context).size.width < 800;

          return Row(
            children: [
              Text(
                'Soul connection',
                style: TextStyle(
                  color: Color(0xFF2C365D),
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 20 : 24,
                ),
              ),
              if (!isMobile) Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildDesktopNavItem('Dashboard', 0),
                    _buildDesktopNavItem('Coaches', 1),
                    _buildDesktopNavItem('Customers', 2),
                    _buildDesktopNavItem('Tips', 3),
                    _buildDesktopNavItem('Events', 4),
                    _buildDesktopNavItem('Astro', 5),
                  ],
                ),
              ),
              if (isMobile) Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Color(0xFF2C365D),
                      ),
                      onPressed: () => _showMobileMenu(context),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}