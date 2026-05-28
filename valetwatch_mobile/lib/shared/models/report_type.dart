enum ReportType {
  fakeValet,
  overcharging,
  unsafeArea,
  publicSpotClaimed,
}

extension ReportTypeExtension on ReportType {
  String get value {
    switch (this) {
      case ReportType.fakeValet:
        return 'fake_valet';

      case ReportType.overcharging:
        return 'overcharging';

      case ReportType.unsafeArea:
        return 'unsafe_area';

      case ReportType.publicSpotClaimed:
        return 'public_spot_claimed';
    }
  }

  String get label {
    switch (this) {
      case ReportType.fakeValet:
        return 'Fake Valet';

      case ReportType.overcharging:
        return 'Overcharging';

      case ReportType.unsafeArea:
        return 'Unsafe Area';

      case ReportType.publicSpotClaimed:
        return 'Public Spot Claimed';
    }
  }
}