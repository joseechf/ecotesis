// lib/data/mappers/especie_mapper.dart
import '../../domain/entities/especie.dart';
import '../models/especie_db.dart';
import '../models/especie_dto.dart';

/// Traducciones **sin lógica de negocio** entre capas.
extension EspecieMapper on Especie {
  /* ----------  DOMINIO → DTO  (para enviar a la API) ---------- */
  EspecieDto toDto() => EspecieDto(
    nombreCientifico: nombreCientifico,
    daSombra: daSombra,
    florDistintiva: florDistintiva,
    frutaDistintiva: frutaDistintiva,
    saludSuelo: saludSuelo,
    huespedes: huespedes,
    formaCrecimiento: formaCrecimiento,
    pionero: pionero,
    polinizador: polinizador,
    ambiente: ambiente,
    nativoAmerica: nativoAmerica,
    nativoPanama: nativoPanama,
    nativoAzuero: nativoAzuero,
    estrato: estrato,
    nombresComunes: nombresComunes,
    utilidades: utilidades,
    origenes: origenes,
    imagenes: imagenes,
  );

  /* ----------  DTO → DOMINIO  (al llegar de la API) ---------- */
  static Especie fromDto(EspecieDto dto) => Especie(
    nombreCientifico: dto.nombreCientifico,
    daSombra: dto.daSombra,
    florDistintiva: dto.florDistintiva,
    frutaDistintiva: dto.frutaDistintiva,
    saludSuelo: dto.saludSuelo,
    huespedes: dto.huespedes,
    formaCrecimiento: dto.formaCrecimiento,
    pionero: dto.pionero,
    polinizador: dto.polinizador,
    ambiente: dto.ambiente,
    nativoAmerica: dto.nativoAmerica,
    nativoPanama: dto.nativoPanama,
    nativoAzuero: dto.nativoAzuero,
    estrato: dto.estrato,
    nombresComunes: dto.nombresComunes ?? const [],
    utilidades: dto.utilidades ?? const [],
    origenes: dto.origenes ?? const [],
    imagenes: dto.imagenes ?? const [],
  );

  /* ----------  DOMINIO → DB  (para SQLite) ---------- */
  EspecieDb toDb() => EspecieDb(
    nombreCientifico: nombreCientifico,
    daSombra: daSombra,
    florDistintiva: florDistintiva,
    frutaDistintiva: frutaDistintiva,
    saludSuelo: saludSuelo,
    huespedes: huespedes,
    formaCrecimiento: formaCrecimiento,
    pionero: pionero,
    polinizador: polinizador,
    ambiente: ambiente,
    nativoAmerica: nativoAmerica,
    nativoPanama: nativoPanama,
    nativoAzuero: nativoAzuero,
    estrato: estrato,
  );

  /* ----------  DB → DOMINIO  (desde SQLite) ---------- */
  static Especie fromDb(EspecieDb db) => Especie(
    nombreCientifico: db.nombreCientifico,
    daSombra: db.daSombra,
    florDistintiva: db.florDistintiva,
    frutaDistintiva: db.frutaDistintiva,
    saludSuelo: db.saludSuelo,
    huespedes: db.huespedes,
    formaCrecimiento: db.formaCrecimiento,
    pionero: db.pionero,
    polinizador: db.polinizador,
    ambiente: db.ambiente,
    nativoAmerica: db.nativoAmerica,
    nativoPanama: db.nativoPanama,
    nativoAzuero: db.nativoAzuero,
    estrato: db.estrato,
    nombresComunes: const [],
    utilidades: const [],
    origenes: const [],
    imagenes: const [],
  );
}
