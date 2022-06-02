class FilteredSearch {
  final int employeeNumberSearch;
  final int selectedBenefitType;
  final int selectedRequestStatus;
  final int selectedTimingId;
  final int selectedDepartmentId;

  FilteredSearch(
      {required this.employeeNumberSearch,
      required this.selectedBenefitType,
      required this.selectedRequestStatus,
      required this.selectedTimingId,
      required this.selectedDepartmentId});
}
