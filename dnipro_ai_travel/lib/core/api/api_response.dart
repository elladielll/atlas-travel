class ApiResponse<T> {
  final T data;
  final bool success;

  const ApiResponse({
    required this.data,
    this.success = true,
  });
}