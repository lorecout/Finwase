class StaffMember {
  final String id;
  final StaffRole role;
  int level;
  double productionBuff; // multiplicador adicional
  double speedBuff; // reduz tempo por ciclo
  double valueBuff; // aumenta valor por prato

  StaffMember({
    required this.id,
    required this.role,
    this.level = 1,
    this.productionBuff = 0.0,
    this.speedBuff = 0.0,
    this.valueBuff = 0.0,
  });

  double totalProductionMultiplier() => 1 + productionBuff + (level - 1) * 0.05;
  double totalSpeedMultiplier() => 1 + speedBuff + (level - 1) * 0.03;
  double totalValueMultiplier() => 1 + valueBuff + (level - 1) * 0.04;
}

enum StaffRole { chef, assistant, waiter, mascot }
