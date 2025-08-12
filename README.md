# Mason Bricks for Flutter

A collection of reusable **Mason** bricks. The highlight brick is **`flutter_feature`** — a feature scaffold that generates:

- `data / domain / presentation` folders
- **entities + DTOs**
- **mappers** (extension methods `toDto()` / `toEntity()`)
- optional **pagination wrappers** (`Paged<Model>` + `Paged<Model>Dto`)
- optional **BLoC** boilerplate

Use these bricks from **any project** via GitHub, or add them globally and reuse everywhere.

---

## Contents

```
bricks/
  flutter_feature/
    brick.yaml
    __brick__/...
    hooks/
      pubspec.yaml
      pre_gen.dart
      post_gen.dart
      templates/
        entity.dart.tpl
        dto.dart.tpl
        entity_mapper.dart.tpl
        dto_mapper.dart.tpl
        paged_entity.dart.tpl
        paged_dto.dart.tpl
        paged_entity_mapper.dart.tpl
        paged_dto_mapper.dart.tpl
README.md
LICENSE
```

> You don’t need a `mason.yaml` in this repo; consumers will reference bricks via Git.

---

## Prerequisites

- Dart SDK installed
- Mason CLI

```bash
dart pub global activate mason_cli
mason --version
```

---

## Use from **any project** (recommended)

### Option A) Project‑local (pin version per project)

Creates/updates the project’s `mason.yaml` and `mason-lock.json`.

```bash
# In your Flutter/Dart project root:
mason init

mason add flutter_feature   --git-url https://github.com/MohamedOsama26/mason-bricks.git   --git-path bricks/flutter_feature   --git-ref v0.2.0   # tag/branch/commit

mason get
```

Generate a feature (interactive):

```bash
mason make flutter_feature
```

Or provide a config file (repeatable):

```jsonc
// feature_config.json
{
  "feature_name": "booking",
  "models_csv": "Booking,BookingDetails,TestItem",
  "pagination_models_csv": "TestItem",
  "include_bloc": true,
  "include_dto": true,
  "include_remote": true,
  "include_local": false,
  "include_tests": false
}
```

```bash
mason make flutter_feature -c feature_config.json --on-conflict overwrite
```

### Option B) Global (no `mason.yaml` in projects)

Install once, use everywhere on your machine.

```bash
mason add -g flutter_feature   --git-url https://github.com/<YOUR_GH_USERNAME>/<YOUR_REPO>.git   --git-path bricks/flutter_feature   --git-ref v0.2.0
mason get

# then in any project:
mason make flutter_feature -c feature_config.json
```

---

## `flutter_feature` – Variables

| Var | Type | Example | Notes |
|---|---|---|---|
| `feature_name` | string (snake_case) | `booking` | Top-level feature folder name under `lib/features/` |
| `include_bloc` | boolean | `true` | Creates BLoC boilerplate (`bloc/`, page wiring) |
| `include_dto` | boolean | `true` | DTOs for each model |
| `include_remote` | boolean | `true` | Remote data source stub |
| `include_local` | boolean | `false` | Local data source stub |
| `include_tests` | boolean | `false` | (placeholder) |
| `models_csv` | string (PascalCase, comma-separated) | `Booking,BookingDetails,TestItem` | Each model gets entity, dto, and mappers |
| `pagination_models_csv` | string (PascalCase, comma-separated) | `TestItem` | For any listed model, also generate `Paged<Model>` & `Paged<Model>Dto` + mappers |

---

## What gets generated (example)

Input:

```
feature_name=booking
models_csv=Booking,BookingDetails,TestItem
pagination_models_csv=TestItem
include_bloc=true
```

Output tree:

```
lib/features/booking/
  domain/
    entities/
      booking.dart
      booking_details.dart
      test_item.dart
      test_item_paged.dart
      mappers/
        booking_mapper.dart
        booking_details_mapper.dart
        test_item_mapper.dart
        test_item_paged_mapper.dart
    repositories/booking_repository.dart
    usecases/get_booking.dart

  data/
    models/
      booking_dto.dart
      booking_details_dto.dart
      test_item_dto.dart
      test_item_paged_dto.dart
      mappers/
        booking_dto_mapper.dart
        booking_details_dto_mapper.dart
        test_item_dto_mapper.dart
        test_item_paged_dto_mapper.dart
    datasources/
      booking_remote_data_source.dart      # if include_remote
      booking_local_data_source.dart       # if include_local
    repositories/booking_repository_impl.dart

  presentation/
    bloc/booking_bloc.dart                 # if include_bloc
    pages/booking_page.dart
    widgets/booking_view.dart
```

**Mapper style** (extensions):

```dart
// domain/entities/mappers/booking_details_mapper.dart
import '../../entities/booking_details.dart';
import '../../../data/models/booking_details_dto.dart';

extension BookingDetailsMapper on BookingDetailsDto {
  BookingDetails toEntity() {
    return BookingDetails(
      id: id,
      // ...map fields (e.g., tests: tests.map((e) => e.toEntity()).toList())
    );
  }
}

extension BookingDetailsToDto on BookingDetails {
  BookingDetailsDto toDto() {
    return BookingDetailsDto(
      id: id,
      // ...map fields (e.g., tests: tests.map((e) => e.toDto()).toList())
    );
  }
}
```

---

## Updating / version pinning

- Bump a **tag** in this repo (e.g., `v0.2.1`).
- In consuming projects, update the `ref` and run:

```bash
mason get
```

- If Mason uses cached content unexpectedly:

```bash
mason cache clear
mason get
```

---

## Troubleshooting

- **Hooks didn’t run / models not generated**  
  Ensure you’re using this brick (Git URL + `git-path`) and you see logs like:

  ```
  ✓ Compiled pre_gen.dart
  ✓ Compiled post_gen.dart
  ```

  Then `post_gen` will create entities, DTOs, and mappers.

- **Path issues on Windows**  
  The included `post_gen.dart` resolves the templates directory across common build paths. If you moved folders around, re‑add the brick and run `mason get`.

- **Re‑run clean**

```bash
mason cache clear
mason get
mason make flutter_feature --on-conflict overwrite --verbose
```

---

## Contributing

- Add new bricks under `bricks/<brick_name>/`
- Keep each brick self‑contained with `hooks/` and a short README.
- Follow SemVer for tags (`vMAJOR.MINOR.PATCH`) and update CHANGELOGs.

---

## License

This repository is licensed under the **MIT License** (see `LICENSE`).

---

### Quick copy‑paste command (project‑local)

```bash
mason init
mason add flutter_feature   --git-url https://github.com/<YOUR_GH_USERNAME>/<YOUR_REPO>.git   --git-path bricks/flutter_feature   --git-ref v0.2.0
mason get
mason make flutter_feature -c feature_config.json --on-conflict overwrite
```
