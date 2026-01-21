------------------------------division para las responsabilidades de la libreria
UI
 │
 ▼
Provider (EspeciesProvider)
 │  llama
 ▼
Servicio dominio (ej: EspecieService)
 │
 ├─ obtiene datos dominio (Flora)
 └─ llama sincronización
      │
      ├─ obtiene sync LOCAL (SQLite)
      ├─ obtiene sync REMOTO (API)
      ├─ ejecuta SyncService
      └─ actualiza SQLite / API

backend/
 └─ libSinc/
    ├─ reglas.dart
    ├─ sincronizacion.dart
    ├─ calcularHash.dart
    ├─ sicOrquestador.dart

    sicOrquestador Orquesta todo el proceso:
        obtiene sync local (SQLite)
        obtiene sync remoto (API)
        llama a SyncService

Dónde va cada responsabilidad 
| Capa         | Carpeta                   | Responsabilidad   |
| ------------ | ------------------------- | ----------------- |
| UI           | `frond/pages`             | Renderizar        |
| Estado UI    | `frond/providers`         | Exponer datos     |
| Infra local  | `backend/llamadasLocales` | SQLite CRUD       |
| Infra remota | `backend/llamadasRemotas` | HTTP              |
| Sync         | `backend/libSinc`         | Comparar, decidir |
| Dominio      | `backend/utilidades`      | Hash, reglas      |


------------------------------------------------------------modelo de datos

lib/
├─ domain/
│  ├─ entities/
│  │  └─ especie.dart
│  └─ value_objects.dart
│        
├─ data/
│  ├─ models/
│  │  ├─ especie_db.dart
│  │  └─ especie_dto.dart
│  └─ mappers/
│     └─ especie_mapper.dart
└─ backend/
   ├─ llamadasLocales/
   │  ├─ sqliteHelper.dart
   │  └─ sinc_local.dart       
   └─ llamadasRemotas/
      └─ flora_remote.dart

DOCUMENTACIÓN RESUMIDA – ESPECIES

1️⃣ Dominio: Especie
-------------------
Qué es:
- Representa una especie dentro de la aplicación.
- Contiene atributos simples y listas de VO (nombres comunes, utilidades, origenes) y URLs de imágenes.

Ejemplo de atributos:
nombreCientifico: 'Ficus benjamina'
...

Uso:
- Instanciar directamente en la app:
  especie = Especie(nombreCientifico: 'Ficus benjamina', ...)

---

2️⃣ DTO: EspecieDto
------------------
Qué es:
- DTO para transporte de datos hacia/desde la API.
- Contiene VO y listas de imágenes con estado local.

Ejemplo de atributos:
nombreCientifico: 'Ficus benjamina'
...

Uso:
- Convertir JSON a DTO: EspecieDto.fromJson(jsonData)
- Convertir DTO a JSON: dto.toJson()

---

3️⃣ DB: EspecieDb
-----------------
Qué es:
- Representa la especie en SQLite.
- Solo incluye atributos simples, sin listas ni VO.

Ejemplo de atributos:
nombreCientifico: 'Ficus benjamina'
...

Uso:
- Leer de SQLite: EspecieDb.fromRow(row)
- Guardar en SQLite: db.insert('especies', dbModel.toRow())

---

4️⃣ Mapper: EspecieMapper
------------------------
Qué es:
- Convierte entre Dominio, DTO y DB.
- Funciones principales:
  - toDto(): Dominio → DTO
  - fromDto(): DTO → Dominio
  - toDb(): Dominio → DB
  - fromDb(): DB → Dominio

Uso:
- especie = EspecieMapper.fromDto(dto)
- dto = especie.toDto()
- dbModel = especie.toDb()
- especieFromDb = EspecieMapper.fromDb(dbModel)

---

5️⃣ Value Objects (VO)
---------------------
NombreComun:
- nombres: 'Ficus'
- ...

Utilidad:
- utilpara: 'Sombra'
- ...

Origen:
- origen: 'Panamá'
- ...

ImagenTemp:
- urlFoto: 'https://...'
- estado: 'activa'
- ...

Uso:
- nombre = NombreComun(nombres: 'Ficus')
- utilidad = Utilidad(utilpara: 'Sombra')
- origen = Origen(origen: 'Panamá')
- imagen = ImagenTemp(urlFoto: 'https://...', estado: 'activa')

---

Flujo de Datos
--------------
1. API JSON → EspecieDto.fromJson() → EspecieMapper.fromDto() → Especie
2. Dominio → EspecieMapper.toDto() → EspecieDto.toJson() → API JSON
3. SQLite → EspecieDb.fromRow() → EspecieMapper.fromDb() → Especie
4. Dominio → EspecieMapper.toDb() → EspecieDb.toRow() → SQLite

final especie = Especie(...);      // UI / Dominio
final dto = especie.toDto();       // Mapper
final body = dto.toJson();         // JSON

ENVÍO AL API
{
  "nombre_cientifico": "Tabebuia rosea",
  "da_sombra": 1,
  "flor_distintiva": "rosada",
  "fruta_distintiva": null,
  "salud_suelo": 1,
  "huespedes": "abejas",
  "forma_crecimiento": "árbol",
  "pionero": 0,
  "polinizador": "abejas",
  "ambiente": "bosque seco",
  "nativo_america": 1,
  "nativo_panama": 1,
  "nativo_azuero": 1,
  "estrato": "dosel",

  "NombreComun": [
    { "nombre_comun": "Roble" }
  ],
  "Utilidad": [
    { "utilidad": "madera" }
  ],
  "Origen": [
    { "origen": "América Central" }
  ],
  "Imagen": [
    {
      "url_foto": "https://...",
      "estado": "aprobada"
    }
  ]
}

OBTENER DEL API
final json = response.data;
final dto = EspecieDto.fromJson(json);
final especie = EspecieMapper.fromDto(dto);

{
  "nombre_cientifico": "Tabebuia rosea",
  "da_sombra": 1,
  "flor_distintiva": "rosada",
  "fruta_distintiva": null,
  "salud_suelo": 1,
  "huespedes": "abejas",
  "forma_crecimiento": "árbol",
  "pionero": 0,
  "polinizador": "abejas",
  "ambiente": "bosque seco",
  "nativo_america": 1,
  "nativo_panama": 1,
  "nativo_azuero": 1,
  "estrato": "dosel",

  "NombreComun": [
    { "nombre_comun": "Roble" }
  ],
  "Utilidad": [
    { "utilidad": "madera" }
  ],
  "Origen": [
    { "origen": "América Central" }
  ],
  "Imagen": [
    {
      "url_foto": "https://...",
      "estado": "aprobada"
    }
  ]
}
