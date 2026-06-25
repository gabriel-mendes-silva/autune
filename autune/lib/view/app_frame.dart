import 'package:autune/pages/home_page.dart';
import 'package:autune/view/widgets/app_colors.dart';
import 'package:autune/view/widgets/app_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppFrame extends StatefulWidget{
  const AppFrame({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AppFrameState();
  }

}

class _AppFrameState extends State<AppFrame>{
  int paginaAtual = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AutuneBar(),
      body: HomePage(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.borderGreyColor, width: 1)
          )
        ),
        child: BottomNavigationBar(
          selectedItemColor: AppColors.mainColor,
            unselectedItemColor: AppColors.oliveBrownColor,
          selectedLabelStyle: TextStyle(
            fontFamily: 'AlanSans',
            fontSize: 14,

          ), unselectedLabelStyle: TextStyle(
                fontFamily: 'AlanSans',
               fontSize: 14,
            ),
          items: [
            BottomNavigationBarItem(
                activeIcon: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SvgPicture.asset('assets/afinador-icon.svg',
                    colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    width: 24,
                  ),
                ),
                icon: SvgPicture.asset(

                  'assets/afinador-icon.svg',
                  colorFilter: ColorFilter.mode(AppColors.oliveBrownColor, BlendMode.srcIn),
                  width: 24,
                ),
                label: "Afinador"
            ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/home-icon.svg',
                  colorFilter: ColorFilter.mode(AppColors.oliveBrownColor, BlendMode.srcIn),
                  width: 24,
                ),
                label: "Início"),
            BottomNavigationBarItem(

                icon: SvgPicture.asset(
                  'assets/music-icon.svg',
                  colorFilter: ColorFilter.mode(AppColors.oliveBrownColor, BlendMode.srcIn),
                  width: 24,
                ),
                label: "Histórico")
          ]),)
    );
  }

}

class AutuneBar extends StatelessWidget implements PreferredSizeWidget{

  const AutuneBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Autune",
        style: TextStyle(
            fontFamily: 'NotoSerif',
            fontSize: 22,
            color: Colors.white
        ),),
      backgroundColor: AppColors.mainColor,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Image.asset("assets/autune-logo.png", scale: 4),
            onPressed: () {},
          );
        },
      ),
      actions: <Widget>[
        Padding(padding: EdgeInsetsGeometry.only(right: 10),child: Container(
          width: 42,
          decoration: BoxDecoration(

              shape: BoxShape.circle,
              color: Colors.white
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: CircleAvatar(
                backgroundImage: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/c/c0/Neymar_Junior_Brazil_V_Morocco_13_June_2026-40.jpg/960px-Neymar_Junior_Brazil_V_Morocco_13_June_2026-40.jpg")
            ),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This is a snackbar')),
              );
            },
          ),
        ))
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}

class AutuneBottomBar extends StatefulWidget{



  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }

}

