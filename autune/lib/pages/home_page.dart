import 'package:autune/view/widgets/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
  int? numeroSessoes = 0;
  double? porcentagemAfinacaoGeral = 98.5;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(padding: EdgeInsetsGeometry.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Olá, usuário!',
                    style: TextStyle(
                        fontFamily: 'NotoSerif',
                        fontSize: 32,
                        fontWeight: FontWeight(900),
                        color: AppColors.mainColor
                    ),
                  ),
                  Text('O que deseja praticar hoje?',
                    style: TextStyle(
                        fontFamily: 'AlanSans',
                        fontSize: 18,
                        fontWeight: FontWeight(500),
                        color: AppColors.mainColor
                    ),
                  ),
                ],
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(shape: BoxShape.rectangle,
                    color: AppColors.coffeishColor,
                    border: Border.all(color: AppColors.borderCoffeishColor, width: 1),
                  borderRadius: BorderRadius.circular(15)
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DESEMPENHO',
                    style: TextStyle(
                        fontFamily: 'AlanSans',
                        fontSize: 16,
                        fontWeight: FontWeight(600),
                        color: AppColors.mainColor
                    ),
                  ),
                  Divider(color: AppColors.borderGreyColor),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 160,
                    width: 175,
                    decoration: BoxDecoration(shape: BoxShape.rectangle,
                        color: Colors.white,
                        border: Border.all(color: AppColors.borderGreyColor, width: 1),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(padding: EdgeInsetsGeometry.only(right: 20, left: 12, top: 12, bottom: 16),child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                          Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(shape: BoxShape.rectangle,
                              color: AppColors.middleGreyColor,
                                borderRadius: BorderRadius.circular(15)
                            ),
                          ),
                          Text('Nº DE PRÁTICAS',
                            style: TextStyle(
                                fontFamily: 'AlanSans',
                                fontSize: 13,
                                fontWeight: FontWeight(500),
                                color: AppColors.mainColor
                            ),
                          ),
                        ],),
                        Align(alignment: AlignmentGeometry.bottomEnd,
                            child: Text(numeroSessoes.toString(), style: TextStyle(
                            fontFamily: 'NotoSerif',
                            fontWeight: FontWeight(900),
                            fontSize: 36,
                            color: AppColors.oliveBrownColor
                        )))

                      ],
                    ),
                    )
                  ),
                  Container(
                      height: 160,
                      width: 175,
                      decoration: BoxDecoration(shape: BoxShape.rectangle,
                          color: Colors.white,
                          border: Border.all(color: AppColors.borderGreyColor, width: 1),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Padding(padding: EdgeInsetsGeometry.only(right: 20, left: 12, top: 12, bottom: 16),child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 10,
                            children: [
                              Container(
                                height: 12,
                                width: 12,
                                decoration: BoxDecoration(shape: BoxShape.rectangle,
                                    color: AppColors.rosehColor,
                                    borderRadius: BorderRadius.circular(15)
                                ),
                              ),
                              Text('AFINAÇÃO GERAL',
                                style: TextStyle(
                                    fontFamily: 'AlanSans',
                                    fontSize: 13,
                                    fontWeight: FontWeight(500),
                                    color: AppColors.mainColor
                                ),
                              ),
                            ],),
                          Align(alignment: AlignmentGeometry.bottomEnd,
                              child: Text('$porcentagemAfinacaoGeral%', style: TextStyle(
                                  fontFamily: 'NotoSerif',
                                  fontWeight: FontWeight(900),
                                  fontSize: 36,
                                  color: AppColors.oliveBrownColor
                              )))

                        ],
                      ),
                      )
                  )
                ],
              )



            ],
          )
      ),
    );
  }
  
}