# flutter_feature brick

A Mason brick to scaffold a Flutter **feature** with clean layers:
- `data / domain / presentation`
- Entities + DTOs
- **Mapper extensions** (`toDto()` / `toEntity()`), including paginated wrappers
- Optional BLoC boilerplate
- Optional local/remote data sources

> Drop this file at: `bricks/flutter_feature/README.md`

---

## Quick start

### Use from a project (recommended)
```bash
mason init
mason add flutter_feature   --git-url https://github.com/<YOUR_GH_USERNAME>/<YOUR_REPO>.git   --git-path bricks/flutter_feature   --git-ref v0.2.0
mason get
```

Generate interactively:
```bash
mason make flutter_feature
```

Or with a config (repeatable):
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

### Install globally (optional)
```bash
mason add -g flutter_feature   --git-url https://github.com/<YOUR_GH_USERNAME>/<YOUR_REPO>.git   --git-path bricks/flutter_feature   --git-ref v0.2.0
mason get
# then in any project:
mason make flutter_feature -c feature_config.json
```

---

## Variables

| Var | Type | Example | Notes |
|---|---|---|---|
| `feature_name` | string (snake_case) | `booking` | Creates `lib/features/booking/` |
| `include_bloc` | boolean | `true` | Adds `presentation/bloc` and wires page with BlocProvider |
| `include_dto` | boolean | `true` | Creates `<model>_dto.dart` per model |
| `include_remote` | boolean | `true` | Adds remote data source stub |
| `include_local` | boolean | `false` | Adds local data source stub |
| `include_tests` | boolean | `false` | (placeholder) |
| `models_csv` | string (PascalCase list) | `Booking,BookingDetails,TestItem` | Generates entities, DTOs, and mappers per model |
| `pagination_models_csv` | string (PascalCase list) | `TestItem` | Also generate `Paged<Model>` + `Paged<Model>Dto` and mappers |

---

## What it generates (example)

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

**Mapper style (extensions)**

```dart
// domain/entities/mappers/booking_details_mapper.dart
import '../../entities/booking_details.dart';
import '../../../data/models/booking_details_dto.dart';

extension BookingDetailsMapper on BookingDetailsDto {
  BookingDetails toEntity() {
    return BookingDetails(
      id: id,
      // e.g. tests: tests.map((e) => e.toEntity()).toList(),
    );
  }
}

extension BookingDetailsToDto on BookingDetails {
  BookingDetailsDto toDto() {
    return BookingDetailsDto(
      id: id,
      // e.g. tests: tests.map((e) => e.toDto()).toList(),
    );
  }
}
```

---

## Troubleshooting

- **Models/entities not created**: ensure hooks run (you should see “Compiled pre_gen.dart / post_gen.dart”). Re-add the brick and run:
```bash
mason cache clear
mason get
mason make flutter_feature --on-conflict overwrite --verbose
```
- **Windows path errors**: `post_gen.dart` includes a resilient templates resolver. If you moved folders, re-add the brick with the correct `--git-path` and run `mason get` again.

---

## Version pinning

Pin a version (tag/branch/SHA) in project `mason.yaml`:
```yaml
bricks:
  flutter_feature:
    git:
      url: https://github.com/<YOUR_GH_USERNAME>/<YOUR_REPO>.git
      path: bricks/flutter_feature
      ref: v0.2.0
```

Update your tag to release changes (`v0.2.1`, etc.), then:
```bash
mason get
```

---

## Local development

- Edit files under `bricks/flutter_feature/` (`__brick__/`, `hooks/`).
- Test from any project using `--on-conflict overwrite` or a throwaway project.
- If using a local path instead of Git:
```bash
mason remove flutter_feature
mason add flutter_feature --path ./bricks/flutter_feature
mason get
```
