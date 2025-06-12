/// BaseResult es una clase base que representa el resultado de una operación de red.
sealed class BaseResult {}

/// Representa un resultado satisfactorio en una operación de red.
class BaseResultSuccess<T> extends BaseResult {
  final T data;
  BaseResultSuccess(this.data);
}

/// Representa un resultado de error en una operación de red.
class BaseResultError extends BaseResult {
  final String message;
  BaseResultError(this.message);
}
