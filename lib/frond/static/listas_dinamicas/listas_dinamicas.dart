import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

//nosotros
Future<List<Map<String, String>>> cargarColaboradores(
  BuildContext context,
) async {
  return [
    {
      'imagen': 'assets/images/colaborador1.jpg',
      'titulo': 'Dra. María González',
      'puesto': context.tr('colaboradores.Dra_Maria_Gonzalez.puesto'),
      'descripcion': context.tr('colaboradores.Dra_Maria_Gonzalez.descripcion'),
    },
    {
      'imagen': 'assets/images/colaborador2.jpg',
      'titulo': 'Carlos Méndez',
      'puesto': context.tr('colaboradores.Carlos_Mendez.puesto'),
      'descripcion': context.tr('colaboradores.Carlos_Mendez.descripcion'),
    },
    {
      'imagen': 'assets/images/colaborador4.jpg',
      'titulo': 'Dra. Ana Antonieta',
      'puesto': context.tr('colaboradores.Dra_Maria_Gonzalez.puesto'),
      'descripcion': context.tr('colaboradores.Dra_Maria_Gonzalez.descripcion'),
    },
  ];
}

//compañeros
Future<List<Map<String, String>>> cargarCompanieros(
  BuildContext context,
) async {
  return [
    {'imagen': 'assets/images/colaborador1.jpg', 'titulo': 'Juan Jose'},
    {'imagen': 'assets/images/colaborador2.jpg', 'titulo': 'Jose Juan'},
    {'imagen': 'assets/images/colaborador1.jpg', 'titulo': 'Julio Jaramillo'},
  ];
}

//home
Future<List<Map<String, String>>> cargarListasHacemos(
  BuildContext context,
) async {
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


//conservacion y reforestacion
Future<List<Map<String, String>>> cargarListaIniciativas(
  BuildContext context,
) async {
  return [
    {
      'imagen': 'assets/images/doñas.jpg',
      'titulo': context.tr(
        'texts.conservrefor.cultivosSostenibles.titulo.viveros',
      ),
      'resumen': context.tr(
        'texts.conservrefor.cultivosSostenibles.texto.viveros',
      ),
    },
    {
      'imagen': 'assets/images/doñas.jpg',
      'titulo': context.tr(
        'texts.conservrefor.cultivosSostenibles.titulo.Microproductores',
      ),
      'resumen': context.tr(
        'texts.conservrefor.cultivosSostenibles.texto.Microproductores',
      ),
    },
    {
      'imagen': 'assets/images/doñas.jpg',
      'titulo': context.tr(
        'texts.conservrefor.cultivosSostenibles.titulo.semillas',
      ),
      'resumen': context.tr(
        'texts.conservrefor.cultivosSostenibles.texto.semillas',
      ),
    },
  ];
}

// educacion
final List<String> listaEstudiantes = [
  'assets/images/est1.jpg',
  'assets/images/est2.jpg',
  'assets/images/est3.jpg',
];


// ecoguias pdfs
Future<List<Map<String, dynamic>>> cargarGuias(BuildContext context) async {
  return [
    {
      "imagen": "assets/images/incendio.jpg",
      "titulo": "Fire Control: Rights & Regulations",
      "texto": "A guide to protect your farm from neighboring fires.",
      "pdfKey": "texts.ecoguias.pdfs.firecontrol",
    },
    {
      "imagen": "assets/images/explorador.jpg",
      "titulo":
          "Riparian Zone Conservation: A Guide to Understand & Protect Panamanian Riparian Zones",
      "texto":
          "To increase the integrity of these areas, reforest riparian zones using trees that grow well around bodies of water.",
      "pdfKey": "texts.ecoguias.pdfs.riparianzone",
    },
  ];
}