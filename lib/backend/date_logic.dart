void main() {
  String dateString = "Sat Sep 28 2024 16:49:38 GMT+0530";
  DateTime givenDate =
      DateTime.parse("2024-09-28 16:49:38"); // Parse the given date string

  DateTime currentDate = DateTime.now(); // Get the current date and time

  if (currentDate.isBefore(givenDate)) {
    print("Given date is in the future compared to the current date.");
  } else if (currentDate.isAfter(givenDate)) {
    print("Given date is in the past compared to the current date.");
  } else {
    print("Given date and current date are the same.");
  }

  Duration timeDifference =
      givenDate.difference(currentDate); // Calculate the time difference

  int daysRemaining = timeDifference.inDays; // Get the number of days remaining

  print("Number of days remaining until $givenDate: $daysRemaining days");
}
