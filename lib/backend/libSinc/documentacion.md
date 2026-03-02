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

------------------------------------------------------------------------------
SOFT DELETE

en remoto no se debe eliminar completamente un registro, simplemente se marga is_delete = true, pero en la tabla Flora se deja igual. En local se debe marcar el is_delete y dejar Flora igual hasta que se haga la sincronización y luego se puede decidir si eliminar completamente el registro en caso que 1. Remoto también tenga is_delete = true (en la app is_delete = 1). 2. Remoto no tenga ese registro, nunca se sincronizo. 
Si está is_delete=1 en local pero no en remoto depende de la versión lo que va a pasar 1. version remoto mayor gana remoto y se quita el is_delete de local 2. version local mayor se elimina remoto (soft delete) y se elimina completamente local (tanto tabla flora como tabla sincronización) 3. versiones iguales gana remoto
