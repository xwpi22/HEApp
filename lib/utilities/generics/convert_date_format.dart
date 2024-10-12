String convertDateFormat(String originalDateString) {
  // Parse the original date string
  DateTime parsedDate = DateTime.parse(originalDateString.replaceAll('/', '-'));

  // Format the date to YYYY-MM-DD
  String formattedDate =
      "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";

  return formattedDate;
}
