import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

//nosotros
List<Map<String,String>> cargarColaboradores(
  BuildContext context,
) {
  return [
    {
      'imagen': 'assets/images/colaborador1.jpg',
      'titulo': 'Alisson Ortega',
      'puesto': context.tr('colaboradores.Dra_Maria_Gonzalez.puesto'),
      'descripcion': context.tr('colaboradores.Dra_Maria_Gonzalez.descripcion'),
    },
    {
      'imagen': 'assets/images/colaborador2.jpg',
      'titulo': 'Jose Juan',
      'puesto': context.tr('colaboradores.Carlos_Mendez.puesto'),
      'descripcion': context.tr('colaboradores.Carlos_Mendez.descripcion'),
    },
    {
      'imagen': 'assets/images/colaborador4.jpg',
      'titulo': 'Ana María',
      'puesto': context.tr('colaboradores.Ana_Maria.puesto'),
      'descripcion': context.tr('colaboradores.Ana_Maria.descripcion'),
    },
  ];
}

// compañeros
List<Map<String, String>> cargarCompanieros(
  BuildContext context,
) {
  return [
    {'imagen': 'assets/images/colaborador1.jpg','titulo':'Alisson Ortega'},
    {'imagen': 'assets/images/colaborador2.jpg','titulo':'Jose Juan'},
    {'imagen': 'assets/images/colaborador4.jpg','titulo':'Ana María'},
  ];
}

// home
List<Map<String, String>> cargarListasHacemos(
  BuildContext context,
) {
  return [
    {
      'imagen': 'assets/images/mono1.jpg',
      'titulo': context.tr('texts.textsHome.hacemos.titulo.conservacion'),
      'resumen': context.tr('texts.textsHome.hacemos.texto.conservacion'),
      'boton': 'conservacion',
    },
    {
      'imagen': 'assets/images/educacion.jpg',
      'titulo': context.tr('texts.textsHome.hacemos.titulo.educDiv'),
      'resumen': context.tr('texts.textsHome.hacemos.texto.educDiv'),
      'boton': 'educDiv',
    },
    {
      'imagen': 'assets/images/colaborador3.jpg',
      'titulo': context.tr('texts.textsHome.hacemos.titulo.colaboracion'),
      'resumen': context.tr('texts.textsHome.hacemos.texto.colaboracion'),
      'boton': 'colaboracion',
    },
  ];
}

// conservacion y reforestacion
List<Map<String, String>> cargarListaIniciativas(
  BuildContext context,
) {
  return [
    {
      'imagen': 'assets/images/viveros.jpg',
      'titulo': context.tr('texts.conservrefor.cultivosSostenibles.titulo.viveros'),
      'resumen': context.tr('texts.conservrefor.cultivosSostenibles.texto.viveros'),
    },
    {
      'imagen': 'assets/images/doñas.jpg',
      'titulo': context.tr('texts.conservrefor.cultivosSostenibles.titulo.Microproductores'),
      'resumen': context.tr('texts.conservrefor.cultivosSostenibles.texto.Microproductores'), 
    },
    {
      'imagen': 'assets/images/semillas.jpg',
      'titulo': context.tr('texts.conservrefor.cultivosSostenibles.titulo.semillas'),
      'resumen': context.tr('texts.conservrefor.cultivosSostenibles.texto.semillas'),
    },
  ];
}

//educacion
final List<String> listaEstudiantes = [
  'assets/images/est1.jpg',
  'assets/images/est2.jpg',
  'assets/images/est3.jpg',
];

//plantando
final List<String> listaPlantando = [
  'assets/images/reforestando1.jpg',
  'assets/images/reforestando2.jpg',
  'assets/images/reforestando3.jpg',
];

//ecoguias pdfs
List<Map<String, String>> cargarGuias(
  BuildContext context,
) {
  return [
    {
      'imagen': 'assets/images/incendio.jpg',
      'titulo': 'Fire Control: Rights & Regulations',
      'texto': 'A guide to protect your farm from neighboring fires.',
      'pdfkey': 'texts.ecoguias.pdfs.firecontrol',
    },
    {
      'imagen': 'assets/images/explorador.jpg',
      'titulo': 'Riparian Zone Conservation: A Guide to Understand & Protect Panamanian Riparian Zones',
      'texto': 'To increase the integrity of these areas, reforest riparian zones using trees that grow well around bodies of water',
      'pdfkey': 'texts.ecoguias.pdfs.riparianzone',
    },
  ];
}